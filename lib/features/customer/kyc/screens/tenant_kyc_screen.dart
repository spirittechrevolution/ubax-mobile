import 'package:statefulclickcounter/core/network/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'package:statefulclickcounter/core/di/injection.dart';
import 'package:statefulclickcounter/core/network/api_exception.dart';
import 'package:statefulclickcounter/core/widgets/orange_button.dart';
import 'package:statefulclickcounter/features/customer/kyc/data/models/tenant_models.dart';
import 'package:statefulclickcounter/features/customer/kyc/domain/repositories/tenant_repository.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

// ─── Employment status options ─────────────────────────────────────────────────

const _kEmploymentOptions = [
  ('EMPLOYED', 'Salarié(e)'),
  ('SELF_EMPLOYED', 'Indépendant(e)'),
  ('UNEMPLOYED', 'Sans emploi'),
  ('STUDENT', 'Étudiant(e)'),
  ('RETIRED', 'Retraité(e)'),
];

const _kDocumentTypes = [
  ('CNI', "Carte nationale d'identité"),
  ('PASSEPORT', 'Passeport'),
  ('TITRE_SEJOUR', 'Titre de séjour'),
];

// ─── Screen ────────────────────────────────────────────────────────────────────

class TenantKycScreen extends StatefulWidget {
  const TenantKycScreen({
    super.key,
    required this.propertyId,
    required this.propertyTitle,
    this.onPayment,
  });

  final String propertyId;
  final String propertyTitle;

  /// Called when the user taps "Procéder au paiement" after qualification.
  final VoidCallback? onPayment;

  @override
  State<TenantKycScreen> createState() => _TenantKycScreenState();
}

enum _Phase { loading, step1, step2, status, error }

class _TenantKycScreenState extends State<TenantKycScreen> {
  final _repo = getIt<TenantRepository>();
  final _picker = ImagePicker();

  _Phase _phase = _Phase.loading;
  TenantProfile? _existingProfile;
  String? _errorMsg;
  bool _submitting = false;

  // Step 1 — professional info
  String? _employmentStatus;
  final _employerCtrl = TextEditingController();
  final _incomeCtrl = TextEditingController();
  bool _hasGuarantor = false;
  final _guarantorNameCtrl = TextEditingController();
  final _guarantorPhoneCtrl = TextEditingController();
  final _guarantorEmailCtrl = TextEditingController();
  final _step1Key = GlobalKey<FormState>();

