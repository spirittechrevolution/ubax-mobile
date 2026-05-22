import 'package:statefulclickcounter/core/network/error_handler.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:statefulclickcounter/core/favorites/favorites_store.dart';
import 'package:statefulclickcounter/features/customer/favorites/data/models/favorite_models.dart';
import 'package:statefulclickcounter/features/customer/home/screens/proprety/property_details_screen.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

// ─── Category pill data ────────────────────────────────────────────────────────

class _CategoryData {
  const _CategoryData({
    required this.key,
    required this.labelKey,
    required this.icon,
    required this.matcher,
  });

  final String key;
  final String labelKey;
  final IconData icon;
  final bool Function(String propertyType) matcher;
}

bool _isHouse(String t) {
  final u = t.toUpperCase();
  return u.contains('MAISON') || u.contains('VILLA') || u.contains('HOUSE');
}

bool _isApartment(String t) {
  final u = t.toUpperCase();
  return u.contains('APPART') || u.contains('APART') || u.contains('STUDIO');
}

bool _isHotel(String t) => t.toUpperCase().contains('HOTEL');

bool _isLand(String t) {
  final u = t.toUpperCase();
  return u.contains('TERRAIN') || u.contains('LAND');
}

const _kCategories = [
  _CategoryData(
    key: 'house',
    labelKey: 'favorites.categories.house',
    icon: Icons.house_outlined,
    matcher: _isHouse,
  ),
  _CategoryData(
    key: 'apartment',
    labelKey: 'favorites.categories.apartment',
    icon: Icons.apartment_rounded,
    matcher: _isApartment,
  ),
  _CategoryData(
    key: 'hotel',
    labelKey: 'favorites.categories.hotel',
    icon: Icons.hotel_rounded,
    matcher: _isHotel,
  ),
  _CategoryData(
    key: 'land',
    labelKey: 'favorites.categories.land',
    icon: Icons.landscape_rounded,
    matcher: _isLand,
  ),
];

// ─── Main screen ──────────────────────────────────────────────────────────────

class FavoritesTab extends StatefulWidget {
  const FavoritesTab({super.key, this.isActive = true});

  final bool isActive;

  @override
  State<FavoritesTab> createState() => _FavoritesTabState();
}

class _FavoritesTabState extends State<FavoritesTab> {
  String _selectedCategoryKey = 'apartment';
  bool _isSwitchingCategory = false;
  bool _isGridView = true;
  bool _searchActive = false;
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  bool _loading = true;
  String? _errorMessage;
  List<FavoriteItem> _all = const [];

  @override
  void initState() {
    super.initState();
    if (widget.isActive) _load();
    FavoritesStore.instance.favorites.addListener(_onFavoritesChanged);
  }

