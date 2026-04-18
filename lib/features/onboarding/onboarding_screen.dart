import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';

import 'package:statefulclickcounter/core/widgets/orange_button.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.onDone});

  final VoidCallback onDone;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const _orange = AppColors.primary;
  final _pageController = PageController();
  int _index = 0;

  List<_OnboardingPageData> get _pages => const [
        _OnboardingPageData(
          imageAsset: 'assets/images/onb1.png',
          titleKey: 'onboarding.page1.title',
          descriptionKey: 'onboarding.page1.description',
        ),
        _OnboardingPageData(
          imageAsset: 'assets/images/onb2.png',
          titleKey: 'onboarding.page2.title',
          descriptionKey: 'onboarding.page2.description',
        ),
        _OnboardingPageData(
          imageAsset: 'assets/images/onb3.png',
          titleKey: 'onboarding.page3.title',
          descriptionKey: 'onboarding.page3.description',
        ),
        _OnboardingPageData(
          imageAsset: 'assets/images/mobilemoney.png',
          titleKey: 'onboarding.page4.title',
          descriptionKey: 'onboarding.page4.description',
        ),
      ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    if (_index >= _pages.length - 1) {
      widget.onDone();
      return;
    }
    await _pageController.animateToPage(
      _index + 1,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _index == _pages.length - 1;

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (context, i) {
              final p = _pages[i];
              return _OnboardingPage(
                data: p,
                index: i,
                total: _pages.length,
                orange: _orange,
              );
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).padding.bottom + 24,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _NextButton(
                isLast: isLast,
                onPressed: _next,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPageData {
  const _OnboardingPageData({
    required this.imageAsset,
    required this.titleKey,
    required this.descriptionKey,
  });

  final String imageAsset;
  final String titleKey;
  final String descriptionKey;
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.data,
    required this.index,
    required this.total,
    required this.orange,
  });

  final _OnboardingPageData data;
  final int index;
  final int total;
  final Color orange;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          data.imageAsset,
          fit: BoxFit.cover,
        ),
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xCC000000),
                Color(0x33000000),
                Color(0xCC000000),
              ],
              stops: [0.0, 0.45, 1.0],
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    'assets/icons/logoUbaxWhite.png',
                    width: 54,
                    height: 54,
                  ),
                ),
                const SizedBox(height: 18),
                _ProgressBar(
                  index: index,
                  total: total,
                  orange: orange,
                ),
                const Spacer(),
                Text(
                  data.titleKey.tr(),
                  style: AppTextStyles.semibold30.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 22),
                Text(
                  data.descriptionKey.tr(),
                  style: AppTextStyles.light15.copyWith(color: Colors.white),
                ),
                SizedBox(height: MediaQuery.of(context).padding.bottom + 92),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({
    required this.index,
    required this.total,
    required this.orange,
  });

  final int index;
  final int total;
  final Color orange;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (i) {
        final active = i <= index;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i == total - 1 ? 0 : 8),
            height: 4,
            decoration: BoxDecoration(
              color: active ? orange : Colors.white,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        );
      }),
    );
  }
}

class _NextButton extends StatelessWidget {
  const _NextButton({required this.isLast, required this.onPressed});

  final bool isLast;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (isLast) {
      return OrangeButton(
        text: 'onboarding.discover'.tr(),
        onPressed: onPressed,
      );
    }

    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2E2E2E).withOpacity(0.55),
          elevation: 0,
          shape: const StadiumBorder(
            side: BorderSide(color: Color(0x66FFFFFF)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'onboarding.next'.tr(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.arrow_forward_rounded,
                color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }
}
