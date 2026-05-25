import 'package:flutter/material.dart';
import 'package:statefulclickcounter/features/customer/bailleur_apply/data/models/agency_models.dart';
import 'package:statefulclickcounter/features/customer/bailleur_apply/screens/agency_details_screen.dart';
import 'package:statefulclickcounter/features/customer/chat/screens/chat_screen.dart';
import 'package:statefulclickcounter/features/customer/home/screens/appointment_booking_screen.dart';
import 'package:statefulclickcounter/features/customer/kyc/screens/tenant_kyc_screen.dart';
import 'package:statefulclickcounter/features/customer/home/screens/payment/reservation_payment_screen.dart';
import 'package:statefulclickcounter/features/customer/home/screens/proprety/view_360_screen.dart';
import 'package:statefulclickcounter/core/di/injection.dart';
import 'package:statefulclickcounter/core/favorites/favorites_store.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';
import 'package:statefulclickcounter/features/customer/properties/domain/repositories/properties_repository.dart';
import 'package:statefulclickcounter/features/customer/properties/data/models/property_models.dart';
import 'package:statefulclickcounter/features/customer/properties/utils/properties_utils.dart';

class PropertyDetailsScreen extends StatefulWidget {
  const PropertyDetailsScreen({
    super.key,
    required this.propertyId,
    this.coverImageFallback,
    this.mockTitle,
    this.mockLocation,
    this.mockPrice,
    this.mockDescription,
    this.mockBeds,
    this.mockBaths,
    this.mockKitchens,
  });

  final String propertyId;
  final String? coverImageFallback;

  final String? mockTitle;
  final String? mockLocation;
  final String? mockPrice;
  final String? mockDescription;
  final int? mockBeds;
  final int? mockBaths;
  final int? mockKitchens;

  static const _bg = AppColors.background;
  static const _dark = AppColors.dark;
  static const _orange = AppColors.primary;
  static const text = AppColors.text;

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  String get _favoriteId => widget.propertyId;
  late bool _isFavorite = FavoritesStore.instance.isFavorite(widget.propertyId);

  static const _extraGallery = [
    'assets/images/chambre11.jpg',
    'assets/images/chambre12.jpg',
    'assets/images/chambre4.jpg',
    'assets/images/villa9.jpg',
    'assets/images/villa7.jpg',
    'assets/images/appartements-luxe.jpg',
  ];

  late List<String> _gallery;
  late String _currentImage;
  bool _galleryExpanded = false;

  bool _loading = true;
  PropertyItem? _property;

  @override
  void initState() {
    super.initState();
    final fallback = widget.coverImageFallback ?? 'assets/images/chambre11.jpg';
    _gallery = [fallback, ..._extraGallery];
    _currentImage = fallback;

    FavoritesStore.instance.favorites.addListener(_onFavoritesChanged);

    final hasMock = widget.mockTitle != null ||
        widget.mockLocation != null ||
        widget.mockPrice != null ||
        widget.mockDescription != null;

    if (hasMock) {
      _loading = false;
    } else {
      _load();
    }
  }

  @override
  void dispose() {
    FavoritesStore.instance.favorites.removeListener(_onFavoritesChanged);
    super.dispose();
  }