  @override
  void didUpdateWidget(covariant FavoritesTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _load();
    }
  }

  @override
  void dispose() {
    FavoritesStore.instance.favorites.removeListener(_onFavoritesChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onFavoritesChanged() {
    // Bail while a load is in flight: refresh() mutates the store's notifier
    // and would otherwise re-trigger this listener in a loop.
    if (!mounted || !widget.isActive || _loading) return;
    final currentIds = _all.map((e) => e.id).toSet();
    final storeIds = FavoritesStore.instance.favorites.value;
    final addedRemote = storeIds.difference(currentIds);
    if (addedRemote.isNotEmpty) {
      _load();
    }
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });
    try {
      final page = await FavoritesStore.instance.refresh();
      if (!mounted) return;
      setState(() {
        _all = page.content;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _errorMessage = AppErrors.translate(e);
      });
    }
  }

  Future<void> _remove(FavoriteItem item) async {
    final previous = List<FavoriteItem>.of(_all);
    setState(() => _all = _all.where((e) => e.id != item.id).toList());
    try {
      await FavoritesStore.instance.toggle(item.id);
    } catch (_) {
      if (!mounted) return;
      setState(() => _all = previous);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('favorites.delete_failed'.tr())),
      );
    }
  }

  List<FavoriteItem> get _filtered {
    final matcher =
        _kCategories.firstWhere((c) => c.key == _selectedCategoryKey).matcher;
    Iterable<FavoriteItem> filtered =
        _all.where((p) => matcher(p.propertyType));
    if (_query.isNotEmpty) {
      final q = _query.toLowerCase();
      filtered = filtered.where((p) =>
          p.title.toLowerCase().contains(q) ||
          p.city.toLowerCase().contains(q));
    }
    return filtered.toList(growable: false);
  }

  Future<void> _handleCategoryChanged(String nextKey) async {
    if (nextKey == _selectedCategoryKey || _isSwitchingCategory) return;
    setState(() => _isSwitchingCategory = true);
    await Future<void>.delayed(const Duration(milliseconds: 420));
    if (!mounted) return;
    setState(() {
      _selectedCategoryKey = nextKey;
      _isSwitchingCategory = false;
    });
  }

  void _toggleSearch() {
    setState(() {
      _searchActive = !_searchActive;
      if (!_searchActive) {
        _searchController.clear();
        _query = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header(
          searchActive: _searchActive,
          searchController: _searchController,
          query: _query,
          onQueryChanged: (v) => setState(() => _query = v),
          onClearQuery: () => setState(() {
            _searchController.clear();
            _query = '';
          }),
          onToggleSearch: _toggleSearch,
        ),
        SizedBox(
          height: 48,
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
            scrollDirection: Axis.horizontal,
            itemCount: _kCategories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) {
              final c = _kCategories[i];
              return _CategoryPill(
                label: c.labelKey.tr(),
                icon: c.icon,
                selected: c.key == _selectedCategoryKey,
                onTap: () => _handleCategoryChanged(c.key),
              );
            },
          ),
        ),
        Expanded(child: _buildBody()),
      ],
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return _FavoritesSkeleton(grid: _isGridView);
    }
    if (_errorMessage != null) {
      return _ErrorView(message: 'favorites.error'.tr(), onRetry: _load);
    }

    final displayed = _filtered;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 10),
          child: Row(
            children: [
              Text(
                'favorites.count'.plural(displayed.length),
                style: AppTextStyles.sectionTitle.copyWith(
                  color: AppColors.text,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => setState(() => _isGridView = false),
                child: Icon(
                  Icons.format_list_bulleted_rounded,
                  color: _isGridView ? AppColors.muted : AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => setState(() => _isGridView = true),
                child: Icon(
                  Icons.grid_view_rounded,
                  color: _isGridView ? AppColors.primary : AppColors.muted,
                  size: 22,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            child: _isSwitchingCategory
                ? _FavoritesSkeleton(
                    key: ValueKey<String>(
                        'skeleton_${_isGridView ? 'grid' : 'list'}'),
                    grid: _isGridView,
                  )
                : displayed.isEmpty
                    ? _EmptyView(
                        key: ValueKey('empty_$_selectedCategoryKey'),
                      )
                    : _isGridView
                        ? GridView.builder(
                            key: ValueKey<String>('grid_$_selectedCategoryKey'),
                            padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.74,
                            ),
                            itemCount: displayed.length,
                            itemBuilder: (_, i) => _PropertyCard(
                              data: displayed[i],
                              onUnfavorite: () => _remove(displayed[i]),
                            ),
                          )
                        : ListView.separated(
                            key: ValueKey<String>('list_$_selectedCategoryKey'),
                            padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                            itemCount: displayed.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (_, i) => _SwipeToDelete(
                              key: ValueKey(displayed[i].id),
                              onDelete: () => _remove(displayed[i]),
                              child: _PropertyListCard(
                                data: displayed[i],
                                onUnfavorite: () => _remove(displayed[i]),
                              ),
                            ),
                          ),
          ),
        ),
      ],
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({
    required this.searchActive,
    required this.searchController,
    required this.query,
    required this.onQueryChanged,
    required this.onClearQuery,
    required this.onToggleSearch,
  });

  final bool searchActive;
  final TextEditingController searchController;
  final String query;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onClearQuery;
  final VoidCallback onToggleSearch;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
      child: Row(
        children: [
          if (!searchActive) ...[
            Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.favorite_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'favorites.title'.tr(),
              style: AppTextStyles.sectionTitle.copyWith(
                color: AppColors.text,
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Spacer(),
          ] else ...[
            Expanded(
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xFFE7E7E7)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search_rounded,
                        color: AppColors.dark, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        autofocus: true,
                        style: const TextStyle(
                          color: AppColors.text,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'favorites.search_hint'.tr(),
                          hintStyle: const TextStyle(
                            color: AppColors.text,
                            fontSize: 13,
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: onQueryChanged,
                      ),
                    ),
                    if (query.isNotEmpty)
                      GestureDetector(
                        onTap: onClearQuery,
                        child: const Icon(Icons.close_rounded,
                            color: AppColors.dark, size: 18),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],
          GestureDetector(
            onTap: onToggleSearch,
            child: Icon(
              searchActive ? Icons.close_rounded : Icons.search_rounded,
              color: AppColors.dark,
              size: 26,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Empty / Error states ─────────────────────────────────────────────────────

class _EmptyView extends StatelessWidget {
  const _EmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.favorite_border_rounded,
              size: 64,
              color: AppColors.muted,
            ),
            const SizedBox(height: 16),
            Text(
              'favorites.empty_title'.tr(),
              textAlign: TextAlign.center,
              style: AppTextStyles.sectionTitle.copyWith(
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'favorites.empty_message'.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.muted,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded,
                size: 56, color: AppColors.muted),
            const SizedBox(height: 14),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.text,
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
              child: Text('favorites.retry'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Skeleton ─────────────────────────────────────────────────────────────────

class _FavoritesSkeleton extends StatelessWidget {
  const _FavoritesSkeleton({super.key, required this.grid});

  final bool grid;

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

    if (grid) {
      return GridView.builder(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.74,
        ),
        itemCount: 4,
        itemBuilder: (_, __) => block(h: 240),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
      itemCount: 4,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => block(h: 230),
    );
  }
}

// ─── Swipe-to-delete (list view only) ─────────────────────────────────────────

class _SwipeToDelete extends StatefulWidget {
  const _SwipeToDelete({
    super.key,
    required this.child,
    required this.onDelete,
  });

  final Widget child;
  final VoidCallback onDelete;

  @override
  State<_SwipeToDelete> createState() => _SwipeToDeleteState();
}

class _SwipeToDeleteState extends State<_SwipeToDelete> {
  static const double _maxReveal = 150;
  double _dragOffset = 0;
  double _targetOffset = 0;

  Future<void> _confirmDelete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('favorites.delete_confirm_title'.tr()),
        content: Text('favorites.delete_confirm_message'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('favorites.delete_confirm_cancel'.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text('favorites.delete_confirm_ok'.tr()),
          ),
        ],
      ),
    );

    if (ok == true) {
      widget.onDelete();
    }
    if (!mounted) return;
    setState(() {
      _dragOffset = 0;
      _targetOffset = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        final next = (_dragOffset + details.delta.dx).clamp(0.0, _maxReveal);
        setState(() {
          _dragOffset = next;
          _targetOffset = next;
        });
      },
      onHorizontalDragEnd: (_) {
        final shouldOpen = _dragOffset > (_maxReveal * 0.45);
        setState(() {
          _targetOffset = shouldOpen ? _maxReveal : 0;
          _dragOffset = _targetOffset;
        });
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 11),
                child: GestureDetector(
                  onTap: _confirmDelete,
                  child: Container(
                    width: 135,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.delete_rounded,
                            color: Colors.white, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          'favorites.delete'.tr(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: _targetOffset),
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            builder: (_, value, child) {
              return Transform.translate(
                offset: Offset(value, 0),
                child: child,
              );
            },
            child: widget.child,
          ),
        ],
      ),
    );
  }
}

// ─── Category pill ────────────────────────────────────────────────────────────

class _CategoryPill extends StatelessWidget {
  const _CategoryPill({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: selected ? null : Border.all(color: const Color(0xFFE7E7E7)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: selected ? Colors.white : AppColors.dark,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Lexend',
                color: selected ? Colors.white : AppColors.dark,
                fontWeight: FontWeight.w300,
                fontSize: 13,
                height: 1.4,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Property card (grid) ─────────────────────────────────────────────────────

class _PropertyCard extends StatelessWidget {
  const _PropertyCard({required this.data, required this.onUnfavorite});

  final FavoriteItem data;
  final VoidCallback onUnfavorite;

  void _openDetails(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PropertyDetailsScreen(
          propertyId: data.id,
          coverImageFallback: data.coverPhotoUrl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openDetails(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 0.3),
          boxShadow: const [
            BoxShadow(
              color: Color(0x03000000),
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: _CoverImage(
                      url: data.coverPhotoUrl,
                      height: 114,
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: 2,
                    child: InkWell(
                      onTap: onUnfavorite,
                      borderRadius: BorderRadius.circular(20),
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.favorite_rounded,
                          color: Color(0xFFEF4444),
                          size: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      data.title,
                      style: const TextStyle(
                        color: AppColors.textBlack,
                        fontWeight: FontWeight.w400,
                        fontSize: 11,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 11, color: AppColors.textBlack),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            data.city,
                            style: const TextStyle(
                              color: AppColors.textBlack,
                              fontSize: 10,
                              fontWeight: FontWeight.w300,
                              height: 1.0,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      runSpacing: 2,
                      children: [
                        _MetaInfo(
                          icon: Icons.meeting_room_outlined,
                          fontSize: 8,
                          text: '${data.rooms} ${'favorites.meta.rooms'.tr()}',
                        ),
                        _MetaInfo(
                          icon: Icons.bed_rounded,
                          fontSize: 8,
                          text:
                              '${data.bedrooms} ${'favorites.meta.bedrooms'.tr()}',
                        ),
                        _MetaInfo(
                          icon: Icons.bathtub_outlined,
                          fontSize: 8,
                          text:
                              '${data.bathrooms} ${'favorites.meta.bathrooms'.tr()}',
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${_fmt(data.price.round())} Fcfa',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                              fontSize: 11,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _openDetails(context),
                          child: Container(
                            width: 70,
                            height: 20,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Text(
                              'favorites.see_details'.tr(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 7,
                              ),
                            ),
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
}

// ─── Property card (list) ─────────────────────────────────────────────────────

class _PropertyListCard extends StatelessWidget {
  const _PropertyListCard({required this.data, required this.onUnfavorite});

  final FavoriteItem data;
  final VoidCallback onUnfavorite;

  void _openDetails(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PropertyDetailsScreen(
          propertyId: data.id,
          coverImageFallback: data.coverPhotoUrl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openDetails(context),
      child: Container(
        width: double.infinity,
        height: 119,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Color(0x10000000),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: _CoverImage(
                url: data.coverPhotoUrl,
                height: 102,
                width: 127,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          data.title,
                          style: AppTextStyles.sectionTitle.copyWith(
                            color: AppColors.text,
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: onUnfavorite,
                        borderRadius: BorderRadius.circular(20),
                        child: const Padding(
                          padding: EdgeInsets.all(2),
                          child: Icon(
                            Icons.favorite_rounded,
                            color: Colors.red,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 11, color: AppColors.dark),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          data.city,
                          style: AppTextStyles.regular12.copyWith(
                            color: AppColors.text,
                            fontSize: 9,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Wrap(
                    spacing: 10,
                    runSpacing: 4,
                    children: [
                      _MetaInfo(
                        icon: Icons.meeting_room_outlined,
                        fontSize: 9,
                        text: '${data.rooms} ${'favorites.meta.rooms'.tr()}',
                      ),
                      _MetaInfo(
                        icon: Icons.bed_rounded,
                        fontSize: 9,
                        text:
                            '${data.bedrooms} ${'favorites.meta.bedrooms'.tr()}',
                      ),
                      _MetaInfo(
                        icon: Icons.bathtub_outlined,
                        fontSize: 9,
                        text:
                            '${data.bathrooms} ${'favorites.meta.bathrooms'.tr()}',
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${_fmt(data.price.round())} Fcfa',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Cover image with fallback ────────────────────────────────────────────────

class _CoverImage extends StatelessWidget {
  const _CoverImage({
    required this.url,
    required this.height,
    this.width,
  });

  final String? url;
  final double height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      height: height,
      width: width ?? double.infinity,
      color: const Color(0xFFE2E8F0),
      alignment: Alignment.center,
      child: const Icon(Icons.image_rounded, color: AppColors.dark, size: 36),
    );

    final source = url;
    if (source == null || source.trim().isEmpty) return placeholder;

    return Image.network(
      source,
      height: height,
      width: width ?? double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => placeholder,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          height: height,
          width: width ?? double.infinity,
          color: const Color(0xFFE2E8F0),
        );
      },
    );
  }
}

// ─── Meta info chip ───────────────────────────────────────────────────────────

class _MetaInfo extends StatelessWidget {
  const _MetaInfo({
    required this.icon,
    required this.text,
    required this.fontSize,
  });

  final IconData icon;
  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: fontSize + 2, color: AppColors.primary),
        const SizedBox(width: 3),
        Text(
          text,
          style: TextStyle(
            color: AppColors.textBlack,
            fontSize: fontSize,
            fontWeight: FontWeight.w300,
            height: 1.0,
          ),
        ),
      ],
    );
  }
}

// ─── Utils ────────────────────────────────────────────────────────────────────

String _fmt(int value) {
  final s = value.toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    final fromEnd = s.length - i;
    buf.write(s[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buf.write(' ');
  }
  return buf.toString().trim();
}
