import 'package:flutter/material.dart';

import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

class InvoiceDetailScreen extends StatelessWidget {
  const InvoiceDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                // Dark background (flat bottom, no radius)
                Container(
                  height: topPadding + 280,
                  color: AppColors.dark,
                ),
                // Card overlapping dark header
                SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(22, topPadding + 50, 22, 18),
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x10000000),
                              blurRadius: 16,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Avatar
                            ClipOval(
                              child: Image.asset(
                                'assets/images/pexels-ekrulila-2128329.jpg',
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 60,
                                  height: 60,
                                  color: const Color(0xFFD0DDE8),
                                  child: const Icon(Icons.person),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Arnaud Koffi',
                              style: AppTextStyles.sectionTitle.copyWith(
                                color: AppColors.dark,
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Contact info
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.phone_rounded,
                                    color: AppColors.muted, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  '+225 01 02 03 04 05',
                                  style: AppTextStyles.regular12.copyWith(
                                    color: AppColors.muted,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Icon(Icons.mail_outlined,
                                    color: AppColors.muted, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  'arnaud@gmail.com',
                                  style: AppTextStyles.regular12.copyWith(
                                    color: AppColors.muted,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            // Check-in / Check-out
                            Row(
                              children: [
                                Expanded(
                                    child: _DateBox(
                                        label: 'Check-in',
                                        date: '15 Mars 2026')),
                                const SizedBox(width: 12),
                                Expanded(
                                    child: _DateBox(
                                        label: 'Check-out',
                                        date: '18 Mars 2026')),
                              ],
                            ),
                            const SizedBox(height: 20),
                            // Info grid row 1
                            const Row(
                              children: [
                                Expanded(
                                    child: _InfoItem(
                                        label: 'Hotel',
                                        value: 'Résidence Azur')),
                                Expanded(
                                    child: _InfoItem(
                                        label: 'Adresse',
                                        value: 'Plateau, Abidjan')),
                                Expanded(
                                    child: _InfoItem(
                                        label: 'Type de réservation',
                                        value: 'Séjour hôtelier')),
                              ],
                            ),
                            const SizedBox(height: 14),
                            // Info grid row 2
                            const Row(
                              children: [
                                Expanded(
                                    child: _InfoItem(
                                        label: 'Nombre', value: '2 Adultes')),
                                Expanded(
                                    child: _InfoItem(
                                        label: 'Type de logement',
                                        value: 'Chambre Deluxe')),
                                Expanded(
                                    child: _InfoItem(
                                        label: 'Date de reservation',
                                        value: '18 Janvier 2026')),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Divider(color: Color(0xFFE5E7EB)),
                            const SizedBox(height: 16),
                            // Price section
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                          child: _PriceItem(
                                              label: 'Nuitée chambre Deluxe',
                                              value: '45 000 FCFA')),
                                      Expanded(
                                          child: _PriceItem(
                                              label: 'Nombre de nuits',
                                              value: '3')),
                                      Expanded(
                                          child: _PriceItem(
                                              label: 'Prix total',
                                              value: '135 000 FCFA')),
                                    ],
                                  ),
                                  SizedBox(height: 14),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: _PriceItem(
                                              label: 'Frais de service UBAX',
                                              value: '5 000 FCFA')),
                                      Expanded(
                                          child: _PriceItem(
                                              label: 'TVA 0%',
                                              value: '0 FCFA')),
                                      Expanded(
                                          child: _PriceItem(
                                              label: 'Total à payer',
                                              value: '140 000 FCFA',
                                              isBold: true)),
                                    ],
                                  ),
                                  SizedBox(height: 14),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: _PriceItem(
                                              label: 'Numéro de facture',
                                              value: 'UBX-HTL-2026-00124')),
                                      Expanded(
                                          child: _PriceItem(
                                              label: 'Mode de paiement',
                                              value: 'Mobile money',
                                              isOrange: true)),
                                      Expanded(
                                          child: _PriceItem(
                                              label: 'Date de facturation',
                                              value: '20 janvier 2026')),
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  Center(
                                    child: Icon(Icons.qr_code_2_rounded,
                                        size: 70, color: AppColors.dark),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Orange left border
                      Positioned(
                        left: 0,
                        top: 80,
                        bottom: 80,
                        child: Container(
                          width: 4,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Back + title (on top of scroll)
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
                            'Ma Facture',
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
          // Download button
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
}

// ─── Date box ─────────────────────────────────────────────────────────────────

class _DateBox extends StatelessWidget {
  const _DateBox({required this.label, required this.date});

  final String label;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_month_rounded,
              color: AppColors.muted, size: 18),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.sectionTitle.copyWith(
                  color: AppColors.dark,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                date,
                style: AppTextStyles.regular12.copyWith(
                  color: AppColors.muted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Info item ────────────────────────────────────────────────────────────────

class _InfoItem extends StatelessWidget {
  const _InfoItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.regular12.copyWith(
            color: AppColors.muted,
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: AppTextStyles.regular12.copyWith(
            color: AppColors.dark,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ─── Price item ───────────────────────────────────────────────────────────────

class _PriceItem extends StatelessWidget {
  const _PriceItem({
    required this.label,
    required this.value,
    this.isBold = false,
    this.isOrange = false,
  });

  final String label;
  final String value;
  final bool isBold;
  final bool isOrange;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isOrange ? AppColors.primary : AppColors.muted,
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: TextStyle(
            color: AppColors.dark,
            fontSize: isBold ? 12 : 11,
            fontWeight: isBold ? FontWeight.w900 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
