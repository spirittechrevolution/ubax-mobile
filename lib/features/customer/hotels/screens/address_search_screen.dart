import 'package:flutter/material.dart';

import 'package:statefulclickcounter/features/customer/hotels/screens/search_results_screen.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

// ─── Data ─────────────────────────────────────────────────────────────────────

class _AddressItem {
  const _AddressItem(this.title, this.subtitle);
  final String title;
  final String subtitle;
}

const _kAddresses = [
  _AddressItem(
    'Cocody Angré',
    'Angré 8e Tranche – Rue des Jardins, Cocody Angré Château – Rue des Résidences, Cocody Angré Nouveau CHU',
  ),
  _AddressItem(
    'Cocody Riviera',
    'Riviera Palmeraie – Avenue des Palmiers, Riviera Golf – Boulevard Mitterrand, Riviera Bonoumin – Rue des Villas, Cocody',
  ),
  _AddressItem(
    'Cocody Deux-Plateaux',
    'Angré 8e Tranche – Rue des Jardins, Cocody Angré Château – Rue des Résidences, Cocody Angré Nouveau CHU – Boulevard Latrille, Cocody',
  ),
  _AddressItem(
    'Marcory Zone 4',
    'Zone 4 A – Rue Paul Langevin, Zone 4 C – Rue du Canal, Marcory',
  ),
  _AddressItem(
    'Marcory Biétry',
    'Biétry Résidentiel – Rue du Littoral, Biétry Danga – Avenue de la Paix, Marcory',
  ),
  _AddressItem(
    'Cocody Angré',
    'Angré 8e Tranche – Rue des Jardins, Cocody Angré Château – Rue des Résidences, Cocody Angré Nouveau CHU – Boulevard Latrille, Cocody',
  ),
];

// ─── Screen ───────────────────────────────────────────────────────────────────

class AddressSearchScreen extends StatefulWidget {
  const AddressSearchScreen({super.key});

  @override
  State<AddressSearchScreen> createState() => _AddressSearchScreenState();
}

class _AddressSearchScreenState extends State<AddressSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<_AddressItem> _filtered = List.of(_kAddresses);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    final q = query.toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _filtered = List.of(_kAddresses);
      } else {
        _filtered = _kAddresses
            .where((a) =>
                a.title.toLowerCase().contains(q) ||
                a.subtitle.toLowerCase().contains(q))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Dark header
          Container(
            padding: EdgeInsets.fromLTRB(18, topPadding + 16, 18, 24),
            decoration: const BoxDecoration(
              color: AppColors.dark,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(26),
              ),
            ),
            child: Row(
              children: [
                // Orange icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.my_location_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                // Search field
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Adresse',
                        style: AppTextStyles.sectionTitle.copyWith(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      TextField(
                        controller: _controller,
                        autofocus: true,
                        onChanged: _onSearch,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                        cursorColor: AppColors.primary,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          hintText: 'Quelle localités voulez vous voir ?',
                          hintStyle: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
              itemCount: _filtered.length,
              separatorBuilder: (_, __) => const Divider(
                height: 1,
                color: Color(0xFFE5E7EB),
              ),
              itemBuilder: (_, i) {
                final item = _filtered[i];
                return InkWell(
                  onTap: () {
                    Navigator.of(context).pop(item.title);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => SearchResultsScreen(
                          addressTitle: item.title,
                          addressSubtitle: item.subtitle,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Pin icon
                        const Icon(
                          Icons.location_on,
                          color: Color(0xFFE05A2B),
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        // Text
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: AppTextStyles.sectionTitle.copyWith(
                                  color: AppColors.dark,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.subtitle,
                                style: AppTextStyles.regular12.copyWith(
                                  color: const Color(0xFF858585),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                ),
                                maxLines: 3,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
