import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:statefulclickcounter/core/widgets/recommended_tile.dart';
import 'package:statefulclickcounter/features/customer/home/screens/all_properties_screen.dart';
import 'package:statefulclickcounter/core/di/injection.dart';
import 'package:statefulclickcounter/features/customer/hotels/screens/address_search_screen.dart';
import 'package:statefulclickcounter/features/customer/hotels/screens/hotel_details_screen.dart';
import 'package:statefulclickcounter/features/customer/hotels/screens/search_results_screen.dart';
import 'package:statefulclickcounter/core/favorites/favorites_store.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';
import 'package:statefulclickcounter/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:statefulclickcounter/features/customer/properties/data/models/property_models.dart';
import 'package:statefulclickcounter/features/customer/properties/domain/repositories/properties_repository.dart';
import 'package:statefulclickcounter/features/customer/settings/screens/personal_info_screen.dart';

// ─── Data ─────────────────────────────────────────────────────────────────────

class _TypeData {
  const _TypeData(this.label, this.icon);
  final String label;
  final IconData icon;
}

class _PopularSkeleton extends StatelessWidget {
  const _PopularSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    Widget block() {
      return Container(
        width: 156,
        height: 220,
        decoration: BoxDecoration(
          color: const Color(0xFFE2E8F0),
          borderRadius: BorderRadius.circular(12),
        ),
      );
    }

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: 3,
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (_, __) => block(),
    );
  }
}

class _ApiRecommendedList extends StatelessWidget {
  const _ApiRecommendedList({
    super.key,
    required this.items,
    required this.selectedType,
  });

  final List<PropertyItem> items;
  final String selectedType;

  int _asInt(num v) => v.round();

  @override
  Widget build(BuildContext context) {
    final favorites = FavoritesStore.instance;
    return ValueListenableBuilder<Set<String>>(
      valueListenable: favorites.favorites,
      builder: (context, _, __) => _buildList(context, favorites),
    );
  }

  Widget _buildList(BuildContext context, FavoritesStore favorites) {
    return Column(
      children: [
        for (final p in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: selectedType == 'Hotels'
                ? _HotelHorizontalCard(
                    imagePath: p.coverPhotoUrl ?? 'assets/images/chambre12.jpg',
                    title: p.title,
                    location: p.district.isNotEmpty
                        ? '${p.district}, ${p.city}'
                        : p.city,
                    price: _asInt(p.price),
                    rating: 4.7,
                    favoriteId: p.id,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => HotelDetailsScreen(
                            imagePath: p.coverPhotoUrl ??
                                'assets/images/chambre12.jpg',
                            name: p.title,
                            location: p.district.isNotEmpty
                                ? '${p.district}, ${p.city}'
                                : p.city,
                            price: _asInt(p.price),
                            rating: 4.7,
                          ),
                        ),
                      );
                    },
                  )
                : RecommendedTile(
                    imagePath: p.coverPhotoUrl ?? 'assets/images/chambre11.jpg',
                    title: p.title,
                    location: p.district.isNotEmpty
                        ? '${p.district}, ${p.city}'
                        : p.city,
                    beds: p.bedrooms,
                    baths: p.bathrooms,
                    salons: 1,
                    isFavorite: favorites.isFavorite(p.id),
                    onFavoriteToggle: () => favorites.toggle(p.id),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => HotelDetailsScreen(
                            imagePath: p.coverPhotoUrl ??
                                'assets/images/chambre11.jpg',
                            name: p.title,
                            location: p.district.isNotEmpty
                                ? '${p.district}, ${p.city}'
                                : p.city,
                            price: _asInt(p.price),
                            rating: 4.7,
                          ),
                        ),
                      );
                    },
                  ),
          ),
      ],
    );
  }
}

class _RecommendedList extends StatelessWidget {
  const _RecommendedList({
    super.key,
    required this.selectedType,
  });

  final String selectedType;

