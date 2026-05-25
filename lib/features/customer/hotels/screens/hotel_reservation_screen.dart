import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:statefulclickcounter/core/network/error_handler.dart';
import 'package:statefulclickcounter/features/customer/hotels/data/models/reservation_models.dart';
import 'package:statefulclickcounter/features/customer/hotels/domain/repositories/reservation_repository.dart';
import 'package:statefulclickcounter/features/customer/profile/screens/reservations_screen.dart';
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

String _formatDateFull(DateTime d) =>
    '${d.day} ${_kMonths[d.month - 1]} ${d.year}';

String _isoDate(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

// ─── Screen 1: HotelReservationScreen (kept for backward compat) ──────────────

class HotelReservationScreen extends StatefulWidget {
  const HotelReservationScreen({
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
  State<HotelReservationScreen> createState() => _HotelReservationScreenState();
}

class _HotelReservationScreenState extends State<HotelReservationScreen> {
  late DateTime _arrivalDate;
  late DateTime _departureDate;
  int _guestCount = 1;

  @override
  void initState() {
    super.initState();
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    _arrivalDate = DateTime(tomorrow.year, tomorrow.month, tomorrow.day);
    _departureDate = _arrivalDate.add(const Duration(days: 1));
  }

  int get _nights =>
      _departureDate.difference(_arrivalDate).inDays.clamp(1, 365);
  int get _totalAmount => _nights * widget.price;

  void _openCalendar() async {
    final firstDate = DateTime.now().add(const Duration(days: 1));
    final result = await showDialog<List<DateTime>>(
      context: context,
      builder: (_) => HotelCalendarDialog(
        initialStart: _arrivalDate,
        initialEnd: _departureDate,
        firstDate: firstDate,
      ),
    );
    if (result != null && result.length == 2) {
      setState(() {
        _arrivalDate = result[0];
        _departureDate = result[1];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.dark, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Demande de réservation',
          style: AppTextStyles.sectionTitle.copyWith(
            color: AppColors.text,
            fontSize: 17,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: _openCalendar,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date',
                            style: AppTextStyles.sectionTitle.copyWith(
                              color: AppColors.text,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Arrivée',
                                        style: AppTextStyles.regular12
                                            .copyWith(color: AppColors.text)),
                                    const SizedBox(height: 4),
                                    Text(
                                      _formatDateFull(_arrivalDate),
                                      style: AppTextStyles.sectionTitle
                                          .copyWith(
                                              color: AppColors.text,
                                              fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                  width: 1,
                                  height: 40,
                                  color: const Color(0xFFE5E7EB)),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Départ',
                                          style: AppTextStyles.regular12
                                              .copyWith(color: AppColors.text)),
                                      const SizedBox(height: 4),
                                      Text(
                                        _formatDateFull(_departureDate),
                                        style: AppTextStyles.sectionTitle
                                            .copyWith(
                                                color: AppColors.text,
                                                fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Icon(Icons.calendar_today_rounded,
                                  color: AppColors.primary, size: 20),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Text('Invité',
                            style: AppTextStyles.sectionTitle
                                .copyWith(color: AppColors.text, fontSize: 15)),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            if (_guestCount > 1) {
                              setState(() => _guestCount--);
                            }
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: const Color(0xFFE5E7EB), width: 1.5),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(Icons.remove,
                                color: AppColors.dark, size: 18),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text('$_guestCount',
                              style: const TextStyle(
                                  color: AppColors.text,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16)),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => _guestCount++),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primary),
                            alignment: Alignment.center,
                            child: const Icon(Icons.add,
                                color: Colors.white, size: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('Détails du paiement',
                      style: AppTextStyles.sectionTitle
                          .copyWith(color: AppColors.text, fontSize: 15)),
                  const SizedBox(height: 14),
                  _PaymentRow(
                    label: 'Total $_nights Nuitées',
                    value: '${_fmt(_totalAmount)} Fcfa',
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(color: Color(0xFFE5E7EB)),
                  ),
                  _PaymentRow(
                    label: 'Total estimé',
                    value: '${_fmt(_totalAmount)} Fcfa',
                    isBold: true,
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 10,
                    offset: Offset(0, -4))
              ],
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.dark,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
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
                          arrivalDate: _arrivalDate,
                          departureDate: _departureDate,
                          guestCount: _guestCount,
                          nights: _nights,
                          totalAmount: _totalAmount,
                          propertyId: widget.propertyId,
                        ),
                      ),
                    );
                  },
                  child: const Text('Suivant', style: AppTextStyles.button),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Payment row helper ──────────────────────────────────────────────────────

class _PaymentRow extends StatelessWidget {
  const _PaymentRow({
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
          style: TextStyle(
            color: const Color(0xFF171725),
            fontWeight: isBold ? FontWeight.w500 : FontWeight.w300,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: const Color(0xFF171725),
            fontWeight: isBold ? FontWeight.w500 : FontWeight.w300,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

// ─── Payment Method Bottom Sheet ─────────────────────────────────────────────

class HotelPaymentMethodSheet extends StatefulWidget {
  const HotelPaymentMethodSheet({super.key, required this.currentMethod});

  final String currentMethod;

  @override
  State<HotelPaymentMethodSheet> createState() =>
      HotelPaymentMethodSheetState();
}

class HotelPaymentMethodSheetState extends State<HotelPaymentMethodSheet> {
  late String _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.currentMethod;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: const Color(0xFFD0DDE8),
                  borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Text('Selectionner votre methode de paiement',
                      style: AppTextStyles.sectionTitle.copyWith(
                          color: AppColors.text,
                          fontSize: 13,
                          fontWeight: FontWeight.w500)),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close, color: AppColors.dark),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _PaymentTile(
                iconAsset: 'assets/icons/wave.png',
                label: 'Wave',
                isSelected: _selected == 'Wave',
                onTap: () => setState(() => _selected = 'Wave')),
            const SizedBox(height: 10),
            _PaymentTile(
                iconAsset: 'assets/icons/orangemoney.png',
                label: 'Orange Money',
                isSelected: _selected == 'Orange Money',
                onTap: () => setState(() => _selected = 'Orange Money')),
            const SizedBox(height: 10),
            _PaymentTile(
                iconAsset: 'assets/icons/mtn.png',
                label: 'MTN',
                isSelected: _selected == 'MTN',
                onTap: () => setState(() => _selected = 'MTN')),
            const SizedBox(height: 10),
            _PaymentTile(
                iconAsset: 'assets/icons/Visa.png',
                label: 'Visa',
                isSelected: _selected == 'Visa',
                onTap: () => setState(() => _selected = 'Visa')),
            const SizedBox(height: 10),
            _PaymentTile(
                iconAsset: 'assets/icons/mastercard.png',
                label: 'Master Card',
                isSelected: _selected == 'Master Card',
                onTap: () => setState(() => _selected = 'Master Card')),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.dark,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                ),
                onPressed: () => Navigator.of(context).pop(_selected),
                child: const Text('Choisir', style: AppTextStyles.button),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  const _PaymentTile({
    required this.iconAsset,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String iconAsset;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(14),
          border: isSelected
              ? Border.all(color: AppColors.primary, width: 1.5)
              : null,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(iconAsset,
                  width: 36,
                  height: 36,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                            color: const Color(0xFFD0DDE8),
                            borderRadius: BorderRadius.circular(8)),
                        alignment: Alignment.center,
                        child: const Icon(Icons.payment, size: 18),
                      )),
            ),
            const SizedBox(width: 12),
            Expanded(
                child: Text(label,
                    style: const TextStyle(
                        color: AppColors.text,
                        fontWeight: FontWeight.w600,
                        fontSize: 13))),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : const Color(0xFFD0DDE8),
                    width: 2),
                color: isSelected ? AppColors.primary : Colors.transparent,
              ),
              alignment: Alignment.center,
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 14)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── AddCardScreen ────────────────────────────────────────────────────────────

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final _cardNumberController =
      TextEditingController(text: '2894 - 4389 - 4432 - 9432');
  final _nameController = TextEditingController(text: 'Franck Ouattara');
  final _expirationController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _nameController.dispose();
    _expirationController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.dark, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Ajouter une carte',
            style: AppTextStyles.sectionTitle
                .copyWith(color: AppColors.text, fontSize: 17)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF1A3047), Color(0xFF2C4A63)],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Maestro Kard',
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                                fontWeight: FontWeight.w500)),
                        const SizedBox(height: 24),
                        Text(_cardNumberController.text,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2)),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Prenom',
                                    style: TextStyle(
                                        color: Colors.white54, fontSize: 11)),
                                const SizedBox(height: 2),
                                Text(
                                    _nameController.text.isEmpty
                                        ? 'Prenom'
                                        : _nameController.text,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                            Row(
                              children: List.generate(
                                2,
                                (i) => Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: i == 0
                                        ? const Color(0xB3F44336)
                                        : const Color(0xB3FF9800),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 10,
                    offset: Offset(0, -4))
              ],
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.dark,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Ajouter la carte',
                      style: AppTextStyles.button),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Calendar Dialog ──────────────────────────────────────────────────────────

