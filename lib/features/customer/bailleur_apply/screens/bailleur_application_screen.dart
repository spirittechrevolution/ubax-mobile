import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:statefulclickcounter/core/di/injection.dart';
import 'package:statefulclickcounter/core/network/error_handler.dart';
import 'package:statefulclickcounter/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:statefulclickcounter/features/customer/bailleur_apply/data/models/agency_models.dart';
import 'package:statefulclickcounter/features/customer/bailleur_apply/domain/repositories/bailleur_apply_repository.dart';
import 'package:statefulclickcounter/features/customer/bailleur_apply/screens/bailleur_confirmation_screen.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

const _kIdTypes = [
  ('CNI', "Carte nationale d'identité"),
  ('PASSEPORT', 'Passeport'),
  ('PERMIS_CONDUIRE', 'Permis de conduire'),
  ('TITRE_SEJOUR', 'Titre de séjour'),
  ('CARTE_CONSULAIRE', 'Carte consulaire'),
];

class BailleurApplicationScreen extends StatefulWidget {
  const BailleurApplicationScreen({super.key, required this.agency});

  final AgencyItem agency;

  @override
  State<BailleurApplicationScreen> createState() =>
      _BailleurApplicationScreenState();
}

class _BailleurApplicationScreenState extends State<BailleurApplicationScreen> {
  final _repo = getIt<BailleurApplyRepository>();
  final _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  String? _idType;
  final _idNumberCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  XFile? _rectoFile;
  XFile? _versoFile;
  bool _submitting = false;
  String? _submitError;

  bool get _needsEmail {
    final user = context.read<AuthBloc>().state.currentUser;
    return user?.email == null || user!.email!.trim().isEmpty;
  }

