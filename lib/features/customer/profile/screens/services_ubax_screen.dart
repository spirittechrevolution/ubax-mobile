import 'package:flutter/material.dart';

import 'package:statefulclickcounter/core/widgets/header_tab.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

// ─── Data ─────────────────────────────────────────────────────────────────────

class _FaqItem {
  const _FaqItem(this.question, this.answer);
  final String question;
  final String answer;
}

const _kCategories = ['Général', 'Compte', 'Paiement', 'Sécurité'];

const _kFaqs = {
  'Général': [
    _FaqItem(
      'UBAX est-elle une agence immobilière ?',
      'Non, UBAX est une plateforme technologique qui met en relation les utilisateurs avec des propriétaires, agents et promoteurs immobiliers.',
    ),
    _FaqItem(
      'Les annonces publiées sur UBAX sont-elles fiables ?',
      'Toutes les annonces sont vérifiées par notre équipe avant publication afin de garantir leur fiabilité.',
    ),
    _FaqItem(
      'Comment signaler une annonce suspecte ?',
      'Vous pouvez signaler une annonce suspecte directement depuis sa fiche, en cliquant sur l\u2019icône de signalement.',
    ),
    _FaqItem(
      ' Puis-je contacter directement les propriétaires ou agents ?',
      'Oui, vous pouvez les contacter directement via la messagerie intégrée de l\u2019application.',
    ),
    _FaqItem(
      'Mes données personnelles sont-elles sécurisées ?',
      'Oui, vos données sont chiffrées et conservées selon les standards de sécurité les plus élevés.',
    ),
  ],
  'Compte': [
    _FaqItem(
      'Comment créer un compte UBAX ?',
      'Cliquez sur "S\u2019inscrire" depuis l\u2019écran d\u2019accueil et suivez les étapes.',
    ),
  ],
  'Paiement': [
    _FaqItem(
      'Quels moyens de paiement sont acceptés ?',
      'Wave, Orange Money, MTN Money et les cartes Visa/Mastercard.',
    ),
  ],
  'Sécurité': [
    _FaqItem(
      'Comment activer la double authentification ?',
      'Rendez-vous dans Profil > Paramètres > Sécurité pour l\u2019activer.',
    ),
  ],
};

// ─── Screen ───────────────────────────────────────────────────────────────────

class ServicesUbaxScreen extends StatefulWidget {
  const ServicesUbaxScreen({super.key});

  @override
  State<ServicesUbaxScreen> createState() => _ServicesUbaxScreenState();
}

class _ServicesUbaxScreenState extends State<ServicesUbaxScreen> {
  int _tab = 0; // 0 = Assistance, 1 = FAQ
  String _category = 'Général';
  int? _expanded = 0;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Dark header
          Container(
            padding: EdgeInsets.fromLTRB(18, topPadding + 10, 18, 20),
            decoration: const BoxDecoration(
              color: AppColors.dark,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white, size: 20),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Services UBAX',
                          style: AppTextStyles.sectionTitle.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
                const SizedBox(height: 16),
                _TabSegment(
                  tab: _tab,
                  onChanged: (i) => setState(() => _tab = i),
                ),
              ],
            ),
          ),

          // ── Body
          Expanded(
            child: _tab == 0 ? const _AssistanceTab() : _buildFaqTab(),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqTab() {
    final items = _kFaqs[_category] ?? const <_FaqItem>[];
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('FAQ', style: AppTextStyles.sectionTitle),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _kCategories.map((c) {
                final selected = c == _category;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: _CategoryPill(
                    label: c,
                    selected: selected,
                    onTap: () => setState(() {
                      _category = c;
                      _expanded = 0;
                    }),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(items.length, (i) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _FaqCard(
                item: items[i],
                expanded: _expanded == i,
                onTap: () => setState(
                  () => _expanded = _expanded == i ? null : i,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ─── Tab segment ──────────────────────────────────────────────────────────────

class _TabSegment extends StatelessWidget {
  const _TabSegment({required this.tab, required this.onChanged});

  final int tab;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF2F445A),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [
          HeaderTab(
            label: 'Assistance',
            selected: tab == 0,
            onTap: () => onChanged(0),
          ),
          HeaderTab(
            label: 'FAQ',
            selected: tab == 1,
            onTap: () => onChanged(1),
          ),
        ],
      ),
    );
  }
}

// ─── Assistance tab ───────────────────────────────────────────────────────────

class _AssistanceTab extends StatelessWidget {
  const _AssistanceTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Centre d\u2019assistance', style: AppTextStyles.sectionTitle),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _AssistCard(
                  icon: Icons.headset_mic_rounded,
                  label: 'Services Client',
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _AssistCard(
                  assetIcon: 'assets/images/Vector.png',
                  label: 'WhatsApp',
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AssistCard extends StatelessWidget {
  const _AssistCard({
    this.icon,
    this.assetIcon,
    required this.label,
    required this.onTap,
  });

  final IconData? icon;
  final String? assetIcon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFEAF0F6),
              ),
              alignment: Alignment.center,
              child: assetIcon != null
                  ? Image.asset(
                      assetIcon!,
                      width: 28,
                      height: 28,
                      fit: BoxFit.contain,
                    )
                  : Icon(icon, color: AppColors.primary, size: 26),
            ),
            const SizedBox(height: 14),
            Text(
              label,
              style: AppTextStyles.regular12.copyWith(
                color: AppColors.dark,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── FAQ ──────────────────────────────────────────────────────────────────────

class _CategoryPill extends StatelessWidget {
  const _CategoryPill({
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
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.dark : Colors.white,
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
    );
  }
}

class _FaqCard extends StatelessWidget {
  const _FaqCard({
    required this.item,
    required this.expanded,
    required this.onTap,
  });

  final _FaqItem item;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.question,
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.textBlack,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Icon(
                  expanded ? Icons.remove_rounded : Icons.add_rounded,
                  color: AppColors.dark,
                  size: 22,
                ),
              ],
            ),
            if (expanded) ...[
              const SizedBox(height: 10),
              const Divider(height: 1, color: Color(0xFFE5E7EB)),
              const SizedBox(height: 10),
              Text(
                item.answer,
                style: AppTextStyles.regular12.copyWith(
                  color: AppColors.text,
                  fontSize: 11,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
