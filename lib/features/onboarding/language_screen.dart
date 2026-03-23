import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';

import 'package:statefulclickcounter/core/widgets/orange_button.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key, required this.onContinue});

  final ValueChanged<String> onContinue;

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  static const _orange = Color(0xFFE67E22);

  final TextEditingController _searchController = TextEditingController();

  String _selected = 'fr';
  bool _syncedWithLocale = false;

  final List<_LanguageItem> _languages = const [
    _LanguageItem(code: 'en', label: 'Anglais', flag: '🇺🇸'),
    _LanguageItem(code: 'es', label: 'Espagnol', flag: '🇪🇸'),
    _LanguageItem(code: 'fr', label: 'Français', flag: '🇫🇷'),
    _LanguageItem(code: 'de', label: 'Allemand', flag: '🇩🇪'),
    _LanguageItem(code: 'hi', label: 'Hindi', flag: '🇮🇳'),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_syncedWithLocale) return;
    _syncedWithLocale = true;
    final code = context.locale.languageCode;
    _selected = code;
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();
    final filtered = _languages
        .where((l) => l.label.toLowerCase().contains(query))
        .toList(growable: false);

    final selectedItem = _languages.firstWhere((l) => l.code == _selected,
        orElse: () => _languages.first);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/icons/logoubaxblue.png',
                        width: 40, height: 40),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'language.title'.tr(),
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                'language.subtitle'.tr(),
                style: const TextStyle(color: Color(0xFF6D6D6D), height: 1.3),
              ),
              const SizedBox(height: 18),
              Text(
                'language.selected'.tr(),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              _SelectedLanguageTile(
                item: selectedItem,
                orange: _orange,
              ),
              const SizedBox(height: 18),
              Text(
                'language.all'.tr(),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE7E7E7)),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'language.search'.tr(),
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: const Color(0xFFF5F5F5),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 220,
                      child: ListView.separated(
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, i) {
                          final item = filtered[i];
                          final selected = item.code == _selected;
                          return InkWell(
                            onTap: () {
                              setState(() => _selected = item.code);
                            },
                            child: Container(
                              color: selected ? const Color(0xFFFFF0E6) : null,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                              child: Row(
                                children: [
                                  Text(item.flag,
                                      style: const TextStyle(fontSize: 22)),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      item.label,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  _RadioDot(
                                      selected: selected, orange: _orange),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                child: OrangeButton(
                  text: 'common.continue'.tr(),
                  onPressed: () async {
                    await context.setLocale(Locale(_selected));
                    if (!mounted) return;
                    widget.onContinue(_selected);
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

class _LanguageItem {
  const _LanguageItem(
      {required this.code, required this.label, required this.flag});

  final String code;
  final String label;
  final String flag;
}

class _SelectedLanguageTile extends StatelessWidget {
  const _SelectedLanguageTile({required this.item, required this.orange});

  final _LanguageItem item;
  final Color orange;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: orange, width: 1.5),
      ),
      child: Row(
        children: [
          Text(item.flag, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              item.label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: orange,
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(Icons.check, size: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _RadioDot extends StatelessWidget {
  const _RadioDot({required this.selected, required this.orange});

  final bool selected;
  final Color orange;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFD0D0D0)),
        color: Colors.white,
      ),
      child: selected
          ? Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: orange,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            )
          : null,
    );
  }
}
