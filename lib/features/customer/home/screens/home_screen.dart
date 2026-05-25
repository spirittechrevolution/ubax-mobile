import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:statefulclickcounter/features/customer/home/screens/advanced_search_screen.dart';
import 'package:statefulclickcounter/features/customer/home/screens/map_search_tab.dart';
import 'package:statefulclickcounter/features/customer/favorites/screens/favorites_screen.dart';
import 'package:statefulclickcounter/features/customer/hotels/screens/hotels_tab.dart';
import 'package:statefulclickcounter/features/customer/profile/screens/profile_tab.dart';
import 'package:statefulclickcounter/features/customer/profile/screens/bailleur_profile_tab.dart';
import 'package:statefulclickcounter/core/profile/profile_mode.dart';
import 'package:statefulclickcounter/core/navigation/app_router.dart';
import 'package:statefulclickcounter/core/favorites/favorites_store.dart';
import 'package:statefulclickcounter/core/di/injection.dart';

import 'package:statefulclickcounter/features/customer/home/screens/all_properties_screen.dart';
import 'package:statefulclickcounter/core/widgets/orange_button.dart';
import 'package:statefulclickcounter/core/widgets/recommended_tile.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';
import 'package:statefulclickcounter/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:statefulclickcounter/features/customer/properties/data/models/property_models.dart';
import 'package:statefulclickcounter/features/customer/properties/domain/repositories/properties_repository.dart';
import 'package:statefulclickcounter/features/customer/settings/screens/personal_info_screen.dart';

final ValueNotifier<int?> homeRequestedTabIndex = ValueNotifier<int?>(null);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeMockData {
  const _HomeMockData({required this.popular, required this.recommended});

  final List<_PopularMockProperty> popular;
  final List<_RecommendedMockProperty> recommended;

  static _HomeMockData generate({
    required bool rent,
    required int seed,
    _SearchFilters filters = const _SearchFilters(),
  }) {
    final r = Random(seed);

    const propertyTypes = <String>[
      'Appartement',
      'Villa',
      'Studio',
      'Duplex',
      'Terrain',
    ];

    final images = <String>[
      'assets/images/villa.jpg',
      'assets/images/villa1.jpg',
      'assets/images/villa2.jpg',
      'assets/images/villa3.jpg',
      'assets/images/piscine.jpg',
      'assets/images/villa8.jpg',
      'assets/images/villapiscnie.jpg',
      'assets/images/appartements-luxe.jpg',
      'assets/images/chambre11.jpg',
      'assets/images/chambre12.jpg',
      'assets/images/chambre13.jpg',
    ];

    final titlesRent = <String>[
      'Appartement moderne',
      'Studio meublé premium',
      'Duplex familial',
      'Villa cosy',
      'Penthouse lumineux',
      'Résidence sécurisée',
    ];

    final titlesBuy = <String>[
      'Villa contemporaine',
      'Duplex avec jardin',
      'Appartement vue mer',
      'Penthouse moderne',
      'Villa de luxe',
      'Résidence haut standing',
    ];

    final locations = <String>[
      "Cocody Angré, Abidjan – Côte d'Ivoire",
      "Riviera, Abidjan – Côte d'Ivoire",
      "Plateau, Abidjan – Côte d'Ivoire",
      "Marcory, Abidjan – Côte d'Ivoire",
      "Treichville, Abidjan – Côte d'Ivoire",
      "Zone 4, Abidjan – Côte d'Ivoire",
    ];

    final popular = List.generate(4, (i) {
      final id = '${rent ? 'rent' : 'buy'}-popular-$seed-$i';
      final beds = 3 + r.nextInt(5);
      final baths = 1 + r.nextInt(4);
      final kitchens = 1 + r.nextInt(2);
      final type = propertyTypes[r.nextInt(propertyTypes.length)];
      final img = images[r.nextInt(images.length)];
      final titlePool = rent ? titlesRent : titlesBuy;
      final title = titlePool[r.nextInt(titlePool.length)];
      final location = locations[r.nextInt(locations.length)];
      final base = rent
          ? (150000 + r.nextInt(250000))
          : (45000000 + r.nextInt(90000000));
      final price = _formatFcfa(base);

      return _PopularMockProperty(
        id: id,
        imagePath: img,
        price: price,
        title: title,
        location: location,
        beds: beds,
        baths: baths,
        kitchens: kitchens,
        type: type,
      );
    });

    final recommended = List.generate(5, (i) {
      final id = '${rent ? 'rent' : 'buy'}-recommended-$seed-$i';
      final beds = 1 + r.nextInt(5);
      final baths = 1 + r.nextInt(3);
      final salons = 1 + r.nextInt(2);
      final kitchens = 1;
      final type = propertyTypes[r.nextInt(propertyTypes.length)];
      final img = images[r.nextInt(images.length)];
      final titlePool = rent ? titlesRent : titlesBuy;
      final title = titlePool[r.nextInt(titlePool.length)];
      final location = locations[r.nextInt(locations.length)];
      final base = rent
          ? (120000 + r.nextInt(380000))
          : (38000000 + r.nextInt(120000000));
      final price = _formatFcfa(base);

      return _RecommendedMockProperty(
        id: id,
        imagePath: img,
        type: type,
        title: title,
        location: location,
        price: price,
        beds: beds,
        baths: baths,
        salons: salons,
        kitchens: kitchens,
      );
    });

    popular.shuffle(r);
    recommended.shuffle(r);

    var filteredPopular = popular;
    var filteredRecommended = recommended;

    if (filters.rooms != null) {
      filteredPopular =
          filteredPopular.where((p) => p.beds == filters.rooms).toList();
      filteredRecommended =
          filteredRecommended.where((p) => p.beds == filters.rooms).toList();
    }

    if (filters.type != null) {
      filteredPopular =
          filteredPopular.where((p) => p.type == filters.type).toList();
      filteredRecommended =
          filteredRecommended.where((p) => p.type == filters.type).toList();
    }

    final finalPopular = filteredPopular.isNotEmpty ? filteredPopular : popular;
    final finalRecommended =
        filteredRecommended.isNotEmpty ? filteredRecommended : recommended;

    return _HomeMockData(popular: finalPopular, recommended: finalRecommended);
  }

  static String _formatFcfa(int amount) {
    final s = amount.toString();
    final b = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      final reverseIndex = s.length - i;
      b.write(s[i]);
      if (reverseIndex > 1 && reverseIndex % 3 == 1) b.write(' ');
    }
    return '${b.toString()} Fcfa';
  }
}

