import 'package:flutter/material.dart';

import 'package:statefulclickcounter/core/widgets/dark_button.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

class AdvancedSearchScreen extends StatefulWidget {
  const AdvancedSearchScreen({super.key, required this.initialRent});

  final bool initialRent;

  @override
  State<AdvancedSearchScreen> createState() => _AdvancedSearchScreenState();
}

class _AdvancedSearchScreenState extends State<AdvancedSearchScreen> {
  late bool _rent;
  String _zone = 'cocody';
  String _propertyType = 'Terrain';

  RangeValues _price = const RangeValues(0.2, 0.8);
  RangeValues _area = const RangeValues(0.0, 0.4);

  int _bedrooms = 3;
  int _bathrooms = 2;

  int? _landDocIndex = 0;
  int? _landAreaPreset;

  @override
  void initState() {
    super.initState();
    _rent = widget.initialRent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.dark),
        ),
        title: const Text(
          'Recherche avancée',
          style: TextStyle(
            color: AppColors.text,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Segmented(
              leftLabel: 'Louer',
              rightLabel: 'Acheter',
              leftSelected: _rent,
              onLeft: () => setState(() => _rent = true),
              onRight: () => setState(() => _rent = false),
            ),
            const SizedBox(height: 16),
            const _FieldLabel('Choisir une zone'),
            const SizedBox(height: 8),
            _SelectField(
              icon: Icons.my_location_rounded,
              value: _zone,
              onTap: () async {
                final selected = await _showSelectSheet(
                  title: 'Choisir une zone',
                  options: const ['cocody', 'yopougon', 'plateau', 'marcory'],
                  current: _zone,
                );
                if (!mounted || selected == null) return;
                setState(() => _zone = selected);
              },
            ),
            const SizedBox(height: 14),
            const _FieldLabel('Type de propriété'),
            const SizedBox(height: 8),
            _SelectField(
              icon: Icons.apartment_rounded,
              value: _propertyType,
              onTap: () async {
                final selected = await _showSelectSheet(
                  title: 'Type de propriété',
                  options: const ['Terrain', 'Appartement'],
                  current: _propertyType,
                );
                if (!mounted || selected == null) return;
                setState(() => _propertyType = selected);
              },
            ),
            const SizedBox(height: 18),
            const _FieldLabel('Prix'),
            const SizedBox(height: 8),
            _MinMaxRow(
              minLabel: 'min',
              maxLabel: 'max',
            ),
            _RangeSlider(
              values: _price,
              onChanged: (v) => setState(() => _price = v),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: _MinMaxRow(
                minLabel: _propertyType == 'Terrain'
                    ? '5 Millions FCFA'
                    : '100 000 FCFA',
                maxLabel: _propertyType == 'Terrain'
                    ? '500 Millions FCFA'
                    : '2 MD FCFA',
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 18),
            if (_propertyType == 'Terrain') ...[
              const _FieldLabel('Superficie'),
              const SizedBox(height: 8),
              _MinMaxRow(minLabel: 'min', maxLabel: 'max'),
              _RangeSlider(
                values: _area,
                onChanged: (v) {
                  setState(() {
                    _area = v;
                    _landAreaPreset = null;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: _MinMaxRow(
                  minLabel: '150 m2',
                  maxLabel: '1000 m2',
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _PillChoice(
                    label: '200 m2',
                    selected: _landAreaPreset == 200,
                    onTap: () => setState(() => _landAreaPreset = 200),
                  ),
                  _PillChoice(
                    label: '300 m2',
                    selected: _landAreaPreset == 300,
                    onTap: () => setState(() => _landAreaPreset = 300),
                  ),
                  _PillChoice(
                    label: '500 m2',
                    selected: _landAreaPreset == 500,
                    onTap: () => setState(() => _landAreaPreset = 500),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const _FieldLabel('Documents du terrain'),
              const SizedBox(height: 10),
              _RadioRow(
                label: 'Titre foncier',
                value: 0,
                groupValue: _landDocIndex,
                onChanged: (v) => setState(() => _landDocIndex = v),
              ),
              _RadioRow(
                label: 'ACD',
                value: 1,
                groupValue: _landDocIndex,
                onChanged: (v) => setState(() => _landDocIndex = v),
              ),
              _RadioRow(
                label: 'Attestation villageoise',
                value: 2,
                groupValue: _landDocIndex,
                onChanged: (v) => setState(() => _landDocIndex = v),
              ),
            ] else ...[
              const _FieldLabel('Chambres'),
              const SizedBox(height: 10),
              _CountChoices(
                values: const [1, 2, 3, 4, 5],
                selected: _bedrooms,
                onSelect: (v) => setState(() => _bedrooms = v),
                plusLabel: '+5',
              ),
              const SizedBox(height: 18),
              const _FieldLabel('Salle de bains'),
              const SizedBox(height: 10),
              _CountChoices(
                values: const [1, 2, 3, 4, 5],
                selected: _bathrooms,
                onSelect: (v) => setState(() => _bathrooms = v),
                plusLabel: '+5',
              ),
              const SizedBox(height: 18),
              const _FieldLabel('Surface'),
              const SizedBox(height: 8),
              _MinMaxRow(minLabel: 'min', maxLabel: 'max'),
              _RangeSlider(
                values: _area,
                onChanged: (v) => setState(() => _area = v),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: _MinMaxRow(
                  minLabel: '100 m2',
                  maxLabel: '500 m2',
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const _FieldLabel('Commodités'),
              const SizedBox(height: 10),
              _SelectField(
                icon: Icons.check_circle_outline_rounded,
                value: 'Sélectionner',
                onTap: () {},
              ),
            ],
            const SizedBox(height: 22),
            DarkButton(
              text: 'Appliquer',
              onPressed: () {
                Navigator.of(context).pop(<String, dynamic>{
                  'rent': _rent,
                  'zone': _zone,
                  'type': _propertyType,
                  'rooms': _propertyType == 'Terrain' ? null : _bedrooms,
                });
              },
              height: 56,
              borderRadius: 24,
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _showSelectSheet({
    required String title,
    required List<String> options,
    required String current,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.text,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              ...options.map(
                (o) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    o,
                    style: const TextStyle(
                      color: AppColors.text,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  trailing: current == o
                      ? const Icon(Icons.check_circle_rounded,
                          color: AppColors.dark)
                      : const Icon(Icons.circle_outlined,
                          color: Color(0xFFCBD5E1)),
                  onTap: () => Navigator.of(ctx).pop(o),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.sectionTitle,
    );
  }
}

class _Segmented extends StatelessWidget {
  const _Segmented({
    required this.leftLabel,
    required this.rightLabel,
    required this.leftSelected,
    required this.onLeft,
    required this.onRight,
  });

  final String leftLabel;
  final String rightLabel;
  final bool leftSelected;
  final VoidCallback onLeft;
  final VoidCallback onRight;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 57,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SegmentButton(
              label: leftLabel,
              selected: leftSelected,
              onTap: onLeft,
            ),
          ),
          Expanded(
            child: _SegmentButton(
              label: rightLabel,
              selected: !leftSelected,
              onTap: onRight,
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 49,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.dark : Colors.transparent,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Text(
          label,
          style: AppTextStyles.regularlight16.copyWith(
            color: selected ? Colors.white : AppColors.dark,
          ),
        ),
      ),
    );
  }
}

class _SelectField extends StatelessWidget {
  const _SelectField({
    required this.icon,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: const Color(0xFFE7E7E7), width: 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.dark),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                value,
                style: AppTextStyles.regular12.copyWith(color: AppColors.text),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.keyboard_arrow_down_rounded,
                color: AppColors.dark),
          ],
        ),
      ),
    );
  }
}

class _RangeSlider extends StatelessWidget {
  const _RangeSlider({required this.values, required this.onChanged});

  final RangeValues values;
  final ValueChanged<RangeValues> onChanged;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 3,
        activeTrackColor: AppColors.dark,
        inactiveTrackColor: AppColors.muted,
        rangeThumbShape:
            const RoundRangeSliderThumbShape(enabledThumbRadius: 9),
        overlayShape: SliderComponentShape.noOverlay,
      ),
      child: RangeSlider(
        values: values,
        onChanged: onChanged,
      ),
    );
  }
}

class _MinMaxRow extends StatelessWidget {
  const _MinMaxRow({
    required this.minLabel,
    required this.maxLabel,
    this.style,
  });

  final String minLabel;
  final String maxLabel;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final s = style ??
        const TextStyle(
          color: Color(0xFF8A97A6),
          fontSize: 12,
          fontWeight: FontWeight.w700,
        );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(minLabel, style: s),
        Text(maxLabel, style: s),
      ],
    );
  }
}

