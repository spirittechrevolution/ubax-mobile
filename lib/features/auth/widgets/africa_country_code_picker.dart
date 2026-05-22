import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';

import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

class AfricaCountry {
  const AfricaCountry({
    required this.name,
    required this.iso2,
    required this.dialCode,
  });

  final String name;
  final String iso2;
  final String dialCode;

  String get flagEmoji {
    final code = iso2.toUpperCase();
    if (code.length != 2) return '';
    final first = code.codeUnitAt(0) - 65 + 0x1F1E6;
    final second = code.codeUnitAt(1) - 65 + 0x1F1E6;
    return String.fromCharCode(first) + String.fromCharCode(second);
  }
}

class AfricaCountryCodePicker extends StatefulWidget {
  const AfricaCountryCodePicker({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final AfricaCountry value;
  final ValueChanged<AfricaCountry> onChanged;

  static const List<AfricaCountry> countries = [
    AfricaCountry(name: 'Algeria', iso2: 'DZ', dialCode: '+213'),
    AfricaCountry(name: 'Angola', iso2: 'AO', dialCode: '+244'),
    AfricaCountry(name: 'Benin', iso2: 'BJ', dialCode: '+229'),
    AfricaCountry(name: 'Botswana', iso2: 'BW', dialCode: '+267'),
    AfricaCountry(name: 'Burkina Faso', iso2: 'BF', dialCode: '+226'),
    AfricaCountry(name: 'Burundi', iso2: 'BI', dialCode: '+257'),
    AfricaCountry(name: 'Cabo Verde', iso2: 'CV', dialCode: '+238'),
    AfricaCountry(name: 'Cameroon', iso2: 'CM', dialCode: '+237'),
    AfricaCountry(
        name: 'Central African Republic', iso2: 'CF', dialCode: '+236'),
    AfricaCountry(name: 'Chad', iso2: 'TD', dialCode: '+235'),
    AfricaCountry(name: 'Comoros', iso2: 'KM', dialCode: '+269'),
    AfricaCountry(name: 'Congo (DRC)', iso2: 'CD', dialCode: '+243'),
    AfricaCountry(name: 'Congo (Republic)', iso2: 'CG', dialCode: '+242'),
    AfricaCountry(name: "Cote d'Ivoire", iso2: 'CI', dialCode: '+225'),
    AfricaCountry(name: 'Djibouti', iso2: 'DJ', dialCode: '+253'),
    AfricaCountry(name: 'Egypt', iso2: 'EG', dialCode: '+20'),
    AfricaCountry(name: 'Equatorial Guinea', iso2: 'GQ', dialCode: '+240'),
    AfricaCountry(name: 'Eritrea', iso2: 'ER', dialCode: '+291'),
    AfricaCountry(name: 'Eswatini', iso2: 'SZ', dialCode: '+268'),
    AfricaCountry(name: 'Ethiopia', iso2: 'ET', dialCode: '+251'),
    AfricaCountry(name: 'Gabon', iso2: 'GA', dialCode: '+241'),
    AfricaCountry(name: 'Gambia', iso2: 'GM', dialCode: '+220'),
    AfricaCountry(name: 'Ghana', iso2: 'GH', dialCode: '+233'),
    AfricaCountry(name: 'Guinea', iso2: 'GN', dialCode: '+224'),
    AfricaCountry(name: 'Guinea-Bissau', iso2: 'GW', dialCode: '+245'),
    AfricaCountry(name: 'Kenya', iso2: 'KE', dialCode: '+254'),
    AfricaCountry(name: 'Lesotho', iso2: 'LS', dialCode: '+266'),
    AfricaCountry(name: 'Liberia', iso2: 'LR', dialCode: '+231'),
    AfricaCountry(name: 'Libya', iso2: 'LY', dialCode: '+218'),
    AfricaCountry(name: 'Madagascar', iso2: 'MG', dialCode: '+261'),
    AfricaCountry(name: 'Malawi', iso2: 'MW', dialCode: '+265'),
    AfricaCountry(name: 'Mali', iso2: 'ML', dialCode: '+223'),
    AfricaCountry(name: 'Mauritania', iso2: 'MR', dialCode: '+222'),
    AfricaCountry(name: 'Mauritius', iso2: 'MU', dialCode: '+230'),
    AfricaCountry(name: 'Morocco', iso2: 'MA', dialCode: '+212'),
    AfricaCountry(name: 'Mozambique', iso2: 'MZ', dialCode: '+258'),
    AfricaCountry(name: 'Namibia', iso2: 'NA', dialCode: '+264'),
    AfricaCountry(name: 'Niger', iso2: 'NE', dialCode: '+227'),
    AfricaCountry(name: 'Nigeria', iso2: 'NG', dialCode: '+234'),
    AfricaCountry(name: 'Rwanda', iso2: 'RW', dialCode: '+250'),
    AfricaCountry(name: 'Sao Tome and Principe', iso2: 'ST', dialCode: '+239'),
    AfricaCountry(name: 'Senegal', iso2: 'SN', dialCode: '+221'),
    AfricaCountry(name: 'Seychelles', iso2: 'SC', dialCode: '+248'),
    AfricaCountry(name: 'Sierra Leone', iso2: 'SL', dialCode: '+232'),
    AfricaCountry(name: 'Somalia', iso2: 'SO', dialCode: '+252'),
    AfricaCountry(name: 'South Africa', iso2: 'ZA', dialCode: '+27'),
    AfricaCountry(name: 'South Sudan', iso2: 'SS', dialCode: '+211'),
    AfricaCountry(name: 'Sudan', iso2: 'SD', dialCode: '+249'),
    AfricaCountry(name: 'Tanzania', iso2: 'TZ', dialCode: '+255'),
    AfricaCountry(name: 'Togo', iso2: 'TG', dialCode: '+228'),
    AfricaCountry(name: 'Tunisia', iso2: 'TN', dialCode: '+216'),
    AfricaCountry(name: 'Uganda', iso2: 'UG', dialCode: '+256'),
    AfricaCountry(name: 'Zambia', iso2: 'ZM', dialCode: '+260'),
    AfricaCountry(name: 'Zimbabwe', iso2: 'ZW', dialCode: '+263'),
  ];

  static AfricaCountry byIso2(String iso2) {
    final idx =
        countries.indexWhere((c) => c.iso2.toLowerCase() == iso2.toLowerCase());
    return idx == -1 ? countries.first : countries[idx];
  }

  /// Résout le pays depuis un numéro de téléphone (ex: "+225 0102...") ou
  /// depuis un code ISO2 / nom de pays stocké dans le profil.
  static AfricaCountry fromUser({String? phone, String? country}) {
    // 1. Depuis le champ country (ISO2 ou nom)
    if (country != null && country.trim().isNotEmpty) {
      final iso = country.trim();
      if (iso.length == 2) return byIso2(iso);
      final byName = countries.firstWhere(
        (c) => c.name.toLowerCase() == iso.toLowerCase(),
        orElse: () => countries.first,
      );
      if (byName != countries.first ||
          countries.first.name.toLowerCase() == iso.toLowerCase()) {
        return byName;
      }
    }
    // 2. Depuis l'indicatif en tête du numéro de téléphone
    if (phone != null && phone.startsWith('+')) {
      // Trier par longueur décroissante pour matcher "+225" avant "+22"
      final sorted = [...countries]
        ..sort((a, b) => b.dialCode.length.compareTo(a.dialCode.length));
      for (final c in sorted) {
        if (phone.startsWith(c.dialCode)) return c;
      }
    }
    return byIso2('CI'); // fallback Côte d'Ivoire
  }

  @override
  State<AfricaCountryCodePicker> createState() =>
      _AfricaCountryCodePickerState();
}

class _AfricaCountryCodePickerState extends State<AfricaCountryCodePicker> {
  final TextEditingController _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(40),
      onTap: () async {
        final selected = await showModalBottomSheet<AfricaCountry>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => _PickerSheet(initial: widget.value, search: _search),
        );

        if (selected == null) return;
        widget.onChanged(selected);
      },
      child: Container(
        width: 135,
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: const Color(0xFFE7E7E7), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipOval(
              child: CountryFlag.fromCountryCode(
                widget.value.iso2,
                width: 35,
                height: 35,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              widget.value.dialCode,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w300,
                height: 1.4,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(width: 2),
            const Icon(Icons.keyboard_arrow_down_rounded,
                size: 18, color: Color(0xFF6D6D6D)),
          ],
        ),
      ),
    );
  }
}

