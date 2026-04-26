import 'package:country_flags/country_flags.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

class _LanguageItem {
  const _LanguageItem({
    required this.code,
    required this.label,
    required this.countryCode,
  });

  final String code;
  final String label;
  final String countryCode;
}

class LanguageSettingsScreen extends StatefulWidget {
  const LanguageSettingsScreen({super.key});

  @override
  State<LanguageSettingsScreen> createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String _selected = 'fr';
  bool _syncedWithLocale = false;

  static const List<_LanguageItem> _languages = [
    _LanguageItem(code: 'en', label: 'Anglais', countryCode: 'US'),
    _LanguageItem(code: 'es', label: 'Espagnol', countryCode: 'ES'),
    _LanguageItem(code: 'fr', label: 'Français', countryCode: 'FR'),
    _LanguageItem(code: 'de', label: 'Allemand', countryCode: 'DE'),
    _LanguageItem(code: 'hi', label: 'Hindi', countryCode: 'IN'),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_syncedWithLocale) return;
    _syncedWithLocale = true;
    _selected = context.locale.languageCode;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  _LanguageItem get _selectedItem =>
      _languages.firstWhere((l) => l.code == _selected,
          orElse: () => _languages[2]);

  List<_LanguageItem> get _filtered {
    if (_query.isEmpty) return _languages;
    final q = _query.toLowerCase();
    return _languages.where((l) => l.label.toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // ── Top bar
            Padding(
              padding: EdgeInsets.fromLTRB(14, topPadding + 10, 14, 18),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: AppColors.text, size: 20),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Langue',
                        style: AppTextStyles.sectionTitle.copyWith(
                          fontFamily: 'Lexend',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.text,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Choisir la langue',
                      style: AppTextStyles.sectionTitle.copyWith(
                        fontFamily: 'Lexend',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Sélectionnez votre langue préférée ci-dessous. Cela nous aide à mieux vous servir.',
                      style: AppTextStyles.regular12.copyWith(
                        fontFamily: 'Lexend',
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      'Vous avez selectionner',
                      style: AppTextStyles.regular12.copyWith(
                        fontFamily: 'Lexend',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Selected card
                    Container(
                      height: 56,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                            color: AppColors.primary, width: 1.2),
                      ),
                      child: Row(
                        children: [
                          ClipOval(
                            child: CountryFlag.fromCountryCode(
                              _selectedItem.countryCode,
                              width: 28,
                              height: 28,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _selectedItem.label,
                              style: AppTextStyles.regularlight16.copyWith(
                                fontFamily: 'Lexend',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.text,
                              ),
                            ),
                          ),
                          Container(
                            width: 22,
                            height: 22,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: const Icon(Icons.check_rounded,
                                color: Colors.white, size: 14),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      'Tous les langues',
                      style: AppTextStyles.regular12.copyWith(
                        fontFamily: 'Lexend',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Search
                    Row(
                      children: [
                        const Icon(Icons.search_rounded,
                            color: AppColors.text, size: 22),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (v) => setState(() => _query = v),
                            style: AppTextStyles.regularlight16.copyWith(
                              fontFamily: 'Lexend',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.text,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              hintText: 'Rechercher',
                              hintStyle:
                                  AppTextStyles.regularlight16.copyWith(
                                fontFamily: 'Lexend',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.text,
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 8),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(height: 1, color: const Color(0xFFE5E7EB)),
                    const SizedBox(height: 6),
                    // List
                    ..._filtered.map((l) => _LanguageRow(
                          item: l,
                          selected: l.code == _selected,
                          onTap: () => setState(() => _selected = l.code),
                        )),
                  ],
                ),
              ),
            ),

            // ── Enregistrer
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.dark,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  onPressed: () {
                    context.setLocale(Locale(_selected));
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Enregistrer',
                    style: AppTextStyles.button.copyWith(
                      fontFamily: 'Lexend',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
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

class _LanguageRow extends StatelessWidget {
  const _LanguageRow({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _LanguageItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFDECE0) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            ClipOval(
              child: CountryFlag.fromCountryCode(
                item.countryCode,
                width: 28,
                height: 28,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.label,
                style: AppTextStyles.regularlight16.copyWith(
                  fontFamily: 'Lexend',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.text,
                ),
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : Colors.transparent,
                shape: BoxShape.circle,
                border: selected
                    ? null
                    : Border.all(
                        color: const Color(0xFFD9DEE5), width: 1),
              ),
              alignment: Alignment.center,
              child: selected
                  ? const Icon(Icons.check_rounded,
                      color: Colors.white, size: 12)
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