class HotelCalendarDialog extends StatefulWidget {
  const HotelCalendarDialog({
    super.key,
    required this.initialStart,
    this.initialEnd,
    this.firstDate,
    this.singleDate = false,
  });

  final DateTime initialStart;
  final DateTime? initialEnd;
  final DateTime? firstDate;
  final bool singleDate;

  @override
  State<HotelCalendarDialog> createState() => HotelCalendarDialogState();
}

class HotelCalendarDialogState extends State<HotelCalendarDialog> {
  late DateTime _displayMonth;
  late DateTime? _startDate;
  late DateTime? _endDate;
  bool _selectingEnd = false;

  @override
  void initState() {
    super.initState();
    _displayMonth =
        DateTime(widget.initialStart.year, widget.initialStart.month);
    _startDate = widget.initialStart;
    _endDate = widget.initialEnd;
  }

  bool _isDisabled(DateTime date) {
    final min = widget.firstDate;
    if (min == null) return false;
    final minDay = DateTime(min.year, min.month, min.day);
    final day = DateTime(date.year, date.month, date.day);
    return day.isBefore(minDay);
  }

  void _onDayTap(DateTime day) {
    if (_isDisabled(day)) return;
    if (widget.singleDate) {
      Navigator.of(context).pop([day]);
      return;
    }
    setState(() {
      if (!_selectingEnd || (_startDate != null && day.isBefore(_startDate!))) {
        _startDate = day;
        _endDate = null;
        _selectingEnd = true;
      } else {
        _endDate = day;
        _selectingEnd = false;
      }
    });
  }

