import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:statefulclickcounter/core/network/error_handler.dart';
import 'package:statefulclickcounter/features/customer/hotels/data/models/reservation_models.dart';
import 'package:statefulclickcounter/features/customer/hotels/domain/repositories/reservation_repository.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

// ─── Helpers ─────────────────────────────────────────────────────────────────

String _fmtAmt(double v) {
  final s = v.round().toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    final fromEnd = s.length - i;
    buf.write(s[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buf.write(' ');
  }
  return buf.toString().trim();
}

String _fmtDate(String iso) {
  final d = DateTime.tryParse(iso);
  if (d == null) return iso;
  const months = [
    'jan', 'fév', 'mar', 'avr', 'mai', 'jun',
    'jul', 'aoû', 'sep', 'oct', 'nov', 'déc'
  ];
  return '${d.day} ${months[d.month - 1]} ${d.year}';
}

// ─── Screen ───────────────────────────────────────────────────────────────────

class ReservationDetailScreen extends StatefulWidget {
  const ReservationDetailScreen({
    super.key,
    required this.reservationId,
    this.initialTitle = '',
  });

  final String reservationId;
  final String initialTitle;

  @override
  State<ReservationDetailScreen> createState() =>
      _ReservationDetailScreenState();
}

class _ReservationDetailScreenState extends State<ReservationDetailScreen> {
  ReservationResponse? _reservation;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final repo = GetIt.instance<ReservationRepository>();
      final r = await repo.getReservationById(widget.reservationId);
      if (!mounted) return;
      setState(() {
        _reservation = r;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = AppErrors.translate(e);
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: _loading
                ? _buildSkeleton(topPadding)
                : _error != null
                    ? _buildError(topPadding)
                    : _buildContent(topPadding),
          ),
        ],
      ),
    );
  }

  // ── Loading skeleton ────────────────────────────────────────────────────────

  Widget _buildSkeleton(double topPadding) {
    Widget block({required double w, required double h, double r = 10}) =>
        Container(
          width: w,
          height: h,
          decoration: BoxDecoration(
            color: const Color(0xFFE2E8F0),
            borderRadius: BorderRadius.circular(r),
          ),
        );

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero placeholder
          Stack(
            children: [
              Container(height: 280, color: const Color(0xFFD0DDE8)),
              Positioned(
                top: topPadding + 8,
                left: 18,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
          Transform.translate(
            offset: const Offset(0, -8),
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  block(w: 260, h: 24, r: 6),
                  const SizedBox(height: 10),
                  block(w: 140, h: 16, r: 6),
                  const SizedBox(height: 24),
                  block(w: double.infinity, h: 130, r: 14),
                  const SizedBox(height: 14),
                  block(w: double.infinity, h: 100, r: 14),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Error state ─────────────────────────────────────────────────────────────

  Widget _buildError(double topPadding) {
    return Column(
      children: [
        // minimal back header
        Container(
          height: topPadding + 56,
          color: AppColors.dark,
          alignment: Alignment.bottomLeft,
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 14),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white, size: 20),
          ),
        ),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline,
                      color: AppColors.muted, size: 48),
                  const SizedBox(height: 14),
                  Text(_error!,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.regular12
                          .copyWith(color: AppColors.muted, fontSize: 14)),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: _load,
                    child: Text('Réessayer',
                        style: AppTextStyles.regular12.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Main content ─────────────────────────────────────────────────────────────

  Widget _buildContent(double topPadding) {
    final r = _reservation!;
    final statusStyle = _statusStyle(r.status);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Hero
          Stack(
            children: [
              // Background gradient (no image from API)
              Container(
                height: 280,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1A3047), Color(0xFF2C5282)],
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.hotel_rounded,
                      color: Colors.white24, size: 100),
                ),
              ),
              // Top gradient overlay
              Container(
                height: 100,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x88000000), Colors.transparent],
                  ),
                ),
              ),
              // Back + title
              Positioned(
                top: topPadding + 8,
                left: 18,
                right: 18,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Détail réservation',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              // Status chip bottom-left
              Positioned(
                bottom: 24,
                left: 18,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusStyle.bg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    statusStyle.label,
                    style: AppTextStyles.regular12.copyWith(
                        color: statusStyle.fg,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),

          // ── White rounded content
          Transform.translate(
            offset: const Offset(0, -8),
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    r.propertyTitle,
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.text,
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // City
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          color: AppColors.primary, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        r.propertyCity,
                        style: AppTextStyles.regular12.copyWith(
                          color: AppColors.text,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ── Détails de la réservation
                  _sectionTitle('Détails de la réservation'),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _DetailRow(
                          icon: Icons.login_rounded,
                          label: 'Arrivée',
                          value: _fmtDate(r.checkInDate),
                        ),
                        const _Divider(),
                        _DetailRow(
                          icon: Icons.logout_rounded,
                          label: 'Départ',
                          value: _fmtDate(r.checkOutDate),
                        ),
                        const _Divider(),
                        _DetailRow(
                          icon: Icons.nights_stay_outlined,
                          label: 'Durée',
                          value:
                              '${r.numberOfNights} nuit${r.numberOfNights > 1 ? 's' : ''}',
                        ),
                        const _Divider(),
                        _DetailRow(
                          icon: Icons.person_outline_rounded,
                          label: 'Invités',
                          value:
                              '${r.guestCount} personne${r.guestCount > 1 ? 's' : ''}',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Récapitulatif prix
                  _sectionTitle('Récapitulatif du prix'),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _PriceRow(
                          label:
                              '${_fmtAmt(r.pricePerNight)} Fcfa × ${r.numberOfNights} nuit${r.numberOfNights > 1 ? 's' : ''}',
                          value: '',
                        ),
                        const _Divider(),
                        _PriceRow(
                          label: 'Total estimé',
                          value: '${_fmtAmt(r.totalAmount)} Fcfa',
                          bold: true,
                        ),
                      ],
                    ),
                  ),

                  // ── Notes
                  if (r.notes != null && r.notes!.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    _sectionTitle('Demandes spéciales'),
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        r.notes!,
                        style: AppTextStyles.regular12.copyWith(
                            color: AppColors.text,
                            fontSize: 13,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],

                  // ── Date de réservation
                  if (r.createdAt != null) ...[
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Icon(Icons.access_time_rounded,
                            size: 14, color: AppColors.muted),
                        const SizedBox(width: 6),
                        Text(
                          'Réservé le ${_fmtDate(r.createdAt!.substring(0, 10))}',
                          style: AppTextStyles.regular12.copyWith(
                              color: AppColors.muted,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) => Text(
        text,
        style: AppTextStyles.sectionTitle
            .copyWith(color: AppColors.text, fontSize: 15),
      );

  _StatusStyle _statusStyle(String status) {
    switch (status.toUpperCase()) {
      case 'CONFIRMED':
        return const _StatusStyle(
            label: 'Confirmée',
            bg: Color(0xFFDCFCE7),
            fg: Color(0xFF16A34A));
      case 'CANCELLED':
        return const _StatusStyle(
            label: 'Annulée',
            bg: Color(0xFFFFE4E6),
            fg: Color(0xFFDC2626));
      default:
        return const _StatusStyle(
            label: 'En attente',
            bg: Color(0xFFFFF7ED),
            fg: AppColors.primary);
    }
  }
}

// ─── Status style ─────────────────────────────────────────────────────────────

class _StatusStyle {
  const _StatusStyle({required this.label, required this.bg, required this.fg});
  final String label;
  final Color bg;
  final Color fg;
}

// ─── Detail row ───────────────────────────────────────────────────────────────

class _DetailRow extends StatelessWidget {
  const _DetailRow(
      {required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: AppColors.dark, size: 16),
          ),
          const SizedBox(width: 12),
          Text(label,
              style: AppTextStyles.regular12.copyWith(
                  color: AppColors.muted,
                  fontSize: 13,
                  fontWeight: FontWeight.w400)),
          const Spacer(),
          Text(value,
              style: AppTextStyles.sectionTitle.copyWith(
                  color: AppColors.text,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ─── Price row ────────────────────────────────────────────────────────────────

class _PriceRow extends StatelessWidget {
  const _PriceRow(
      {required this.label, required this.value, this.bold = false});

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: AppTextStyles.regular12.copyWith(
                  color: bold ? AppColors.text : AppColors.muted,
                  fontSize: 13,
                  fontWeight: bold ? FontWeight.w600 : FontWeight.w400)),
          if (value.isNotEmpty)
            Text(value,
                style: AppTextStyles.sectionTitle.copyWith(
                    color: bold ? AppColors.primary : AppColors.text,
                    fontSize: 14,
                    fontWeight: bold ? FontWeight.w700 : FontWeight.w400)),
        ],
      ),
    );
  }
}

// ─── Divider ──────────────────────────────────────────────────────────────────

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) =>
      const Divider(color: Color(0xFFE5E7EB), height: 1);
}
