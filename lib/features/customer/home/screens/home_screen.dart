import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:statefulclickcounter/features/customer/home/screens/advanced_search_screen.dart';
import 'package:statefulclickcounter/features/customer/home/screens/map_search_tab.dart';
import 'package:statefulclickcounter/features/customer/favorites/screens/favorites_screen.dart';
import 'package:statefulclickcounter/features/customer/hotels/screens/hotels_tab.dart';
import 'package:statefulclickcounter/features/customer/profile/screens/profile_tab.dart';
import 'package:statefulclickcounter/features/customer/profile/screens/bailleur_profile_tab.dart';
import 'package:statefulclickcounter/core/profile/profile_mode.dart';

import 'package:statefulclickcounter/core/widgets/orange_button.dart';
import 'package:statefulclickcounter/core/widgets/recommended_tile.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

import 'package:statefulclickcounter/features/customer/home/screens/proprety/property_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ValueListenableBuilder<ProfileMode>(
        valueListenable: profileModeNotifier,
        builder: (_, mode, __) => IndexedStack(
          index: _index,
          children: [
            const SafeArea(bottom: false, child: _HomeTab()),
            const SafeArea(top: false, bottom: false, child: HotelsTab()),
            const SafeArea(bottom: false, child: MapSearchTab()),
            const SafeArea(bottom: false, child: FavoritesTab()),
            // Profile/Bailleur tabs let their hero header extend behind the status bar
            mode == ProfileMode.bailleur
                ? const BailleurProfileTab()
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
                        onTap: () => setState(() => _index = 0),
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
                        onTap: () => setState(() => _index = 1),
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
                        onTap: () => setState(() => _index = 2),
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
                        onTap: () => setState(() => _index = 3),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: _index == 4 ? 2 : 1,
                    child: Center(
                      child: _NavItem(
                        icon: Icons.person_rounded,
                        label: 'Profil',
                        selected: _index == 4,
                        onTap: () => setState(() => _index = 4),
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

  Future<void> _handleRentChanged(bool v) async {
    if (v == _rent || _isSwitching) return;
    setState(() => _isSwitching = true);
    await Future<void>.delayed(const Duration(milliseconds: 1220));
    if (!mounted) return;
    setState(() {
      _rent = v;
      _isSwitching = false;
    });
  }

  static const _popularRentProperties = [
    {
      'image': 'assets/images/piscine.jpg',
      'price': '49 990 000 Fcfa',
      'title': 'Villa avec piscine',
      'location': 'Cocody Angré, Abidjan – Côte d\'Ivoire',
      'beds': '6',
      'baths': '4',
      'kitchens': '2'
    },
    {
      'image': 'assets/images/villa1.jpg',
      'price': '35 000 000 Fcfa',
      'title': 'Villa sur la côte',
      'location': 'Cocody Angré, Abidjan – Côte d\'Ivoire',
      'beds': '5',
      'baths': '3',
      'kitchens': '1'
    },
    {
      'image': 'assets/images/villa2.jpg',
      'price': '28 500 000 Fcfa',
      'title': 'Villa moderne',
      'location': 'Marcory, Abidjan – Côte d\'Ivoire',
      'beds': '4',
      'baths': '2',
      'kitchens': '1'
    },
    {
      'image': 'assets/images/villa3.jpg',
      'price': '55 000 000 Fcfa',
      'title': 'Villa de luxe',
      'location': 'Riviera, Abidjan – Côte d\'Ivoire',
      'beds': '7',
      'baths': '5',
      'kitchens': '2'
    },
  ];

  static const _popularBuyProperties = [
    {
      'image': 'assets/images/villa.jpg',
      'price': '99 990 000 Fcfa',
      'title': 'Villa contemporaine',
      'location': 'Cocody Angré, Abidjan – Côte d\'Ivoire',
      'beds': '6',
      'baths': '4',
      'kitchens': '2'
    },
    {
      'image': 'assets/images/villa1.jpg',
      'price': '75 000 000 Fcfa',
      'title': 'Duplex familial',
      'location': 'Riviera, Abidjan – Côte d\'Ivoire',
      'beds': '5',
      'baths': '3',
      'kitchens': '1'
    },
    {
      'image': 'assets/images/villa2.jpg',
      'price': '58 500 000 Fcfa',
      'title': 'Villa moderne',
      'location': 'Marcory, Abidjan – Côte d\'Ivoire',
      'beds': '4',
      'baths': '2',
      'kitchens': '1'
    },
    {
      'image': 'assets/images/villa3.jpg',
      'price': '125 000 000 Fcfa',
      'title': 'Villa de luxe',
      'location': 'Riviera, Abidjan – Côte d\'Ivoire',
      'beds': '7',
      'baths': '5',
      'kitchens': '2'
    },
  ];

  static const _recommendedRentProperties = [
    {
      'image': 'assets/images/villa.jpg',
      'title': 'Appartement Moderne à\nCocody',
      'location': 'Cocody Angré, Abidjan – Côte d\'Ivoire',
      'beds': '3',
      'baths': '2',
      'salons': '1'
    },
    {
      'image': 'assets/images/piscine.jpg',
      'title': 'Studio meublé au\nPlateau',
      'location': 'Plateau, Abidjan – Côte d\'Ivoire',
      'beds': '1',
      'baths': '1',
      'salons': '1'
    },
    {
      'image': 'assets/images/villa1.jpg',
      'title': 'Duplex à Marcory',
      'location': 'Marcory, Abidjan – Côte d\'Ivoire',
      'beds': '4',
      'baths': '2',
      'salons': '2'
    },
    {
      'image': 'assets/images/villa2.jpg',
      'title': 'Appartement vue mer\nà Treichville',
      'location': 'Treichville, Abidjan – Côte d\'Ivoire',
      'beds': '2',
      'baths': '1',
      'salons': '1'
    },
    {
      'image': 'assets/images/villa3.jpg',
      'title': 'Appartement vue mer\nà Treichville',
      'location': 'Treichville, Abidjan – Côte d\'Ivoire',
      'beds': '2',
      'baths': '1',
      'salons': '1'
    },
  ];

  static const _recommendedBuyProperties = [
    {
      'image': 'assets/images/piscine.jpg',
      'title': 'Appartement Premium\nau Plateau',
      'location': 'Plateau, Abidjan – Côte d\'Ivoire',
      'beds': '2',
      'baths': '2',
      'salons': '1'
    },
    {
      'image': 'assets/images/villa1.jpg',
      'title': 'Duplex avec jardin',
      'location': 'Cocody, Abidjan – Côte d\'Ivoire',
      'beds': '4',
      'baths': '2',
      'salons': '2'
    },
    {
      'image': 'assets/images/villa2.jpg',
      'title': 'Appartement vue mer',
      'location': 'Treichville, Abidjan – Côte d\'Ivoire',
      'beds': '3',
      'baths': '2',
      'salons': '1'
    },
    {
      'image': 'assets/images/villa3.jpg',
      'title': 'Penthouse moderne',
      'location': 'Riviera, Abidjan – Côte d\'Ivoire',
      'beds': '4',
      'baths': '3',
      'salons': '1'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final popular = _rent ? _popularRentProperties : _popularBuyProperties;
    final recommended =
        _rent ? _recommendedRentProperties : _recommendedBuyProperties;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 22,
                backgroundColor: Color(0xFFD9E3EE),
                child: Icon(Icons.person, color: AppColors.dark),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bonjour',
                      style: TextStyle(
                        color: Color(0xFF6D6D6D),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Arnaud Koffi',
                      style: TextStyle(
                        color: AppColors.textBlack,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
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
                    ClipOval(
                      child: CountryFlag.fromCountryCode(
                        'CI',
                        width: 28,
                        height: 28,
                      ),
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
                : SingleChildScrollView(
                    key: ValueKey<bool>(_rent),
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 110),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SearchCard(
                          rent: _rent,
                          onRentChanged: _handleRentChanged,
                        ),
                        const SizedBox(height: 20),
                        const _SectionHeader(title: 'Les plus populaires'),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 194,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: popular.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 12),
                            itemBuilder: (_, i) {
                              final p = popular[i];
                              return _PropertyCard(
                                imagePath: p['image']!,
                                price: p['price']!,
                                title: p['title']!,
                                location: p['location']!,
                                beds: int.parse(p['beds']!),
                                baths: int.parse(p['baths']!),
                                kitchens: int.parse(p['kitchens']!),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 18),
                        const _SectionHeader(title: 'Biens recommandés'),
                        const SizedBox(height: 12),
                        ...recommended.map(
                          (p) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: RecommendedTile(
                              imagePath: p['image']!,
                              title: p['title']!,
                              location: p['location']!,
                              beds: int.parse(p['beds']!),
                              baths: int.parse(p['baths']!),
                              salons: int.parse(p['salons']!),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => PropertyDetailsScreen(
                                      imagePath: p['image']!,
                                      title: p['title']!,
                                      location: p['location']!,
                                      price: '250 000 Fcfa',
                                      beds: 3,
                                      baths: 2,
                                      kitchens: 1,
                                    ),
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
      ],
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
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.notifications_none_rounded,
                color: AppColors.dark),
          ),
          if (count > 0)
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                alignment: Alignment.center,
                child: Text(
                  '$count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SearchCard extends StatefulWidget {
  const _SearchCard({required this.rent, required this.onRentChanged});

  final bool rent;
  final ValueChanged<bool> onRentChanged;

  @override
  State<_SearchCard> createState() => _SearchCardState();
}

class _SearchCardState extends State<_SearchCard> {
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
          const _InputChip(
            icon: Icons.location_on_outlined,
            text: 'Abidjan, Cocody',
            trailing: null,
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
              Expanded(
                flex: 222,
                child: _InputChip(
                  icon: Icons.meeting_room_outlined,
                  text: 'Nombre de pièces',
                  trailing: Icon(Icons.keyboard_arrow_down_rounded,
                      color: AppColors.dark),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                flex: 147,
                child: _InputChip(
                  icon: Icons.apartment_rounded,
                  text: 'Type',
                  trailing: Icon(Icons.keyboard_arrow_down_rounded,
                      color: AppColors.dark),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          OrangeButton(
            height: 49,
            borderRadius: 40,
            text: 'Rechercher les biens',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      AdvancedSearchScreen(initialRent: widget.rent),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
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
  });

  final IconData icon;
  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

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
          onPressed: () {},
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
    required this.imagePath,
    required this.price,
    required this.title,
    required this.location,
    required this.beds,
    required this.baths,
    required this.kitchens,
  });

  final String imagePath;
  final String price;
  final String title;
  final String location;
  final int beds;
  final int baths;
  final int kitchens;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PropertyDetailsScreen(
              imagePath: imagePath,
              title: title,
              location: location,
              price: price,
              beds: beds,
              baths: baths,
              kitchens: kitchens,
            ),
          ),
        );
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
              child: Image.asset(imagePath, fit: BoxFit.cover),
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
            const Positioned(
              right: 10,
              top: 10,
              child: const Icon(Icons.favorite_rounded, color: Colors.white),
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
