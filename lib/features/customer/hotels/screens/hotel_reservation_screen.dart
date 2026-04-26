import 'package:flutter/material.dart';
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

String _formatDate(DateTime d) {
  return '${d.day} ${_kMonths[d.month - 1]} ${d.year}';
}

// ─── Screen 1: HotelReservationScreen ────────────────────────────────────────

class HotelReservationScreen extends StatefulWidget {
  const HotelReservationScreen({
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
  State<HotelReservationScreen> createState() => _HotelReservationScreenState();
}

class _HotelReservationScreenState extends State<HotelReservationScreen> {
  DateTime _arrivalDate = DateTime(2026, 3, 15);
  DateTime _departureDate = DateTime(2026, 3, 18);
  int _guestCount = 1;
  String _paymentMethod = 'Master Card';
  String _paymentDisplay = 'carte visa ******6587';

  int get _nights =>
      _departureDate.difference(_arrivalDate).inDays.clamp(1, 365);

  int get _totalNights => _nights * widget.price;

  int get _adminFees => 2000;

  int get _totalPayment => _totalNights + _adminFees;

  void _openCalendar() async {
    final result = await showDialog<List<DateTime>>(
      context: context,
      builder: (_) => HotelCalendarDialog(
        initialStart: _arrivalDate,
        initialEnd: _departureDate,
      ),
    );
    if (result != null && result.length == 2) {
      setState(() {
        _arrivalDate = result[0];
        _departureDate = result[1];
      });
    }
  }

  void _openPaymentMethodSheet() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => HotelPaymentMethodSheet(
        currentMethod: _paymentMethod,
      ),
    );
    if (result != null) {
      setState(() {
        _paymentMethod = result;
        if (result == 'Wave') {
          _paymentDisplay = 'Wave ******1234';
        } else if (result == 'Orange Money') {
          _paymentDisplay = 'Orange Money ******5678';
        } else if (result == 'MTN') {
          _paymentDisplay = 'MTN ******9012';
        } else if (result == 'Visa') {
          _paymentDisplay = 'carte visa ******6587';
        } else if (result == 'Master Card') {
          _paymentDisplay = 'Master Card ******3456';
        } else {
          _paymentDisplay = result;
        }
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
              color: AppColors.text, size: 20),
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
                  // ── Date card
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
                                    Text(
                                      'Arrivée',
                                      style: AppTextStyles.regular12.copyWith(
                                        color: AppColors.text,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _formatDate(_arrivalDate),
                                      style:
                                          AppTextStyles.sectionTitle.copyWith(
                                        color: AppColors.text,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 40,
                                color: const Color(0xFFE5E7EB),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Départ',
                                        style: AppTextStyles.regular12.copyWith(
                                          color: AppColors.text,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _formatDate(_departureDate),
                                        style:
                                            AppTextStyles.sectionTitle.copyWith(
                                          color: AppColors.text,
                                          fontSize: 14,
                                        ),
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

                  // ── Invité row
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Invité',
                          style: AppTextStyles.sectionTitle.copyWith(
                            color: AppColors.text,
                            fontSize: 15,
                          ),
                        ),
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
                                color: AppColors.text, size: 18),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            '$_guestCount',
                            style: const TextStyle(
                              color: AppColors.text,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => _guestCount++),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary,
                            ),
                            alignment: Alignment.center,
                            child: const Icon(Icons.add,
                                color: Colors.white, size: 18),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Payé avec
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.credit_card_rounded,
                            color: AppColors.text, size: 22),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Payé avec',
                                style: AppTextStyles.regular12.copyWith(
                                  color: AppColors.text,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _paymentDisplay,
                                style: AppTextStyles.sectionTitle.copyWith(
                                  color: AppColors.text,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: _openPaymentMethodSheet,
                          child: const Text(
                            'Edit',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Détails du paiement
                  Text(
                    'Détails du paiement',
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.text,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _PaymentRow(
                    label: 'Total $_nights Nuitées',
                    value: '${_fmt(_totalNights)} Fcfa',
                  ),
                  const SizedBox(height: 10),
                  _PaymentRow(
                    label: 'Frais administratifs',
                    value: '${_fmt(_adminFees)} Fcfa',
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(color: Color(0xFFE5E7EB)),
                  ),
                  _PaymentRow(
                    label: 'Paiement totale',
                    value: '${_fmt(_totalPayment)} Fcfa',
                    isBold: true,
                  ),
                ],
              ),
            ),
          ),

          // ── Bottom button
          Container(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 10,
                  offset: Offset(0, -4),
                ),
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
                      borderRadius: BorderRadius.circular(50),
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
                          arrivalDate: _arrivalDate,
                          departureDate: _departureDate,
                          guestCount: _guestCount,
                          totalNights: _totalNights,
                          adminFees: _adminFees,
                          totalPayment: _totalPayment,
                          nights: _nights,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Suivant',
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
            color: isBold ? Color(0xFF171725) : Color(0xFF171725),
            fontWeight: isBold ? FontWeight.w500 : FontWeight.w300,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Color(0xFF171725),
            fontWeight: isBold ? FontWeight.w500 : FontWeight.w300,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

// ─── Screen 2: Payment Method Bottom Sheet ───────────────────────────────────

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
            // Handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFD0DDE8),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 14),
            // Title + close
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Selectionner votre methode de paiement',
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.text,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close, color: AppColors.text),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Mobile money options
            _PaymentTile(
              iconAsset: 'assets/icons/wave.png',
              label: 'Wave',
              isSelected: _selected == 'Wave',
              onTap: () => setState(() => _selected = 'Wave'),
            ),
            const SizedBox(height: 10),
            _PaymentTile(
              iconAsset: 'assets/icons/orangemoney.png',
              label: 'Orange Money',
              isSelected: _selected == 'Orange Money',
              onTap: () => setState(() => _selected = 'Orange Money'),
            ),
            const SizedBox(height: 10),
            _PaymentTile(
              iconAsset: 'assets/icons/mtn.png',
              label: 'MTN',
              isSelected: _selected == 'MTN',
              onTap: () => setState(() => _selected = 'MTN'),
            ),

            const SizedBox(height: 10),

            // Card options
            _PaymentTile(
              iconAsset: 'assets/icons/Visa.png',
              label: 'Visa',
              isSelected: _selected == 'Visa',
              onTap: () => setState(() => _selected = 'Visa'),
            ),
            const SizedBox(height: 10),
            _PaymentTile(
              iconAsset: 'assets/icons/mastercard.png',
              label: 'Master Card',
              isSelected: _selected == 'Master Card',
              onTap: () => setState(() => _selected = 'Master Card'),
            ),

            const SizedBox(height: 10),

            // Add card
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AddCardScreen()),
                );
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.add,
                          color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Ajouter une carte de débit',
                      style: TextStyle(
                        color: AppColors.text,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Choose button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.dark,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(_selected),
                child: const Text(
                  'Choisir',
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
              child: Image.asset(
                iconAsset,
                width: 36,
                height: 36,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD0DDE8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.payment, size: 18),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: AppColors.text,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      isSelected ? AppColors.primary : const Color(0xFFD0DDE8),
                  width: 2,
                ),
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

// ─── Screen 3: AddCardScreen ─────────────────────────────────────────────────

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final _cardNumberController =
      TextEditingController(text: '2894 - 4389 - 4432 - 9432');
  final _nameController = TextEditingController(text: 'Franck Ouattara');
  final _expirationController = TextEditingController(text: '');
  final _cvvController = TextEditingController(text: '');

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
              color: AppColors.text, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Ajouter une carte',
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
                  // ── Card preview
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF1A3047),
                          Color(0xFF2C4A63),
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Maestro Kard',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          _cardNumberController.text,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Prenom',
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 11,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _nameController.text.isEmpty
                                      ? 'Prenom'
                                      : _nameController.text,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: List.generate(
                                2,
                                (i) => Container(
                                  width: 28,
                                  height: 28,
                                  margin: EdgeInsets.only(left: i == 0 ? 0 : 0),
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

                  const SizedBox(height: 28),

                  // ── Card number field
                  Text(
                    'Numéro de la carte',
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.text,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _cardNumberController,
                    hint: '0000 - 0000 - 0000 - 0000',
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 18),

                  // ── Name field
                  Text(
                    'Prenom',
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.text,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _nameController,
                    hint: 'Nom complet',
                  ),

                  const SizedBox(height: 18),

                  // ── Expiration + CVV
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Expiration',
                              style: AppTextStyles.sectionTitle.copyWith(
                                color: AppColors.text,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildTextField(
                              controller: _expirationController,
                              hint: 'MM/YY',
                              keyboardType: TextInputType.datetime,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CVV Code',
                              style: AppTextStyles.sectionTitle.copyWith(
                                color: AppColors.text,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildTextField(
                              controller: _cvvController,
                              hint: '***',
                              keyboardType: TextInputType.number,
                              obscureText: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Bottom button
          Container(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 10,
                  offset: Offset(0, -4),
                ),
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
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Ajouter la carte',
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    bool obscureText = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        onChanged: (_) => setState(() {}),
        style: const TextStyle(
          color: AppColors.text,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: AppColors.text,
            fontWeight: FontWeight.w400,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
      ),
    );
  }
}

// ─── Screen 4: Calendar Dialog ───────────────────────────────────────────────

class HotelCalendarDialog extends StatefulWidget {
  const HotelCalendarDialog({
    super.key,
    required this.initialStart,
    required this.initialEnd,
  });

  final DateTime initialStart;
  final DateTime initialEnd;

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

  void _onDayTap(DateTime day) {
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

  int _daysInMonth(DateTime month) {
    return DateTime(month.year, month.month + 1, 0).day;
  }

  int _firstWeekday(DateTime month) {
    // Sunday = 0
    return DateTime(month.year, month.month, 1).weekday % 7;
  }

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
            // Title
            Text(
              'Selectionner Date',
              style: AppTextStyles.sectionTitle.copyWith(
                color: AppColors.text,
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 18),

            // Month navigation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _displayMonth =
                          DateTime(_displayMonth.year, _displayMonth.month - 1);
                    });
                  },
                  child: const Icon(Icons.chevron_left,
                      color: AppColors.text, size: 28),
                ),
                Text(
                  '${_kMonths[_displayMonth.month - 1]} ${_displayMonth.year}',
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: AppColors.text,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _displayMonth =
                          DateTime(_displayMonth.year, _displayMonth.month + 1);
                    });
                  },
                  child: const Icon(Icons.chevron_right,
                      color: AppColors.text, size: 28),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Weekday headers
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

