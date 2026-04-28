import 'package:flutter/material.dart';

import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

class EtatDesLieuxScreen extends StatelessWidget {
  const EtatDesLieuxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Body with dark bg
          Expanded(
            child: Stack(
              children: [
                // Dark background (flat bottom)
                Container(
                  height: topPadding + 250,
                  color: AppColors.dark,
                ),

                SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(18, topPadding + 90, 18, 18),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //
                        Center(
                          child: Text(
                            'État des lieux',
                            style: AppTextStyles.sectionTitle.copyWith(
                              color: AppColors.primary,
                              fontSize: 22,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Informations générales
                        Text(
                          'Informations générales',
                          style: AppTextStyles.sectionTitle.copyWith(
                            color: AppColors.text,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _PlaceholderLine(width: 280),
                        const SizedBox(height: 8),
                        _PlaceholderLine(width: 220),
                        const SizedBox(height: 8),
                        _PlaceholderLine(width: 180),

                        const SizedBox(height: 28),

                        // Installations & équipements
                        Text(
                          'Installations & équipements',
                          style: AppTextStyles.sectionTitle.copyWith(
                            color: AppColors.text,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _EquipmentRow(width: 240),
                        const SizedBox(height: 8),
                        _EquipmentRow(width: 200),
                        const SizedBox(height: 8),
                        _EquipmentRow(width: 260),
                        const SizedBox(height: 8),
                        _EquipmentRow(width: 180),

                        const SizedBox(height: 24),

                        // Tableau
                        Table(
                          border: TableBorder.all(
                            color: const Color(0xFFE5E7EB),
                            width: 0.5,
                          ),
                          columnWidths: const {
                            0: FlexColumnWidth(2),
                            1: FlexColumnWidth(1),
                            2: FlexColumnWidth(1.5),
                          },
                          children: [
                            // Header
                            TableRow(
                              decoration: const BoxDecoration(
                                color: Color(0xFFF8F9FA),
                              ),
                              children: const [
                                _TableCell(text: 'Équipements', isHeader: true),
                                _TableCell(text: 'État', isHeader: true),
                                _TableCell(text: 'Remarques', isHeader: true),
                              ],
                            ),
                            // Rows
                            _tableDataRow(80),
                            _tableDataRow(100),
                            _tableDataRow(90),
                            _tableDataRow(60),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Back + title (on top)
                Positioned(
                  top: topPadding + 10,
                  left: 18,
                  right: 18,
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
                            'Etat des lieux',
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
              ],
            ),
          ),

          // ── Download button
          Container(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Télécharger',
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

  static TableRow _tableDataRow(double nameWidth) {
    return TableRow(
      children: [
        _TableCellPlaceholder(width: nameWidth),
        const _TableCellPlaceholder(width: 30),
        const _TableCellPlaceholder(width: 50),
      ],
    );
  }
}

// ─── Placeholder line ─────────────────────────────────────────────────────────

class _PlaceholderLine extends StatelessWidget {
  const _PlaceholderLine({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 10,
      decoration: BoxDecoration(
        color: const Color(0xFFFDE8D0),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

// ─── Equipment row (line + checkboxes) ────────────────────────────────────────

class _EquipmentRow extends StatelessWidget {
  const _EquipmentRow({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: width,
          height: 10,
          decoration: BoxDecoration(
            color: const Color(0xFFFDE8D0),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        const Spacer(),
        _checkbox(),
        const SizedBox(width: 6),
        _checkbox(),
      ],
    );
  }

  Widget _checkbox() {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: const Color(0xFFFDE8D0),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

// ─── Table cell ───────────────────────────────────────────────────────────────

class _TableCell extends StatelessWidget {
  const _TableCell({required this.text, this.isHeader = false});

  final String text;
  final bool isHeader;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.text,
          fontWeight: isHeader ? FontWeight.w600 : FontWeight.w400,
          fontSize: 11,
        ),
      ),
    );
  }
}

class _TableCellPlaceholder extends StatelessWidget {
  const _TableCellPlaceholder({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: Container(
        width: width,
        height: 8,
        decoration: BoxDecoration(
          color: const Color(0xFFFDE8D0),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