  // Step 2 — documents
  String? _docType;
  final _docNumberCtrl = TextEditingController();
  DateTime? _docExpiry;
  XFile? _idDocFile;
  XFile? _incomeFile;
  XFile? _addressFile;
  final _step2Key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _employerCtrl.dispose();
    _incomeCtrl.dispose();
    _guarantorNameCtrl.dispose();
    _guarantorPhoneCtrl.dispose();
    _guarantorEmailCtrl.dispose();
    _docNumberCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    setState(() => _phase = _Phase.loading);
    try {
      final profile = await _repo.getProfile();
      if (!mounted) return;
      if (profile == null) {
        setState(() => _phase = _Phase.step1);
      } else {
        _existingProfile = profile;
        // Pre-fill form for potential update
        _employmentStatus = profile.employmentStatus;
        _employerCtrl.text = profile.employerName ?? '';
        _incomeCtrl.text = profile.monthlyIncome?.round().toString() ?? '';
        _hasGuarantor = profile.hasGuarantor;
        _guarantorNameCtrl.text = profile.guarantorName ?? '';
        _guarantorPhoneCtrl.text = profile.guarantorPhone ?? '';
        _guarantorEmailCtrl.text = profile.guarantorEmail ?? '';
        _docType = profile.idDocumentType;
        _docNumberCtrl.text = profile.idDocumentNumber ?? '';
        if (profile.idDocumentExpiry != null) {
          _docExpiry = DateTime.tryParse(profile.idDocumentExpiry!);
        }
        setState(() => _phase = _Phase.status);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMsg = AppErrors.translate(e);
        _phase = _Phase.error;
      });
    }
  }

  Future<void> _pickFile(_DocField field) async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    setState(() {
      switch (field) {
        case _DocField.id:
          _idDocFile = picked;
        case _DocField.income:
          _incomeFile = picked;
        case _DocField.address:
          _addressFile = picked;
      }
    });
  }

  Future<void> _pickExpiry() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _docExpiry ?? DateTime(now.year + 5),
      firstDate: now,
      lastDate: DateTime(now.year + 30),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme:
              const ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _docExpiry = picked);
  }

  Future<void> _submit() async {
    if (!(_step2Key.currentState?.validate() ?? false)) return;
    if (_idDocFile == null) {
      _showSnack("Veuillez fournir une photo de votre pièce d'identité");
      return;
    }
    if (_incomeFile == null) {
      _showSnack('Veuillez fournir un justificatif de revenus');
      return;
    }

    setState(() => _submitting = true);
    try {
      // 1. Upload documents
      final idUpload = await _repo.uploadDocument(_idDocFile!);
      final incomeUpload = await _repo.uploadDocument(_incomeFile!);
      String? addressUrl;
      if (_addressFile != null) {
        final r = await _repo.uploadDocument(_addressFile!);
        addressUrl = r.fileUrl;
      }

      // 2. Build body
      final body = <String, dynamic>{
        'propertyId': widget.propertyId,
        'employmentStatus': _employmentStatus,
        if (_employerCtrl.text.trim().isNotEmpty)
          'employerName': _employerCtrl.text.trim(),
        if (_incomeCtrl.text.trim().isNotEmpty)
          'monthlyIncome':
              (double.tryParse(_incomeCtrl.text.trim()) ?? 0).round(),
        'hasGuarantor': _hasGuarantor,
        if (_hasGuarantor && _guarantorNameCtrl.text.trim().isNotEmpty)
          'guarantorName': _guarantorNameCtrl.text.trim(),
        if (_hasGuarantor && _guarantorPhoneCtrl.text.trim().isNotEmpty)
          'guarantorPhone': _guarantorPhoneCtrl.text.trim(),
        if (_hasGuarantor && _guarantorEmailCtrl.text.trim().isNotEmpty)
          'guarantorEmail': _guarantorEmailCtrl.text.trim(),
        'idDocumentUrl': idUpload.fileUrl,
        if (_docType != null) 'idDocumentType': _docType,
        if (_docNumberCtrl.text.trim().isNotEmpty)
          'idDocumentNumber': _docNumberCtrl.text.trim(),
        if (_docExpiry != null)
          'idDocumentExpiry': _docExpiry!.toIso8601String().substring(0, 10),
        'incomeProofUrl': incomeUpload.fileUrl,
        if (addressUrl != null) 'addressProofUrl': addressUrl,
      };

      // 3. Create or update
      TenantProfile profile;
      if (_existingProfile != null) {
        profile = await _repo.updateProfile(body);
      } else {
        try {
          profile = await _repo.createProfile(body);
        } on ApiException catch (e) {
          if (e.isConflict) {
            // Already exists → patch instead
            profile = await _repo.updateProfile(body);
          } else {
            rethrow;
          }
        }
      }

      if (!mounted) return;
      setState(() {
        _existingProfile = profile;
        _phase = _Phase.status;
        _submitting = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      _showSnack(
        AppErrors.translate(e),
        isError: true,
      );
    }
  }

  Future<void> _submitDocsOnly() async {
    // Called from status screen when profile is INCOMPLETE (missing docs)
    if (_idDocFile == null) {
      _showSnack("Veuillez fournir une photo de votre pièce d'identité");
      return;
    }
    if (_incomeFile == null) {
      _showSnack('Veuillez fournir un justificatif de revenus');
      return;
    }
    setState(() => _submitting = true);
    try {
      final idUpload = await _repo.uploadDocument(_idDocFile!);
      final incomeUpload = await _repo.uploadDocument(_incomeFile!);
      String? addressUrl;
      if (_addressFile != null) {
        final r = await _repo.uploadDocument(_addressFile!);
        addressUrl = r.fileUrl;
      }

      final body = <String, dynamic>{
        'idDocumentUrl': idUpload.fileUrl,
        if (_docType != null) 'idDocumentType': _docType,
        if (_docNumberCtrl.text.trim().isNotEmpty)
          'idDocumentNumber': _docNumberCtrl.text.trim(),
        if (_docExpiry != null)
          'idDocumentExpiry': _docExpiry!.toIso8601String().substring(0, 10),
        'incomeProofUrl': incomeUpload.fileUrl,
        if (addressUrl != null) 'addressProofUrl': addressUrl,
      };

      final updated = await _repo.updateProfile(body);
      if (!mounted) return;
      setState(() {
        _existingProfile = updated;
        _submitting = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      _showSnack(
        AppErrors.translate(e),
        isError: true,
      );
    }
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red[700] : AppColors.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.dark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Ma candidature',
          style: AppTextStyles.regular20.copyWith(
            color: AppColors.dark,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: _phase == _Phase.step1 || _phase == _Phase.step2
            ? PreferredSize(
                preferredSize: const Size.fromHeight(4),
                child: _StepIndicator(
                  current: _phase == _Phase.step1 ? 0 : 1,
                  total: 2,
                ),
              )
            : null,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    switch (_phase) {
      case _Phase.loading:
        return const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        );
      case _Phase.step1:
        return _Step1Form(
          formKey: _step1Key,
          employmentStatus: _employmentStatus,
          employerCtrl: _employerCtrl,
          incomeCtrl: _incomeCtrl,
          hasGuarantor: _hasGuarantor,
          guarantorNameCtrl: _guarantorNameCtrl,
          guarantorPhoneCtrl: _guarantorPhoneCtrl,
          guarantorEmailCtrl: _guarantorEmailCtrl,
          onEmploymentChanged: (v) =>
              setState(() => _employmentStatus = v),
          onGuarantorChanged: (v) =>
              setState(() => _hasGuarantor = v),
          onNext: () {
            if (_step1Key.currentState?.validate() ?? false) {
              if (_employmentStatus == null) {
                _showSnack('Veuillez choisir votre statut professionnel');
                return;
              }
              setState(() => _phase = _Phase.step2);
            }
          },
        );
      case _Phase.step2:
        return _Step2Form(
          formKey: _step2Key,
          docType: _docType,
          docNumberCtrl: _docNumberCtrl,
          docExpiry: _docExpiry,
          idDocFile: _idDocFile,
          incomeFile: _incomeFile,
          addressFile: _addressFile,
          submitting: _submitting,
          onDocTypeChanged: (v) => setState(() => _docType = v),
          onPickExpiry: _pickExpiry,
          onPickFile: _pickFile,
          onBack: () => setState(() => _phase = _Phase.step1),
          onSubmit: _submit,
        );
      case _Phase.status:
        final profile = _existingProfile!;
        return _StatusView(
          profile: profile,
          propertyTitle: widget.propertyTitle,
          idDocFile: _idDocFile,
          incomeFile: _incomeFile,
          addressFile: _addressFile,
          docType: _docType,
          docNumberCtrl: _docNumberCtrl,
          docExpiry: _docExpiry,
          submitting: _submitting,
          onPickFile: _pickFile,
          onPickExpiry: _pickExpiry,
          onDocTypeChanged: (v) => setState(() => _docType = v),
          onSubmitDocs: _submitDocsOnly,
          onEdit: () => setState(() => _phase = _Phase.step1),
          onPayment: widget.onPayment,
        );
      case _Phase.error:
        return _ErrorView(
          message: _errorMsg ?? 'Erreur inconnue',
          onRetry: _loadProfile,
        );
    }
  }
}

// ─── Step indicator ────────────────────────────────────────────────────────────

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.current, required this.total});

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 8),
      child: Row(
        children: List.generate(total, (i) {
          final active = i <= current;
          return Expanded(
            child: Container(
              height: 4,
              margin: EdgeInsets.only(right: i < total - 1 ? 6 : 0),
              decoration: BoxDecoration(
                color: active ? AppColors.primary : const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ─── Step 1 — Professional info ────────────────────────────────────────────────

class _Step1Form extends StatelessWidget {
  const _Step1Form({
    required this.formKey,
    required this.employmentStatus,
    required this.employerCtrl,
    required this.incomeCtrl,
    required this.hasGuarantor,
    required this.guarantorNameCtrl,
    required this.guarantorPhoneCtrl,
    required this.guarantorEmailCtrl,
    required this.onEmploymentChanged,
    required this.onGuarantorChanged,
    required this.onNext,
  });

  final GlobalKey<FormState> formKey;
  final String? employmentStatus;
  final TextEditingController employerCtrl;
  final TextEditingController incomeCtrl;
  final bool hasGuarantor;
  final TextEditingController guarantorNameCtrl;
  final TextEditingController guarantorPhoneCtrl;
  final TextEditingController guarantorEmailCtrl;
  final ValueChanged<String?> onEmploymentChanged;
  final ValueChanged<bool> onGuarantorChanged;
  final VoidCallback onNext;

  bool get _showEmployer =>
      employmentStatus == 'EMPLOYED' ||
      employmentStatus == 'SELF_EMPLOYED';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionTitle(
              icon: Icons.work_outline_rounded,
              title: 'Situation professionnelle',
              subtitle:
                  'Ces informations nous permettent d\'évaluer votre candidature.',
            ),
            const SizedBox(height: 20),
            _Label('Statut professionnel *'),
            const SizedBox(height: 8),
            _DropdownField<String>(
              value: employmentStatus,
              hint: 'Choisir votre statut',
              items: _kEmploymentOptions
                  .map((e) => DropdownMenuItem(value: e.$1, child: Text(e.$2)))
                  .toList(),
              onChanged: onEmploymentChanged,
            ),
            if (_showEmployer) ...[
              const SizedBox(height: 14),
              _Label('Employeur / Entreprise'),
              const SizedBox(height: 8),
              _TextField(
                controller: employerCtrl,
                hint: 'Nom de l\'employeur',
              ),
            ],
            const SizedBox(height: 14),
            _Label('Revenu mensuel net (FCFA) *'),
            const SizedBox(height: 8),
            _TextField(
              controller: incomeCtrl,
              hint: 'Ex: 350 000',
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Champ requis' : null,
            ),
            const SizedBox(height: 20),
            _Divider(),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Avez-vous un garant ?',
                        style: AppTextStyles.regular12.copyWith(
                          color: AppColors.text,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        'Personne qui se porte caution pour vous',
                        style: AppTextStyles.regular12.copyWith(
                          color: AppColors.muted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: hasGuarantor,
                  onChanged: onGuarantorChanged,
                  activeThumbColor: AppColors.primary,
                  activeTrackColor: AppColors.primary.withValues(alpha: 0.4),
                ),
              ],
            ),
            if (hasGuarantor) ...[
              const SizedBox(height: 14),
              _Label('Nom complet du garant *'),
              const SizedBox(height: 8),
              _TextField(
                controller: guarantorNameCtrl,
                hint: 'Prénom et nom',
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Champ requis' : null,
              ),
              const SizedBox(height: 14),
              _Label('Téléphone du garant *'),
              const SizedBox(height: 8),
              _TextField(
                controller: guarantorPhoneCtrl,
                hint: '+225 07 00 00 00 00',
                keyboardType: TextInputType.phone,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Champ requis' : null,
              ),
              const SizedBox(height: 14),
              _Label('Email du garant'),
              const SizedBox(height: 8),
              _TextField(
                controller: guarantorEmailCtrl,
                hint: 'garant@email.com',
                keyboardType: TextInputType.emailAddress,
              ),
            ],
            const SizedBox(height: 28),
            OrangeButton(
              text: 'Continuer',
              onPressed: onNext,
              height: 50,
              borderRadius: 40,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Step 2 — Documents ────────────────────────────────────────────────────────

enum _DocField { id, income, address }

class _Step2Form extends StatelessWidget {
  const _Step2Form({
    required this.formKey,
    required this.docType,
    required this.docNumberCtrl,
    required this.docExpiry,
    required this.idDocFile,
    required this.incomeFile,
    required this.addressFile,
    required this.submitting,
    required this.onDocTypeChanged,
    required this.onPickExpiry,
    required this.onPickFile,
    required this.onBack,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final String? docType;
  final TextEditingController docNumberCtrl;
  final DateTime? docExpiry;
  final XFile? idDocFile;
  final XFile? incomeFile;
  final XFile? addressFile;
  final bool submitting;
  final ValueChanged<String?> onDocTypeChanged;
  final VoidCallback onPickExpiry;
  final void Function(_DocField) onPickFile;
  final VoidCallback onBack;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionTitle(
              icon: Icons.folder_copy_outlined,
              title: 'Vos documents',
              subtitle:
                  'Uploadez des photos lisibles de vos documents. Formats acceptés : JPG, PNG.',
            ),
            const SizedBox(height: 20),
            _Label("Type de pièce d'identité *"),
            const SizedBox(height: 8),
            _DropdownField<String>(
              value: docType,
              hint: 'Choisir le type',
              items: _kDocumentTypes
                  .map((e) => DropdownMenuItem(value: e.$1, child: Text(e.$2)))
                  .toList(),
              onChanged: onDocTypeChanged,
            ),
            const SizedBox(height: 14),
            _Label('Numéro de la pièce'),
            const SizedBox(height: 8),
            _TextField(
              controller: docNumberCtrl,
              hint: 'Ex: CI-123456789',
            ),
            const SizedBox(height: 14),
            _Label("Date d'expiration"),
            const SizedBox(height: 8),
            _DatePickerField(
              date: docExpiry,
              hint: 'Sélectionner une date',
              onTap: onPickExpiry,
            ),
            const SizedBox(height: 20),
            _Divider(),
            const SizedBox(height: 16),
            _UploadTile(
              label: "Pièce d'identité *",
              subtitle: 'CNI, passeport ou titre de séjour',
              file: idDocFile,
              onPick: () => onPickFile(_DocField.id),
            ),
            const SizedBox(height: 12),
            _UploadTile(
              label: 'Justificatif de revenus *',
              subtitle: 'Fiche de paie, relevé bancaire...',
              file: incomeFile,
              onPick: () => onPickFile(_DocField.income),
            ),
            const SizedBox(height: 12),
            _UploadTile(
              label: 'Justificatif de domicile',
              subtitle: 'Facture, quittance (optionnel)',
              file: addressFile,
              onPick: () => onPickFile(_DocField.address),
            ),
            const SizedBox(height: 28),
            if (submitting)
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(color: AppColors.primary),
                    SizedBox(height: 12),
                    Text(
                      'Upload en cours…',
                      style: TextStyle(color: AppColors.text, fontSize: 13),
                    ),
                  ],
                ),
              )
            else ...[
              OrangeButton(
                text: 'Soumettre ma candidature',
                onPressed: onSubmit,
                height: 50,
                borderRadius: 40,
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: onBack,
                  child: const Text(
                    'Retour',
                    style: TextStyle(color: AppColors.text),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Status view ───────────────────────────────────────────────────────────────

class _StatusView extends StatelessWidget {
  const _StatusView({
    required this.profile,
    required this.propertyTitle,
    required this.idDocFile,
    required this.incomeFile,
    required this.addressFile,
    required this.docType,
    required this.docNumberCtrl,
    required this.docExpiry,
    required this.submitting,
    required this.onPickFile,
    required this.onPickExpiry,
    required this.onDocTypeChanged,
    required this.onSubmitDocs,
    required this.onEdit,
    this.onPayment,
  });

  final TenantProfile profile;
  final String propertyTitle;
  final XFile? idDocFile;
  final XFile? incomeFile;
  final XFile? addressFile;
  final String? docType;
  final TextEditingController docNumberCtrl;
  final DateTime? docExpiry;
  final bool submitting;
  final void Function(_DocField) onPickFile;
  final VoidCallback onPickExpiry;
  final ValueChanged<String?> onDocTypeChanged;
  final VoidCallback onSubmitDocs;
  final VoidCallback onEdit;
  final VoidCallback? onPayment;

  ({Color bg, Color text, IconData icon, String label}) _statusInfo() {
    switch (profile.status) {
      case 'PENDING_REVIEW':
        return (
          bg: const Color(0xFFFFF7ED),
          text: const Color(0xFFEA580C),
          icon: Icons.hourglass_top_rounded,
          label: 'En cours de vérification',
        );
      case 'QUALIFIED':
        return (
          bg: const Color(0xFFECFDF5),
          text: const Color(0xFF16A34A),
          icon: Icons.check_circle_outline_rounded,
          label: 'Dossier validé',
        );
      case 'REJECTED':
        return (
          bg: const Color(0xFFFFF1F2),
          text: const Color(0xFFE11D48),
          icon: Icons.cancel_outlined,
          label: 'Dossier rejeté',
        );
      case 'BLACKLISTED':
        return (
          bg: const Color(0xFFF1F5F9),
          text: const Color(0xFF475569),
          icon: Icons.block_rounded,
          label: 'Dossier bloqué',
        );
      default: // INCOMPLETE
        return (
          bg: const Color(0xFFEFF6FF),
          text: const Color(0xFF2563EB),
          icon: Icons.edit_note_rounded,
          label: 'Dossier incomplet',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final info = _statusInfo();
    final incomplete = profile.status == 'INCOMPLETE';
    final rejected = profile.status == 'REJECTED';

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status badge
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: info.bg,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(info.icon, color: info.text, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        info.label,
                        style: TextStyle(
                          color: info.text,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          fontFamily: 'Lexend',
                        ),
                      ),
                      if (rejected &&
                          profile.rejectionReason != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          profile.rejectionReason!,
                          style: TextStyle(
                            color: info.text.withValues(alpha: 0.8),
                            fontSize: 12,
                            fontFamily: 'Lexend',
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Property card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.home_work_outlined,
                      color: AppColors.primary, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bien visé',
                        style: AppTextStyles.regular12.copyWith(
                          color: AppColors.muted,
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        propertyTitle,
                        style: AppTextStyles.regular12.copyWith(
                          color: AppColors.text,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Profile summary
          _InfoCard(
            title: 'Informations professionnelles',
            rows: [
              if (profile.employmentStatus != null)
                _infoRow('Statut', _labelFor(
                    profile.employmentStatus!, _kEmploymentOptions)),
              if (profile.monthlyIncome != null)
                _infoRow('Revenu mensuel',
                    '${_fmt(profile.monthlyIncome!.round())} FCFA'),
              if (profile.employerName != null)
                _infoRow('Employeur', profile.employerName!),
              _infoRow(
                  'Garant', profile.hasGuarantor ? 'Oui' : 'Non'),
            ],
          ),
          const SizedBox(height: 12),
          _InfoCard(
            title: 'Documents',
            rows: [
              _infoRow(
                  "Pièce d'identité",
                  profile.idDocumentUrl != null
                      ? '✓ Fournie'
                      : '✗ Manquante'),
              _infoRow(
                  'Justificatif de revenus',
                  profile.incomeProofUrl != null
                      ? '✓ Fourni'
                      : '✗ Manquant'),
              _infoRow(
                  'Justificatif de domicile',
                  profile.addressProofUrl != null
                      ? '✓ Fourni'
                      : 'Non fourni'),
            ],
          ),
          const SizedBox(height: 24),

          // Actions based on status
          if (incomplete) ...[
            Text(
              'Documents manquants',
              style: AppTextStyles.regular20.copyWith(
                  color: AppColors.text, fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            if (profile.idDocumentUrl == null)
              _UploadTile(
                label: "Pièce d'identité *",
                subtitle: 'CNI, passeport ou titre de séjour',
                file: idDocFile,
                onPick: () => onPickFile(_DocField.id),
              ),
            if (profile.idDocumentUrl == null) const SizedBox(height: 10),
            if (profile.incomeProofUrl == null)
              _UploadTile(
                label: 'Justificatif de revenus *',
                subtitle: 'Fiche de paie, relevé bancaire...',
                file: incomeFile,
                onPick: () => onPickFile(_DocField.income),
              ),
            if (profile.incomeProofUrl == null) const SizedBox(height: 10),
            if (profile.addressProofUrl == null)
              _UploadTile(
                label: 'Justificatif de domicile',
                subtitle: 'Facture, quittance (optionnel)',
                file: addressFile,
                onPick: () => onPickFile(_DocField.address),
              ),
            const SizedBox(height: 20),
            if (submitting)
              const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            else
              OrangeButton(
                text: 'Envoyer mes documents',
                onPressed: onSubmitDocs,
                height: 50,
                borderRadius: 40,
              ),
            const SizedBox(height: 12),
          ],

          if (profile.status == 'QUALIFIED' && onPayment != null) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.verified_rounded,
                      color: Color(0xFF16A34A), size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Votre dossier est validé. Vous pouvez procéder au paiement.',
                      style: AppTextStyles.regular12.copyWith(
                        color: const Color(0xFF16A34A),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            OrangeButton(
              text: 'Procéder au paiement',
              onPressed: onPayment!,
              height: 50,
              borderRadius: 40,
            ),
          ],

          if (rejected)
            OrangeButton(
              text: 'Modifier mon dossier',
              onPressed: onEdit,
              height: 50,
              borderRadius: 40,
            ),
        ],
      ),
    );
  }

  (String, String) _infoRow(String label, String value) => (label, value);

  String _labelFor(String value, List<(String, String)> options) {
    for (final o in options) {
      if (o.$1 == value) return o.$2;
    }
    return value;
  }

  String _fmt(int value) {
    final s = value.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      final fromEnd = s.length - i;
      buf.write(s[i]);
      if (fromEnd > 1 && fromEnd % 3 == 1) buf.write(' ');
    }
    return buf.toString();
  }
}

// ─── Error view ────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded,
                color: AppColors.muted, size: 56),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.regular12
                  .copyWith(color: AppColors.text, fontSize: 14),
            ),
            const SizedBox(height: 24),
            OrangeButton(
              text: 'Réessayer',
              onPressed: onRetry,
              height: 48,
              borderRadius: 40,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Shared small widgets ──────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.regular20.copyWith(
                  color: AppColors.dark,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTextStyles.regular12.copyWith(
                  color: AppColors.muted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.regular12.copyWith(
        color: AppColors.text,
        fontWeight: FontWeight.w500,
        fontSize: 13,
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: const Color(0xFFE7ECF2),
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
  });

  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      style: AppTextStyles.regular12.copyWith(
        color: AppColors.text,
        fontSize: 13,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            AppTextStyles.regular12.copyWith(color: AppColors.muted, fontSize: 13),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE7ECF2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE7ECF2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}

class _DropdownField<T> extends StatelessWidget {
  const _DropdownField({
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
  });

  final T? value;
  final String hint;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE7ECF2)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          hint: Text(
            hint,
            style: AppTextStyles.regular12
                .copyWith(color: AppColors.muted, fontSize: 13),
          ),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: AppColors.text),
          style: AppTextStyles.regular12.copyWith(
            color: AppColors.text,
            fontSize: 13,
          ),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _DatePickerField extends StatelessWidget {
  const _DatePickerField({
    required this.date,
    required this.hint,
    required this.onTap,
  });

  final DateTime? date;
  final String hint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final label = date != null
        ? '${date!.day.toString().padLeft(2, '0')}/'
            '${date!.month.toString().padLeft(2, '0')}/'
            '${date!.year}'
        : hint;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE7ECF2)),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_month_outlined,
                color: AppColors.muted, size: 18),
            const SizedBox(width: 10),
            Text(
              label,
              style: AppTextStyles.regular12.copyWith(
                color: date != null ? AppColors.text : AppColors.muted,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UploadTile extends StatelessWidget {
  const _UploadTile({
    required this.label,
    required this.subtitle,
    required this.file,
    required this.onPick,
  });

  final String label;
  final String subtitle;
  final XFile? file;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    final hasFile = file != null;
    return InkWell(
      onTap: onPick,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: hasFile ? AppColors.primary : const Color(0xFFE7ECF2),
            width: hasFile ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: hasFile
                    ? AppColors.primary.withValues(alpha: 0.12)
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Icon(
                hasFile
                    ? Icons.check_circle_outline_rounded
                    : Icons.upload_file_rounded,
                color: hasFile ? AppColors.primary : AppColors.muted,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.regular12.copyWith(
                      color: AppColors.text,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    hasFile ? file!.name : subtitle,
                    style: AppTextStyles.regular12.copyWith(
                      color: hasFile ? AppColors.primary : AppColors.muted,
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.muted,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.rows});

  final String title;
  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.regular12.copyWith(
              color: AppColors.text,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 10),
          ...rows.map((row) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        row.$1,
                        style: AppTextStyles.regular12.copyWith(
                          color: AppColors.muted,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        row.$2,
                        style: AppTextStyles.regular12.copyWith(
                          color: AppColors.text,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
