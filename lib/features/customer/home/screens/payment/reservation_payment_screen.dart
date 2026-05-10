import 'package:flutter/material.dart';

import 'package:statefulclickcounter/core/widgets/recommended_tile.dart';
import 'package:statefulclickcounter/features/customer/hotels/screens/hotel_reservation_screen.dart'
    show AddCardScreen;
import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

const Color _kBg = AppColors.background;
const Color _kDark = AppColors.dark;
const Color _kOrange = AppColors.primary;

const String _kIconWave = 'assets/icons/wave.png';
const String _kIconOrangeMoney = 'assets/icons/orangemoney.png';
const String _kIconMtn = 'assets/icons/mtn.png';
const String _kIconVisa = 'assets/icons/Visa.png';
const String _kIconMastercard = 'assets/icons/mastercard.png';

String _paymentMethodIconAsset(_PaymentMethod m) {
  switch (m) {
    case _PaymentMethod.wave:
      return _kIconWave;
    case _PaymentMethod.orangeMoney:
      return _kIconOrangeMoney;
    case _PaymentMethod.mtn:
      return _kIconMtn;
    case _PaymentMethod.visa:
      return _kIconVisa;
    case _PaymentMethod.mastercard:
      return _kIconMastercard;
  }
}

class ReservationPaymentScreen extends StatefulWidget {
  const ReservationPaymentScreen({
    super.key,
    required this.imagePath,
    required this.title,
    required this.location,
    required this.beds,
    required this.baths,
    required this.kitchens,
    required this.advanceAmount,
    required this.depositAmount,
  });

  final String imagePath;
  final String title;
  final String location;
  final int beds;
  final int baths;
  final int kitchens;
  final int advanceAmount;
  final int depositAmount;

  @override
  State<ReservationPaymentScreen> createState() =>
      _ReservationPaymentScreenState();
}

class _ReservationPaymentScreenState extends State<ReservationPaymentScreen> {
  static const _jobStatuses = ['Salarié', 'Indépendant', 'Étudiant'];
  static const _leaseDurations = ['6 mois', '1 an', '2 ans'];

  String _jobStatus = _jobStatuses.first;
  String _leaseDuration = _leaseDurations[1];

  _PaymentMethod? _method;

  int get _total => widget.advanceAmount + widget.depositAmount;

  @override
  Widget build(BuildContext context) {
    final payEnabled = _method != null;

    return Scaffold(
      backgroundColor: _kBg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 10),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(22),
                    child: const SizedBox(
                      width: 44,
                      height: 44,
                      child: Center(
                        child: Icon(Icons.arrow_back_ios_new_rounded),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Réservation',
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: _kDark,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 44, height: 44),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RecommendedTile(
                      imagePath: widget.imagePath,
                      title: widget.title,
                      location: widget.location,
                      beds: widget.beds,
                      baths: widget.baths,
                      salons: widget.kitchens,
                      isFavorite: false,
                      onFavoriteToggle: () {},
                      onTap: () {},
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Statut professionnel',
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: _kDark,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _DropdownPill(
                      value: _jobStatus,
                      items: _jobStatuses,
                      onChanged: (v) => setState(() => _jobStatus = v),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      'Durée du bail',
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: _kDark,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _DropdownPill(
                      value: _leaseDuration,
                      items: _leaseDurations,
                      onChanged: (v) => setState(() => _leaseDuration = v),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      'Détails du paiement',
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: _kDark,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _PaymentLine(
                      label: 'Avance',
                      amount: _formatFcfa(widget.advanceAmount),
                      bold: false,
                    ),
                    const SizedBox(height: 8),
                    _PaymentLine(
                      label: 'Caution',
                      amount: _formatFcfa(widget.depositAmount),
                      bold: false,
                    ),
                    const SizedBox(height: 8),
                    _PaymentLine(
                      label: 'Paiement total',
                      amount: _formatFcfa(_total),
                      bold: true,
                    ),
                    const SizedBox(height: 22),
                    Text(
                      'Payé avec',
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: _kDark,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _PaymentMethodField(
                      method: _method,
                      onTap: _openPaymentMethods,
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              payEnabled ? _kDark : const Color(0xFFD1D5DB),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        onPressed: payEnabled ? _pay : null,
                        child: const Text(
                          'Payer',
                          style: AppTextStyles.button,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openPaymentMethods() async {
    final result = await showModalBottomSheet<_PaymentMethod>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return _PaymentMethodSheet(selected: _method);
      },
    );

    if (result == null) return;
    setState(() => _method = result);
  }

  Future<void> _pay() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return _PaymentSuccessSheet(
          onDashboard: () {
            Navigator.of(ctx).pop();
            Navigator.of(context).popUntil((r) => r.isFirst);
          },
          onInvoice: () {
            Navigator.of(ctx).pop();
          },
        );
      },
    );
  }

  static String _formatFcfa(int value) {
    final str = value.toString();
    final buf = StringBuffer();
    for (var i = 0; i < str.length; i++) {
      final idxFromEnd = str.length - i;
      buf.write(str[i]);
      if (idxFromEnd > 1 && idxFromEnd % 3 == 1) {
        buf.write(' ');
      }
    }
    return '${buf.toString().trim()} FCFA';
  }
}

class _DropdownPill extends StatelessWidget {
  const _DropdownPill({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      alignment: Alignment.center,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(17),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.keyboard_arrow_down_rounded,
                color: AppColors.primary),
          ),
          items: items
              .map(
                (t) => DropdownMenuItem(
                  value: t,
                  child: Text(t, style: AppTextStyles.regular12),
                ),
              )
              .toList(),
          onChanged: (v) {
            if (v == null) return;
            onChanged(v);
          },
        ),
      ),
    );
  }
}

