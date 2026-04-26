import 'package:flutter/material.dart';

import 'package:statefulclickcounter/core/widgets/header_tab.dart';
import 'package:statefulclickcounter/features/customer/profile/screens/etat_des_lieux_screen.dart';
import 'package:statefulclickcounter/features/customer/profile/screens/reservation_invoice_screen.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

// ─── Data ─────────────────────────────────────────────────────────────────────

class _InvoiceData {
  const _InvoiceData({
    required this.number,
    required this.location,
    required this.amount,
    required this.month,
  });

  final String number;
  final String location;
  final int amount;
  final String month;
}

const _kInvoices = [
  _InvoiceData(
    number: 'Facture UBX-FAC-0265',
    location: 'Appartement – Cocody Angré',
    amount: 250000,
    month: 'Janvier 2026',
  ),
  _InvoiceData(
    number: 'Facture UBX-FAC-0264',
    location: 'Appartement – Cocody Angré',
    amount: 250000,
    month: 'Février 2026',
  ),
  _InvoiceData(
    number: 'Facture UBX-FAC-0263',
    location: 'Appartement – Cocody Angré',
    amount: 250000,
    month: 'Mars 2026',
  ),
  _InvoiceData(
    number: 'Facture UBX-FAC-0262',
    location: 'Appartement – Cocody Angré',
    amount: 250000,
    month: 'Avril 2026',
  ),
];

// ─── Screen ───────────────────────────────────────────────────────────────────

class FormalitiesScreen extends StatefulWidget {
  const FormalitiesScreen({super.key});

  @override
  State<FormalitiesScreen> createState() => _FormalitiesScreenState();
}

class _FormalitiesScreenState extends State<FormalitiesScreen> {
  int _tabIndex = 0; // 0 = Liste des factures, 1 = Etat des lieux

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Dark header
          Container(
            padding: EdgeInsets.fromLTRB(16, topPadding + 10, 16, 20),
            decoration: const BoxDecoration(
              color: AppColors.text,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // Title
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white, size: 20),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Formalités',
                          style: AppTextStyles.sectionTitle.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
                const SizedBox(height: 18),
                // Tabs
                Container(
                  height: 65,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF243E55),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    children: [
                      HeaderTab(
                        label: 'Liste des factures',
                        selected: _tabIndex == 0,
                        onTap: () => setState(() => _tabIndex = 0),
                      ),
                      HeaderTab(
                        label: 'Etat des lieux',
                        selected: _tabIndex == 1,
                        onTap: () => setState(() => _tabIndex = 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Body
          Expanded(
            child: _tabIndex == 0
                ? const _InvoiceListTab()
                : const _EtatDesLieuxTab(),
          ),
        ],
      ),
    );
  }
}

// ─── Tab 1: Liste des factures ────────────────────────────────────────────────

class _InvoiceListTab extends StatelessWidget {
  const _InvoiceListTab();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header row
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total',
                    style: AppTextStyles.sectionTitle.copyWith(
                        color: AppColors.textBlack,
                        fontSize: 11,
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '4 Factures',
                    style: AppTextStyles.regular12.copyWith(
                        color: AppColors.textBlack,
                        fontSize: 9,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                width: 151,
                height: 39,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Toutes les factures',
                      style: AppTextStyles.regular12.copyWith(
                          color: AppColors.text,
                          fontWeight: FontWeight.w400,
                          fontSize: 10),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.keyboard_arrow_down_rounded,
                        color: AppColors.text, size: 18),
                  ],
                ),
              ),
            ],
          ),
        ),
        // List
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
            itemCount: _kInvoices.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) => _InvoiceCard(invoice: _kInvoices[i]),
          ),
        ),
      ],
    );
  }
}

// ─── Invoice card ─────────────────────────────────────────────────────────────

class _InvoiceCard extends StatelessWidget {
  const _InvoiceCard({required this.invoice});

  final _InvoiceData invoice;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: const Border(
          top: BorderSide(color: AppColors.primary, width: 9),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon + number + month (same line)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // File icon
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0E6),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.description_outlined,
                    color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  invoice.number,
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: AppColors.text,
                    fontSize: 13,
                  ),
                ),
              ),
              Text(
                invoice.month,
                style: AppTextStyles.sectionTitle.copyWith(
                    color: AppColors.text,
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Location (second line, aligned with title)
          Padding(
            padding: const EdgeInsets.only(left: 44),
            child: Text(
              invoice.location,
              style: AppTextStyles.regular12.copyWith(
                color: AppColors.text,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Price
          Padding(
            padding: const EdgeInsets.only(left: 44),
            child: Text(
              '${_fmt(invoice.amount)} FCFA',
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),

          const SizedBox(height: 8),
          // Buttons row
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Voir la facture
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const ReservationInvoiceScreen()),
                  );
                },
                child: Container(
                  width: 97,
                  height: 33,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  alignment: Alignment.center,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.visibility_rounded,
                          color: AppColors.text, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'Voir la facture',
                        style: TextStyle(
                          color: AppColors.text,
                          fontWeight: FontWeight.w500,
                          fontSize: 8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Télécharger
              Container(
                width: 97,
                height: 33,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.text,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Télécharger',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _fmt(int value) {
    final s = value.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      final fromEnd = s.length - i;
      buf.write(s[i]);
      if (fromEnd > 1 && fromEnd % 3 == 1) buf.write(' ');
    }
    return buf.toString().trim();
  }
}

// ─── Tab 2: Etat des lieux ───────────────────────────────────────────────────

class _EtatDesLieuxTab extends StatelessWidget {
  const _EtatDesLieuxTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(11, 40, 11, 18),
      child: Container(
        width: double.infinity,
        height: 329,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 18),
            Text(
              'Etat des lieux',
              style: AppTextStyles.sectionTitle.copyWith(
                  color: AppColors.text,
                  fontWeight: FontWeight.w500,
                  fontSize: 18),
            ),
            const SizedBox(height: 19),
            // File row
            Container(
              height: 72,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.hardEdge,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    border: Border.all(
                      color: AppColors.primary,
                    )),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0E6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.description_outlined,
                          color: AppColors.primary, size: 16),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Etat des lieux .pdf',
                            style: AppTextStyles.sectionTitle.copyWith(
                              color: AppColors.text,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '200 KB',
                            style: AppTextStyles.regular12.copyWith(
                              color: AppColors.text,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.check_circle_rounded,
                        color: AppColors.primary, size: 22),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 47),
            // Telecharger button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.dark,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  'Telecharger',
                  style: AppTextStyles.button,
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Voir le document
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.dark,
                  side: const BorderSide(color: Color(0xFFE5E7EB)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const EtatDesLieuxScreen()),
                  );
                },
                icon: const Icon(Icons.visibility_rounded, size: 18),
                label: const Text(
                  'Voir le document',
                  style: AppTextStyles.button,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