  @override
  Widget build(BuildContext context) {
    final favorites = FavoritesStore.instance;
    final data = selectedType == 'Villas'
        ? _kRecommandesVillas
        : selectedType == 'Résidences'
            ? _kRecommandesResidences
            : _kRecommandesData;

    return Column(
      children: [
        for (final p in data)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: selectedType == 'Hotels'
                ? _HotelHorizontalCard(
                    imagePath: p['image'] as String,
                    title: p['name'] as String,
                    location: p['location'] as String,
                    price: int.tryParse(
                          (p['price'] as String).replaceAll(' ', ''),
                        ) ??
                        0,
                    rating: 4.7,
                    favoriteId:
                        'hotel-${p['name'] as String}-${p['location'] as String}',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => HotelDetailsScreen(
                            imagePath: p['image'] as String,
                            name: p['name'] as String,
                            location: p['location'] as String,
                            price: int.tryParse(
                                  (p['price'] as String).replaceAll(' ', ''),
                                ) ??
                                0,
                            rating: 4.7,
                          ),
                        ),
                      );
                    },
                  )
                : RecommendedTile(
                    imagePath: p['image'] as String,
                    title: p['name'] as String,
                    location: p['location'] as String,
                    beds: p['beds'] as int,
                    baths: p['baths'] as int,
                    salons: p['salons'] as int,
                    isFavorite: favorites.isFavorite(
                      'stay-${p['name'] as String}-${p['location'] as String}',
                    ),
                    onFavoriteToggle: () => favorites.toggle(
                      'stay-${p['name'] as String}-${p['location'] as String}',
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => HotelDetailsScreen(
                            imagePath: p['image'] as String,
                            name: p['name'] as String,
                            location: p['location'] as String,
                            price: int.tryParse(
                                  (p['price'] as String).replaceAll(' ', ''),
                                ) ??
                                0,
                            rating: 4.7,
                          ),
                        ),
                      );
                    },
                  ),
          ),
      ],
    );
  }
}

class _RecommendedSkeleton extends StatelessWidget {
  const _RecommendedSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    Widget block({required double h}) {
      return Container(
        height: h,
        decoration: BoxDecoration(
          color: const Color(0xFFE2E8F0),
          borderRadius: BorderRadius.circular(18),
        ),
      );
    }

    return Column(
      children: [
        block(h: 119),
        const SizedBox(height: 12),
        block(h: 119),
        const SizedBox(height: 12),
        block(h: 119),
      ],
    );
  }
}

const _kTypes = [
  _TypeData('Hotels', Icons.apartment_rounded),
  _TypeData('Villas', Icons.house_rounded),
  _TypeData('Résidences', Icons.business_rounded),
];

const _kRecommandesData = [
  {
    'image': 'assets/images/appartements-luxe.jpg',
    'name': 'Appartement Moderne à Cocody',
    'location': 'Cocody Angré, Abidjan – Côte d\'Ivoire',
    'beds': 3,
    'baths': 2,
    'salons': 1,
    'price': '250 000',
  },
  {
    'image': 'assets/images/chambre11.jpg',
    'name': 'Studio meublé au Plateau',
    'location': 'Plateau, Abidjan – Côte d\'Ivoire',
    'beds': 1,
    'baths': 1,
    'salons': 1,
    'price': '180 000',
  },
  {
    'image': 'assets/images/chambre12.jpg',
    'name': 'Studio Ultra Moderna',
    'location': 'Riviera Palmeraie, Abidjan – Côte d\'Ivoire',
    'beds': 4,
    'baths': 3,
    'salons': 2,
    'price': '450 000',
  },
];

const _kRecommandesVillas = [
  {
    'image': 'assets/images/villa1.jpg',
    'name': 'Villa contemporaine à Cocody',
    'location': 'Cocody Angré, Abidjan – Côte d\'Ivoire',
    'beds': 5,
    'baths': 3,
    'salons': 2,
    'price': '520 000',
  },
  {
    'image': 'assets/images/chambre4.jpg',
    'name': 'Villa familiale à Marcory',
    'location': 'Marcory, Abidjan – Côte d\'Ivoire',
    'beds': 4,
    'baths': 2,
    'salons': 2,
    'price': '410 000',
  },
  {
    'image': 'assets/images/villa3.jpg',
    'name': 'Villa de luxe nà Riviera',
    'location': 'Riviera, Abidjan – Côte d\'Ivoire',
    'beds': 6,
    'baths': 4,
    'salons': 3,
    'price': '680 000',
  },
];

