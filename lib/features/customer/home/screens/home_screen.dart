import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:statefulclickcounter/features/customer/home/screens/advanced_search_screen.dart';
import 'package:statefulclickcounter/features/customer/favorites/screens/favorites_screen.dart';
import 'package:statefulclickcounter/features/customer/hotels/screens/hotels_tab.dart';
import 'package:statefulclickcounter/features/customer/profile/screens/profile_tab.dart';

import 'package:statefulclickcounter/core/widgets/orange_button.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';

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
      body: SafeArea(
        child: IndexedStack(
          index: _index,
          children: const [
            _HomeTab(),
            HotelsTab(),
            _PlaceholderTab(),
            FavoritesTab(),
            ProfileTab(),
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
                        label: 'Rechercher',
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

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  static const _popularProperties = [
    {'image': 'assets/images/villa.jpg', 'price': '49 990 000 Fcfa', 'title': 'Villa avec piscine', 'location': 'Cocody Angré, Abidjan – Côte d\'Ivoire', 'beds': '6', 'baths': '4', 'kitchens': '2'},
    {'image': 'assets/images/villa.jpg', 'price': '35 000 000 Fcfa', 'title': 'Villa sur la côte', 'location': 'Cocody Angré, Abidjan – Côte d\'Ivoire', 'beds': '5', 'baths': '3', 'kitchens': '1'},
    {'image': 'assets/images/villa.jpg', 'price': '28 500 000 Fcfa', 'title': 'Villa moderne', 'location': 'Marcory, Abidjan – Côte d\'Ivoire', 'beds': '4', 'baths': '2', 'kitchens': '1'},
    {'image': 'assets/images/villa.jpg', 'price': '55 000 000 Fcfa', 'title': 'Villa de luxe', 'location': 'Riviera, Abidjan – Côte d\'Ivoire', 'beds': '7', 'baths': '5', 'kitchens': '2'},
  ];

  static const _recommendedProperties = [
    {'image': 'assets/images/villa.jpg', 'title': 'Appartement Moderne à\nCocody', 'location': 'Cocody Angré, Abidjan – Côte d\'Ivoire', 'beds': '3', 'baths': '2', 'salons': '1'},
    {'image': 'assets/images/villa.jpg', 'title': 'Studio meublé au\nPlateau', 'location': 'Plateau, Abidjan – Côte d\'Ivoire', 'beds': '1', 'baths': '1', 'salons': '1'},
    {'image': 'assets/images/villa.jpg', 'title': 'Duplex à Marcory', 'location': 'Marcory, Abidjan – Côte d\'Ivoire', 'beds': '4', 'baths': '2', 'salons': '2'},
    {'image': 'assets/images/villa.jpg', 'title': 'Appartement vue mer\nà Treichville', 'location': 'Treichville, Abidjan – Côte d\'Ivoire', 'beds': '2', 'baths': '1', 'salons': '1'},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 110),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                        color: AppColors.dark,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              _NotifButton(count: 5, onTap: () {}),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
          const SizedBox(height: 16),
          const _SearchCard(),
          const SizedBox(height: 20),
          const _SectionHeader(title: 'Les plus populaires'),
          const SizedBox(height: 12),
          SizedBox(
            height: 190,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _popularProperties.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, i) {
                final p = _popularProperties[i];
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
          ..._recommendedProperties.map(
            (p) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _RecommendedTile(
                imagePath: p['image']!,
                title: p['title']!,
                location: p['location']!,
                beds: int.parse(p['beds']!),
                baths: int.parse(p['baths']!),
                salons: int.parse(p['salons']!),
              ),
            ),
          ),
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
  const _SearchCard();

  @override
  State<_SearchCard> createState() => _SearchCardState();
}

class _SearchCardState extends State<_SearchCard> {
  bool _rent = true;

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
            height: 44,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _Segment(
                    label: 'Louer',
                    selected: _rent,
                    onTap: () => setState(() => _rent = true),
                  ),
                ),
                Expanded(
                  child: _Segment(
                    label: 'Acheter',
                    selected: !_rent,
                    onTap: () => setState(() => _rent = false),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _InputChip(
            icon: Icons.location_on_outlined,
            text: 'Abidjan, Cocody',
            trailing: null,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _InputChip(
                  icon: Icons.meeting_room_outlined,
                  text: 'Nombre de pièces',
                  trailing: const Icon(Icons.keyboard_arrow_down_rounded,
                      color: AppColors.muted),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _InputChip(
                  icon: Icons.apartment_rounded,
                  text: 'Type',
                  trailing: const Icon(Icons.keyboard_arrow_down_rounded,
                      color: AppColors.muted),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          OrangeButton(
            height: 52,
            text: 'Rechercher les biens',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AdvancedSearchScreen(initialRent: _rent),
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
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: selected ? AppColors.dark : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.dark,
            fontWeight: FontWeight.w800,
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
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE7E7E7)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.dark),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.dark,
                fontWeight: FontWeight.w700,
              ),
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
            style: const TextStyle(
              color: AppColors.dark,
              fontWeight: FontWeight.w600,
              fontSize: 16,
              height: 24 / 16,
              letterSpacing: 0.08,
            ),
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            'Voir tout',
            style: TextStyle(
              color: AppColors.dark,
              fontWeight: FontWeight.w700,
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
        width: 250,
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
                      Color(0x00000000),
                      Color(0xAA000000),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 12,
              top: 12,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.dark,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  price,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 10,
              top: 10,
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(17),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.favorite_rounded,
                    color: Colors.white),
              ),
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    location,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 6,
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
                        width: 30,
                        height: 30,
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
  const _Info({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 120),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFFD1D5DB), size: 16),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(color: Color(0xFFD1D5DB), fontSize: 11),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendedTile extends StatelessWidget {
  const _RecommendedTile({
    required this.imagePath,
    required this.title,
    required this.location,
    required this.beds,
    required this.baths,
    required this.salons,
  });

  final String imagePath;
  final String title;
  final String location;
  final int beds;
  final int baths;
  final int salons;

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
              price: '250 000 Fcfa',
              beds: 3,
              baths: 2,
              kitchens: 1,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                imagePath,
                width: 88,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.dark,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 16, color: AppColors.muted),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          style: const TextStyle(
                              color: AppColors.muted, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 10,
                    runSpacing: 4,
                    children: [
                      _Info(icon: Icons.bed_rounded, text: '$beds Chambres'),
                      _Info(icon: Icons.bathtub_rounded, text: '$baths Salle de bains'),
                      _Info(icon: Icons.weekend_rounded, text: '$salons Salon'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.favorite_rounded, color: Colors.red),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  const _PlaceholderTab();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Coming soon',
        style: TextStyle(fontWeight: FontWeight.w800),
      ),
    );
  }
}
