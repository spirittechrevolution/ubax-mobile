import 'package:flutter/material.dart';

import 'package:statefulclickcounter/features/customer/profile/screens/create_ticket_screen.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

// ─── Data ─────────────────────────────────────────────────────────────────────

enum _TicketStatus { enCours, resolu }

class _Ticket {
  const _Ticket({
    required this.category,
    required this.residence,
    required this.apartment,
    required this.number,
    required this.date,
    required this.status,
  });

  final String category;
  final String residence;
  final String apartment;
  final String number;
  final String date;
  final _TicketStatus status;
}

const _kTickets = [
  _Ticket(
    category: 'Electricité',
    residence: 'Résidence Azalai',
    apartment: 'Appartement 0025',
    number: 'UBX-SAV-0265',
    date: '30 Avril 2026',
    status: _TicketStatus.enCours,
  ),
  _Ticket(
    category: 'Plomberie',
    residence: 'Résidence Azalai',
    apartment: 'Appartement 0025',
    number: 'UBX-SAV-0262',
    date: '18 Mars 2026',
    status: _TicketStatus.resolu,
  ),
  _Ticket(
    category: 'Electricité',
    residence: 'Résidence Azalai',
    apartment: 'Appartement 0025',
    number: 'UBX-SAV-0261',
    date: '',
    status: _TicketStatus.resolu,
  ),
];

// ─── Screen ───────────────────────────────────────────────────────────────────

class SavScreen extends StatelessWidget {
  const SavScreen({super.key});

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
              color: AppColors.text,
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

                  // Ticket list
                  ..._kTickets.map(
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
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const CreateTicketScreen(),
                      ),
                    );
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

// ─── Ticket card ──────────────────────────────────────────────────────────────

class _TicketCard extends StatelessWidget {
  const _TicketCard({required this.ticket});

  final _Ticket ticket;

  @override
  Widget build(BuildContext context) {
    final isResolu = ticket.status == _TicketStatus.resolu;
    final accent = isResolu ? const Color(0xFF22C55E) : AppColors.primary;
    final accentBg =
        isResolu ? const Color(0xFFDCFCE7) : const Color(0xFFFFE7D3);

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
            // Left colored strip
            Container(width: 5, color: accent),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category + number
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ticket.category,
                                style: AppTextStyles.sectionTitle.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                ticket.residence,
                                style: AppTextStyles.sectionTitle.copyWith(
                                  color: AppColors.text,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
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
                        Text(
                          ticket.number,
                          style: AppTextStyles.regular12.copyWith(
                            color: AppColors.text,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Date + status + details
                    Row(
                      children: [
                        if (ticket.date.isNotEmpty) ...[
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
                              color: AppColors.text,
                              size: 14,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            ticket.date,
                            style: AppTextStyles.regular12.copyWith(
                              color: AppColors.text,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                        const Spacer(),
                        // Status pill (filled)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: accentBg,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            isResolu ? 'Résolu' : 'En cour',
                            style: AppTextStyles.regular12.copyWith(
                              color: accent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Details button
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
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