            // Calendar grid
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
                if (index < firstWeekday) {
                  return const SizedBox();
                }
                final day = index - firstWeekday + 1;
                final date =
                    DateTime(_displayMonth.year, _displayMonth.month, day);

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
                Color textColor = AppColors.dark;

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

                return GestureDetector(
                  onTap: () => _onDayTap(date),
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

            // Buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Annuler',
                      style: AppTextStyles.button.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
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
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      onPressed: (_startDate != null && _endDate != null)
                          ? () {
                              Navigator.of(context)
                                  .pop([_startDate!, _endDate!]);
                            }
                          : null,
                      child: const Text(
                        'Appliquer',
                        style: AppTextStyles.button,
                      ),
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
        style: AppTextStyles.regular12.copyWith(
          color: AppColors.text,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ─── Screen 5: HotelReservationSummaryScreen ─────────────────────────────────

class HotelReservationSummaryScreen extends StatelessWidget {
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
    required this.totalNights,
    required this.adminFees,
    required this.totalPayment,
    required this.nights,
  });

  final String imagePath;
  final String name;
  final String location;
  final int price;
  final double rating;
  final DateTime arrivalDate;
  final DateTime departureDate;
  final int guestCount;
  final int totalNights;
  final int adminFees;
  final int totalPayment;
  final int nights;

  @override
  Widget build(BuildContext context) {
    final dateRange =
        '${arrivalDate.day} - ${departureDate.day} ${_kMonths[departureDate.month - 1]} ${departureDate.year}';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.text, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Resumé',
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
                  // ── Property card
                  Container(
                    width: 380,
                    height: 123,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(7.88),
                          child: Image.asset(
                            imagePath,
                            width: 108,
                            height: 98,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 108,
                              height: 98,
                              color: const Color(0xFFE2E8F0),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                height: 3,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      name,
                                      style:
                                          AppTextStyles.sectionTitle.copyWith(
                                        color: AppColors.text,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        height: 1.2,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(Icons.star_rounded,
                                      color: Color(0xFFFACC15), size: 15),
                                  const SizedBox(width: 2),
                                  Text(
                                    rating.toString(),
                                    style: AppTextStyles.regular12.copyWith(
                                      color: AppColors.text,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.location_on_outlined,
                                      size: 13, color: AppColors.text),
                                  const SizedBox(width: 3),
                                  Expanded(
                                    child: Text(
                                      location,
                                      style: AppTextStyles.regular12.copyWith(
                                        color: AppColors.text,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '${_fmt(price)} ',
                                      style: const TextStyle(
                                        fontFamily: 'Lexend',
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: 'FCFA',
                                      style: TextStyle(
                                        fontFamily: 'Lexend',
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: '/ nuit',
                                      style: TextStyle(
                                        fontFamily: 'Lexend',
                                        color: AppColors.text,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Votre réservation + Détails du prix (unified card)
                  Container(
                    height: 362,
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
                        Text(
                          'Votre réservation',
                          style: AppTextStyles.sectionTitle.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 14),
                        _SummaryRow(
                          icon: Icons.calendar_month_outlined,
                          label: 'Dates',
                          value: dateRange,
                        ),
                        const SizedBox(height: 10),
                        _SummaryRow(
                          icon: Icons.person_outline_rounded,
                          label: 'invité',
                          value: '$guestCount Guests (1 Room)',
                        ),
                        const SizedBox(height: 10),
                        const _SummaryRow(
                          icon: Icons.article_outlined,
                          label: 'Type de chambre',
                          value: 'Queen Room',
                        ),
                        const SizedBox(height: 10),
                        const _SummaryRow(
                          icon: Icons.phone_outlined,
                          label: 'Téléphone',
                          value: '+225 01 02 03 04 05',
                        ),
                        const SizedBox(height: 18),
                        // Dashed divider
                        SizedBox(
                          width: double.infinity,
                          height: 1,
                          child: CustomPaint(
                            painter: _DashedLinePainter(),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'Détails du prix',
                          style: AppTextStyles.sectionTitle.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 14),
                        _PaymentRow(
                          label: 'Prix',
                          value: '${_fmt(totalNights)} Fcfa',
                        ),
                        const SizedBox(height: 10),
                        _PaymentRow(
                          label: 'frais administratifs',
                          value: '${_fmt(adminFees)} Fcfa',
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Divider(color: Color(0xFFE5E7EB), height: 1),
                        ),
                        _PaymentRow(
                          label: 'Prix total',
                          value: '${_fmt(totalPayment)} Fcfa',
                          isBold: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Promo section
                  Text(
                    'Promo',
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: Color(0xFF171725),
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.local_offer_outlined,
                            color: Color(0xFF2563EB), size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Select',
                            style: AppTextStyles.regular12.copyWith(
                              color: const Color(0xFF2563EB),
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        const Icon(Icons.chevron_right,
                            color: AppColors.text, size: 22),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Bottom button
          Container(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 10,
                  offset: Offset(0, -4),
                ),
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
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ReservationSuccessScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Finaliser et payer',
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

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.icon,
  });

  final String label;
  final String value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, color: const Color(0xFF171725), size: 16),
              const SizedBox(width: 10),
            ],
            Text(
              label,
              style: AppTextStyles.regular12.copyWith(
                color: const Color(0xFF171725),
                fontWeight: FontWeight.w300,
                fontSize: 13,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: AppTextStyles.sectionTitle.copyWith(
            color: const Color(0xFF171725),
            fontWeight: FontWeight.w400,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD0DDE8)
      ..strokeWidth = 1;

    const dashWidth = 6.0;
    const dashSpace = 4.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Screen 6: ReservationSuccessScreen ──────────────────────────────────────

class ReservationSuccessScreen extends StatelessWidget {
  const ReservationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Success image
                  Container(
                    width: 220,
                    height: 220,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      // color: Color(0xFFE8ECF0),
                    ),
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/images/recu.png',
                      width: 180,
                      height: 180,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.check_circle_outline,
                        color: Color(0xFF22C55E),
                        size: 80,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'votre réservation a été effectuée avec succès',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.sectionTitle.copyWith(
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF22C55E),
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'Un reçu de paiement a été envoyé à votre adresse e-mail.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.regular12.copyWith(
                        color: AppColors.text,
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),

            // ── Bottom button
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.dark,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: const Text(
                    'Voir mes reservations',
                    style: AppTextStyles.button,
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
