import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../core/navigation/app_router.dart';

import '../../core/storage/app_prefs.dart';
import 'splash_screen.dart';

class AppStart extends StatefulWidget {
  const AppStart({super.key, required this.home});

  final Widget home;

  @override
  State<AppStart> createState() => _AppStartState();
}

class _AppStartState extends State<AppStart> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _route();
    });
  }

  Future<void> _route() async {
    final onboardingDone = await AppPrefs.isOnboardingDone();
    final language = await AppPrefs.getLanguageCode();

    // If there's an existing logged-in session, skip onboarding/login and go to home
    final hasSession = await AppPrefs.hasValidSession();
    if (hasSession) {
      if (language != null && language.isNotEmpty) {
        await context.setLocale(Locale(language));
      }
      if (!mounted) return;
      context.go(AppRoutes.home);
      return;
    }

    if (!mounted) return;

    if (language != null && language.isNotEmpty) {
      await context.setLocale(Locale(language));
      if (!mounted) return;

      if (!onboardingDone) {
        context.go(AppRoutes.onboarding);
        return;
      }

      context.go(AppRoutes.login);
      return;
    }

    context.go(AppRoutes.language);
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
