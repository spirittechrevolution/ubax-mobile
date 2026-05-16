import 'package:flutter/material.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

class _Contact {
  const _Contact({
    required this.name,
    required this.phone,
    required this.avatarAsset,
  });

  final String name;
  final String phone;
  final String avatarAsset;
}

const _kContacts = <_Contact>[
  _Contact(
    name: 'Adama Traoré',
    phone: '+225 01 02 03 04 05',
    avatarAsset: 'assets/images/pexels-ekrulila-2128329.jpg',
  ),
  _Contact(
    name: 'Kouamé Koffi',
    phone: '+225 01 02 03 04 05',
    avatarAsset: 'assets/images/pexels-ekrulila-2128329.jpg',
  ),
  _Contact(
    name: 'Aïssata Coulibaly',
    phone: '+225 01 02 03 04 05',
    avatarAsset: 'assets/images/villa9.jpg',
  ),
  _Contact(
    name: 'Ismaël Fofana',
    phone: '+225 01 02 03 04 05',
    avatarAsset: 'assets/images/sara2.jpg',
  ),
  _Contact(
    name: 'Adama Traoré',
    phone: '+225 01 02 03 04 05',
    avatarAsset: 'assets/images/full-shot-happy-family-playing-games.jpg',
  ),
  _Contact(
    name: 'Serge  N\'Guessan',
    phone: '+225 01 02 03 04 05',
    avatarAsset: 'assets/images/pexels-ekrulila-2128329.jpg',
  ),
  _Contact(
    name: 'Franck Ouattara',
    phone: '+225 01 02 03 04 05',
    avatarAsset: 'assets/images/pexels-ekrulila-2128329.jpg',
  ),
  _Contact(
    name: 'Jessica Amon',
    phone: '+225 01 02 03 04 05',
    avatarAsset: 'assets/images/sara2.jpg',
  ),
  _Contact(
    name: 'Rosine Gnahoré',
    phone: '+225 01 02 03 04 05',
    avatarAsset: 'assets/images/villa9.jpg',
  ),
  _Contact(
    name: 'Adama Traoré',
    phone: '+225 01 02 03 04 05',
    avatarAsset: 'assets/images/medium-shot-smiley-family-with-tablet.jpg',
  ),
];

class InviteFriendsScreen extends StatelessWidget {
  const InviteFriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Top bar
          Padding(
            padding: EdgeInsets.fromLTRB(14, topPadding + 10, 14, 10),
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
                      'Inviter des amis',
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

          // ── List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              itemCount: _kContacts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _ContactRow(contact: _kContacts[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({required this.contact});
  final _Contact contact;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipOval(
          child: Image.asset(
            contact.avatarAsset,
            width: 48,
            height: 48,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 48,
              height: 48,
              color: AppColors.dark,
              child: const Icon(Icons.person, color: Colors.white, size: 22),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                contact.name,
                style: AppTextStyles.regularlight16.copyWith(
                  fontFamily: 'Lexend',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                contact.phone,
                style: AppTextStyles.regular12.copyWith(
                  fontFamily: 'Lexend',
                  fontSize: 11,
                  fontWeight: FontWeight.w300,
                  color: AppColors.text,
                  height: 1.0,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Container(
            width: 96,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Text(
              'Inviter',
              style: AppTextStyles.regularlight16.copyWith(
                fontFamily: 'Lexend',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