  void _onFavoritesChanged() {
    final next = FavoritesStore.instance.isFavorite(_favoriteId);
    if (next != _isFavorite && mounted) {
      setState(() => _isFavorite = next);
    }
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final property = await getIt<PropertiesRepository>()
          .getPropertyById(widget.propertyId);
      if (!mounted) return;
      final cover = property.coverPhotoUrl ?? widget.coverImageFallback;
      setState(() {
        _property = property;
        if (cover != null && cover.trim().isNotEmpty) {
          _currentImage = cover;
          _gallery = [cover, ..._extraGallery];
        }
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  void _toggleFavorite() {
    // Listener will pick up the optimistic update from the store; no need to
    // call setState here directly.
    FavoritesStore.instance.toggle(_favoriteId);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final headerHeight = (size.height * 0.40).clamp(280.0, 440.0);

    final p = _property;

    final title = p?.title ?? widget.mockTitle ?? '—';
    final location = p != null
        ? (p.district.isNotEmpty ? '${p.district}, ${p.city}' : p.city)
        : (widget.mockLocation ?? '—');
    final price =
        p != null ? '${formatFcfa(p.price)} FCFA' : (widget.mockPrice ?? '—');
    final beds = p?.bedrooms ?? widget.mockBeds ?? 0;
    final baths = p?.bathrooms ?? widget.mockBaths ?? 0;
    final kitchens = widget.mockKitchens ?? 1;
    final description = p?.description ?? widget.mockDescription ?? '';
    final amenityCodes =
        p?.amenities.map((a) => a.code).toList(growable: false) ??
            const <String>[];

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _BottomActions(
        agencyName: _property?.agencyName,
        onAgencyTap: () {
          final name = _property?.agencyName ?? 'Agence Immobilière';
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => AgencyDetailsScreen(
                agency: AgencyItem(
                  id: '',
                  name: name,
                  verified: false,
                ),
              ),
            ),
          );
        },
        onInterested: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => TenantKycScreen(
                propertyId: widget.propertyId,
                propertyTitle: title,
                onPayment: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ReservationPaymentScreen(
                        imagePath: _currentImage,
                        title: title,
                        location: location,
                        beds: beds,
                        baths: baths,
                        kitchens: kitchens,
                        advanceAmount: ((_property?.price ?? 0) * 0.5).round(),
                        depositAmount: ((_property?.price ?? 0) * 0.5).round(),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
        onBookVisit: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => AppointmentBookingScreen(
                title: title,
                location: location,
                propertyId: widget.propertyId,
              ),
            ),
          );
        },
      ),
      body: Column(
        children: [
          _Header(
            height: headerHeight,
            imagePath: _currentImage,
            gallery: _gallery,
            galleryExpanded: _galleryExpanded,
            favoriteId: _favoriteId,
            isFavorite: _isFavorite,
            onToggleGallery: () =>
                setState(() => _galleryExpanded = !_galleryExpanded),
            onSelectImage: (path) => setState(() => _currentImage = path),
            onBack: () => Navigator.of(context).pop(),
            onFavorite: _toggleFavorite,
            onView360: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => View360Screen(
                    imagePath: _currentImage,
                    title: title,
                    location: location,
                    beds: beds,
                    baths: baths,
                    kitchens: kitchens,
                  ),
                ),
              );
            },
          ),
          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -8),
              child: _loading
                  ? const _DetailsSkeleton()
                  : _Content(
                      title: title,
                      price: price,
                      location: location,
                      beds: beds,
                      baths: baths,
                      kitchens: kitchens,
                      description: description,
                      amenityCodes: amenityCodes,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailsSkeleton extends StatelessWidget {
  const _DetailsSkeleton();

  @override
  Widget build(BuildContext context) {
    Widget block({required double h, double r = 16}) {
      return Container(
        height: h,
        decoration: BoxDecoration(
          color: const Color(0xFFE2E8F0),
          borderRadius: BorderRadius.circular(r),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
      child: Column(
        children: [
          block(h: 132, r: 15),
          const SizedBox(height: 18),
          block(h: 120),
          const SizedBox(height: 18),
          block(h: 180),
        ],
      ),
    );
  }
}

class _BottomActions extends StatelessWidget {
  const _BottomActions({
    required this.onInterested,
    required this.onBookVisit,
    required this.onAgencyTap,
    this.agencyName,
  });

  final VoidCallback onInterested;
  final VoidCallback onBookVisit;
  final VoidCallback onAgencyTap;
  final String? agencyName;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 61,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE7E7E7), width: 1),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      // color: PropertyDetailsScreen._bg,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.home_rounded,
                        color: PropertyDetailsScreen.text),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            agencyName ?? 'Agence Immobilière',
                            style: AppTextStyles.sectionTitle.copyWith(
                                color: PropertyDetailsScreen.text,
                                fontSize: 13),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Agence Immobilière',
                            style: AppTextStyles.regular12.copyWith(
                                color: PropertyDetailsScreen.text,
                                fontWeight: FontWeight.w300,
                                fontSize: 9),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // _MiniAction(
                  //   icon: Icons.chat_bubble_outline,
                  //   onTap: () => Navigator.of(context).push(
                  //     MaterialPageRoute(builder: (_) => const ChatScreen()),
                  //   ),
                  // ),
                  const SizedBox(width: 10),
                  _MiniAction(
                    icon: Icons.person_outline_rounded,
                    onTap: onAgencyTap,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 49,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: PropertyDetailsScreen._orange,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                onPressed: onInterested,
                child: const Text(
                  'Je suis intéressée',
                  style: AppTextStyles.button,
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 49,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: PropertyDetailsScreen._dark,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                onPressed: onBookVisit,
                icon: const Icon(
                  Icons.calendar_month_rounded,
                  size: 24,
                ),
                label: const Text(
                  'Réserver une visite',
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

class _Header extends StatelessWidget {
  const _Header({
    required this.height,
    required this.imagePath,
    required this.gallery,
    required this.galleryExpanded,
    required this.favoriteId,
    required this.isFavorite,
    required this.onToggleGallery,
    required this.onSelectImage,
    required this.onBack,
    required this.onFavorite,
    required this.onView360,
  });

  final double height;
  final String imagePath;
  final List<String> gallery;
  final bool galleryExpanded;
  final String favoriteId;
  final bool isFavorite;
  final VoidCallback onToggleGallery;
  final ValueChanged<String> onSelectImage;
  final VoidCallback onBack;
  final VoidCallback onFavorite;
  final VoidCallback onView360;

  @override
  Widget build(BuildContext context) {
    final isNetwork = isNetworkImage(imagePath);

    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          isNetwork
              ? Image.network(imagePath, fit: BoxFit.cover)
              : Image.asset(imagePath, fit: BoxFit.cover),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.35),
                  Colors.transparent,
                  Colors.black.withOpacity(0.10),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                14,
                MediaQuery.paddingOf(context).top + 6,
                14,
                0,
              ),
              child: Row(
                children: [
                  _CircleIcon(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: onBack,
                  ),
                  const Spacer(),
                  Text(
                    'Détails',
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  _CircleIcon(
                    icon: isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    onTap: onFavorite,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 10,
            top: 135,
            child: Container(
              width: 54,
              height: 211,
              padding: const EdgeInsets.symmetric(vertical: 13),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.22),
                borderRadius: BorderRadius.circular(50),
              ),
              child: ScrollConfiguration(
                behavior: const _NoGlowBehavior(),
                child: SingleChildScrollView(
                  physics: galleryExpanded
                      ? const BouncingScrollPhysics()
                      : const NeverScrollableScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (var i = 0;
                          i < (galleryExpanded ? gallery.length : 3) &&
                              i < gallery.length;
                          i++) ...[
                        _GalleryThumb(
                          imagePath: gallery[i],
                          onTap: () => onSelectImage(gallery[i]),
                        ),
                        const SizedBox(height: 8),
                      ],
                      _GalleryMore(
                        countText: '+${(gallery.length - 3).clamp(0, 99)}',
                        onTap: onToggleGallery,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 15,
            bottom: 20,
            child: InkWell(
              onTap: onView360,
              borderRadius: BorderRadius.circular(22.5),
              child: Container(
                width: 113,
                height: 45,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xA1000000),
                  borderRadius: BorderRadius.circular(22.5),
                ),
                child: Text('Vue 360',
                    style: AppTextStyles.sectionTitle.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.title,
    required this.location,
    required this.price,
    required this.beds,
    required this.baths,
    required this.kitchens,
    required this.description,
    required this.amenityCodes,
  });

  final String title;
  final String location;
  final String price;
  final int beds;
  final int baths;
  final int kitchens;
  final String description;
  final List<String> amenityCodes;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
        child: Column(
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
            const SizedBox(height: 14),
            Container(
              height: 132,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 18,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: AppTextStyles.sectionTitle.copyWith(
                            color: PropertyDetailsScreen._dark,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: PropertyDetailsScreen._orange,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(
                          price,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          color: PropertyDetailsScreen._orange, size: 16),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          location,
                          style: AppTextStyles.regular12.copyWith(
                            color: PropertyDetailsScreen.text,
                            fontWeight: FontWeight.w300,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 9),
                  Row(
                    children: [
                      Expanded(
                        child: _SpecChip(
                          icon: Icons.bed_rounded,
                          value: '$beds',
                          label: 'Chambres',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _SpecChip(
                          icon: Icons.bathtub_rounded,
                          value: '$baths',
                          label: 'Salle de bains',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _SpecChip(
                          icon: Icons.kitchen_rounded,
                          value: '$kitchens',
                          label: 'Cuisine',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Description',
              style: AppTextStyles.sectionTitle.copyWith(
                color: PropertyDetailsScreen._orange,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              description.isEmpty ? '—' : description,
              style: AppTextStyles.regular12.copyWith(
                color: PropertyDetailsScreen.text,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Détails & Commodités',
              style: AppTextStyles.sectionTitle.copyWith(
                color: PropertyDetailsScreen._orange,
              ),
            ),
            const SizedBox(height: 12),
            _AmenitiesGrid(codes: amenityCodes),
            const SizedBox(height: 18),
            Text(
              'Localisation',
              style: AppTextStyles.sectionTitle.copyWith(
                color: PropertyDetailsScreen._orange,
              ),
            ),
            const SizedBox(height: 12),
            const _LocationCard(),
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }
}

class _AmenitiesGrid extends StatelessWidget {
  const _AmenitiesGrid({required this.codes});

  final List<String> codes;

  static const _items = [
    _AmenityData(Icons.open_in_full_rounded, 'Surface', '150m²'),
    _AmenityData(Icons.ac_unit_rounded, 'Climatisation', '2'),
    _AmenityData(Icons.stairs_rounded, 'Etage', '2ème'),
    _AmenityData(Icons.local_pharmacy_outlined, 'Pharmacie', '300m'),
    _AmenityData(Icons.local_hospital_outlined, 'Clinique', '700 m'),
    _AmenityData(Icons.restaurant_rounded, 'Restaurant', '50m'),
    _AmenityData(Icons.account_balance_outlined, 'Banque', '1.5 Km'),
    _AmenityData(Icons.shopping_cart_outlined, 'Supermarché', '500m'),
    _AmenityData(Icons.local_gas_station_outlined, 'Stations', '1km'),
  ];

  @override
  Widget build(BuildContext context) {
    if (codes.isNotEmpty) {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final c in codes)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                c,
                style: AppTextStyles.regular12.copyWith(
                  color: PropertyDetailsScreen._dark,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      );
    }

    return Column(
      children: List.generate(3, (row) {
        return Padding(
          padding: EdgeInsets.only(bottom: row == 2 ? 0 : 10),
          child: Row(
            children: List.generate(3, (col) {
              final item = _items[row * 3 + col];
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: col == 2 ? 0 : 8),
                  child: _AmenityCard(item: item),
                ),
              );
            }),
          ),
        );
      }),
    );
  }
}

class _AmenityData {
  const _AmenityData(this.icon, this.label, this.value);
  final IconData icon;
  final String label;
  final String value;
}

class _AmenityCard extends StatelessWidget {
  const _AmenityCard({required this.item});
  final _AmenityData item;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 27.22,
            height: 27.22,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
            ),
            alignment: Alignment.center,
            child:
                Icon(item.icon, color: PropertyDetailsScreen._dark, size: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: AppTextStyles.regular12.copyWith(
                    color: PropertyDetailsScreen.text,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    height: 1.0,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  item.value,
                  style: AppTextStyles.regular12.copyWith(
                    color: PropertyDetailsScreen._orange,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    height: 1.0,
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

class _LocationCard extends StatelessWidget {
  const _LocationCard();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.asset(
            'assets/images/Map.png',
            height: 170,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: 170,
              width: double.infinity,
              color: const Color(0xFFE9EEF3),
              alignment: Alignment.center,
              child: const Icon(Icons.map_rounded,
                  color: Color(0xFFB8C4D0), size: 60),
            ),
          ),
        ),
        Positioned(
          right: 14,
          bottom: 14,
          child: Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: PropertyDetailsScreen._orange,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child:
                const Icon(Icons.map_outlined, color: Colors.white, size: 22),
          ),
        ),
      ],
    );
  }
}

class _CircleIcon extends StatelessWidget {
  const _CircleIcon({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.20),
          borderRadius: BorderRadius.circular(22),
        ),
        alignment: Alignment.center,
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}

class _GalleryThumb extends StatelessWidget {
  const _GalleryThumb({required this.imagePath, this.onTap});

  final String imagePath;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isNetwork = isNetworkImage(imagePath);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: ClipOval(
        child: isNetwork
            ? Image.network(
                imagePath,
                width: 38,
                height: 38,
                fit: BoxFit.cover,
              )
            : Image.asset(
                imagePath,
                width: 38,
                height: 38,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}

class _NoGlowBehavior extends ScrollBehavior {
  const _NoGlowBehavior();

  @override
  Widget buildOverscrollIndicator(
          BuildContext context, Widget child, ScrollableDetails details) =>
      child;
}

class _GalleryMore extends StatelessWidget {
  const _GalleryMore({required this.countText, required this.onTap});

  final String countText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(23),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.35),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          countText,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _SpecChip extends StatelessWidget {
  const _SpecChip({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFECF2F7),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Container(
            width: 31,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2.5),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: AppColors.primary, size: 21),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: AppTextStyles.regular12.copyWith(
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    label,
                    style: AppTextStyles.regular12.copyWith(
                        color: AppColors.text,
                        fontWeight: FontWeight.w300,
                        fontSize: 9),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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

class _MiniAction extends StatelessWidget {
  const _MiniAction({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(5),
      child: Container(
        width: 41,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.dark,
          borderRadius: BorderRadius.circular(5),
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          color: Colors.white,
          size: 17,
        ),
      ),
    );
  }
}