class _PillChoice extends StatelessWidget {
  const _PillChoice({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 104,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.dark : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: selected ? null : Border.all(color: const Color(0xFFE7E7E7)),
        ),
        child: Text(
          label,
          style: selected
              ? const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                )
              : AppTextStyles.regular12.copyWith(color: AppColors.text),
        ),
      ),
    );
  }
}

class _RadioRow extends StatelessWidget {
  const _RadioRow({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  final String label;
  final int value;
  final int? groupValue;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        label,
        style: AppTextStyles.regular12.copyWith(color: AppColors.text),
      ),
      trailing: Radio<int>(
        value: value,
        groupValue: groupValue,
        activeColor: AppColors.dark,
        onChanged: onChanged,
      ),
      onTap: () => onChanged(value),
    );
  }
}

class _CountChoices extends StatelessWidget {
  const _CountChoices({
    required this.values,
    required this.selected,
    required this.onSelect,
    required this.plusLabel,
  });

  final List<int> values;
  final int selected;
  final ValueChanged<int> onSelect;
  final String plusLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...values.take(4).map(
              (v) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: _SmallPill(
                    label: '$v',
                    selected: selected == v,
                    onTap: () => onSelect(v),
                  ),
                ),
              ),
            ),
        Expanded(
          child: _SmallPill(
            label: plusLabel,
            selected: selected >= 5,
            onTap: () => onSelect(5),
          ),
        ),
      ],
    );
  }
}

class _SmallPill extends StatelessWidget {
  const _SmallPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.dark : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: selected
              ? const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                )
              : AppTextStyles.regular12.copyWith(color: AppColors.text),
        ),
      ),
    );
  }
}
