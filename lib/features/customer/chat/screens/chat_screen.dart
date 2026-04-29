import 'package:flutter/material.dart';

import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const _ChatHeader(),
          Expanded(
            child: _ChatBody(),
          ),
          _ChatInput(controller: _controller),
        ],
      ),
    );
  }
}

// ─── Header ──────────────────────────────────────────────────────────────────

class _ChatHeader extends StatelessWidget {
  const _ChatHeader();

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.dark,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      padding: EdgeInsets.fromLTRB(18, topPadding + 10, 18, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Message',
            style: AppTextStyles.sectionTitle.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Avatar (UBAX logo)
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(
                    'assets/icons/logoubaxblue.png',
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.home_rounded,
                      color: AppColors.primary,
                      size: 28,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Name + status
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Aigle Immobilière',
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF22C55E),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'en ligne',
                          style: AppTextStyles.regular12.copyWith(
                            color: const Color(0xFF94A3B8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Phone button
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.phone_rounded,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Chat body ───────────────────────────────────────────────────────────────

class _ChatBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 8),
      children: const [
        // Date separator
        _DateSeparator(label: "Aujourd'hui"),
        SizedBox(height: 16),
        // Property card shared in chat
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: _SharedPropertyCard(
            tag: 'Hôtel',
            imagePath:
                'assets/images/luxurious-modern-living-room-with-blue-wall-white-sofa.jpg',
            name: 'Palm Club Plateau',
            location: 'Cocody Angré, Abidjan',
            rating: 4.7,
            pricePerNight: 45000,
          ),
        ),
        SizedBox(height: 12),
        // Message bubble
        _BubbleMessage(
          text: 'Bonjour, je suis intéressé par ce bien.',
          time: '12 h : 00',
          isMine: true,
        ),
      ],
    );
  }
}

// ─── Date separator ──────────────────────────────────────────────────────────

class _DateSeparator extends StatelessWidget {
  const _DateSeparator({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        label,
        style: AppTextStyles.regular12.copyWith(
          color: AppColors.text,
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ),
    );
  }
}

// ─── Shared property card ────────────────────────────────────────────────────

class _SharedPropertyCard extends StatelessWidget {
  const _SharedPropertyCard({
    required this.tag,
    required this.imagePath,
    required this.name,
    required this.location,
    required this.rating,
    required this.pricePerNight,
  });

  final String tag;
  final String imagePath;
  final String name;
  final String location;
  final double rating;
  final int pricePerNight;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 232,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with tag and heart (inset with border-radius 20 all 4 corners)
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 7, right: 7),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    imagePath,
                    width: 216.77,
                    height: 122.20,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 216.77,
                      height: 122.20,
                      color: const Color(0xFFE2E8F0),
                      alignment: Alignment.center,
                      child: const Icon(Icons.image_rounded,
                          color: AppColors.dark, size: 40),
                    ),
                  ),
                ),
                // Tag
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.dark,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
                // Heart
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.favorite_rounded,
                      color: Colors.red,
                      size: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Info
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: AppTextStyles.sectionTitle.copyWith(
                          color: AppColors.text,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.star_rounded,
                        color: Color(0xFFFACC15), size: 16),
                    const SizedBox(width: 2),
                    Text(
                      rating.toString(),
                      style: const TextStyle(
                        color: AppColors.text,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  location,
                  style: AppTextStyles.regular12.copyWith(
                    color: AppColors.text,
                    fontSize: 9,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${_formatAmount(pricePerNight)} FCFA',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                            ),
                          ),
                          const TextSpan(
                            text: ' / nuit',
                            style: TextStyle(
                              color: AppColors.text,
                              fontWeight: FontWeight.w300,
                              fontSize: 7,
                            ),
                          ),
                        ],
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

  static String _formatAmount(int value) {
    final str = value.toString();
    final buf = StringBuffer();
    for (var i = 0; i < str.length; i++) {
      final idxFromEnd = str.length - i;
      buf.write(str[i]);
      if (idxFromEnd > 1 && idxFromEnd % 3 == 1) buf.write(' ');
    }
    return buf.toString().trim();
  }
}

// ─── Message bubble ──────────────────────────────────────────────────────────

class _BubbleMessage extends StatelessWidget {
  const _BubbleMessage({
    required this.text,
    required this.time,
    required this.isMine,
  });

  final String text;
  final String time;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.72,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isMine ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(18),
              topRight: const Radius.circular(18),
              bottomLeft: Radius.circular(isMine ? 18 : 4),
              bottomRight: Radius.circular(isMine ? 4 : 18),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isMine ? Colors.white : AppColors.dark,
              fontWeight: FontWeight.w300,
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: AppTextStyles.regular12.copyWith(
            color: AppColors.text,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ─── Input bar ───────────────────────────────────────────────────────────────

class _ChatInput extends StatelessWidget {
  const _ChatInput({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: EdgeInsets.fromLTRB(
          16, 10, 16, MediaQuery.of(context).padding.bottom + 10),
      child: Row(
        children: [
          // Plus button
          const Icon(Icons.add_rounded, color: AppColors.primary, size: 28),
          const SizedBox(width: 10),
          // Text field
          Expanded(
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
              ),
              alignment: Alignment.center,
              child: TextField(
                controller: controller,
                style: const TextStyle(
                  color: AppColors.text,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Saisir votre message',
                  hintStyle: TextStyle(
                    color: AppColors.text,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Send button
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}