  @override
  void dispose() {
    _idNumberCtrl.dispose();
    _emailCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage(bool isRecto) async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (file == null) return;
    setState(() {
      if (isRecto) {
        _rectoFile = file;
      } else {
        _versoFile = file;
      }
    });
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final needsEmail = _needsEmail;
    final email = _emailCtrl.text.trim();
    final idNumber = _idNumberCtrl.text.trim();
    final description = _descCtrl.text.trim();

    if (description.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length <
        10) {
      setState(() => _submitError = 'bailleur_apply.form.desc_too_short'.tr());
      return;
    }

    setState(() {
      _submitting = true;
      _submitError = null;
    });

    try {
      String? rectoUrl;
      String? versoUrl;

      if (_rectoFile != null) {
        final bytes = await _rectoFile!.readAsBytes();
        rectoUrl = await _repo.uploadDocument(bytes, _rectoFile!.name);
      }
      if (_versoFile != null) {
        final bytes = await _versoFile!.readAsBytes();
        versoUrl = await _repo.uploadDocument(bytes, _versoFile!.name);
      }

      final body = <String, dynamic>{
        'agencyId': widget.agency.id,
        'idType': _idType,
        'idNumber': idNumber,
        'description': description,
        if (rectoUrl != null) 'idDocRectoUrl': rectoUrl,
        if (versoUrl != null) 'idDocVersoUrl': versoUrl,
        if (needsEmail) 'email': email,
      };

      await _repo.apply(body);
      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const BailleurConfirmationScreen(),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _submitError =
            AppErrors.translate(e);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthBloc>().state.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'bailleur_apply.form.title'.tr(),
          style: AppTextStyles.regularlight16.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_submitError != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFECACA)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline_rounded,
                          color: Color(0xFFEF4444), size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _submitError!,
                          style: AppTextStyles.regular12.copyWith(
                            color: const Color(0xFFEF4444),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              SizedBox(
                height: 54,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        AppColors.primary.withValues(alpha: 0.6),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    _submitting
                        ? 'bailleur_apply.form.submitting'.tr()
                        : 'bailleur_apply.form.submit'.tr(),
                    style: AppTextStyles.regular12.copyWith(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: CustomScrollView(
          slivers: [
            // ── Hero agence
            SliverToBoxAdapter(
              child: _FormHero(agency: widget.agency),
            ),

            // ── Contenu formulaire
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // ── Informations personnelles
                  _SectionTitle('bailleur_apply.form.personal_section'.tr()),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _ReadOnlyField(
                          value: user?.firstName ?? '—',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ReadOnlyField(
                          value: user?.lastName ?? '—',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _ReadOnlyField(
                          value: user?.phone ?? '—',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _needsEmail
                            ? _EditableField(
                                controller: _emailCtrl,
                                hint: 'bailleur_apply.form.email_hint'.tr(),
                                keyboardType: TextInputType.emailAddress,
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return 'bailleur_apply.form.required'.tr();
                                  }
                                  if (!v.contains('@')) {
                                    return 'bailleur_apply.form.invalid_email'
                                        .tr();
                                  }
                                  return null;
                                },
                              )
                            : _ReadOnlyField(value: user?.email ?? '—'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ── Documents
                  _SectionTitle('bailleur_apply.form.id_section'.tr()),
                  const SizedBox(height: 12),

                  // Type de document
                  _DropdownField(
                    hint: 'bailleur_apply.form.id_type'.tr(),
                    value: _idType,
                    items: _kIdTypes
                        .map((t) => DropdownMenuItem(
                              value: t.$1,
                              child: Text(
                                t.$2,
                                style: AppTextStyles.regular12.copyWith(
                                  fontSize: 13,
                                  color: AppColors.text,
                                ),
                              ),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => _idType = v),
                    validator: (v) =>
                        v == null ? 'bailleur_apply.form.required'.tr() : null,
                  ),
                  const SizedBox(height: 10),

                  // Numéro document
                  _EditableField(
                    controller: _idNumberCtrl,
                    hint: 'bailleur_apply.form.id_number'.tr(),
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'bailleur_apply.form.required'.tr()
                        : null,
                  ),
                  const SizedBox(height: 10),

                  // Recto / Verso
                  Row(
                    children: [
                      Expanded(
                        child: _UploadButton(
                          label: 'bailleur_apply.form.recto'.tr(),
                          file: _rectoFile,
                          onTap: () => _pickImage(true),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _UploadButton(
                          label: 'bailleur_apply.form.verso'.tr(),
                          file: _versoFile,
                          onTap: () => _pickImage(false),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ── Message
                  _SectionTitle('bailleur_apply.form.desc_section'.tr()),
                  const SizedBox(height: 12),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x08000000),
                          blurRadius: 10,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: _descCtrl,
                      maxLines: 5,
                      maxLength: 1000,
                      style: AppTextStyles.regular12
                          .copyWith(color: AppColors.text, fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'bailleur_apply.form.desc_hint'.tr(),
                        hintStyle: AppTextStyles.regular12.copyWith(
                          color: AppColors.muted,
                          fontSize: 13,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16),
                        counterText: '',
                      ),
                      onChanged: (_) => setState(() {}),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'bailleur_apply.form.required'.tr();
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'max 1000 caractères',
                      style: AppTextStyles.regular12.copyWith(
                        fontSize: 11,
                        color: AppColors.muted,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Hero ─────────────────────────────────────────────────────────────────────

class _FormHero extends StatelessWidget {
  const _FormHero({required this.agency});

  final AgencyItem agency;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Stack(
        children: [
          SizedBox(
            height: 210 + topPadding,
            width: double.infinity,
            child: Image.asset(
              'assets/images/appartements-luxe.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: 210 + topPadding,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x99000000), Color(0xCC1A3047)],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            child: Column(
              children: [
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 2.5),
                    color: Colors.white,
                  ),
                  child: ClipOval(
                    child: agency.logoUrl != null
                        ? Image.network(
                            agency.logoUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                _LogoInitial(name: agency.name),
                          )
                        : _LogoInitial(name: agency.name),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  agency.name,
                  style: AppTextStyles.sectionTitle.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                if (agency.city != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    agency.city!,
                    style: AppTextStyles.regular12.copyWith(
                      fontSize: 12,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoInitial extends StatelessWidget {
  const _LogoInitial({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.dark,
      alignment: Alignment.center,
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : 'A',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 26,
          fontWeight: FontWeight.w700,
          fontFamily: 'Lexend',
        ),
      ),
    );
  }
}

// ─── Helpers UI ───────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.sectionTitle.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: AppColors.text,
      ),
    );
  }
}

BoxDecoration get _fieldDecoration => const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(14)),
      boxShadow: [
        BoxShadow(
          color: Color(0x08000000),
          blurRadius: 10,
          offset: Offset(0, 3),
        ),
      ],
    );

class _ReadOnlyField extends StatelessWidget {
  const _ReadOnlyField({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: _fieldDecoration,
      alignment: Alignment.centerLeft,
      child: Text(
        value,
        style: AppTextStyles.regular12.copyWith(
          fontSize: 13,
          color: AppColors.text,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _EditableField extends StatelessWidget {
  const _EditableField({
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.validator,
  });

  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _fieldDecoration,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: AppTextStyles.regular12
            .copyWith(color: AppColors.text, fontSize: 13),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.regular12
              .copyWith(color: AppColors.muted, fontSize: 13),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFEF4444)),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFEF4444)),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        validator: validator,
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
  });

  final String hint;
  final String? value;
  final List<DropdownMenuItem<String>> items;
  final ValueChanged<String?> onChanged;
  final FormFieldValidator<String?>? validator;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _fieldDecoration,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonFormField<String>(
        key: ValueKey(value),
        initialValue: value,
        hint: Text(
          hint,
          style: AppTextStyles.regular12
              .copyWith(color: AppColors.muted, fontSize: 13),
        ),
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: AppColors.muted,
        ),
        style: AppTextStyles.regular12
            .copyWith(color: AppColors.text, fontSize: 13),
        decoration: const InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 16),
        ),
        items: items,
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}

class _UploadButton extends StatelessWidget {
  const _UploadButton({
    required this.label,
    required this.file,
    required this.onTap,
  });

  final String label;
  final XFile? file;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasFile = file != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Color(0x08000000),
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
          border: hasFile
              ? Border.all(color: const Color(0xFF10B981), width: 1.5)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            hasFile
                ? const Icon(
                    Icons.check_circle_rounded,
                    size: 26,
                    color: Color(0xFF10B981),
                  )
                : Image.asset(
                    'assets/images/rectoverso.png',
                    width: 26,
                    height: 26,
                  ),
            const SizedBox(height: 6),
            Text(
              label,
              style: AppTextStyles.regular12.copyWith(
                fontSize: 12,
                color: hasFile ? const Color(0xFF10B981) : AppColors.text,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
