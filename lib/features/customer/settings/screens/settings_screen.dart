import 'package:flutter/material.dart';
import 'package:statefulclickcounter/features/customer/settings/screens/help_center_screen.dart';
import 'package:statefulclickcounter/features/customer/settings/screens/invite_friends_screen.dart';
import 'package:statefulclickcounter/features/customer/settings/screens/language_settings_screen.dart';
import 'package:statefulclickcounter/features/customer/settings/screens/notifications_screen.dart';
import 'package:statefulclickcounter/features/customer/settings/screens/personal_info_screen.dart';
import 'package:statefulclickcounter/features/customer/settings/screens/security_screen.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = true;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top bar
            Padding(
              padding: EdgeInsets.fromLTRB(14, topPadding + 10, 14, 18),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: AppColors.dark, size: 20),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Profil',
                        style: AppTextStyles.sectionTitle.copyWith(
                          fontFamily: 'Lexend',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.dark,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            ),

            // ── Identity card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 106,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: const Color(0xFFDADADA),
                    width: 0.5,
                  ),
                ),
                child: Row(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        'assets/images/pexels-ekrulila-2128329.jpg',
                        width: 58,
                        height: 58,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 58,
                          height: 58,
                          color: AppColors.muted,
                          child: const Icon(Icons.person,
                              color: Colors.white, size: 28),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Arnaud Koffi',
                            style: AppTextStyles.regularlight16.copyWith(
                              fontFamily: 'Lexend',
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.text,
                              height: 1.0,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: 103,
                            height: 28,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.statusPaid,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.check_circle_outline_rounded,
                                    color: Colors.white, size: 13),
                                const SizedBox(width: 5),
                                Text(
                                  'Complété 100%',
                                  style: AppTextStyles.regular12.copyWith(
                                    fontFamily: 'Lexend',
                                    fontSize: 9,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    height: 1.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ── Section title: Détails du compte
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                'Détails du compte',
                style: AppTextStyles.sectionTitle.copyWith(
                  fontFamily: 'Lexend',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.text,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // ── Account group
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    _SettingsRow(
                      icon: Icons.perm_contact_cal_outlined,
                      label: 'Informations Personnelles',
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const PersonalInfoScreen(),
                        ));
                      },
                    ),
                    const _RowDivider(),
                    _SettingsRow(
                      icon: Icons.lock_outline_rounded,
                      label: 'Sécurité',
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const SecurityScreen(),
                        ));
                      },
                    ),
                    const _RowDivider(),
                    _SettingsRow(
                      icon: Icons.notifications_none_rounded,
                      label: 'Notifications',
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const NotificationsScreen(),
                        ));
                      },
                    ),
                    const _RowDivider(),
                    _SettingsRow(
                      icon: Icons.language_rounded,
                      label: 'Langue',
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const LanguageSettingsScreen(),
                        ));
                      },
                    ),
                    const _RowDivider(),
                    _SettingsRow(
                      icon: Icons.dark_mode_outlined,
                      label: 'Mode sombre',
                      trailing: Switch.adaptive(
                        value: _darkMode,
                        onChanged: (v) => setState(() => _darkMode = v),
                        activeColor: Colors.white,
                        activeTrackColor: AppColors.dark,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 26),

            // ── Other group
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    _SettingsRow(
                      icon: Icons.chat_bubble_outline_rounded,
                      label: 'Centre d\'aide',
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const HelpCenterScreen(),
                        ));
                      },
                    ),
                    const _RowDivider(),
                    _SettingsRow(
                      icon: Icons.group_add_outlined,
                      label: 'Inviter des amis',
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const InviteFriendsScreen(),
                        ));
                      },
                    ),
                    const _RowDivider(),
                    _SettingsRow(
                      icon: Icons.info_outline_rounded,
                      label: 'A propos de l\'application',
                      onTap: () {},
                    ),
                    const _RowDivider(),
                    _SettingsRow(
                      icon: Icons.logout_rounded,
                      label: 'Déconnexion',
                      danger: true,
                      onTap: () {},
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

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.label,
    this.onTap,
    this.trailing,
    this.danger = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final color = danger ? Colors.red : AppColors.text;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color:
                    danger ? const Color(0xFFFDECEA) : const Color(0xFFEEF3F7),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 17, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.regularlight16.copyWith(
                  fontFamily: 'Lexend',
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: color,
                  height: 1.0,
                ),
              ),
            ),
            trailing ??
                Icon(
                  Icons.chevron_right_rounded,
                  color: color,
                  size: 22,
                ),
          ],
        ),
      ),
    );
  }
}

class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: const Color(0xFFEEF3F7),
    );
  }
}
