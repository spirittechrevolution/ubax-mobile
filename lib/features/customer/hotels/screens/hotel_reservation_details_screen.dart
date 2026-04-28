import 'package:flutter/material.dart';

import 'package:statefulclickcounter/features/customer/hotels/screens/hotel_reservation_screen.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

// ─── Helpers ─────────────────────────────────────────────────────────────────

String _fmt(int value) {
  final s = value.toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    final fromEnd = s.length - i;
    buf.write(s[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buf.write(' ');
  }
  return buf.toString().trim();
}

const _kMonths = [
  'Janvier',
  'Février',
  'Mars',
  'Avril',
  'Mai',
  'Juin',
  'Juillet',
  'Août',
  'Septembre',
  'Octobre',
  'Novembre',
  'Décembre',
];

String _formatDate(DateTime d) => '${d.day} ${_kMonths[d.month - 1]} ${d.year}';

class HotelReservationDetailsScreen extends StatefulWidget {
  const HotelReservationDetailsScreen({
    super.key,
    required this.imagePath,
    required this.name,
    required this.location,
    required this.price,
    required this.rating,
  });

  final String imagePath;
  final String name;
  final String location;
  final int price;
  final double rating;

  @override
  State<HotelReservationDetailsScreen> createState() =>
      _HotelReservationDetailsScreenState();
}

class _HotelReservationDetailsScreenState
    extends State<HotelReservationDetailsScreen> {
  DateTime _arrival = DateTime(2026, 3, 15);
  DateTime _departure = DateTime(2026, 3, 18);
  int _guests = 1;

  String _paymentMethod = 'Visa';
  String _paymentTitle = 'carte visa';
  String _paymentMask = '******6587';

  int get _nights => _departure.difference(_arrival).inDays.clamp(1, 365);
  int get _totalNights => _nights * widget.price;
  int get _adminFees => 2000;
  int get _totalPayment => _totalNights + _adminFees;

  Future<void> _openCalendar() async {
    final result = await showDialog<List<DateTime>>(
      context: context,
      builder: (_) => HotelCalendarDialog(
        initialStart: _arrival,
        initialEnd: _departure,
      ),
    );
    if (result != null && result.length == 2) {
      setState(() {
        _arrival = result[0];
        _departure = result[1];
      });
    }
  }

  Future<void> _openPaymentMethodSheet() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => HotelPaymentMethodSheet(currentMethod: _paymentMethod),
    );
    if (result == null) return;
    setState(() {
      _paymentMethod = result;
      switch (result) {
        case 'Wave':
          _paymentTitle = 'Wave';
          _paymentMask = '******1234';
          break;
        case 'Orange Money':
          _paymentTitle = 'Orange Money';
          _paymentMask = '******5678';
          break;
        case 'MTN':
          _paymentTitle = 'MTN';
          _paymentMask = '******9012';
          break;
        case 'Visa':
          _paymentTitle = 'carte visa';
          _paymentMask = '******6587';
          break;
        case 'Master Card':
          _paymentTitle = 'Master Card';
          _paymentMask = '******3456';
          break;
        default:
          _paymentTitle = result;
          _paymentMask = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.dark, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Détails de la reservation',
          style: AppTextStyles.sectionTitle.copyWith(
            color: AppColors.text,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 18),
              child: Container(
                height: 521,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle('Date'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _DatePill(
                            label: 'Arrivée',
                            date: _formatDate(_arrival),
                            onTap: _openCalendar,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _DatePill(
                            label: 'Départ',
                            date: _formatDate(_departure),
                            onTap: _openCalendar,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        _sectionTitle('Invité'),
                        const Spacer(),
                        _CounterButton(
                          icon: Icons.remove,
                          filled: false,
                          onTap: () {
                            if (_guests > 1) setState(() => _guests--);
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Text(
                            '$_guests',
                            style: AppTextStyles.sectionTitle.copyWith(
                              color: AppColors.text,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        _CounterButton(
                          icon: Icons.add,
                          filled: true,
                          onTap: () => setState(() => _guests++),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    _sectionTitle('Payé avec'),
                    const SizedBox(height: 12),
                    _PaymentMethodTile(
                      title: _paymentTitle,
                      mask: _paymentMask,
                      onEdit: _openPaymentMethodSheet,
                    ),
                    const SizedBox(height: 30),
                    _sectionTitle('Détails du paiement'),
                    const SizedBox(height: 12),
                    _PayRow(
                      label: 'Total : $_nights Nuités',
                      value: '${_fmt(_totalNights)} Fcfa',
                    ),
                    const SizedBox(height: 10),
                    _PayRow(
                      label: 'Frais administratifs',
                      value: '${_fmt(_adminFees)} Fcfa',
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Divider(color: Color(0xFFE5E7EB), height: 1),
                    ),
                    _PayRow(
                      label: 'Paiement totale:',
                      value: '${_fmt(_totalPayment)} Fcfa',
                      isBold: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Suivant
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 6, 18, 18),
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
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => HotelReservationSummaryScreen(
                          imagePath: widget.imagePath,
                          name: widget.name,
                          location: widget.location,
                          price: widget.price,
                          rating: widget.rating,
                          arrivalDate: _arrival,
                          departureDate: _departure,
                          guestCount: _guests,
                          totalNights: _totalNights,
                          adminFees: _adminFees,
                          totalPayment: _totalPayment,
                          nights: _nights,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'Suivant',
                    style: AppTextStyles.button.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: AppTextStyles.sectionTitle.copyWith(
        color: AppColors.text,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

// ─── Date pill ───────────────────────────────────────────────────────────────

class _DatePill extends StatelessWidget {
  const _DatePill({
    required this.label,
    required this.date,
    this.onTap,
  });

  final String label;
  final String date;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 165,
        height: 85,
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        decoration: BoxDecoration(
          color: const Color(0xFFECF2F7),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_month_outlined,
                    color: AppColors.dark, size: 16),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: AppColors.text,
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              date,
              style: AppTextStyles.regular12.copyWith(
                color: AppColors.text,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Counter button ──────────────────────────────────────────────────────────

class _CounterButton extends StatelessWidget {
  const _CounterButton({
    required this.icon,
    required this.filled,
    required this.onTap,
  });

  final IconData icon;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: filled ? AppColors.primary : const Color(0xFFF1F5F9),
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          color: filled ? Colors.white : AppColors.primary,
          size: 16,
        ),
      ),
    );
  }
}

// ─── Payment method tile ─────────────────────────────────────────────────────

class _PaymentMethodTile extends StatelessWidget {
  const _PaymentMethodTile({
    required this.title,
    required this.mask,
    required this.onEdit,
  });

  final String title;
  final String mask;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 14, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFEDF2F7),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.account_balance_wallet_outlined,
                color: AppColors.dark, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: AppColors.text,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (mask.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    mask,
                    style: AppTextStyles.regular12.copyWith(
                      color: AppColors.text,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ],
            ),
          ),
          GestureDetector(
            onTap: onEdit,
            child: Container(
              height: 30,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primary, width: 1),
              ),
              alignment: Alignment.center,
              child: Text(
                'Edit',
                style: AppTextStyles.regular12.copyWith(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Payment row ─────────────────────────────────────────────────────────────

class _PayRow extends StatelessWidget {
  const _PayRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  final String label;
  final String value;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.regular12.copyWith(
            color: isBold ? AppColors.dark : AppColors.muted,
            fontSize: 13,
            fontWeight: isBold ? FontWeight.w500 : FontWeight.w300,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.sectionTitle.copyWith(
            color: AppColors.text,
            fontSize: 13,
            fontWeight: isBold ? FontWeight.w500 : FontWeight.w300,
          ),
        ),
      ],
    );
  }
}