  int _daysInMonth(DateTime month) =>
      DateTime(month.year, month.month + 1, 0).day;

  int _firstWeekday(DateTime month) =>
      DateTime(month.year, month.month, 1).weekday % 7;

  @override
  Widget build(BuildContext context) {
    final daysInMonth = _daysInMonth(_displayMonth);
    final firstWeekday = _firstWeekday(_displayMonth);

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Selectionner Date',
                style: AppTextStyles.sectionTitle
                    .copyWith(color: AppColors.text, fontSize: 17)),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => setState(() => _displayMonth =
                      DateTime(_displayMonth.year, _displayMonth.month - 1)),
                  child: const Icon(Icons.chevron_left,
                      color: AppColors.dark, size: 28),
                ),
                Text(
                  '${_kMonths[_displayMonth.month - 1]} ${_displayMonth.year}',
                  style: AppTextStyles.sectionTitle
                      .copyWith(color: AppColors.text),
                ),
                GestureDetector(
                  onTap: () => setState(() => _displayMonth =
                      DateTime(_displayMonth.year, _displayMonth.month + 1)),
                  child: const Icon(Icons.chevron_right,
                      color: AppColors.dark, size: 28),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                _WeekdayLabel('Dim'),
                _WeekdayLabel('Lun'),
                _WeekdayLabel('Mar'),
                _WeekdayLabel('Mer'),
                _WeekdayLabel('Jeu'),
                _WeekdayLabel('Ven'),
                _WeekdayLabel('Sam'),
              ],
            ),
            const SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
              ),
              itemCount: firstWeekday + daysInMonth,
              itemBuilder: (context, index) {
                if (index < firstWeekday) return const SizedBox();
                final day = index - firstWeekday + 1;
                final date =
                    DateTime(_displayMonth.year, _displayMonth.month, day);
                final disabled = _isDisabled(date);

                final isStart = _startDate != null &&
                    date.year == _startDate!.year &&
                    date.month == _startDate!.month &&
                    date.day == _startDate!.day;
                final isEnd = _endDate != null &&
                    date.year == _endDate!.year &&
                    date.month == _endDate!.month &&
                    date.day == _endDate!.day;
                final isBetween = _startDate != null &&
                    _endDate != null &&
                    date.isAfter(_startDate!) &&
                    date.isBefore(_endDate!);

                Color? bgColor;
                Color textColor =
                    disabled ? const Color(0xFFCBD5E1) : AppColors.dark;

                if (!disabled) {
                  if (isStart) {
                    bgColor = AppColors.primary;
                    textColor = Colors.white;
                  } else if (isEnd) {
                    bgColor = const Color(0xFFE85D3A);
                    textColor = Colors.white;
                  } else if (isBetween) {
                    bgColor = AppColors.dark;
                    textColor = Colors.white;
                  }
                }

                return GestureDetector(
                  onTap: disabled ? null : () => _onDayTap(date),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: bgColor,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$day',
                      style: TextStyle(
                        color: textColor,
                        fontWeight: (isStart || isEnd)
                            ? FontWeight.w700
                            : FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Annuler',
                        style: AppTextStyles.button
                            .copyWith(color: AppColors.primary)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 46,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.dark,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                      ),
                      onPressed: _startDate != null
                          ? () => Navigator.of(context).pop(
                                widget.singleDate
                                    ? [_startDate!]
                                    : (_endDate != null
                                        ? [_startDate!, _endDate!]
                                        : null),
                              )
                          : null,
                      child:
                          const Text('Appliquer', style: AppTextStyles.button),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WeekdayLabel extends StatelessWidget {
  const _WeekdayLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: AppTextStyles.regular12
            .copyWith(color: AppColors.text, fontWeight: FontWeight.w600),
      ),
    );
  }
}

