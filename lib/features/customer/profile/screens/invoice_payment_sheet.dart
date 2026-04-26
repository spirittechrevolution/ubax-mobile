import 'package:flutter/material.dart';

import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

// ─── Payment icons ────────────────────────────────────────────────────────────

const String _kWave = 'assets/icons/wave.png';
const String _kOrange = 'assets/icons/orangemoney.png';
const String _kMtn = 'assets/icons/mtn.png';
const String _kVisa = 'assets/icons/Visa.png';
const String _kMastercard = 'assets/icons/mastercard.png';

// ─── Payment Sheet ────────────────────────────────────────────────────────────

class InvoicePaymentSheet extends StatefulWidget {
  const InvoicePaymentSheet({
    super.key,
    required this.amount,
    required this.onPaid,
  });

  final int amount;
  final VoidCallback onPaid;

  @override
  State<InvoicePaymentSheet> createState() => _InvoicePaymentSheetState();
}

class _InvoicePaymentSheetState extends State<InvoicePaymentSheet> {
  int _selected = -1; // 0=wave,1=orange,2=mtn,3=visa,4=mastercard

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
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
            // Title + close
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Paiement Facture de location',
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.text,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close_rounded,
                      color: AppColors.text, size: 24),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Montant
            Row(
              children: [
                const Icon(Icons.language_rounded,
                    color: AppColors.text, size: 24),
                const SizedBox(width: 10),
                Text(
                  'Montant',
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: AppColors.text,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                Text(
                  '${_fmt(widget.amount)} FCFA',
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: AppColors.text,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Montant total
            Row(
              children: [
                const Icon(Icons.language_rounded,
                    color: AppColors.text, size: 24),
                const SizedBox(width: 10),
                Text(
                  'Montant total',
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: AppColors.text,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                Text(
                  '${_fmt(widget.amount)} FCFA',
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: AppColors.primary,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const Divider(color: Color(0xFFE5E7EB)),
            const SizedBox(height: 14),
            // Payment methods title
            Text(
              'Selectionner votre methode de paiement',
              style: AppTextStyles.sectionTitle.copyWith(
                color: AppColors.text,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 14),
            // Tiles: Wave, Orange, MTN
            Row(
              children: [
                Expanded(
                  child: _MethodTile(
                    label: 'Wave',
                    icon: _kWave,
                    selected: _selected == 0,
                    onTap: () => setState(() => _selected = 0),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MethodTile(
                    label: 'Orange Money',
                    icon: _kOrange,
                    selected: _selected == 1,
                    onTap: () => setState(() => _selected = 1),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MethodTile(
                    label: 'MTN',
                    icon: _kMtn,
                    selected: _selected == 2,
                    onTap: () => setState(() => _selected = 2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Visa
            _MethodRow(
              label: 'Visa',
              icon: _kVisa,
              selected: _selected == 3,
              onTap: () => setState(() => _selected = 3),
            ),
            const SizedBox(height: 10),
            // Mastercard
            _MethodRow(
              label: 'Master Card',
              icon: _kMastercard,
              selected: _selected == 4,
              onTap: () => setState(() => _selected = 4),
            ),
            const SizedBox(height: 10),
            // Add card
            _AddCardRow(),
            const SizedBox(height: 16),
            // Pay button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _selected >= 0 ? AppColors.dark : const Color(0xFFD1D5DB),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                onPressed: _selected >= 0
                    ? () {
                        Navigator.of(context).pop();
                        widget.onPaid();
                      }
                    : null,
                child: const Text(
                  'Payer',
                  style: AppTextStyles.button,
                ),
              ),
            ),
          ],
        ),
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

// ─── Method tile ──────────────────────────────────────────────────────────────

class _MethodTile extends StatelessWidget {
  const _MethodTile({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 74,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Image.asset(icon,
                  width: 22, height: 22, fit: BoxFit.contain),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: selected ? Colors.white : AppColors.dark,
                fontWeight: FontWeight.w500,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Method row ───────────────────────────────────────────────────────────────

class _MethodRow extends StatelessWidget {
  const _MethodRow({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Image.asset(icon, width: 32, height: 32, fit: BoxFit.contain),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFCBD5E1)),
                borderRadius: BorderRadius.circular(6),
                color: selected ? AppColors.primary : Colors.transparent,
              ),
              child: selected
                  ? const Icon(Icons.check_rounded,
                      size: 16, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Add card row ─────────────────────────────────────────────────────────────

class _AddCardRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB).withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child:
                const Icon(Icons.add, color: Color(0xFF2563EB), size: 18),
          ),
          const SizedBox(width: 12),
          const Text(
            'Ajouter une carte de débit',
            style: TextStyle(
              color: AppColors.text,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