class _PopularMockProperty {
  const _PopularMockProperty({
    required this.id,
    required this.imagePath,
    required this.price,
    required this.title,
    required this.location,
    required this.beds,
    required this.baths,
    required this.kitchens,
    this.propertyId,
    required this.type,
  });

  final String id;
  final String imagePath;
  final String price;
  final String title;
  final String location;
  final int beds;
  final int baths;
  final int kitchens;
  final String? propertyId;
  final String type;
}

class _RecommendedMockProperty {
  const _RecommendedMockProperty({
    required this.id,
    required this.imagePath,
    required this.type,
    required this.title,
    required this.location,
    required this.price,
    required this.beds,
    required this.baths,
    required this.salons,
    required this.kitchens,
  });

  final String id;
  final String imagePath;
  final String type;
  final String title;
  final String location;
  final String price;
  final int beds;
  final int baths;
  final int salons;
  final int kitchens;
}

class _AnimatedTabStack extends StatelessWidget {
  const _AnimatedTabStack({
    required this.index,
    required this.previousIndex,
    required this.children,
  });

  final int index;
  final int previousIndex;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final direction = index >= previousIndex ? 1.0 : -1.0;

    return Stack(
      fit: StackFit.expand,
      children: [
        for (var i = 0; i < children.length; i++)
          Offstage(
            offstage: i != index && i != previousIndex,
            child: IgnorePointer(
              ignoring: i != index,
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeOut,
                offset: i == index ? Offset.zero : Offset(-0.08 * direction, 0),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOut,
                  opacity: i == index ? 1.0 : 0.0,
                  child: children[i],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  int _previousIndex = 0;

  @override
  void initState() {
    super.initState();
    homeRequestedTabIndex.addListener(_handleRequestedTab);
    // Hydrate favorites cache so heart icons across the app reflect the
    // user's real favorites from the very first frame (not just after the
    // Favoris tab is opened). Silent on failure — any explicit toggle
    // will retry against the API.
    FavoritesStore.instance.refresh().then<void>((_) {}).catchError((_) {});
  }

  void _handleRequestedTab() {
    final requested = homeRequestedTabIndex.value;
    if (requested == null) return;
    if (!mounted) return;
    homeRequestedTabIndex.value = null;
    _setIndex(requested);
  }

  @override
  void dispose() {
    homeRequestedTabIndex.removeListener(_handleRequestedTab);
    super.dispose();
  }

  void _setIndex(int next) {
    if (next == _index) return;
    setState(() {
      _previousIndex = _index;
      _index = next;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ValueListenableBuilder<ProfileMode>(
        valueListenable: profileModeNotifier,
        builder: (_, mode, __) => _AnimatedTabStack(
          index: _index,
          previousIndex: _previousIndex,
          children: [
            const SafeArea(bottom: false, child: _HomeTab()),
            const SafeArea(top: false, bottom: false, child: HotelsTab()),
            SafeArea(bottom: false, child: MapSearchTab(isActive: _index == 2)),
            SafeArea(
              bottom: false,
              child: FavoritesTab(isActive: _index == 3),
            ),
            // Profile/Bailleur tabs let their hero header extend behind the status bar
            mode == ProfileMode.bailleur
                ? BailleurProfileTab(
                    onViewChanged: (_) {},
                  )
                : const ProfileTab(),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Container(
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 18,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Row(
                children: [
                  Expanded(
                    flex: _index == 0 ? 2 : 1,
                    child: Center(
                      child: _NavItem(
                        icon: Icons.home_rounded,
                        label: 'Accueil',
                        selected: _index == 0,
                        onTap: () => _setIndex(0),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: _index == 1 ? 2 : 1,
                    child: Center(
                      child: _NavItem(
                        icon: Icons.apartment_rounded,
                        label: 'Hôtels',
                        selected: _index == 1,
                        onTap: () => _setIndex(1),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: _index == 2 ? 2 : 1,
                    child: Center(
                      child: _NavItem(
                        icon: Icons.search_rounded,
                        label: 'Recherche',
                        selected: _index == 2,
                        onTap: () => _setIndex(2),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: _index == 3 ? 2 : 1,
                    child: Center(
                      child: _NavItem(
                        icon: Icons.favorite_rounded,
                        label: 'Favoris',
                        selected: _index == 3,
                        onTap: () => _setIndex(3),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: _index == 4 ? 2 : 1,
                    child: Center(
                      child: _NavItem(
                        icon: Icons.person_rounded,
                        label: 'Dashbo',
                        selected: _index == 4,
                        onTap: () => _setIndex(4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 46,
        padding: selected
            ? const EdgeInsets.symmetric(horizontal: 14)
            : const EdgeInsets.symmetric(horizontal: 0),
        decoration: BoxDecoration(
          color: selected ? AppColors.dark : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: selected ? Colors.white : AppColors.muted,
            ),
            if (selected) ...[
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _HomeTab extends StatefulWidget {
  const _HomeTab();

  @override
  State<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<_HomeTab> {
  bool _rent = true;
  bool _isSwitching = false;

  bool _apiLoading = true;
  List<PropertyItem> _apiItems = const [];

  late _HomeMockData _rentData;
  late _HomeMockData _buyData;

  _SearchFilters _filters = const _SearchFilters();
  final FavoritesStore _favorites = FavoritesStore.instance;

  @override
  void initState() {
    super.initState();
    _refreshData();
    _loadApi();
  }

  Future<void> _loadApi() async {
    setState(() {
      _apiLoading = true;
    });
    try {
      String? apiType;
      final uiType = _filters.type;
      if (uiType != null && uiType.trim().isNotEmpty) {
        final upper = uiType.trim().toUpperCase();
        if (upper.contains('APPART')) apiType = 'APPARTEMENT';
        if (upper.contains('APART')) apiType = 'APPARTEMENT';
        if (upper.contains('VILLA')) apiType = 'VILLA';
        if (upper.contains('STUDIO')) apiType = 'STUDIO';
      }

      String? apiCity;
      final zone = _filters.zoneLabel;
      if (zone != null && zone.trim().isNotEmpty) {
        apiCity = zone.trim();
      }

      final page = await getIt<PropertiesRepository>().getProperties(
        type: apiType,
        city: apiCity,
        minPrice: _filters.minPrice,
        maxPrice: _filters.maxPrice,
        bedrooms: _filters.rooms,
      );
      if (!mounted) return;
      setState(() {
        _apiItems = page.results;
        _apiLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _apiLoading = false;
      });
    }
  }

  bool _matchesTransaction(PropertyItem p) {
    final tx = p.transactionType.toUpperCase();
    if (_rent) return tx.startsWith('RENT');
    return tx == 'SALE';
  }

  String _fmtFcfa(num value) {
    final s = value.round().toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      final fromEnd = s.length - i;
      buf.write(s[i]);
      if (fromEnd > 1 && fromEnd % 3 == 1) buf.write(' ');
    }
    return buf.toString();
  }

  ({List<PropertyItem> popular, List<PropertyItem> recommended}) _splitApi() {
    final popular = _apiItems.where((p) => p.boosted).toList(growable: false);
    final recommended = _apiItems
        .where((p) => !p.boosted && _matchesTransaction(p))
        .toList(growable: false);
    return (popular: popular, recommended: recommended);
  }

  void _refreshData() {
    final seed = DateTime.now().millisecondsSinceEpoch;
    _rentData =
        _HomeMockData.generate(rent: true, seed: seed, filters: _filters);
    _buyData =
        _HomeMockData.generate(rent: false, seed: seed + 41, filters: _filters);
  }

  Future<void> _handlePullToRefresh() async {
    if (_isSwitching) return;
    setState(() => _isSwitching = true);
    try {
      await Future.wait([
        _loadApi(),
        Future<void>.delayed(const Duration(milliseconds: 220)),
      ]);
    } finally {
      if (!mounted) return;
      setState(() {
        _refreshData();
        _isSwitching = false;
      });
    }
  }

  void _handleRentChanged(bool value) {
    if (_rent == value) return;

    setState(() {
      _rent = value;
      _isSwitching = true;
    });

    Future<void>.delayed(const Duration(milliseconds: 750), () {
      if (!mounted) return;
      setState(() {
        _isSwitching = false;
        _refreshData();
      });
    });
  }

  void _handleSearch(_SearchFilters filters) {
    setState(() {
      if (filters.rent != null) _rent = filters.rent!;
      _filters = filters;
      _isSwitching = true;
    });

    _loadApi();

    Future<void>.delayed(const Duration(milliseconds: 750), () {
      if (!mounted) return;
      setState(() {
        _isSwitching = false;
        _refreshData();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = _rent ? _rentData : _buyData;
    final api = _splitApi();

    return ValueListenableBuilder<Set<String>>(
      valueListenable: _favorites.favorites,
      builder: (context, favs, _) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const PersonalInfoScreen(),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BlocBuilder<AuthBloc, AuthState>(
                          buildWhen: (prev, next) =>
                              prev.currentUser?.avatarUrl !=
                              next.currentUser?.avatarUrl,
                          builder: (context, state) {
                            final url = state.currentUser?.avatarUrl;
                            final hasUrl = url != null && url.trim().isNotEmpty;
                            return CircleAvatar(
                              radius: 22,
                              backgroundColor: const Color(0xFFD9E3EE),
                              backgroundImage: hasUrl
                                  ? NetworkImage(url) as ImageProvider
                                  : null,
                              child: hasUrl
                                  ? null
                                  : const Icon(Icons.person,
                                      color: AppColors.dark),
                            );
                          },
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Bonjour',
                              style: TextStyle(
                                color: Color(0xFF6D6D6D),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            BlocBuilder<AuthBloc, AuthState>(
                              buildWhen: (prev, next) =>
                                  prev.currentUser != next.currentUser,
                              builder: (context, state) {
                                final name = state.currentUser?.fullName
                                            .trim()
                                            .isNotEmpty ==
                                        true
                                    ? state.currentUser!.fullName
                                    : '—';
                                return Text(
                                  name,
                                  style: const TextStyle(
                                    color: AppColors.textBlack,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  _NotifButton(count: 5, onTap: () {}),
                  const SizedBox(width: 10),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BlocBuilder<AuthBloc, AuthState>(
                          buildWhen: (prev, next) =>
                              prev.currentUser?.country !=
                              next.currentUser?.country,
                          builder: (context, state) {
                            final raw = state.currentUser?.country;
                            final code = (raw == null || raw.trim().length != 2)
                                ? 'CI'
                                : raw.trim().toUpperCase();
                            return ClipOval(
                              child: CountryFlag.fromCountryCode(
                                code,
                                width: 28,
                                height: 28,
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.keyboard_arrow_down_rounded,
                            size: 16, color: AppColors.dark),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, animation) {
                  final fade =
                      CurvedAnimation(parent: animation, curve: Curves.easeOut);
                  final offsetTween = Tween<Offset>(
                    begin: const Offset(0.0, 0.02),
                    end: Offset.zero,
                  ).animate(fade);
                  return FadeTransition(
                    opacity: fade,
                    child: SlideTransition(position: offsetTween, child: child),
                  );
                },
                child: _isSwitching
                    ? const _HomeSkeleton(key: ValueKey<String>('skeleton'))
                    : RefreshIndicator(
                        onRefresh: _handlePullToRefresh,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          key: ValueKey<bool>(_rent),
                          padding: const EdgeInsets.fromLTRB(18, 0, 18, 110),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _SearchCard(
                                rent: _rent,
                                onRentChanged: _handleRentChanged,
                                onSearch: _handleSearch,
                              ),
                              const SizedBox(height: 20),
                              if (_apiLoading || api.popular.isNotEmpty) ...[
                                _SectionHeader(
                                  title: 'Les plus populaires',
                                  onSeeAll: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute<void>(
                                        builder: (_) => AllPropertiesScreen(
                                          title: 'Les plus populaires',
                                          popular: api.popular,
                                          recommended: api.recommended,
                                          onItemTap: (p) {
                                            final img = p.coverPhotoUrl ??
                                                'assets/images/chambre12.jpg';
                                            context.push(
                                              AppRoutes.propertyDetails,
                                              extra: PropertyDetailsArgs(
                                                propertyId: p.id,
                                                coverImageFallback: img,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  height: 194,
                                  child: _apiLoading
                                      ? ListView.separated(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: 3,
                                          separatorBuilder: (_, __) =>
                                              const SizedBox(width: 12),
                                          itemBuilder: (_, __) => Container(
                                            width: 160,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFE2E8F0),
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                          ),
                                        )
                                      : ListView.separated(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: api.popular.length,
                                          separatorBuilder: (_, __) =>
                                              const SizedBox(width: 12),
                                          itemBuilder: (_, i) {
                                            final p = api.popular[i];
                                            final imagePath = p.coverPhotoUrl ??
                                                'assets/images/chambre12.jpg';
                                            return _PropertyCard(
                                              isFavorite: favs.contains(p.id),
                                              onFavoriteToggle: () =>
                                                  _favorites.toggle(p.id),
                                              imagePath: imagePath,
                                              price:
                                                  '${_fmtFcfa(p.price)} FCFA',
                                              title: p.title,
                                              location: p.district.isNotEmpty
                                                  ? '${p.district}, ${p.city}'
                                                  : p.city,
                                              beds: p.bedrooms,
                                              baths: p.bathrooms,
                                              kitchens: 1,
                                              propertyId: p.id,
                                            );
                                          },
                                        ),
                                ),
                                const SizedBox(height: 18),
                              ],
                              _SectionHeader(
                                title: 'Biens recommandés',
                                onSeeAll: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (_) => AllPropertiesScreen(
                                        title: 'Biens recommandés',
                                        popular: api.popular,
                                        recommended: api.recommended,
                                        onItemTap: (p) {
                                          final img = p.coverPhotoUrl ??
                                              'assets/images/chambre11.jpg';
                                          context.push(
                                            AppRoutes.propertyDetails,
                                            extra: PropertyDetailsArgs(
                                              propertyId: p.id,
                                              coverImageFallback: img,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 12),
                              if (_apiLoading)
                                const SizedBox.shrink()
                              else if (api.recommended.isNotEmpty)
                                ...api.recommended.map(
                                  (p) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: RecommendedTile(
                                      imagePath: p.coverPhotoUrl ??
                                          'assets/images/chambre11.jpg',
                                      title: p.title,
                                      location: p.district.isNotEmpty
                                          ? '${p.district}, ${p.city}'
                                          : p.city,
                                      beds: p.bedrooms,
                                      baths: p.bathrooms,
                                      salons: 1,
                                      isFavorite: favs.contains(p.id),
                                      onFavoriteToggle: () =>
                                          _favorites.toggle(p.id),
                                      onTap: () {
                                        context.push(
                                          AppRoutes.propertyDetails,
                                          extra: PropertyDetailsArgs(
                                            propertyId: p.id,
                                            coverImageFallback: p
                                                    .coverPhotoUrl ??
                                                'assets/images/chambre11.jpg',
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                )
                              else
                                ...data.recommended.map(
                                  (p) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: RecommendedTile(
                                      imagePath: p.imagePath,
                                      title: p.title,
                                      location: p.location,
                                      beds: p.beds,
                                      baths: p.baths,
                                      salons: p.salons,
                                      isFavorite: favs.contains(p.id),
                                      onFavoriteToggle: () =>
                                          _favorites.toggle(p.id),
                                      onTap: () {
                                        context.push(
                                          AppRoutes.propertyDetails,
                                          extra: PropertyDetailsArgs(
                                            propertyId: p.id,
                                            coverImageFallback: p.imagePath,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _HomeSkeleton extends StatelessWidget {
  const _HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    const base = Color(0xFFE2E8F0);

    Widget block({required double h, double? w, double r = 16}) {
      return Container(
        height: h,
        width: w,
        decoration: BoxDecoration(
          color: base,
          borderRadius: BorderRadius.circular(r),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 110),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          block(h: 255, r: 24),
          const SizedBox(height: 20),
          block(h: 14, w: 160, r: 8),
          const SizedBox(height: 12),
          SizedBox(
            height: 194,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, __) => block(h: 194, w: 250, r: 18),
            ),
          ),
          const SizedBox(height: 18),
          block(h: 14, w: 170, r: 8),
          const SizedBox(height: 12),
          block(h: 119, r: 18),
          const SizedBox(height: 12),
          block(h: 119, r: 18),
          const SizedBox(height: 12),
          block(h: 119, r: 18),
        ],
      ),
    );
  }
}

class _NotifButton extends StatelessWidget {
  const _NotifButton({required this.count, required this.onTap});

  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notifications (bientôt disponible)')),
        );
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
        ),
        alignment: Alignment.center,
        child:
            const Icon(Icons.notifications_none_rounded, color: AppColors.dark),
      ),
    );
  }
}

class _SearchCard extends StatefulWidget {
  const _SearchCard({
    required this.rent,
    required this.onRentChanged,
    required this.onSearch,
  });

  final bool rent;
  final ValueChanged<bool> onRentChanged;
  final ValueChanged<_SearchFilters> onSearch;

  @override
  State<_SearchCard> createState() => _SearchCardState();
}

class _SearchCardState extends State<_SearchCard> {
  String? _selectedZone;
  int? _selectedRooms;
  String? _selectedType;

  Future<void> _pickZone() async {
    final selected = await context.push<String>(AppRoutes.addressSearch);
    if (!mounted || selected == null) return;
    setState(() => _selectedZone = selected);
  }

  Future<void> _pickRooms() async {
    final selected = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        final values = <int>[1, 2, 3, 4, 5, 6];
        return SafeArea(
          child: ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
            itemCount: values.length + 1,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              if (index == values.length) {
                return ListTile(
                  title: const Text('6+'),
                  trailing:
                      _selectedRooms == 6 ? const Icon(Icons.check) : null,
                  onTap: () => Navigator.of(context).pop(6),
                );
              }
              final v = values[index];
              return ListTile(
                title: Text('$v'),
                trailing: _selectedRooms == v ? const Icon(Icons.check) : null,
                onTap: () => Navigator.of(context).pop(v),
              );
            },
          ),
        );
      },
    );

    if (!mounted || selected == null) return;
    setState(() => _selectedRooms = selected);
  }

  Future<void> _pickType() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        const values = <String>[
          'Appartement',
          'Villa',
          'Studio',
          'Duplex',
          'Terrain',
        ];
        return SafeArea(
          child: ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
            itemCount: values.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final v = values[index];
              return ListTile(
                title: Text(v),
                trailing: _selectedType == v ? const Icon(Icons.check) : null,
                onTap: () => Navigator.of(context).pop(v),
              );
            },
          ),
        );
      },
    );

    if (!mounted || selected == null) return;
    setState(() => _selectedType = selected);
  }

  void _submitSearch() {
    widget.onSearch(
      _SearchFilters(
        zoneLabel: _selectedZone,
        rooms: _selectedRooms,
        type: _selectedType,
      ),
    );
  }

  Future<void> _openAdvancedSearch() async {
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (_) => AdvancedSearchScreen(initialRent: widget.rent),
      ),
    );
    if (!mounted || result == null) return;

    final rent = result['rent'] as bool?;
    final zone = result['zone'] as String?;
    final type = result['type'] as String?;
    final rooms = result['rooms'] as int?;
    final minPrice = result['minPrice'] as int?;
    final maxPrice = result['maxPrice'] as int?;

    setState(() {
      if (zone != null) _selectedZone = zone;
      if (type != null) _selectedType = type;
      if (rooms != null) _selectedRooms = rooms;
    });

    widget.onSearch(
      _SearchFilters(
        rent: rent,
        zoneLabel: _selectedZone,
        type: _selectedType,
        rooms: _selectedRooms,
        minPrice: minPrice,
        maxPrice: maxPrice,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 57,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _Segment(
                    label: 'Louer',
                    selected: widget.rent,
                    onTap: () => widget.onRentChanged(true),
                  ),
                ),
                Expanded(
                  child: _Segment(
                    label: 'Acheter',
                    selected: !widget.rent,
                    onTap: () => widget.onRentChanged(false),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _InputChip(
            icon: Icons.location_on_outlined,
            text: _selectedZone ?? 'Rechercher une zone',
            trailing: null,
            onTap: _pickZone,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                flex: 222,
                child: _InputChip(
                  icon: Icons.meeting_room_outlined,
                  text: _selectedRooms == null
                      ? 'Nombre de pièces'
                      : (_selectedRooms == 6 ? '6+' : '$_selectedRooms'),
                  trailing: const Icon(Icons.keyboard_arrow_down_rounded,
                      color: AppColors.text),
                  onTap: _pickRooms,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                flex: 147,
                child: _InputChip(
                  icon: Icons.apartment_rounded,
                  text: _selectedType ?? 'Type',
                  trailing: const Icon(Icons.keyboard_arrow_down_rounded,
                      color: AppColors.text),
                  onTap: _pickType,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OrangeButton(
                  height: 49,
                  borderRadius: 40,
                  text: 'Rechercher les biens',
                  onPressed: _submitSearch,
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: () {
                  _openAdvancedSearch();
                },
                borderRadius: BorderRadius.circular(40),
                child: Container(
                  width: 49,
                  height: 49,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: const Icon(Icons.tune_rounded, color: AppColors.text),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SearchFilters {
  const _SearchFilters({
    this.rent,
    this.zoneLabel,
    this.rooms,
    this.type,
    this.minPrice,
    this.maxPrice,
  });

  final bool? rent;
  final String? zoneLabel;
  final int? rooms;
  final String? type;
  final int? minPrice;
  final int? maxPrice;
}

class _Segment extends StatelessWidget {
  const _Segment({
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
      child: Container(
        height: 49,
        decoration: BoxDecoration(
          color: selected ? AppColors.dark : Colors.transparent,
          borderRadius: BorderRadius.circular(40),
        ),
        alignment: Alignment.center,
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

class _InputChip extends StatelessWidget {
  const _InputChip({
    required this.icon,
    required this.text,
    required this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String text;
  final Widget? trailing;
  final VoidCallback? onTap;

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
            Icon(
              color: AppColors.text,
              icon,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.regular12.copyWith(color: AppColors.text),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.onSeeAll});

  final String title;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.regular20.copyWith(color: AppColors.text),
          ),
        ),
        TextButton(
          onPressed: onSeeAll,
          child: const Text(
            'Voir tout',
            style: TextStyle(
              color: AppColors.textBlack,
              fontWeight: FontWeight.w600,
            ),
          ),
        )
      ],
    );
  }
}

class _PropertyCard extends StatelessWidget {
  const _PropertyCard({
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.imagePath,
    required this.price,
    required this.title,
    required this.location,
    required this.beds,
    required this.baths,
    required this.kitchens,
    this.propertyId,
  });

  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  final String imagePath;
  final String price;
  final String title;
  final String location;
  final int beds;
  final int baths;
  final int kitchens;
  final String? propertyId;

  @override
  Widget build(BuildContext context) {
    final isNetwork =
        imagePath.startsWith('http://') || imagePath.startsWith('https://');

    return InkWell(
      onTap: () {
        final id = propertyId;
        if (id != null && id.isNotEmpty) {
          context.push(
            AppRoutes.propertyDetails,
            extra: PropertyDetailsArgs(
              propertyId: id,
              coverImageFallback: imagePath,
              mockTitle: title,
              mockLocation: location,
              mockPrice: price,
              mockDescription:
                  'Situé au cœur de Cocody Angré, l\'un des quartiers les plus recherchés pour son équilibre entre confort moderne, sécurité et proximité avec les services essentiels, ce bien offre un cadre de vie exceptionnel, pensé pour répondre aux besoins d\'une famille, d\'un cadre ou d\'un investisseur à la recherche d\'un bien de qualité.',
              mockBeds: beds,
              mockBaths: baths,
              mockKitchens: kitchens,
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 266,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(
              child: isNetwork
                  ? Image.network(imagePath, fit: BoxFit.cover)
                  : Image.asset(imagePath, fit: BoxFit.cover),
            ),
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x33000000),
                      Color(0x99000000),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 10,
              top: 14,
              child: Text(
                price,
                style: AppTextStyles.regularlight16.copyWith(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Positioned(
              right: 6,
              top: 6,
              child: InkWell(
                onTap: onFavoriteToggle,
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.favorite_rounded,
                    color: isFavorite ? const Color(0xFFEF4444) : Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.regularlight16.copyWith(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    location,
                    style: AppTextStyles.regular12.copyWith(
                      fontSize: 9,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Wrap(
                          spacing: 4,
                          runSpacing: 2,
                          children: [
                            _Info(
                              icon: Icons.bed_rounded,
                              text: '$beds Chambres',
                            ),
                            _Info(
                              icon: Icons.bathtub_rounded,
                              text: '$baths Salles de bains',
                            ),
                            _Info(
                              icon: Icons.kitchen_rounded,
                              text: '$kitchens Cuisines',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 25,
                        height: 25,
                        margin: const EdgeInsets.only(bottom: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(Icons.arrow_forward_rounded,
                            color: Colors.white, size: 16),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;
  static const Color _textColor = Colors.white;
  static const double _fontSize = 8;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 120),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.primary, size: 11),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: AppTextStyles.regular12.copyWith(
                fontSize: _fontSize,
                color: _textColor,
                fontWeight: FontWeight.w300,
                height: 1.4,
                letterSpacing: 0,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