// ─── Summary Screen ───────────────────────────────────────────────────────────

class HotelReservationSummaryScreen extends StatefulWidget {
  const HotelReservationSummaryScreen({
    super.key,
    required this.imagePath,
    required this.name,
    required this.location,
    required this.price,
    required this.rating,
    required this.arrivalDate,
    required this.departureDate,
    required this.guestCount,
    required this.nights,
    required this.totalAmount,
    this.notes = '',
    this.propertyId = '',
  });

  final String imagePath;
  final String name;
  final String location;
  final int price;
  final double rating;
  final DateTime arrivalDate;
  final DateTime departureDate;
  final int guestCount;
  final int nights;
  final int totalAmount;
  final String notes;
  final String propertyId;

  @override
  State<HotelReservationSummaryScreen> createState() =>
      _HotelReservationSummaryScreenState();
}

class _HotelReservationSummaryScreenState
    extends State<HotelReservationSummaryScreen> {
  bool _loading = false;
  String? _error;
  String _paymentMethod = 'Sélectionner paiement';

  Future<void> _openPaymentMethodSheet() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => HotelPaymentMethodSheet(currentMethod: _paymentMethod),
    );
    if (result != null && mounted) {
      setState(() => _paymentMethod = result);
    }
  }

  Future<void> _submit() async {
    if (widget.propertyId.isEmpty) {
      setState(() {
        _error =
            'Ce bien n\'est pas disponible à la réservation en ligne. Contactez l\'hôtel directement.';
      });
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final repo = GetIt.instance<ReservationRepository>();
      final response = await repo.createReservation(
        ReservationRequest(
          propertyId: widget.propertyId,
          checkInDate: _isoDate(widget.arrivalDate),
          checkOutDate: _isoDate(widget.departureDate),
          guestCount: widget.guestCount,
          notes: widget.notes.isEmpty ? null : widget.notes,
        ),
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ReservationSuccessScreen(reservation: response),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = AppErrors.translate(e);
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateRange =
        '${_formatDateFull(widget.arrivalDate)} → ${_formatDateFull(widget.departureDate)}';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.dark, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Récapitulatif',
            style: AppTextStyles.sectionTitle
                .copyWith(color: AppColors.text, fontSize: 17)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Property card
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18)),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            widget.imagePath,
                            width: 90,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                                width: 90,
                                height: 80,
                                color: const Color(0xFFE2E8F0)),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.name,
                                style: AppTextStyles.sectionTitle.copyWith(
                                    color: AppColors.text,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.location_on_outlined,
                                      size: 13, color: AppColors.dark),
                                  const SizedBox(width: 3),
                                  Expanded(
                                    child: Text(
                                      widget.location,
                                      style: AppTextStyles.regular12.copyWith(
                                          color: AppColors.text, fontSize: 11),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text.rich(TextSpan(children: [
                                TextSpan(
                                  text: '${_fmt(widget.price)} ',
                                  style: const TextStyle(
                                      fontFamily: 'Lexend',
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14),
                                ),
                                const TextSpan(
                                  text: 'FCFA / nuit',
                                  style: TextStyle(
                                      fontFamily: 'Lexend',
                                      color: AppColors.text,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 11),
                                ),
                              ])),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ── Payment method

                  const SizedBox(height: 18),

                  // ── Reservation details
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border:
                          Border.all(color: const Color(0xFFE5E7EB), width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Votre réservation',
                            style: AppTextStyles.sectionTitle
                                .copyWith(color: AppColors.primary)),
                        const SizedBox(height: 14),
                        _SummaryRow(
                          icon: Icons.calendar_month_outlined,
                          label: 'Dates',
                          value: dateRange,
                        ),
                        const SizedBox(height: 10),
                        _SummaryRow(
                          icon: Icons.nights_stay_outlined,
                          label: 'Durée',
                          value:
                              '${widget.nights} nuit${widget.nights > 1 ? 's' : ''}',
                        ),
                        const SizedBox(height: 10),
                        _SummaryRow(
                          icon: Icons.person_outline_rounded,
                          label: 'Invités',
                          value: '${widget.guestCount} '
                              'personne${widget.guestCount > 1 ? 's' : ''}',
                        ),
                        if (widget.notes.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          _SummaryRow(
                            icon: Icons.notes_rounded,
                            label: 'Demandes',
                            value: widget.notes,
                          ),
                        ],
                        const SizedBox(height: 14),
                        const Divider(color: Color(0xFFE5E7EB), height: 1),
                        const SizedBox(height: 14),
                        Text('Détails du prix',
                            style: AppTextStyles.sectionTitle
                                .copyWith(color: AppColors.primary)),
                        const SizedBox(height: 12),
                        _PaymentRow(
                          label:
                              '${_fmt(widget.price)} Fcfa × ${widget.nights} nuit${widget.nights > 1 ? 's' : ''}',
                          value: '${_fmt(widget.totalAmount)} Fcfa',
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Divider(color: Color(0xFFE5E7EB), height: 1),
                        ),
                        _PaymentRow(
                          label: 'Total estimé',
                          value: '${_fmt(widget.totalAmount)} Fcfa',
                          isBold: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border:
                          Border.all(color: const Color(0xFFE5E7EB), width: 1),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(Icons.payment_rounded,
                              color: AppColors.dark, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Méthode de paiement',
                                style: AppTextStyles.regular12.copyWith(
                                    color: AppColors.muted,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _paymentMethod,
                                style: AppTextStyles.sectionTitle.copyWith(
                                    color: AppColors.text,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: _openPaymentMethodSheet,
                          child: Text(
                            'Modifier',
                            style: AppTextStyles.regular12.copyWith(
                                color: AppColors.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Error banner
          if (_error != null)
            Container(
              width: double.infinity,
              color: Colors.red.shade50,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _error!,
                      style: const TextStyle(color: Colors.red, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),

          // ── Submit button
          Container(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 10,
                    offset: Offset(0, -4))
              ],
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.dark,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                  ),
                  onPressed: _loading ? null : _submit,
                  child: _loading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2.5),
                        )
                      : const Text('Soumettre', style: AppTextStyles.button),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value, this.icon});

  final String label;
  final String value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Icon(icon, color: const Color(0xFF171725), size: 16),
          const SizedBox(width: 10),
        ],
        Text(label,
            style: AppTextStyles.regular12.copyWith(
                color: const Color(0xFF171725),
                fontWeight: FontWeight.w300,
                fontSize: 13)),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: AppTextStyles.sectionTitle.copyWith(
                color: const Color(0xFF171725),
                fontWeight: FontWeight.w400,
                fontSize: 13),
          ),
        ),
      ],
    );
  }
}

