import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:statefulclickcounter/core/network/error_handler.dart';
import 'package:statefulclickcounter/features/customer/hotels/data/models/reservation_models.dart';
import 'package:statefulclickcounter/features/customer/hotels/domain/repositories/reservation_repository.dart';
import 'package:statefulclickcounter/features/customer/profile/screens/leave_review_screen.dart';
import 'package:statefulclickcounter/features/customer/profile/screens/reservation_detail_screen.dart';
import 'package:statefulclickcounter/features/customer/profile/screens/reservation_invoice_screen.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

// ─── Data ─────────────────────────────────────────────────────────────────────

enum _ResStatus { enAttente, terminee, annulee }

class _ReservationsSkeleton extends StatelessWidget {
  const _ReservationsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    Widget block({required double h, double r = 14}) {
      return Container(
        height: h,
        decoration: BoxDecoration(
          color: const Color(0xFFE2E8F0),
          borderRadius: BorderRadius.circular(r),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 24),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => block(h: 139),
    );
  }
}

enum _ResType { hotel, villa, residence }

class _Reservation {
  _Reservation({
    required this.id,
    required this.image,
    required this.type,
    required this.title,
    required this.location,
    required this.arrival,
    required this.departure,
    required this.arrivalAt,
    required this.departureAt,
    required this.status,
  });

  final String id;
  final String image;
  final _ResType type;
  final String title;
  final String location;
  final String arrival;
  final String departure;
  final DateTime arrivalAt;
  final DateTime departureAt;
  final _ResStatus status;
}

_ResStatus _mapStatus(String s) {
  switch (s.toUpperCase()) {
    case 'CONFIRMED':
      return _ResStatus.terminee;
    case 'CANCELLED':
      return _ResStatus.annulee;
    default:
      return _ResStatus.enAttente;
  }
}

_Reservation _fromApi(ReservationResponse r) {
  return _Reservation(
    id: r.id,
    image: '',
    type: _ResType.hotel,
    title: r.propertyTitle,
    location: r.propertyCity,
    arrival: r.checkInDate,
    departure: r.checkOutDate,
    arrivalAt: DateTime.tryParse(r.checkInDate) ?? DateTime.now(),
    departureAt: DateTime.tryParse(r.checkOutDate) ?? DateTime.now(),
    status: _mapStatus(r.status),
  );
}

// ─── Screen ───────────────────────────────────────────────────────────────────

class ReservationsScreen extends StatefulWidget {
  const ReservationsScreen({super.key});

