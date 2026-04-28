import 'package:flutter/material.dart';

import 'package:statefulclickcounter/features/customer/profile/screens/leave_review_screen.dart';
import 'package:statefulclickcounter/features/customer/profile/screens/reservation_invoice_screen.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

// ─── Data ─────────────────────────────────────────────────────────────────────

enum _ResStatus { annulee, terminee }

class _Reservation {
  const _Reservation({
    required this.image,
    required this.title,
    required this.location,
    required this.arrival,
    required this.departure,
    required this.status,
  });

  final String image;
  final String title;
  final String location;
  final String arrival;
  final String departure;
  final _ResStatus status;
}

const _kReservations = [
  _Reservation(
    image: 'assets/images/modern-elegant-bedroom-interior.jpg',
    title: 'Chambre de luxe',
    location: 'Cocody Angré, Abidjan',
    arrival: '15 Mars 2026',
    departure: '18 Mars 2026',
    status: _ResStatus.annulee,
  ),
  _Reservation(
    image:
        'assets/images/3d-rendering-beautiful-luxury-bedroom-suite-hotel-with-tv.jpg',
    title: 'Chambre de luxe',
    location: 'Cocody Angré, Abidjan',
    arrival: '15 Mars 2026',
    departure: '18 Mars 2026',
    status: _ResStatus.terminee,
  ),
  _Reservation(
    image:
        'assets/images/3d-rendering-beautiful-luxury-bedroom-suite-hotel-with-tv-working-table.jpg',
    title: 'Chambre de luxe',
    location: 'Cocody Angré, Abidjan',
    arrival: '15 Mars 2026',
    departure: '18 Mars 2026',
    status: _ResStatus.annulee,
  ),
  _Reservation(
    image: 'assets/images/expedia_group-695130-2cf588-799717.jpg',
    title: 'Chambre de luxe',
    location: 'Cocody Angré, Abidjan',
    arrival: '15 Mars 2026',
    departure: '18 Mars 2026',
    status: _ResStatus.terminee,
  ),
];

// ─── Screen ───────────────────────────────────────────────────────────────────

class ReservationsScreen extends StatefulWidget {
  const ReservationsScreen({super.key});

  @override
  State<ReservationsScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  bool _filtersOpen = false;
  String _type = 'Hotels';
  int _tab = 0;

  List<_Reservation> get _filtered {
    switch (_tab) {
      case 1:
        return _kReservations
            .where((r) => r.status == _ResStatus.terminee)
            .toList();
      case 2:
        return _kReservations
            .where((r) => r.status == _ResStatus.annulee)
            .toList();
      default:
        return _kReservations;
    }
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
                child: Builder(
                  builder: (_) {
                    final items = _filtered;
                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 24),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) => _SlidableCard(
                        reservation: items[i],
                        swipeEnabled: _tab == 0,
                        onCancel: () => print('cancel ${items[i].title}'),
                      ),
                    );
                  },
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
  });

  final bool expanded;
  final VoidCallback onToggle;
  final String type;
  final ValueChanged<String> onTypeChanged;

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
                        child: Text(
                          'Rechercher une réservation',
                          style: AppTextStyles.regular12.copyWith(
                            color: AppColors.text,
                            fontSize: 11,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
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
                    selected: type == 'Hotels',
                    onTap: () => onTypeChanged('Hotels'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _TypeChip(
                    icon: Icons.villa_rounded,
                    label: 'Villas',
                    selected: type == 'Villas',
                    onTap: () => onTypeChanged('Villas'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _TypeChip(
                    icon: Icons.apartment_rounded,
                    label: 'Résidences',
                    selected: type == 'Résidences',
                    onTap: () => onTypeChanged('Résidences'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Dates
            const Row(
              children: [
                Expanded(
                  child: _DateField(
                    label: 'Arrivée',
                    value: '15 Mars 2026',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _DateField(
                    label: 'Départ',
                    value: '17 Mars 2026',
                  ),
                ),
              ],
            ),
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
  const _DateField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
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
    );
  }
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
  });

  final _Reservation reservation;
  final bool swipeEnabled;
  final VoidCallback onCancel;

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
      onTap: _dx > 0 ? () => setState(() => _dx = 0) : null,
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
    final isAnnulee = reservation.status == _ResStatus.annulee;
    final statusBg =
        isAnnulee ? const Color(0xFFFFDAD6) : const Color(0xFFD7F5DD);
    final statusColor =
        isAnnulee ? const Color(0xFFE53935) : const Color(0xFF22C55E);

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
                        isAnnulee ? 'Annulée' : 'Terminée',
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
