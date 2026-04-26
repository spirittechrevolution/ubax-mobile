import 'package:flutter/material.dart';

import 'package:statefulclickcounter/features/customer/profile/screens/ticket_sent_screen.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

class CreateTicketScreen extends StatefulWidget {
  const CreateTicketScreen({super.key});

  @override
  State<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  String? _problemType;
  String? _property;
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  int _urgency = 0; // 0 = Normal, 1 = Urgent

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Dark header
          Container(
            padding: EdgeInsets.fromLTRB(18, topPadding + 10, 18, 18),
            decoration: const BoxDecoration(
              color: AppColors.text,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white, size: 20),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Création de ticket',
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
              ],
            ),
          ),

          // ── Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type de problème
                  _FieldLabel('Type de problème'),
                  const SizedBox(height: 8),
                  _PillSelect(
                    value: _problemType,
                    placeholder: 'Sélectionner',
                    onTap: () async {
                      final v = await _pickOption(
                        title: 'Type de problème',
                        options: const [
                          'Electricité',
                          'Plomberie',
                          'Serrurerie',
                          'Maçonnerie',
                          'Autre',
                        ],
                        current: _problemType,
                      );
                      if (!mounted || v == null) return;
                      setState(() => _problemType = v);
                    },
                  ),
                  const SizedBox(height: 16),

                  // Bien concerné
                  _FieldLabel('Bien concerné'),
                  const SizedBox(height: 8),
                  _PillSelect(
                    value: _property,
                    placeholder: 'Sélectionner',
                    onTap: () async {
                      final v = await _pickOption(
                        title: 'Bien concerné',
                        options: const [
                          'Résidence Azalai – Apt 0025',
                          'Villa Cocody',
                        ],
                        current: _property,
                      );
                      if (!mounted || v == null) return;
                      setState(() => _property = v);
                    },
                  ),
                  const SizedBox(height: 16),

                  // Titre du problème
                  _FieldLabel('Titre du problème'),
                  const SizedBox(height: 8),
                  _PillInput(
                    controller: _titleController,
                    hint: 'saisir le titre',
                  ),
                  const SizedBox(height: 16),

                  // Description
                  _FieldLabel('Description'),
                  const SizedBox(height: 8),
                  _MultilineInput(
                    controller: _descController,
                    hint: 'Description ....',
                  ),
                  const SizedBox(height: 16),

                  // Ajouter des photos
                  _FieldLabel('Ajouter des photos'),
                  const SizedBox(height: 8),
                  _PhotoPicker(
                    onImport: () => print('import photos'),
                    onCapture: () => print('take photo'),
                  ),
                  const SizedBox(height: 16),

                  // Choisir le niveau d'urgence
                  _FieldLabel('Choisir le niveau d\'urgence'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _UrgencyPill(
                          label: 'Normal',
                          selected: _urgency == 0,
                          onTap: () => setState(() => _urgency = 0),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _UrgencyPill(
                          label: 'Urgent',
                          selected: _urgency == 1,
                          onTap: () => setState(() => _urgency = 1),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // ── Submit
          Container(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.dark,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const TicketSentScreen(
                          ticketNumber: 'UBX-SAV-0265',
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Envoyer le ticket',
                    style: AppTextStyles.button,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> _pickOption({
    required String title,
    required List<String> options,
    required String? current,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(title, style: AppTextStyles.sectionTitle),
            const SizedBox(height: 10),
            ...options.map(
              (o) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  o,
                  style: AppTextStyles.regular12.copyWith(
                    color: AppColors.text,
                    fontSize: 13,
                  ),
                ),
                trailing: current == o
                    ? const Icon(Icons.check_circle_rounded,
                        color: AppColors.text)
                    : const Icon(Icons.circle_outlined,
                        color: Color(0xFFCBD5E1)),
                onTap: () => Navigator.of(ctx).pop(o),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Sub-widgets ──────────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.sectionTitle.copyWith(fontSize: 13),
    );
  }
}

class _PillSelect extends StatelessWidget {
  const _PillSelect({
    required this.value,
    required this.placeholder,
    required this.onTap,
  });

  final String? value;
  final String placeholder;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null && value!.isNotEmpty;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                hasValue ? value! : placeholder,
                style: AppTextStyles.regular12.copyWith(
                  color: hasValue ? AppColors.dark : const Color(0xFF9CA3AF),
                  fontSize: 13,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.keyboard_arrow_down_rounded,
                color: AppColors.text),
          ],
        ),
      ),
    );
  }
}

class _PillInput extends StatelessWidget {
  const _PillInput({required this.controller, required this.hint});

  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: controller,
        style: AppTextStyles.regular12.copyWith(
          color: AppColors.text,
          fontSize: 13,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.regular12.copyWith(
            color: const Color(0xFF9CA3AF),
            fontSize: 13,
          ),
          border: InputBorder.none,
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        ),
      ),
    );
  }
}

class _MultilineInput extends StatelessWidget {
  const _MultilineInput({required this.controller, required this.hint});

  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: controller,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        style: AppTextStyles.regular12.copyWith(
          color: AppColors.text,
          fontSize: 13,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.regular12.copyWith(
            color: const Color(0xFF9CA3AF),
            fontSize: 13,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(14),
        ),
      ),
    );
  }
}

class _PhotoPicker extends StatelessWidget {
  const _PhotoPicker({required this.onImport, required this.onCapture});

  final VoidCallback onImport;
  final VoidCallback onCapture;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(
              'Ajouter des photos (max 5)',
              style: AppTextStyles.regular12.copyWith(
                color: AppColors.text,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Importer des photos (grey)
                _PickerButton(
                  icon: Icons.file_upload_outlined,
                  label: 'Importer des photos',
                  bg: const Color(0xFFD1D5DB),
                  fg: AppColors.dark,
                  onTap: onImport,
                ),
                const SizedBox(width: 10),
                // Prendre une photo (orange)
                _PickerButton(
                  icon: Icons.photo_camera_outlined,
                  label: 'Prendre une photo',
                  bg: AppColors.primary,
                  fg: Colors.white,
                  onTap: onCapture,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PickerButton extends StatelessWidget {
  const _PickerButton({
    required this.icon,
    required this.label,
    required this.bg,
    required this.fg,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color bg;
  final Color fg;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: fg, size: 14),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.regular12.copyWith(
                color: fg,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF64748B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;

    const dashWidth = 5.0;
    const dashSpace = 4.0;
    const radius = 14.0;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(radius),
    );
    final path = Path()..addRRect(rect);

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final len = (dashWidth).clamp(0.0, metric.length - distance).toDouble();
        canvas.drawPath(metric.extractPath(distance, distance + len), paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _UrgencyPill extends StatelessWidget {
  const _UrgencyPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.dark : Colors.white,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Text(
          label,
          style: AppTextStyles.regular12.copyWith(
            color: selected ? Colors.white : AppColors.dark,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
