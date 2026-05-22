import 'package:statefulclickcounter/core/network/error_handler.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:statefulclickcounter/core/di/injection.dart';
import 'package:statefulclickcounter/features/customer/bailleur_apply/data/models/agency_models.dart';
import 'package:statefulclickcounter/features/customer/bailleur_apply/domain/repositories/agencies_repository.dart';
import 'package:statefulclickcounter/features/customer/bailleur_apply/screens/agency_details_screen.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

// ─── Données statiques des filtres ───────────────────────────────────────────

const _kCountries = [
  'Côte d\'Ivoire',
  'Sénégal',
  'Mali',
  'Burkina Faso',
  'Ghana',
  'Guinée',
  'Cameroun',
  'Bénin',
  'Togo',
];

const _kRegions = {
  'Côte d\'Ivoire': [
    'Abidjan',
    'Yamoussoukro',
    'Bouaké',
    'San Pedro',
    'Korhogo',
    'Man',
    'Daloa',
  ],
  'Sénégal': ['Dakar', 'Thiès', 'Saint-Louis', 'Ziguinchor', 'Kaolack'],
  'Mali': ['Bamako', 'Sikasso', 'Ségou', 'Mopti', 'Kayes'],
  'Burkina Faso': ['Ouagadougou', 'Bobo-Dioulasso', 'Koudougou'],
  'Ghana': ['Accra', 'Kumasi', 'Tamale', 'Tema'],
  'Guinée': ['Conakry', 'Kankan', 'Labé'],
  'Cameroun': ['Yaoundé', 'Douala', 'Garoua', 'Bamenda'],
  'Bénin': ['Cotonou', 'Porto-Novo', 'Parakou'],
  'Togo': ['Lomé', 'Sokodé', 'Kpalimé'],
};

const _kZones = {
  'Abidjan': [
    'Cocody',
    'Plateau',
    'Yopougon',
    'Adjamé',
    'Marcory',
    'Treichville',
    'Abobo',
    'Port-Bouët',
    'Koumassi',
    'Attécoubé',
    'Bingerville',
    'Songon',
  ],
  'Yamoussoukro': ['Centre-ville', 'Habitat', 'Dioulakro'],
  'Bouaké': ['Air France', 'Commerce', 'Belleville'],
  'San Pedro': ['Cité', 'Zone industrielle'],
  'Dakar': ['Almadies', 'Plateau', 'Médina', 'Liberté', 'Grand Dakar'],
  'Bamako': ['ACI 2000', 'Hippodrome', 'Badalabougou', 'Lafiabougou'],
  'Ouagadougou': ['Dassasgo', 'Pissy', 'Wemtenga'],
  'Accra': ['East Legon', 'Osu', 'Cantonments', 'Adabraka'],
  'Conakry': ['Kaloum', 'Dixinn', 'Ratoma', 'Matam'],
  'Yaoundé': ['Bastos', 'Mvan', 'Mvog-Mbi', 'Mendong'],
  'Douala': ['Bonanjo', 'Akwa', 'Deido', 'Bali'],
  'Cotonou': ['Cadjehoun', 'Fidjrossè', 'Akpakpa'],
  'Lomé': ['Bè', 'Tokoin', 'Adéwui'],
};

// ─── Screen ───────────────────────────────────────────────────────────────────

class AgencySelectionScreen extends StatefulWidget {
  const AgencySelectionScreen({super.key});

  @override
  State<AgencySelectionScreen> createState() => _AgencySelectionScreenState();
}

class _AgencySelectionScreenState extends State<AgencySelectionScreen> {
  final _repo = getIt<AgenciesRepository>();
  final _searchCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  // Filtres avancés
  bool _showFilters = false;
  String? _selectedCountry;
  String? _selectedRegion;
  String? _selectedZone;

  List<AgencyItem> _agencies = [];
  int _totalElements = 0;
  bool _loading = true;
  bool _loadingMore = false;
  String? _error;
  int _page = 0;
  bool _isLast = false;

