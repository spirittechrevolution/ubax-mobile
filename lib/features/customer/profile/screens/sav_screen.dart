import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:statefulclickcounter/features/customer/profile/data/datasources/tickets_remote_data_source.dart';
import 'package:statefulclickcounter/features/customer/profile/data/models/ticket_models.dart';
import 'package:statefulclickcounter/features/customer/profile/screens/create_ticket_screen.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

// ─── Screen ───────────────────────────────────────────────────────────────────

class SavScreen extends StatefulWidget {
  const SavScreen({super.key});

  @override
  State<SavScreen> createState() => _SavScreenState();
}

class _SavScreenState extends State<SavScreen> {
  final _ds = GetIt.instance<TicketsRemoteDataSource>();
  List<TicketItem> _tickets = [];
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
      final tickets = await _ds.getMyTickets();
      if (mounted) setState(() => _tickets = tickets);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Dark header
          Container(
            padding: EdgeInsets.fromLTRB(18, topPadding + 10, 18, 18),
            decoration: const BoxDecoration(
              color: AppColors.dark,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
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
                      'Service après-vente (SAV)',
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
              ],
            ),
          ),

          // ── Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Illustration
                  Center(
                    child: Image.asset(
                      'assets/images/imagesav.png',
                      height: 200,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Container(
                        height: 200,
                        alignment: Alignment.center,
                        child: const Icon(Icons.handyman_rounded,
                            color: AppColors.primary, size: 80),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      'Pour tout problème lié à votre local, merci de créer\nun ticket afin d\'assurer un suivi rapide.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.regular12.copyWith(
                        color: AppColors.text,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Mes tickets
                  Text(
                    'Mes tickets',
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 14),

                  if (_loading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 32),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (_error != null)
                    _RetryBlock(onRetry: _load)
                  else if (_tickets.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: Text(
                          'Aucun ticket pour le moment.',
                          style: AppTextStyles.regular12
                              .copyWith(color: AppColors.text),
                        ),
                      ),
                    )
                  else
                    ..._tickets.map(
                      (t) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _TicketCard(ticket: t),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // ── Create ticket button
          Container(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.dark,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  onPressed: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const CreateTicketScreen(),
                      ),
                    );
                    _load();
                  },
                  child: const Text(
                    'Créer un ticket',
                    style: AppTextStyles.button,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Retry block ──────────────────────────────────────────────────────────────

class _RetryBlock extends StatelessWidget {
  const _RetryBlock({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          children: [
            Text(
              'Impossible de charger les tickets.',
              style: AppTextStyles.regular12.copyWith(color: AppColors.text),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: onRetry,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Ticket card ──────────────────────────────────────────────────────────────

class _TicketCard extends StatelessWidget {
  const _TicketCard({required this.ticket});

  final TicketItem ticket;

  String _label(String category) {
    switch (category.toUpperCase()) {
      case 'PLOMBIER':
        return 'Plomberie';
      case 'ELECTRICIEN':
        return 'Electricité';
      case 'SERRURIER':
        return 'Serrurerie';
      case 'MACON':
        return 'Maçonnerie';
      default:
        return category.isNotEmpty ? category : 'Autre';
    }
  }

  String _formattedDate(String iso) {
    if (iso.isEmpty) return '';
    try {
      final dt = DateTime.parse(iso).toLocal();
      const months = [
        'Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin',
        'Juil', 'Août', 'Sep', 'Oct', 'Nov', 'Déc'
      ];
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
    } catch (_) {
      return iso;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isResolu = ticket.isResolved;
    final accent = isResolu ? const Color(0xFF22C55E) : AppColors.primary;
    final accentBg =
        isResolu ? const Color(0xFFDCFCE7) : const Color(0xFFFFE7D3);
    final date = _formattedDate(ticket.createdAt);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 5, color: accent),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _label(ticket.category),
                                style: AppTextStyles.sectionTitle.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                              if (ticket.residence.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Text(
                                  ticket.residence,
                                  style: AppTextStyles.sectionTitle.copyWith(
                                    color: AppColors.text,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                              if (ticket.apartment.isNotEmpty)
                                Text(
                                  ticket.apartment,
                                  style: AppTextStyles.regular12.copyWith(
                                    color: AppColors.text,
                                    fontSize: 11,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (ticket.reference.isNotEmpty)
                          Text(
                            ticket.reference,
                            style: AppTextStyles.regular12.copyWith(
                              color: AppColors.text,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        if (date.isNotEmpty) ...[
                          Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.calendar_month_rounded,
                              color: AppColors.dark,
                              size: 14,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            date,
                            style: AppTextStyles.regular12.copyWith(
                              color: AppColors.text,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: accentBg,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            isResolu ? 'Résolu' : 'En cours',
                            style: AppTextStyles.regular12.copyWith(
                              color: accent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border:
                                Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: Text(
                            'Détails',
                            style: AppTextStyles.regular12.copyWith(
                              color: AppColors.text,
                              fontWeight: FontWeight.w500,
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
