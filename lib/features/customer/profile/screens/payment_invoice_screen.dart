import 'package:flutter/material.dart';

import 'package:statefulclickcounter/features/customer/profile/screens/invoice_detail_screen.dart';
import 'package:statefulclickcounter/features/customer/profile/screens/invoice_payment_sheet.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';

// ─── Data ─────────────────────────────────────────────────────────────────────

enum _InvoiceStatus { impayee, payee, avance, enAttente }

class _Invoice {
  const _Invoice({
    required this.month,
    required this.year,
    required this.number,
    required this.amount,
    required this.status,
    this.dueDate,
  });

  final String month;
  final int year;
  final String number;
  final int amount;
  final _InvoiceStatus status;
  final String? dueDate;
}

const _kInvoices = [
  // Impayées
  _Invoice(
    month: 'Mars',
    year: 2026,
    number: 'N°202603A-8644',
    amount: 250000,
    status: _InvoiceStatus.impayee,
    dueDate: 'Échéance 10 - 03 - 2026',
  ),
  // Payées
  _Invoice(
    month: 'Février',
    year: 2026,
    number: 'N°202603A-8644',
    amount: 250000,
    status: _InvoiceStatus.payee,
  ),
  _Invoice(
    month: 'Janvier',
    year: 2026,
    number: 'N°202603A-8644',
    amount: 250000,
    status: _InvoiceStatus.payee,
  ),
  // Avance
  _Invoice(
    month: 'Décembre',
    year: 2025,
    number: 'N°202512A-8644',
    amount: 250000,
    status: _InvoiceStatus.avance,
  ),
  // En attente
  _Invoice(
    month: 'Avril',
    year: 2026,
    number: 'N°202604A-8644',
    amount: 250000,
    status: _InvoiceStatus.enAttente,
    dueDate: 'Échéance 10 - 04 - 2026',
  ),
];

// ─── Screen ───────────────────────────────────────────────────────────────────

class PaymentInvoiceScreen extends StatefulWidget {
  const PaymentInvoiceScreen({super.key});

  @override
  State<PaymentInvoiceScreen> createState() => _PaymentInvoiceScreenState();
}

class _PaymentInvoiceScreenState extends State<PaymentInvoiceScreen> {
  _InvoiceStatus _selectedTab = _InvoiceStatus.impayee;

  List<_Invoice> get _filtered =>
      _kInvoices.where((i) => i.status == _selectedTab).toList();

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Header
          Padding(
            padding: EdgeInsets.fromLTRB(18, topPadding + 10, 18, 14),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: AppColors.dark, size: 20),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      'Paiement Facture',
                      style: TextStyle(
                        color: AppColors.dark,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
              ],
            ),
          ),

          // ── Property card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x10000000),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      'assets/images/appartements-luxe.jpg',
                      width: 110,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 110,
                        height: 80,
                        color: const Color(0xFFE2E8F0),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Appartement Moderne à Cocody',
                          style: TextStyle(
                            color: AppColors.dark,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        const Row(
                          children: [
                            Icon(Icons.location_on,
                                color: AppColors.primary, size: 14),
                            SizedBox(width: 3),
                            Expanded(
                              child: Text(
                                'Cocody Angré, Abidjan – Côte d\'Ivoire',
                                style: TextStyle(
                                  color: AppColors.muted,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  height: 1.0,
                                ),
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            _MetaChip(
                                icon: Icons.bed_rounded, text: '3  Chambres'),
                            _MetaChip(
                                icon: Icons.bathtub_outlined,
                                text: '2  Salle de bains'),
                            _MetaChip(
                                icon: Icons.kitchen_rounded,
                                text: '1  Cuisine'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ── Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                children: [
                  _TabPill(
                    label: 'Impayée',
                    selected: _selectedTab == _InvoiceStatus.impayee,
                    onTap: () =>
                        setState(() => _selectedTab = _InvoiceStatus.impayee),
                  ),
                  _TabPill(
                    label: 'Payée',
                    selected: _selectedTab == _InvoiceStatus.payee,
                    onTap: () =>
                        setState(() => _selectedTab = _InvoiceStatus.payee),
                  ),
                  _TabPill(
                    label: 'Avance',
                    selected: _selectedTab == _InvoiceStatus.avance,
                    onTap: () =>
                        setState(() => _selectedTab = _InvoiceStatus.avance),
                  ),
                  _TabPill(
                    label: 'En attente',
                    selected: _selectedTab == _InvoiceStatus.enAttente,
                    onTap: () =>
                        setState(() => _selectedTab = _InvoiceStatus.enAttente),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ── Invoice list
          Expanded(
            child: _filtered.isEmpty
                ? const Center(
                    child: Text(
                      'Aucune facture',
                      style: TextStyle(
                        color: AppColors.muted,
                        fontSize: 14,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) => _InvoiceCard(invoice: _filtered[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

// ─── Tab pill ─────────────────────────────────────────────────────────────────

class _TabPill extends StatelessWidget {
  const _TabPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 38,
          decoration: BoxDecoration(
            color: selected ? AppColors.dark : Colors.transparent,
            borderRadius: BorderRadius.circular(50),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : AppColors.muted,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Invoice card ─────────────────────────────────────────────────────────────

class _InvoiceCard extends StatelessWidget {
  const _InvoiceCard({required this.invoice});

  final _Invoice invoice;

  void _openPaymentSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => InvoicePaymentSheet(
        amount: invoice.amount,
        onPaid: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const InvoiceDetailScreen()),
          );
        },
      ),
    );
  }

  void _openInvoice(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const InvoiceDetailScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPaid = invoice.status == _InvoiceStatus.payee;
    final isUnpaid = invoice.status == _InvoiceStatus.impayee;
    final isAvance = invoice.status == _InvoiceStatus.avance;
    final isEnAttente = invoice.status == _InvoiceStatus.enAttente;
    final showFacture = isPaid || isAvance;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border:
            isUnpaid ? Border.all(color: AppColors.primary, width: 1) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month + action
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${invoice.month} ${invoice.year}',
                      style: const TextStyle(
                        color: AppColors.dark,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      invoice.number,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              if (showFacture)
                GestureDetector(
                  onTap: () => _openInvoice(context),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.description_outlined,
                          color: AppColors.dark, size: 18),
                      SizedBox(width: 4),
                      Text(
                        'Voir la facture',
                        style: TextStyle(
                          color: AppColors.dark,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              if ((isUnpaid || isEnAttente) && invoice.dueDate != null)
                Text(
                  invoice.dueDate!,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          // Amount + button
          Row(
            children: [
              Text(
                '${_fmt(invoice.amount)} FCFA',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: isUnpaid ? () => _openPaymentSheet(context) : null,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                  decoration: BoxDecoration(
                    color: (isPaid || isAvance)
                        ? const Color(0xFF22C55E)
                        : isEnAttente
                            ? AppColors.primary
                            : AppColors.dark,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    (isPaid || isAvance)
                        ? 'Payé'
                        : isEnAttente
                            ? 'En attente'
                            : 'Payer',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
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

// ─── Meta chip ────────────────────────────────────────────────────────────────

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: AppColors.primary),
        const SizedBox(width: 3),
        Text(
          text,
          style: const TextStyle(
            color: AppColors.muted,
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