const _kRecommandesResidences = [
  {
    'image': 'assets/images/chambre.jpg',
    'name': 'Résidence premium\nau Plateau',
    'location': 'Plateau, Abidjan – Côte d\'Ivoire',
    'beds': 2,
    'baths': 2,
    'salons': 1,
    'price': '230 000',
  },
  {
    'image': 'assets/images/chambre.jpg',
    'name': 'Résidence meublée à Zone 4',
    'location': 'Zone 4, Marcory – Abidjan',
    'beds': 1,
    'baths': 1,
    'salons': 1,
    'price': '190 000',
  },
  {
    'image': 'assets/images/chambre.jpg',
    'name': 'Résidence standing\nà Cocody',
    'location': 'Cocody, Abidjan – Côte d\'Ivoire',
    'beds': 3,
    'baths': 2,
    'salons': 2,
    'price': '310 000',
  },
];

// ─── Main tab ─────────────────────────────────────────────────────────────────

class HotelsTab extends StatefulWidget {
  const HotelsTab({super.key});

  @override
  State<HotelsTab> createState() => _HotelsTabState();
}

class _HotelsTabState extends State<HotelsTab>
    with SingleTickerProviderStateMixin {
  static const double _kDarkBgHeight = 160.0;

  String _selectedType = 'Hotels';
  bool _isSwitchingType = false;
  String? _selectedAddress;
  DateTime _arrival = DateTime(2026, 3, 15);
  DateTime _departure = DateTime(2026, 3, 18);

  bool _apiLoading = true;
  List<PropertyItem> _apiItems = const [];

  bool _isRefreshing = false;

  ({String title, String subtitle}) _splitAddress(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return (title: '', subtitle: '');

    final parts =
        trimmed.split(',').map((e) => e.trim()).toList(growable: false);
    if (parts.length <= 1) return (title: trimmed, subtitle: trimmed);

    final title = parts.first;
    final subtitle = parts.sublist(1).where((e) => e.isNotEmpty).join(', ');
    return (title: title, subtitle: subtitle.isEmpty ? trimmed : subtitle);
  }

  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0;

  final GlobalKey _bannerKey = GlobalKey();
  late AnimationController _buildingController;
  late Animation<Offset> _buildingSlide;
  bool _buildingTriggered = false;

  @override
  void initState() {
    super.initState();
    _buildingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _buildingSlide = Tween<Offset>(
      begin: const Offset(0, 1.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _buildingController,
      curve: Curves.easeOutCubic,
    ));

    _scrollController.addListener(() {
      final clamped = _scrollController.offset.clamp(0.0, _kDarkBgHeight);
      if (clamped != _scrollOffset) {
        setState(() => _scrollOffset = clamped);
      }
      _checkBannerVisibility();
    });

    _loadApi();
  }

  void _checkBannerVisibility() {
    if (_buildingTriggered) return;
    final ctx = _bannerKey.currentContext;
    if (ctx == null) return;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) return;
    final position = box.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;
    if (position.dy < screenHeight * 0.88) {
      _buildingTriggered = true;
      _buildingController.forward();
    }
  }

  Future<void> _loadApi() async {
    setState(() => _apiLoading = true);
    try {
      String? apiType;
      if (_selectedType == 'Villas') apiType = 'VILLA';
      if (_selectedType == 'Résidences') apiType = 'APPARTEMENT';

      String? apiCity;
      final addr = _selectedAddress;
      if (addr != null && addr.trim().isNotEmpty) {
        apiCity = addr.split(',').first.trim();
      }

      final page = await getIt<PropertiesRepository>().getProperties(
        type: apiType,
        city: apiCity,
      );
      if (!mounted) return;
      setState(() {
        _apiItems = page.results;
        _apiLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _apiItems = const [];
        _apiLoading = false;
      });
    }
  }

  Future<void> _handlePullToRefresh() async {
    if (_isRefreshing) return;
    setState(() {
      _isRefreshing = true;
      _apiLoading = true;
    });
    try {
      await Future.wait([
        _loadApi(),
        Future<void>.delayed(const Duration(milliseconds: 220)),
      ]);
    } finally {
      if (!mounted) return;
      setState(() {
        _isRefreshing = false;
        _apiLoading = false;
      });
    }
  }

  bool _matchesType(PropertyItem p) {
    final type = p.propertyType.toUpperCase();
    if (_selectedType == 'Hotels') return p.hotelId != null;
    if (_selectedType == 'Villas') return type == 'VILLA';
    // Résidences
    return type == 'APARTMENT';
  }

  ({List<PropertyItem> popular, List<PropertyItem> recommended}) _splitApi() {
    final popular = _apiItems.where((p) => p.boosted).toList(growable: false);
    final recommended = _apiItems
        .where((p) => !p.boosted && _matchesType(p))
        .toList(growable: false);
    return (popular: popular, recommended: recommended);
  }

  Future<void> _handleTypeChanged(String next) async {
    if (next == _selectedType || _isSwitchingType) return;
    setState(() => _isSwitchingType = true);
    await Future<void>.delayed(const Duration(milliseconds: 420));
    if (!mounted) return;
    setState(() {
      _selectedType = next;
      _isSwitchingType = false;
    });

    _loadApi();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _buildingController.dispose();
    super.dispose();
  }

  Future<void> _pickAddress() async {
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const AddressSearchScreen()),
    );
    if (!mounted || result == null) return;
    setState(() => _selectedAddress = result);
    _loadApi();
  }

  Future<void> _pickDate({required bool isArrival}) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final firstDate = today;

    final current = isArrival ? _arrival : _departure;
    final safeInitial = current.isBefore(firstDate) ? firstDate : current;

    final picked = await showDatePicker(
      context: context,
      initialDate: safeInitial,
      firstDate: firstDate,
      lastDate: DateTime(2027),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (picked == null) return;
    setState(() {
      if (isArrival) {
        _arrival = picked;

        final minDeparture = _arrival.add(const Duration(days: 1));
        if (_departure.isBefore(minDeparture)) {
          _departure = minDeparture;
        }
      } else {
        final minDeparture = _arrival.add(const Duration(days: 1));
        _departure = picked.isBefore(minDeparture) ? minDeparture : picked;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final api = _splitApi();

    return Container(
      color: AppColors.background,
      child: Column(
        children: [
          // ── Dark header
          Container(
            color: AppColors.dark,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                18,
                MediaQuery.of(context).padding.top + 10,
                18,
                20,
              ),
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
                            final hasUrl =
                                url != null && url.trim().isNotEmpty;
                            return CircleAvatar(
                              radius: 22,
                              backgroundColor: const Color(0xFF2D4A65),
                              backgroundImage: hasUrl
                                  ? NetworkImage(url) as ImageProvider
                                  : null,
                              child: hasUrl
                                  ? null
                                  : const Icon(Icons.person,
                                      color: Colors.white),
                            );
                          },
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Bonjour ',
                                  style: AppTextStyles.regular12.copyWith(
                                    color: const Color(0xFF94A3B8),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Text(
                                  '👋',
                                  style: AppTextStyles.regular12,
                                ),
                              ],
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
                                  style: AppTextStyles.regularlight16.copyWith(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
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
                  // Bell
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        alignment: Alignment.center,
                        child: const Icon(Icons.notifications_rounded,
                            color: AppColors.dark, size: 22),
                      ),
                      Positioned(
                        top: -2,
                        right: -2,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '5',
                            style: AppTextStyles.regular12.copyWith(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Container(
                    height: 42,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
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
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 16,
                          color: AppColors.dark,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Body
          Expanded(
            child: Stack(
              children: [
                // Dark background extension behind search card — folds on scroll
                Container(
                  height: (_kDarkBgHeight - _scrollOffset)
                      .clamp(0.0, _kDarkBgHeight),
                  decoration: const BoxDecoration(
                    color: AppColors.dark,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(16),
                    ),
                  ),
                ),
                RefreshIndicator(
                  onRefresh: _handlePullToRefresh,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Search card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x14000000),
                                blurRadius: 20,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Address
                              GestureDetector(
                                onTap: _pickAddress,
                                child: Container(
                                  height: 43,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFECF2F7),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.location_on_outlined,
                                          size: 20, color: AppColors.dark),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          _selectedAddress ??
                                              'Sélectionner une adresse',
                                          style:
                                              AppTextStyles.regular12.copyWith(
                                            color: AppColors.text,
                                            fontSize: 12,
                                            fontWeight: _selectedAddress != null
                                                ? FontWeight.w500
                                                : FontWeight.w400,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Container(
                                        width: 34,
                                        height: 34,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(17),
                                        ),
                                        alignment: Alignment.center,
                                        child: const Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: AppColors.primary,
                                            size: 20),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              // Type pills — same style as Mes réservations
                              Row(
                                children: [
                                  for (var i = 0; i < _kTypes.length; i++) ...[
                                    Expanded(
                                      child: _TypePill(
                                        data: _kTypes[i],
                                        selected:
                                            _kTypes[i].label == _selectedType,
                                        onTap: () => _handleTypeChanged(
                                            _kTypes[i].label),
                                      ),
                                    ),
                                    if (i < _kTypes.length - 1)
                                      const SizedBox(width: 10),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 12),
                              // Date pickers
                              Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => _pickDate(isArrival: true),
                                      child: _DateCard(
                                        label: 'Arrivée',
                                        date: _arrival,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => _pickDate(isArrival: false),
                                      child: _DateCard(
                                        label: 'Départ',
                                        date: _departure,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              // Search button
                              SizedBox(
                                width: double.infinity,
                                height: 43,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  onPressed: () {
                                    final selected = _selectedAddress;
                                    if (selected == null ||
                                        selected.trim().isEmpty) {
                                      _pickAddress();
                                      return;
                                    }

                                    final address = _splitAddress(selected);

                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => SearchResultsScreen(
                                          addressTitle: address.title,
                                          addressSubtitle: address.subtitle,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.search_rounded,
                                      size: 20),
                                  label: Text(
                                    'Rechercher',
                                    style: AppTextStyles.button
                                        .copyWith(fontSize: 15),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ── Populaires
                        if (_apiLoading ||
                            _isRefreshing ||
                            api.popular.isNotEmpty) ...[
                          _SectionRow(
                            title: 'Populaires',
                            onMore: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => AllPropertiesScreen(
                                    title: 'Populaires',
                                    popular: api.popular,
                                    recommended: api.recommended,
                                    onItemTap: (p) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute<void>(
                                          builder: (_) => HotelDetailsScreen(
                                            imagePath: p.coverPhotoUrl ??
                                                'assets/images/chambre12.jpg',
                                            name: p.title,
                                            location: p.district.isNotEmpty
                                                ? '${p.district}, ${p.city}'
                                                : p.city,
                                            price: p.price.round(),
                                            rating: 4.7,
                                          ),
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
                            height: 220,
                            child: _apiLoading || _isRefreshing
                                ? const _PopularSkeleton(
                                    key: ValueKey<String>('popular_skeleton'),
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
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  HotelDetailsScreen(
                                                imagePath: imagePath,
                                                name: p.title,
                                                location: p.district.isNotEmpty
                                                    ? '${p.district}, ${p.city}'
                                                    : p.city,
                                                price: p.price.round(),
                                                rating: 4.7,
                                              ),
                                            ),
                                          );
                                        },
                                        child: _PopularCard(
                                          imagePath: imagePath,
                                          name: p.title,
                                          location: p.district.isNotEmpty
                                              ? '${p.district}, ${p.city}'
                                              : p.city,
                                          pricePerNight: p.price.round(),
                                          rating: 4.7,
                                          favoriteId: 'popular-${p.id}',
                                        ),
                                      );
                                    },
                                  ),
                          ),
                          const SizedBox(height: 24),
                        ],

                        // ── Recommandés
                        _SectionRow(
                          title: 'Recommandés pour vous',
                          onMore: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => AllPropertiesScreen(
                                  title: 'Recommandés pour vous',
                                  popular: api.popular,
                                  recommended: api.recommended,
                                  onItemTap: (p) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute<void>(
                                        builder: (_) => HotelDetailsScreen(
                                          imagePath: p.coverPhotoUrl ??
                                              'assets/images/chambre11.jpg',
                                          name: p.title,
                                          location: p.district.isNotEmpty
                                              ? '${p.district}, ${p.city}'
                                              : p.city,
                                          price: p.price.round(),
                                          rating: 4.7,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),

                        // UBAX banner avec immeuble animé
                        ClipRRect(
                          key: _bannerKey,
                          borderRadius: BorderRadius.circular(18),
                          child: SizedBox(
                            height: 110,
                            child: Stack(
                              clipBehavior: Clip.hardEdge,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/banners.svg',
                                  width: double.infinity,
                                  height: 110,
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: SlideTransition(
                                    position: _buildingSlide,
                                    child: SvgPicture.asset(
                                      'assets/images/immeuble-2.svg',
                                      width: 139,
                                      height: 110,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Type pills (under banner)
                        Row(
                          children: [
                            for (var i = 0; i < _kTypes.length; i++) ...[
                              Expanded(
                                child: _TypePill(
                                  data: _kTypes[i],
                                  selected: _kTypes[i].label == _selectedType,
                                  onTap: () =>
                                      _handleTypeChanged(_kTypes[i].label),
                                ),
                              ),
                              if (i < _kTypes.length - 1)
                                const SizedBox(width: 10),
                            ],
                          ],
                        ),
                        const SizedBox(height: 20),

                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 220),
                          switchInCurve: Curves.easeOut,
                          switchOutCurve: Curves.easeIn,
                          child: _isSwitchingType ||
                                  _apiLoading ||
                                  _isRefreshing
                              ? const _RecommendedSkeleton(
                                  key: ValueKey<String>('recommended_skeleton'),
                                )
                              : (api.recommended.isNotEmpty
                                  ? _ApiRecommendedList(
                                      key: ValueKey<String>(
                                          'api_recommended_$_selectedType'),
                                      items: api.recommended,
                                      selectedType: _selectedType,
                                    )
                                  : _RecommendedList(
                                      key: ValueKey<String>(_selectedType),
                                      selectedType: _selectedType,
                                    )),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HotelHorizontalCard extends StatelessWidget {
  const _HotelHorizontalCard({
    required this.imagePath,
    required this.title,
    required this.location,
    required this.price,
    required this.rating,
    required this.favoriteId,
    required this.onTap,
  });

  final String imagePath;
  final String title;
  final String location;
  final int price;
  final double rating;
  final String favoriteId;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isNetwork =
        imagePath.startsWith('http://') || imagePath.startsWith('https://');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 119,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: isNetwork
                  ? Image.network(
                      imagePath,
                      width: 125,
                      height: 102,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 125,
                        height: 102,
                        color: const Color(0xFFE2E8F0),
                      ),
                    )
                  : Image.asset(
                      imagePath,
                      width: 125,
                      height: 102,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 125,
                        height: 102,
                        color: const Color(0xFFE2E8F0),
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: AppTextStyles.sectionTitle.copyWith(
                              color: AppColors.text,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              height: 1.2,
                            ),
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        ValueListenableBuilder<Set<String>>(
                          valueListenable: FavoritesStore.instance.favorites,
                          builder: (context, favs, _) {
                            final isFav = favs.contains(favoriteId);
                            return InkWell(
                              onTap: () =>
                                  FavoritesStore.instance.toggle(favoriteId),
                              borderRadius: BorderRadius.circular(20),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 6, 0),
                                child: Icon(
                                  Icons.favorite_rounded,
                                  color: isFav
                                      ? const Color(0xFFEF4444)
                                      : AppColors.muted,
                                  size: 14,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            color: AppColors.primary, size: 16),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            location,
                            style: AppTextStyles.regular12.copyWith(
                              color: AppColors.text,
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          _fmt(price),
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        const Text(
                          'FCFA / nuit',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w400,
                            fontSize: 9,
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.star_rounded,
                            color: Color(0xFFFACC15), size: 16),
                        const SizedBox(width: 2),
                        Text(
                          rating.toStringAsFixed(1),
                          style: const TextStyle(
                            color: AppColors.text,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ],
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

  static String _fmt(int value) {
    final s = value.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      final fromEnd = s.length - i;
      buf.write(s[i]);
      if (fromEnd > 1 && fromEnd % 3 == 1) buf.write(' ');
    }
    return buf.toString().trim();
  }
}

// ─── Date card ────────────────────────────────────────────────────────────────

class _DateCard extends StatelessWidget {
  const _DateCard({required this.label, required this.date});

  final String label;
  final DateTime date;

  static const _months = [
    '',
    'Janv',
    'Févr',
    'Mars',
    'Avr',
    'Mai',
    'Juin',
    'Juil',
    'Août',
    'Sept',
    'Oct',
    'Nov',
    'Déc'
  ];

  @override
  Widget build(BuildContext context) {
    final formatted = '${date.day} ${_months[date.month]} ${date.year}';
    return Container(
      height: 62,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.calendar_month_rounded,
                color: AppColors.dark, size: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: AppTextStyles.regular12.copyWith(
                    color: AppColors.text,
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  formatted,
                  style: AppTextStyles.regular12.copyWith(
                    color: AppColors.text,
                    fontSize: 10,
                    fontWeight: FontWeight.w300,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Section row ──────────────────────────────────────────────────────────────

class _SectionRow extends StatelessWidget {
  const _SectionRow({required this.title, required this.onMore});

  final String title;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: AppTextStyles.regular20.copyWith(color: AppColors.text),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onMore,
          child: Text(
            'Tout voir',
            style: AppTextStyles.regular12.copyWith(
              color: AppColors.textBlack,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Popular card ─────────────────────────────────────────────────────────────

class _PopularCard extends StatelessWidget {
  const _PopularCard({
    required this.imagePath,
    required this.name,
    required this.location,
    required this.pricePerNight,
    required this.rating,
    required this.favoriteId,
  });

  final String imagePath;
  final String name;
  final String location;
  final int pricePerNight;
  final double rating;
  final String favoriteId;

  @override
  Widget build(BuildContext context) {
    final isNetwork =
        imagePath.startsWith('http://') || imagePath.startsWith('https://');

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 156,
        height: 220,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image
            isNetwork
                ? Image.network(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFFD0DDE8),
                      alignment: Alignment.center,
                      child: const Icon(Icons.image_rounded,
                          color: AppColors.dark, size: 40),
                    ),
                  )
                : Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFFD0DDE8),
                      alignment: Alignment.center,
                      child: const Icon(Icons.image_rounded,
                          color: AppColors.dark, size: 40),
                    ),
                  ),
            // Gradient overlay: transparent → rgba(0,0,0,0.7)
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xB3000000)],
                  stops: [0.195, 1.0],
                ),
              ),
            ),
            // Heart
            Positioned(
              top: 10,
              right: 10,
              child: ValueListenableBuilder<Set<String>>(
                valueListenable: FavoritesStore.instance.favorites,
                builder: (context, favs, _) {
                  final isFav = favs.contains(favoriteId);
                  return InkWell(
                    onTap: () => FavoritesStore.instance.toggle(favoriteId),
                    borderRadius: BorderRadius.circular(22),
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.favorite_rounded,
                        color:
                            isFav ? const Color(0xFFEF4444) : AppColors.muted,
                        size: 11,
                      ),
                    ),
                  );
                },
              ),
            ),
            // Info at bottom
            Positioned(
              left: 10,
              right: 10,
              bottom: 14,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    style: AppTextStyles.regularlight16.copyWith(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    location,
                    style: AppTextStyles.regular12.copyWith(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                '${_fmt(pricePerNight)} ',
                                style: AppTextStyles.regular12.copyWith(
                                  color: AppColors.background,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.06,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            Text(
                              'FCFA/',
                              style: AppTextStyles.regular12.copyWith(
                                color: const Color(0xAAFFFFFF),
                                fontSize: 7,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.05,
                              ),
                            ),
                            Text(
                              ' nuit',
                              style: AppTextStyles.regular12.copyWith(
                                color: Colors.white,
                                fontSize: 7,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.05,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // const Icon(Icons.star_rounded,
                      //     color: Color(0xFFFACC15), size: 14),
                      // const SizedBox(width: 2),
                      // Text(
                      //   rating.toString(),
                      //   style: AppTextStyles.regular12.copyWith(
                      //     color: Colors.white,
                      //     fontSize: 12,
                      //     fontWeight: FontWeight.w400,
                      //   ),
                      // ),
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

  static String _fmt(int value) {
    final s = value.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      final fromEnd = s.length - i;
      buf.write(s[i]);
      if (fromEnd > 1 && fromEnd % 3 == 1) buf.write(' ');
    }
    return buf.toString().trim();
  }
}

// ─── Recommended tile ─────────────────────────────────────────────────────────

// ─── Type pill ────────────────────────────────────────────────────────────────

class _TypePill extends StatelessWidget {
  const _TypePill({
    required this.data,
    required this.selected,
    required this.onTap,
  });

  final _TypeData data;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(40),
          border: selected
              ? null
              : Border.all(color: const Color(0xFFE5E7EB), width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: selected
                    ? Colors.white.withValues(alpha: 0.25)
                    : AppColors.background,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                data.icon,
                color: selected ? Colors.white : AppColors.primary,
                size: 14,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                data.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.regular12.copyWith(
                  color: selected ? Colors.white : AppColors.dark,
                  fontSize: 11,
                  fontWeight: selected ? FontWeight.w400 : FontWeight.w300,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
