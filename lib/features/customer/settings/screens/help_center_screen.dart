import 'package:flutter/material.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

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
      'Toutes les annonces sont vérifiées par notre équipe avant publication.',
    ),
    _FaqItem(
      'Comment signaler une annonce suspecte ?',
      'Vous pouvez signaler une annonce depuis la page de détails en utilisant le bouton « Signaler ».',
    ),
    _FaqItem(
      'Puis-je contacter directement les propriétaires ou agents ?',
      'Oui, vous pouvez utiliser le chat intégré pour échanger avec eux.',
    ),
    _FaqItem(
      'Mes données personnelles sont-elles sécurisées ?',
      'Oui, UBAX applique les meilleures pratiques de sécurité et de confidentialité.',
    ),
  ],
  'Compte': [
    _FaqItem(
      'Comment créer un compte ?',
      'Cliquez sur S\'inscrire depuis l\'écran d\'accueil et suivez les étapes.',
    ),
  ],
  'Paiement': [
    _FaqItem(
      'Quels moyens de paiement acceptez-vous ?',
      'Wave, Orange Money, MTN Money, ainsi que les cartes bancaires.',
    ),
  ],
  'Sécurité': [
    _FaqItem(
      'Comment changer mon mot de passe ?',
      'Allez dans Profil > Sécurité > Changer mon mot de passe.',
    ),
  ],
};

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  int _tab = 0; // 0 = FAQ, 1 = Contact
  String _category = 'Général';
  int? _expanded = 0;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Top bar
          Padding(
            padding: EdgeInsets.fromLTRB(14, topPadding + 10, 14, 14),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: AppColors.text, size: 20),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Centre d\'aide',
                      style: AppTextStyles.sectionTitle.copyWith(
                        fontFamily: 'Lexend',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
              ],
            ),
          ),

          // ── Tabs: FAQ / Contact
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: _TabHeader(
                    label: 'FAQ',
                    selected: _tab == 0,
                    onTap: () => setState(() => _tab = 0),
                  ),
                ),
                Expanded(
                  child: _TabHeader(
                    label: 'Contact',
                    selected: _tab == 1,
                    onTap: () => setState(() => _tab = 1),
                  ),
                ),
              ],
            ),
          ),

          // ── Body
          Expanded(
            child: _tab == 0 ? _buildFaqTab() : _buildContactTab(),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqTab() {
    final items = _kFaqs[_category] ?? const <_FaqItem>[];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category pills
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _kCategories.map((c) {
                final selected = c == _category;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () => setState(() {
                      _category = c;
                      _expanded = 0;
                    }),
                    child: Container(
                      height: 42,
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selected ? AppColors.dark : Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                        border: selected
                            ? null
                            : Border.all(
                                color: AppColors.primary, width: 1.2),
                      ),
                      child: Text(
                        c,
                        style: AppTextStyles.regularlight16.copyWith(
                          fontFamily: 'Lexend',
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: selected ? Colors.white : AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 14),
          // Search bar
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFDEE3EA),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.search_rounded,
                    color: AppColors.text, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Rechercher',
                    style: AppTextStyles.regularlight16.copyWith(
                      fontFamily: 'Lexend',
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: AppColors.text,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // FAQ items
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

  Widget _buildContactTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      child: Column(
        children: [
          _ContactCard(
            icon: Icons.headset_mic_outlined,
            label: 'Services Client',
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _ContactCard(
            icon: Icons.chat_bubble_outline_rounded,
            label: 'Whatsapp',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _TabHeader extends StatelessWidget {
  const _TabHeader({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              label,
              style: AppTextStyles.regularlight16.copyWith(
                fontFamily: 'Lexend',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: selected ? AppColors.primary : AppColors.text,
              ),
            ),
          ),
          Container(
            height: 3,
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.primary
                  : const Color(0xFFD9DEE5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
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
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(14),
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
                    style: AppTextStyles.regularlight16.copyWith(
                      fontFamily: 'Lexend',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.text,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: AppColors.primary,
                  size: 22,
                ),
              ],
            ),
            if (expanded) ...[
              const SizedBox(height: 10),
              Container(height: 1, color: const Color(0xFFEEF3F7)),
              const SizedBox(height: 10),
              Text(
                item.answer,
                style: AppTextStyles.regular12.copyWith(
                  fontFamily: 'Lexend',
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  color: AppColors.text,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 22),
            const SizedBox(width: 14),
            Text(
              label,
              style: AppTextStyles.regularlight16.copyWith(
                fontFamily: 'Lexend',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
