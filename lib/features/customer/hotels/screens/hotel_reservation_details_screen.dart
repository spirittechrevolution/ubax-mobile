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
  'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
  'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre',
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
    this.propertyId = '',
  });

  final String imagePath;
  final String name;
  final String location;
  final int price;
  final double rating;
  final String propertyId;

  @override
  State<HotelReservationDetailsScreen> createState() =>
      _HotelReservationDetailsScreenState();
}

class _HotelReservationDetailsScreenState
    extends State<HotelReservationDetailsScreen> {
  late DateTime _arrival;
  late DateTime _departure;
  int _guests = 1;
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    _arrival = DateTime(tomorrow.year, tomorrow.month, tomorrow.day);
    _departure = _arrival.add(const Duration(days: 1));
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  int get _nights => _departure.difference(_arrival).inDays.clamp(1, 365);
  int get _totalAmount => _nights * widget.price;

  Future<void> _openArrivalPicker() async {
    final firstDate = DateTime.now().add(const Duration(days: 1));
    final result = await showDialog<List<DateTime>>(
      context: context,
      builder: (_) => HotelCalendarDialog(
        initialStart: _arrival,
        firstDate: firstDate,
        singleDate: true,
      ),
    );
    if (result != null && result.isNotEmpty) {
      setState(() {
        _arrival = result[0];
        if (!_departure.isAfter(_arrival)) {
          _departure = _arrival.add(const Duration(days: 1));
        }
      });
    }
  }

  Future<void> _openDeparturePicker() async {
    final firstDate = _arrival.add(const Duration(days: 1));
    final result = await showDialog<List<DateTime>>(
      context: context,
      builder: (_) => HotelCalendarDialog(
        initialStart: _departure,
        firstDate: firstDate,
        singleDate: true,
      ),
    );
    if (result != null && result.isNotEmpty) {
      setState(() => _departure = result[0]);
    }
  }

  bool get _isValid =>
      _departure.isAfter(_arrival) &&
      _arrival.isAfter(DateTime.now());

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
          'Demande de réservation',
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
          const SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Dates
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
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
                                onTap: _openArrivalPicker,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _DatePill(
                                label: 'Départ',
                                date: _formatDate(_departure),
                                onTap: _openDeparturePicker,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ── Guests
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        _sectionTitle('Invités'),
                        const Spacer(),
                        _CounterButton(
                          icon: Icons.remove,
                          filled: false,
                          onTap: () {
                            if (_guests > 1) setState(() => _guests--);
                          },
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 14),
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
                  ),

                  const SizedBox(height: 14),

                  // ── Notes
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionTitle('Demandes spéciales (optionnel)'),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _notesController,
                          maxLines: 4,
                          maxLength: 1000,
                          style: AppTextStyles.regular12.copyWith(
                            color: AppColors.text,
                            fontSize: 13,
                          ),
                          decoration: InputDecoration(
                            hintText:
                                'Ex: lit king-size, étage élevé, arrivée tardive…',
                            hintStyle: AppTextStyles.regular12.copyWith(
                              color: AppColors.muted,
                              fontSize: 12,
                            ),
                            filled: true,
                            fillColor: const Color(0xFFECF2F7),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.all(14),
                            counterStyle: AppTextStyles.regular12.copyWith(
                              color: AppColors.muted,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ── Price recap
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionTitle('Récapitulatif'),
                        const SizedBox(height: 12),
                        _PayRow(
                          label:
                              '${_fmt(widget.price)} Fcfa × $_nights nuit${_nights > 1 ? 's' : ''}',
                          value: '${_fmt(_totalAmount)} Fcfa',
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child:
                              Divider(color: Color(0xFFE5E7EB), height: 1),
                        ),
                        _PayRow(
                          label: 'Total estimé',
                          value: '${_fmt(_totalAmount)} Fcfa',
                          isBold: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Suivant
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
                  onPressed: _isValid
                      ? () {
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
                                nights: _nights,
                                totalAmount: _totalAmount,
                                notes: _notesController.text.trim(),
                                propertyId: widget.propertyId,
                              ),
                            ),
                          );
                        }
                      : null,
                  child: Text(
                    'Voir le récapitulatif',
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

  Widget _sectionTitle(String text) => Text(
        text,
        style: AppTextStyles.sectionTitle.copyWith(
          color: AppColors.text,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      );
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
                    fontSize: 13,
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
                fontSize: 13,
                fontWeight: FontWeight.w500,
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

// ─── Pay row ─────────────────────────────────────────────────────────────────

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
            color: isBold ? AppColors.primary : AppColors.text,
            fontSize: 13,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w300,
          ),
        ),
      ],
    );
  }
}