class _PaymentLine extends StatelessWidget {
  const _PaymentLine({
    required this.label,
    required this.amount,
    required this.bold,
  });

  final String label;
  final String amount;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: bold ? AppColors.dark : AppColors.muted,
              fontWeight: bold ? FontWeight.w500 : FontWeight.w400,
              fontSize: bold ? 13 : 12,
            ),
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            color: AppColors.text,
            fontWeight: bold ? FontWeight.w500 : FontWeight.w300,
            fontSize: bold ? 14 : 11,
          ),
        ),
      ],
    );
  }
}

enum _PaymentMethod {
  wave,
  orangeMoney,
  mtn,
  visa,
  mastercard,
}

class _PaymentMethodField extends StatelessWidget {
  const _PaymentMethodField({required this.method, required this.onTap});

  final _PaymentMethod? method;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: method == null
                ? const Icon(Icons.account_balance_wallet_outlined,
                    color: AppColors.dark)
                : Image.asset(
                    _paymentMethodIconAsset(method!),
                    width: 22,
                    height: 22,
                    fit: BoxFit.contain,
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              method == null ? '' : _methodLabel(method!),
              style: const TextStyle(
                color: AppColors.text,
                fontWeight: FontWeight.w800,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14),
            ),
            onPressed: onTap,
            child: const Text(
              'Choisir un mode de paiement',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  static String _methodLabel(_PaymentMethod m) {
    switch (m) {
      case _PaymentMethod.wave:
        return 'Wave';
      case _PaymentMethod.orangeMoney:
        return 'Orange Money';
      case _PaymentMethod.mtn:
        return 'MTN';
      case _PaymentMethod.visa:
        return 'Visa';
      case _PaymentMethod.mastercard:
        return 'Master Card';
    }
  }
}

class _PaymentMethodSheet extends StatefulWidget {
  const _PaymentMethodSheet({required this.selected});

  final _PaymentMethod? selected;

  @override
  State<_PaymentMethodSheet> createState() => _PaymentMethodSheetState();
}

class _PaymentMethodSheetState extends State<_PaymentMethodSheet> {
  _PaymentMethod? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    final canChoose = _selected != null;
    final screenH = MediaQuery.sizeOf(context).height;

