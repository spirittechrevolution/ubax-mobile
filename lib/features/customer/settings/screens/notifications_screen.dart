import 'package:flutter/material.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _general = true;
  bool _son = true;
  bool _vibration = false;
  bool _offres = true;
  bool _promo = false;
  bool _paiement = false;
  bool _majApp = true;
  bool _nouveauServices = false;

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
              padding: EdgeInsets.fromLTRB(14, topPadding + 10, 14, 24),
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
                        'Notifications',
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

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _NotifRow(
                    label: 'Notifications Général',
                    value: _general,
                    onChanged: (v) => setState(() => _general = v),
                  ),
                  _NotifRow(
                    label: 'Son',
                    value: _son,
                    onChanged: (v) => setState(() => _son = v),
                  ),
                  _NotifRow(
                    label: 'Vibration',
                    value: _vibration,
                    onChanged: (v) => setState(() => _vibration = v),
                  ),
                  _NotifRow(
                    label: 'Offres spéciales',
                    value: _offres,
                    onChanged: (v) => setState(() => _offres = v),
                  ),
                  _NotifRow(
                    label: 'Promo',
                    value: _promo,
                    onChanged: (v) => setState(() => _promo = v),
                  ),
                  _NotifRow(
                    label: 'Paiement',
                    value: _paiement,
                    onChanged: (v) => setState(() => _paiement = v),
                  ),
                  _NotifRow(
                    label: 'Mis à jour d\'application',
                    value: _majApp,
                    onChanged: (v) => setState(() => _majApp = v),
                  ),
                  _NotifRow(
                    label: 'Nouveau services disponibles',
                    value: _nouveauServices,
                    onChanged: (v) => setState(() => _nouveauServices = v),
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

class _NotifRow extends StatelessWidget {
  const _NotifRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.regularlight16.copyWith(
                fontFamily: 'Lexend',
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppColors.text,
              ),
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