class _PickerSheet extends StatefulWidget {
  const _PickerSheet({required this.initial, required this.search});

  final AfricaCountry initial;
  final TextEditingController search;

  @override
  State<_PickerSheet> createState() => _PickerSheetState();
}

class _PickerSheetState extends State<_PickerSheet> {
  late AfricaCountry _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initial;
    widget.search.text = '';
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final query = widget.search.text.trim().toLowerCase();

    final filtered = AfricaCountryCodePicker.countries.where((c) {
      if (query.isEmpty) return true;
      return c.name.toLowerCase().contains(query) ||
          c.dialCode.toLowerCase().contains(query) ||
          c.iso2.toLowerCase().contains(query);
    }).toList(growable: false);

    return Container(
      padding: EdgeInsets.only(bottom: bottom),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 42,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFE7E7E7),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: TextField(
                  controller: widget.search,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search',
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    prefixIcon: const Icon(Icons.search_rounded),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, i) {
                    final c = filtered[i];
                    final isSelected = c.iso2 == _selected.iso2;
                    return ListTile(
                      leading: Text(c.flagEmoji,
                          style: const TextStyle(fontSize: 22)),
                      title: Text(c.name),
                      subtitle: Text(c.dialCode),
                      trailing: isSelected
                          ? const Icon(Icons.check_rounded,
                              color: AppColors.primary)
                          : null,
                      onTap: () {
                        setState(() => _selected = c);
                        Navigator.of(context).pop(c);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