    return SafeArea(
      top: false,
      child: Container(
        height: screenH * 0.55,
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 18,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Selectionner votre methode\nde paiement',
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: _kDark,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  borderRadius: BorderRadius.circular(18),
                  child: const SizedBox(
                    width: 44,
                    height: 44,
                    child: Center(
                      child: Icon(Icons.close_rounded),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _MethodTile(
                            label: 'Wave',
                            iconAsset: _kIconWave,
                            selected: _selected == _PaymentMethod.wave,
                            onTap: () =>
                                setState(() => _selected = _PaymentMethod.wave),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _MethodTile(
                            label: 'Orange Money',
                            iconAsset: _kIconOrangeMoney,
                            selected: _selected == _PaymentMethod.orangeMoney,
                            onTap: () => setState(
                                () => _selected = _PaymentMethod.orangeMoney),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _MethodTile(
                            label: 'MTN',
                            iconAsset: _kIconMtn,
                            selected: _selected == _PaymentMethod.mtn,
                            onTap: () =>
                                setState(() => _selected = _PaymentMethod.mtn),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _MethodRow(
                      label: 'Visa',
                      icon: Image.asset(
                        _kIconVisa,
                        width: 32,
                        height: 32,
                        fit: BoxFit.contain,
                      ),
                      selected: _selected == _PaymentMethod.visa,
                      onTap: () =>
                          setState(() => _selected = _PaymentMethod.visa),
                    ),
                    const SizedBox(height: 10),
                    _MethodRow(
                      label: 'Master Card',
                      icon: Image.asset(
                        _kIconMastercard,
                        width: 32,
                        height: 32,
                        fit: BoxFit.contain,
                      ),
                      selected: _selected == _PaymentMethod.mastercard,
                      onTap: () =>
                          setState(() => _selected = _PaymentMethod.mastercard),
                    ),
                    const SizedBox(height: 10),
                    _MethodRow(
                      label: 'Ajouter une carte de débit',
                      icon: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2563EB).withOpacity(0.10),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(Icons.add, color: Color(0xFF2563EB)),
                      ),
                      selected: false,
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const AddCardScreen()),
                        );
                      },
                      trailing: const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: canChoose ? _kDark : const Color(0xFFD1D5DB),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                onPressed: canChoose
                    ? () => Navigator.of(context).pop(_selected)
                    : null,
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

class _MethodTile extends StatelessWidget {
  const _MethodTile({
    required this.label,
    required this.iconAsset,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String iconAsset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 80,
        width: 124,
        // constraints: const BoxConstraints(maxWidth: 124),
        decoration: BoxDecoration(
          color: selected ? _kOrange : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconAsset,
              width: 30,
              height: 30,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: selected ? Colors.white : AppColors.dark,
                fontWeight: FontWeight.w500,
                fontSize: 10,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MethodRow extends StatelessWidget {
  const _MethodRow({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    this.trailing,
  });

  final String label;
  final Widget icon;
  final bool selected;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            SizedBox(width: 52, child: Center(child: icon)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(label, style: AppTextStyles.regular12),
            ),
            trailing ??
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                    borderRadius: BorderRadius.circular(6),
                    color: selected ? _kOrange : Colors.transparent,
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

class _PaymentSuccessSheet extends StatelessWidget {
  const _PaymentSuccessSheet({
    required this.onDashboard,
    required this.onInvoice,
  });

  final VoidCallback onDashboard;
  final VoidCallback onInvoice;

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
          children: [
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Félicitations',
              style: AppTextStyles.sectionTitle.copyWith(
                color: _kOrange,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 18),
            Container(
              // width: 170,
              // height: 140,
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/felecitations.png',
                width: 200,
                height: 180,
              ),
            ),
            const SizedBox(height: 14),
            const SizedBox(height: 10),
            Text(
              'votre réservation a été effectuée avec succès.',
              textAlign: TextAlign.center,
              style: AppTextStyles.sectionTitle.copyWith(
                  color: AppColors.text,
                  fontWeight: FontWeight.w400,
                  fontSize: 13),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.dark,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                onPressed: onDashboard,
                child: const Text(
                  'Voir mon tableau de bord',
                  style: AppTextStyles.button,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _kOrange,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                onPressed: onInvoice,
                child: const Text(
                  'Voir la facture',
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