// ─── Success Screen ───────────────────────────────────────────────────────────

class ReservationSuccessScreen extends StatelessWidget {
  const ReservationSuccessScreen({super.key, this.reservation});

  final ReservationResponse? reservation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/recu.png',
                      width: 160,
                      height: 160,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                          Icons.check_circle_outline,
                          color: Color(0xFF22C55E),
                          size: 80),
                    ),
                    const SizedBox(height: 28),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7ED),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.4)),
                      ),
                      child: Text(
                        'Statut : EN ATTENTE',
                        style: AppTextStyles.regular12.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Demande envoyée !',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.sectionTitle.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                          fontSize: 20),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Votre demande a été transmise à l\'hôtel. Vous serez notifié dès confirmation.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.regular12.copyWith(
                          color: AppColors.muted,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                    if (reservation != null) ...[
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECF2F7),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          children: [
                            _InfoRow(
                                label: 'Bien',
                                value: reservation!.propertyTitle),
                            const SizedBox(height: 6),
                            _InfoRow(
                                label: 'Arrivée',
                                value: reservation!.checkInDate),
                            const SizedBox(height: 6),
                            _InfoRow(
                                label: 'Départ',
                                value: reservation!.checkOutDate),
                            const SizedBox(height: 6),
                            _InfoRow(
                                label: 'Nuits',
                                value: '${reservation!.numberOfNights}'),
                            const SizedBox(height: 6),
                            _InfoRow(
                                label: 'Total',
                                value:
                                    '${_fmt(reservation!.totalAmount.round())} Fcfa'),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 6),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.dark,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                  ),
                  onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (_) => const ReservationsScreen()),
                  ),
                  child: const Text('Voir mes réservations',
                      style: AppTextStyles.button),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 4, 18, 18),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: TextButton(
                  onPressed: () =>
                      Navigator.of(context).popUntil((r) => r.isFirst),
                  child: Text(
                    'Retourner à l\'accueil',
                    style: AppTextStyles.button.copyWith(
                        color: AppColors.dark, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: AppTextStyles.regular12.copyWith(
                color: AppColors.muted,
                fontSize: 12,
                fontWeight: FontWeight.w400)),
        Text(value,
            style: AppTextStyles.regular12.copyWith(
                color: AppColors.text,
                fontSize: 12,
                fontWeight: FontWeight.w600)),
      ],
    );
  }
}