  @override
  State<ReservationsScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  bool _filtersOpen = false;
  _ResType _type = _ResType.hotel;
  int _tab = 0;
  String _query = '';
  DateTime? _arrivalFilter;
  DateTime? _departureFilter;
  bool _loading = true;
  String? _apiError;
  List<_Reservation> _reservations = [];
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _loadReservations();
  }

  Future<void> _loadReservations() async {
    setState(() {
      _loading = true;
      _apiError = null;
    });
    try {
      final repo = GetIt.instance<ReservationRepository>();
      final list = await repo.getMyReservations();
      if (!mounted) return;
      setState(() {
        _reservations = list.map(_fromApi).toList();
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _apiError = AppErrors.translate(e);
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _setQuery(String v) {
    setState(() => _query = v);
  }

  void _clearQuery() {
    _searchController.clear();
    setState(() => _query = '');
  }

  Future<void> _pickArrival() async {
    final now = DateTime.now();
    final initial = _arrivalFilter ?? now;
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime(initial.year, initial.month, initial.day),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (time == null) return;

    setState(() {
      _arrivalFilter = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _pickDeparture() async {
    final now = DateTime.now();
    final initial = _departureFilter ?? _arrivalFilter ?? now;
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime(initial.year, initial.month, initial.day),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (time == null) return;

    setState(() {
      _departureFilter = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _clearDates() {
    setState(() {
      _arrivalFilter = null;
      _departureFilter = null;
    });
  }

  List<_Reservation> get _filtered {
    List<_Reservation> base;
    switch (_tab) {
      case 1:
        base = _reservations
            .where((r) => r.status == _ResStatus.terminee)
            .toList();
        break;
      case 2:
        base = _reservations
            .where((r) => r.status == _ResStatus.annulee)
            .toList();
        break;
      default:
        base = _reservations;
    }

    bool matchType(_Reservation r) => r.type == _type;

    bool matchArrival(_Reservation r) {
      final f = _arrivalFilter;
      if (f == null) return true;
      return r.arrivalAt.isAtSameMomentAs(f) || r.arrivalAt.isAfter(f);
    }

    bool matchDeparture(_Reservation r) {
      final f = _departureFilter;
      if (f == null) return true;
      return r.departureAt.isAtSameMomentAs(f) || r.departureAt.isBefore(f);
    }

    bool matchQuery(_Reservation r) {
      final q = _query.trim().toLowerCase();
      if (q.isEmpty) return true;
      final hay =
          '${r.title} ${r.location} ${r.arrival} ${r.departure}'.toLowerCase();
      return hay.contains(q);
    }

    return base
        .where(matchType)
        .where(matchArrival)
        .where(matchDeparture)
        .where(matchQuery)
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final darkHeight = topPadding + (_filtersOpen ? 180 : 170);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── Dark header background (behind everything)
          Container(
            height: darkHeight,
            decoration: const BoxDecoration(
              color: AppColors.dark,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
          ),
          // ── Content
          Column(
            children: [
              SizedBox(height: topPadding + 14),
              // Title row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white, size: 20),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Mes réservations',
                          style: AppTextStyles.sectionTitle.copyWith(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              // Search card — overlaps dark/light boundary
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: _SearchCard(
                  expanded: _filtersOpen,
                  onToggle: () => setState(() => _filtersOpen = !_filtersOpen),
                  type: _type,
                  onTypeChanged: (t) => setState(() => _type = t),
                  controller: _searchController,
                  query: _query,
                  onQueryChanged: _setQuery,
                  onClearQuery: _clearQuery,
                  arrival: _arrivalFilter,
                  departure: _departureFilter,
                  onArrivalTap: _pickArrival,
                  onDepartureTap: _pickDeparture,
                  onClearDates: _clearDates,
                ),
              ),
              const SizedBox(height: 28),
              // Tabs
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: _StatusTabs(
                  tab: _tab,
                  onChanged: (i) => setState(() => _tab = i),
                ),
              ),
              const SizedBox(height: 14),
              // List
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  child: _loading
                      ? const _ReservationsSkeleton(
                          key: ValueKey<String>('reservations_skeleton'),
                        )
                      : _apiError != null
                          ? Center(
                              key: const ValueKey<String>('reservations_error'),
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.error_outline,
                                        color: AppColors.muted, size: 40),
                                    const SizedBox(height: 12),
                                    Text(
                                      _apiError!,
                                      textAlign: TextAlign.center,
                                      style: AppTextStyles.regular12.copyWith(
                                          color: AppColors.muted, fontSize: 13),
                                    ),
                                    const SizedBox(height: 16),
                                    TextButton(
                                      onPressed: _loadReservations,
                                      child: Text('Réessayer',
                                          style: AppTextStyles.regular12
                                              .copyWith(
                                                  color: AppColors.primary,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13)),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Builder(
                              key: const ValueKey<String>('reservations_list'),
                              builder: (_) {
                                final items = _filtered;
                                if (items.isEmpty) {
                                  return Center(
                                    child: Text(
                                      'Aucune réservation',
                                      style: AppTextStyles.regular12.copyWith(
                                        color: AppColors.muted,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  );
                                }
                                return RefreshIndicator(
                                  color: AppColors.primary,
                                  onRefresh: _loadReservations,
                                  child: ListView.separated(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 0, 10, 24),
                                    itemCount: items.length,
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(height: 12),
                                    itemBuilder: (_, i) => _SlidableCard(
                                      reservation: items[i],
                                      swipeEnabled: items[i].status ==
                                          _ResStatus.enAttente,
                                      onCancel: () {},
                                      onCardTap: () => Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (_) => ReservationDetailScreen(
                                          reservationId: items[i].id,
                                          initialTitle: items[i].title,
                                        ),
                                      )),
                                    ),
                                  ),
                                );
                              },
                            ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Search card ──────────────────────────────────────────────────────────────

class _SearchCard extends StatelessWidget {
  const _SearchCard({
    required this.expanded,
    required this.onToggle,
    required this.type,
    required this.onTypeChanged,
    required this.controller,
    required this.query,
    required this.onQueryChanged,
    required this.onClearQuery,
    required this.arrival,
    required this.departure,
    required this.onArrivalTap,
    required this.onDepartureTap,
    required this.onClearDates,
  });

  final bool expanded;
  final VoidCallback onToggle;
  final _ResType type;
  final ValueChanged<_ResType> onTypeChanged;
  final TextEditingController controller;
  final String query;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onClearQuery;
  final DateTime? arrival;
  final DateTime? departure;
  final VoidCallback onArrivalTap;
  final VoidCallback onDepartureTap;
  final VoidCallback onClearDates;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Search bar + toggle button
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search_rounded,
                          color: AppColors.dark, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          key: const ValueKey('reservations-search'),
                          controller: controller,
                          onChanged: onQueryChanged,
                          textInputAction: TextInputAction.search,
                          style: AppTextStyles.regular12.copyWith(
                            color: AppColors.text,
                            fontSize: 11,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                            isCollapsed: true,
                            border: InputBorder.none,
                            hintText: 'Rechercher une réservation',
                            hintStyle: AppTextStyles.regular12.copyWith(
                              color: AppColors.text,
                              fontSize: 11,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ),
                      if (query.trim().isNotEmpty) ...[
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: onClearQuery,
                          child: const Icon(
                            Icons.close_rounded,
                            color: AppColors.dark,
                            size: 18,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: onToggle,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: AppColors.dark,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    expanded ? Icons.close_rounded : Icons.tune_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          if (expanded) ...[
            const SizedBox(height: 12),
            // Type chips
            Row(
              children: [
                Expanded(
                  child: _TypeChip(
                    icon: Icons.hotel_rounded,
                    label: 'Hotels',
                    selected: type == _ResType.hotel,
                    onTap: () => onTypeChanged(_ResType.hotel),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _TypeChip(
                    icon: Icons.villa_rounded,
                    label: 'Villas',
                    selected: type == _ResType.villa,
                    onTap: () => onTypeChanged(_ResType.villa),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _TypeChip(
                    icon: Icons.apartment_rounded,
                    label: 'Résidences',
                    selected: type == _ResType.residence,
                    onTap: () => onTypeChanged(_ResType.residence),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Dates
            Row(
              children: [
                Expanded(
                  child: _DateField(
                    label: 'Arrivée',
                    value: arrival == null
                        ? '--/--/---- --:--'
                        : _formatDateTime(arrival!),
                    onTap: onArrivalTap,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _DateField(
                    label: 'Départ',
                    value: departure == null
                        ? '--/--/---- --:--'
                        : _formatDateTime(departure!),
                    onTap: onDepartureTap,
                  ),
                ),
              ],
            ),
            if (arrival != null || departure != null) ...[
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: onClearDates,
                  style: TextButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Réinitialiser les dates',
                    style: AppTextStyles.regular12.copyWith(
                      color: AppColors.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                onPressed: () {},
                child: const Text('Rechercher', style: AppTextStyles.button),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Type chip (Hotels/Villas/Résidences) ─────────────────────────────────────

class _TypeChip extends StatelessWidget {
  const _TypeChip({
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
                icon,
                color: selected ? Colors.white : AppColors.primary,
                size: 14,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.regular12.copyWith(
                  color: selected ? Colors.white : AppColors.dark,
                  fontSize: 11,
                  fontWeight: selected ? FontWeight.w400 : FontWeight.w300,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Date field ───────────────────────────────────────────────────────────────

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.regular12.copyWith(
                      color: AppColors.text,
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    value,
                    style: AppTextStyles.regular12.copyWith(
                      color: AppColors.text,
                      fontSize: 10,
                      fontWeight: FontWeight.w300,
                    ),
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

String _two(int v) => v.toString().padLeft(2, '0');

String _formatDateTime(DateTime d) {
  return '${_two(d.day)}/${_two(d.month)}/${d.year} ${_two(d.hour)}:${_two(d.minute)}';
}

// ─── Status tabs ──────────────────────────────────────────────────────────────

class _StatusTabs extends StatelessWidget {
  const _StatusTabs({required this.tab, required this.onChanged});

  final int tab;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        children: [
          _TabBtn(
              label: 'Récentes', selected: tab == 0, onTap: () => onChanged(0)),
          _TabBtn(
              label: 'Terminées',
              selected: tab == 1,
              onTap: () => onChanged(1)),
          _TabBtn(
              label: 'Annulées', selected: tab == 2, onTap: () => onChanged(2)),
        ],
      ),
    );
  }
}

class _TabBtn extends StatelessWidget {
  const _TabBtn({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(40),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.dark : Colors.transparent,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Text(
            label,
            style: AppTextStyles.regular12.copyWith(
              color: selected ? Colors.white : AppColors.dark,
              fontSize: 11,
              fontWeight: selected ? FontWeight.w500 : FontWeight.w300,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Slidable card (swipe to reveal Annuler) ─────────────────────────────────

class _SlidableCard extends StatefulWidget {
  const _SlidableCard({
    required this.reservation,
    required this.swipeEnabled,
    required this.onCancel,
    this.onCardTap,
  });

  final _Reservation reservation;
  final bool swipeEnabled;
  final VoidCallback onCancel;
  final VoidCallback? onCardTap;

  @override
  State<_SlidableCard> createState() => _SlidableCardState();
}

class _SlidableCardState extends State<_SlidableCard> {
  static const double _openOffset = 141.0; // 14 left + 113 width + 14 gap

  double _dx = 0;

  void _onUpdate(DragUpdateDetails d) {
    if (!widget.swipeEnabled) return;
    setState(() {
      _dx = (_dx + d.delta.dx).clamp(0.0, _openOffset);
    });
  }

  void _onEnd(DragEndDetails d) {
    if (!widget.swipeEnabled) return;
    setState(() {
      _dx = _dx > _openOffset / 2 ? _openOffset : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: _onUpdate,
      onHorizontalDragEnd: _onEnd,
      onTap: _dx > 0 ? () => setState(() => _dx = 0) : widget.onCardTap,
      child: Stack(
        children: [
          // Revealed "Annuler" button
          if (widget.swipeEnabled)
            Positioned(
              top: 50,
              left: 14,
              child: GestureDetector(
                onTap: widget.onCancel,
                child: Container(
                  width: 113,
                  height: 41,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF2F2F),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Annuler',
                    style: AppTextStyles.button.copyWith(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          // Card translated
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            transform: Matrix4.translationValues(_dx, 0, 0),
            child: _ReservationCard(reservation: widget.reservation),
          ),
        ],
      ),
    );
  }
}

// ─── Reservation card ─────────────────────────────────────────────────────────

class _ReservationCard extends StatelessWidget {
  const _ReservationCard({required this.reservation});

  final _Reservation reservation;

  @override
  Widget build(BuildContext context) {
    final statusBg = switch (reservation.status) {
      _ResStatus.annulee => const Color(0xFFFFDAD6),
      _ResStatus.terminee => const Color(0xFFD7F5DD),
      _ResStatus.enAttente => const Color(0xFFFFF7ED),
    };
    final statusColor = switch (reservation.status) {
      _ResStatus.annulee => const Color(0xFFE53935),
      _ResStatus.terminee => const Color(0xFF22C55E),
      _ResStatus.enAttente => AppColors.primary,
    };
    final statusLabel = switch (reservation.status) {
      _ResStatus.annulee => 'Annulée',
      _ResStatus.terminee => 'Terminée',
      _ResStatus.enAttente => 'En attente',
    };

    return Container(
      height: 139,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              reservation.image,
              width: 128,
              height: 127,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 128,
                height: 127,
                color: const Color(0xFFE2E8F0),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title + status
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 9),
                        child: Text(
                          reservation.title,
                          style: AppTextStyles.sectionTitle.copyWith(
                            color: AppColors.text,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        statusLabel,
                        style: AppTextStyles.regular12.copyWith(
                          color: statusColor,
                          fontSize: 8,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Location
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        color: AppColors.dark, size: 13),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        reservation.location,
                        style: AppTextStyles.regular12.copyWith(
                          color: AppColors.text,
                          fontSize: 9,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Dates
                Row(
                  children: [
                    const Icon(Icons.calendar_month_rounded,
                        color: AppColors.dark, size: 13),
                    const SizedBox(width: 3),
                    Text(
                      reservation.arrival,
                      style: AppTextStyles.regular12.copyWith(
                        color: AppColors.text,
                        fontSize: 8,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      '—',
                      style: TextStyle(
                        fontFamily: 'Lexend',
                        color: AppColors.text,
                        fontSize: 8,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.calendar_month_rounded,
                        color: AppColors.dark, size: 13),
                    const SizedBox(width: 3),
                    Text(
                      reservation.departure,
                      style: AppTextStyles.regular12.copyWith(
                        color: AppColors.text,
                        fontSize: 8,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // Actions
                Row(
                  children: [
                    Expanded(
                      child: _MiniPillBtn(
                        icon: Icons.chat_bubble_outline_rounded,
                        label: 'Laisser un avis',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => LeaveReviewScreen(
                              image: reservation.image,
                              title: reservation.title,
                              location: reservation.location,
                              arrival: reservation.arrival,
                              departure: reservation.departure,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _MiniPillBtn(
                        icon: Icons.description_outlined,
                        label: 'Voir la facture',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ReservationInvoiceScreen(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniPillBtn extends StatelessWidget {
  const _MiniPillBtn({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 28,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.dark, size: 12),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                style: AppTextStyles.regular12.copyWith(
                  color: AppColors.text,
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
