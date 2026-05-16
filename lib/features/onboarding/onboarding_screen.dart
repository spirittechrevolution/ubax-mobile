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
  static const _kPremiumEase = Cubic(0.76, 0.0, 0.24, 1.0);
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
      duration: const Duration(milliseconds: 420),
      curve: _kPremiumEase,
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
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, _) {
                  final page = _pageController.hasClients
                      ? (_pageController.page ?? _index.toDouble())
                      : _index.toDouble();
                  final delta = (page - i).clamp(-1.0, 1.0);

                  return _OnboardingPage(
                    data: p,
                    index: i,
                    total: _pages.length,
                    orange: _orange,
                    delta: delta,
                  );
                },
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

class _OnboardingPage extends StatefulWidget {
  const _OnboardingPage({
    required this.data,
    required this.index,
    required this.total,
    required this.orange,
    required this.delta,
  });

  final _OnboardingPageData data;
  final int index;
  final int total;
  final Color orange;
  final double delta;

  @override
  State<_OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<_OnboardingPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _titleT;
  late final Animation<double> _descT;

  bool get _isActive => widget.delta.abs() < 0.001;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 620),
    );

    _titleT = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.72,
          curve: _OnboardingScreenState._kPremiumEase),
    );
    _descT = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.14, 1.0,
          curve: _OnboardingScreenState._kPremiumEase),
    );

    if (_isActive) {
      _controller.forward(from: 0);
    }
  }

  @override
  void didUpdateWidget(covariant _OnboardingPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    final becameActive = !_wasActive(oldWidget) && _isActive;
    if (becameActive) {
      _controller.forward(from: 0);
    }
  }

  bool _wasActive(_OnboardingPage w) => w.delta.abs() < 0.001;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final delta = widget.delta;
    final dAbs = _OnboardingScreenState._kPremiumEase.transform(delta.abs());
    final dx = -delta * 72;
    final dy = dAbs * 16;
    final scale = 1.0 + (dAbs * 0.10);
    final contentDx = delta * 22;
    final contentOpacity = (1.0 - (dAbs * 0.22)).clamp(0.0, 1.0);
    final pageOpacity = (1.0 - (dAbs * 0.46)).clamp(0.0, 1.0);
    final pageScale = 1.0 - (dAbs * 0.04);

    return Opacity(
      opacity: pageOpacity,
      child: Transform.scale(
        scale: pageScale,
        alignment: Alignment.center,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Transform.translate(
              offset: Offset(dx, dy),
              child: Transform.scale(
                scale: scale,
                child: Image.asset(
                  widget.data.imageAsset,
                  fit: BoxFit.cover,
                ),
              ),
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
            Opacity(
              opacity: contentOpacity,
              child: Transform.translate(
                offset: Offset(contentDx, 0),
                child: SafeArea(
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
                          index: widget.index,
                          total: widget.total,
                          orange: widget.orange,
                        ),
                        const Spacer(),
                        AnimatedBuilder(
                          animation: _titleT,
                          builder: (_, __) => Opacity(
                            opacity: _titleT.value,
                            child: Transform.translate(
                              offset: Offset(0, (1.0 - _titleT.value) * 22),
                              child: Text(
                                widget.data.titleKey.tr(),
                                style: AppTextStyles.semibold30
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        AnimatedBuilder(
                          animation: _descT,
                          builder: (_, __) => Opacity(
                            opacity: _descT.value,
                            child: Transform.translate(
                              offset: Offset(0, (1.0 - _descT.value) * 16),
                              child: Text(
                                widget.data.descriptionKey.tr(),
                                style: AppTextStyles.light15
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).padding.bottom + 92),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
              style: AppTextStyles.button.copyWith(
                color: Colors.white,
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