  List<String> get _availableRegions =>
      _selectedCountry != null ? (_kRegions[_selectedCountry] ?? []) : [];

  List<String> get _availableZones =>
      _selectedRegion != null ? (_kZones[_selectedRegion] ?? []) : [];

  @override
  void initState() {
    super.initState();
    _load(reset: true);
    _scrollCtrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollCtrl.position.pixels >=
            _scrollCtrl.position.maxScrollExtent - 200 &&
        !_loadingMore &&
        !_isLast) {
      _load(reset: false);
    }
  }

  Future<void> _load({required bool reset}) async {
    if (reset) {
      setState(() {
        _loading = true;
        _error = null;
        _page = 0;
        _agencies = [];
        _totalElements = 0;
      });
    } else {
      setState(() => _loadingMore = true);
    }

    try {
      final query =
          _searchCtrl.text.trim().isEmpty ? null : _searchCtrl.text.trim();
      final result = await _repo.getAgencies(
        city: query,
        country: _selectedCountry,
        region: _selectedRegion,
        zone: _selectedZone,
        page: _page,
        size: 20,
      );
      if (!mounted) return;
      setState(() {
        _agencies = reset ? result.results : [..._agencies, ...result.results];
        _totalElements = result.totalElements;
        _isLast = result.isLast;
        _page = result.page + 1;
        _loading = false;
        _loadingMore = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = AppErrors.translate(e);
        _loading = false;
        _loadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.dark,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'bailleur_apply.step1.list_title'.tr(),
          style: AppTextStyles.regularlight16.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // ── Header : barre de recherche + panneau filtre animé
          _SearchHeader(
            controller: _searchCtrl,
            showFilters: _showFilters,
            selectedCountry: _selectedCountry,
            selectedRegion: _selectedRegion,
            selectedZone: _selectedZone,
            availableRegions: _availableRegions,
            availableZones: _availableZones,
            onToggleFilters: () => setState(() => _showFilters = !_showFilters),
            onCountryChanged: (v) => setState(() {
              _selectedCountry = v;
              _selectedRegion = null;
              _selectedZone = null;
            }),
            onRegionChanged: (v) => setState(() {
              _selectedRegion = v;
              _selectedZone = null;
            }),
            onZoneChanged: (v) => setState(() => _selectedZone = v),
            onSearch: () {
              setState(() => _showFilters = false);
              _load(reset: true);
            },
          ),

          // ── Liste
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary))
                : _error != null
                    ? _ErrorState(
                        message: _error!,
                        onRetry: () => _load(reset: true),
                      )
                    : _agencies.isEmpty
                        ? _EmptyState(query: _searchCtrl.text.trim())
                        : _AgencyList(
                            agencies: _agencies,
                            totalElements: _totalElements,
                            loadingMore: _loadingMore,
                            scrollController: _scrollCtrl,
                            onSelect: (agency) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => AgencyDetailsScreen(
                                    agency: agency,
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

// ─── Search header ────────────────────────────────────────────────────────────

class _SearchHeader extends StatelessWidget {
  const _SearchHeader({
    required this.controller,
    required this.showFilters,
    required this.selectedCountry,
    required this.selectedRegion,
    required this.selectedZone,
    required this.availableRegions,
    required this.availableZones,
    required this.onToggleFilters,
    required this.onCountryChanged,
    required this.onRegionChanged,
    required this.onZoneChanged,
    required this.onSearch,
  });

  final TextEditingController controller;
  final bool showFilters;
  final String? selectedCountry;
  final String? selectedRegion;
  final String? selectedZone;
  final List<String> availableRegions;
  final List<String> availableZones;
  final VoidCallback onToggleFilters;
  final ValueChanged<String?> onCountryChanged;
  final ValueChanged<String?> onRegionChanged;
  final ValueChanged<String?> onZoneChanged;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.dark,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
        padding: EdgeInsets.fromLTRB(18, 0, 18, showFilters ? 20 : 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Barre de recherche
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 40, 50, 60),
                      borderRadius: BorderRadius.circular(23),
                    ),
                    child: TextField(
                      controller: controller,
                      onSubmitted: (_) => onSearch(),
                      style: AppTextStyles.regular12.copyWith(
                        color: AppColors.text,
                        fontSize: 13,
                      ),
                      decoration: InputDecoration(
                        hintText: 'bailleur_apply.step1.search_hint'.tr(),
                        hintStyle: AppTextStyles.regular12.copyWith(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: AppColors.muted,
                          size: 20,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: onToggleFilters,
                  child: Container(
                    height: 46,
                    width: 46,
                    decoration: BoxDecoration(
                      color: showFilters ? Colors.white : AppColors.primary,
                      borderRadius: BorderRadius.circular(23),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.tune_rounded,
                      color: showFilters ? AppColors.primary : Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),

            // ── Panneau filtre (visible uniquement si showFilters)
            if (showFilters) ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _FilterDropdown(
                      label: 'bailleur_apply.step1.filter_country'.tr(),
                      value: selectedCountry,
                      allLabel:
                          'bailleur_apply.step1.filter_all_countries'.tr(),
                      items: _kCountries.toList(),
                      onChanged: onCountryChanged,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _FilterDropdown(
                      label: 'bailleur_apply.step1.filter_region'.tr(),
                      value: selectedRegion,
                      allLabel: 'bailleur_apply.step1.filter_all_regions'.tr(),
                      items: availableRegions,
                      enabled: availableRegions.isNotEmpty,
                      onChanged: onRegionChanged,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _FilterDropdown(
                      label: 'bailleur_apply.step1.filter_zone'.tr(),
                      value: selectedZone,
                      allLabel: 'bailleur_apply.step1.filter_all_zones'.tr(),
                      items: availableZones,
                      enabled: availableZones.isNotEmpty,
                      onChanged: onZoneChanged,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 44,
                child: ElevatedButton(
                  onPressed: onSearch,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  child: Text(
                    'bailleur_apply.step1.filter_search'.tr(),
                    style: AppTextStyles.regular12.copyWith(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Dropdown filtre ──────────────────────────────────────────────────────────

class _FilterDropdown extends StatelessWidget {
  const _FilterDropdown({
    required this.label,
    required this.value,
    required this.allLabel,
    required this.items,
    required this.onChanged,
    this.enabled = true,
  });

  final String label;
  final String? value;
  final String allLabel;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final effectiveItems = [null, ...items];
    return PopupMenuButton<String?>(
      enabled: enabled,
      onSelected: onChanged,
      color: AppColors.dark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (_) => effectiveItems
          .map(
            (item) => PopupMenuItem<String?>(
              value: item,
              child: Text(
                item ?? allLabel,
                style: AppTextStyles.regular12.copyWith(
                  fontSize: 12,
                  color: item == value ? AppColors.primary : Colors.white,
                  fontWeight: item == value ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          )
          .toList(),
      child: Container(
        width: 110,
        height: 59,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF243D53),
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: value != null ? AppColors.primary : const Color(0xFF334D65),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                value ?? label,
                style: AppTextStyles.regular12.copyWith(
                  fontSize: 11,
                  color: enabled
                      ? (value != null ? AppColors.primary : Colors.white70)
                      : Colors.white38,
                  fontWeight: value != null ? FontWeight.w600 : FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16,
              color: enabled ? Colors.white70 : Colors.white30,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Agency list ──────────────────────────────────────────────────────────────

class _AgencyList extends StatelessWidget {
  const _AgencyList({
    required this.agencies,
    required this.totalElements,
    required this.loadingMore,
    required this.scrollController,
    required this.onSelect,
  });

  final List<AgencyItem> agencies;
  final int totalElements;
  final bool loadingMore;
  final ScrollController scrollController;
  final void Function(AgencyItem) onSelect;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: agencies.length + 2,
      separatorBuilder: (_, i) =>
          i == 0 ? const SizedBox.shrink() : const SizedBox(height: 12),
      itemBuilder: (_, i) {
        if (i == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              'bailleur_apply.step1.agencies_found'
                  .tr(args: ['$totalElements']),
              style: AppTextStyles.regular12.copyWith(
                fontSize: 13,
                color: AppColors.text,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }
        final idx = i - 1;
        if (idx == agencies.length) {
          return loadingMore
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                )
              : const SizedBox.shrink();
        }
        return _AgencyCard(agency: agencies[idx], onSelect: onSelect);
      },
    );
  }
}

// ─── Agency card ──────────────────────────────────────────────────────────────

class _AgencyCard extends StatelessWidget {
  const _AgencyCard({required this.agency, required this.onSelect});

  final AgencyItem agency;
  final void Function(AgencyItem) onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Logo + Nom + Ville
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _AgencyLogo(name: agency.name, logoUrl: agency.logoUrl),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            agency.name,
                            style: AppTextStyles.sectionTitle.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.text,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (agency.verified) ...[
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.verified_rounded,
                            color: Color(0xFF10B981),
                            size: 16,
                          ),
                        ],
                      ],
                    ),
                    if (agency.city != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        agency.city!,
                        style: AppTextStyles.regular12.copyWith(
                          fontSize: 12,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w300,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (agency.phone != null || agency.email != null) ...[
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (agency.phone != null) ...[
                              const _IconBadge(icon: Icons.phone_outlined),
                              const SizedBox(width: 4),
                              Text(
                                agency.phone!,
                                style: AppTextStyles.regular12.copyWith(
                                    fontSize: 9, color: AppColors.text),
                              ),
                            ],
                            if (agency.phone != null && agency.email != null)
                              const SizedBox(width: 16),
                            if (agency.email != null) ...[
                              const _IconBadge(icon: Icons.email_outlined),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  agency.email!,
                                  style: AppTextStyles.regular12.copyWith(
                                      fontSize: 9, color: AppColors.text),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ],
          ),

          // ── Téléphone + Email

          // ── Bouton
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 42,
            child: ElevatedButton(
              onPressed: () => onSelect(agency),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
              child: Text(
                'bailleur_apply.step1.view_details'.tr(),
                style: AppTextStyles.regular12.copyWith(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Logo ─────────────────────────────────────────────────────────────────────

class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 25,
      height: 25,
      decoration: const BoxDecoration(
        color: Color(0xFFF7F7F7),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: 12, color: AppColors.muted),
    );
  }
}

class _AgencyLogo extends StatelessWidget {
  const _AgencyLogo({required this.name, required this.logoUrl});

  final String name;
  final String? logoUrl;

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'A';
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 80,
        height: 64,
        child: logoUrl != null
            ? Image.network(
                logoUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _Initials(initial: initial),
              )
            : _Initials(initial: initial),
      ),
    );
  }
}

class _Initials extends StatelessWidget {
  const _Initials({required this.initial});

  final String initial;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.dark,
      alignment: Alignment.center,
      child: Text(
        initial,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          fontFamily: 'Lexend',
        ),
      ),
    );
  }
}

// ─── États vides / erreur ─────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.business_outlined,
                size: 64, color: AppColors.muted),
            const SizedBox(height: 16),
            Text(
              'bailleur_apply.step1.empty'.tr(),
              style: AppTextStyles.regular12
                  .copyWith(color: AppColors.muted, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded,
                size: 48, color: AppColors.muted),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.regular12
                  .copyWith(color: AppColors.muted, fontSize: 13),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: onRetry,
              child: Text(
                'Réessayer',
                style:
                    AppTextStyles.regular12.copyWith(color: AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
