import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';

import '../../core/storage/app_prefs.dart';
import '../auth/screens/login_screen.dart';
import 'language_screen.dart';
import 'onboarding_screen.dart';
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

    if (!mounted) return;

    if (language != null && language.isNotEmpty) {
      await context.setLocale(Locale(language));
      if (!mounted) return;

      if (!onboardingDone) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (onboardingRouteContext) => OnboardingScreen(
              onDone: () async {
                await AppPrefs.setOnboardingDone(true);
                if (!onboardingRouteContext.mounted) return;
                Navigator.of(onboardingRouteContext).pushReplacement(
                  MaterialPageRoute(
                    builder: (loginRouteContext) => LoginScreen(
                      onLoggedIn: () {
                        if (!loginRouteContext.mounted) return;
                        Navigator.of(loginRouteContext).pushReplacement(
                          MaterialPageRoute(builder: (_) => widget.home),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        );
        return;
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (loginRouteContext) => LoginScreen(
            onLoggedIn: () {
              if (!loginRouteContext.mounted) return;
              Navigator.of(loginRouteContext).pushReplacement(
                MaterialPageRoute(builder: (_) => widget.home),
              );
            },
          ),
        ),
      );
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (languageRouteContext) => LanguageScreen(
          onContinue: (code) async {
            await AppPrefs.setLanguageCode(code);

            if (!onboardingDone) {
              Navigator.of(languageRouteContext).pushReplacement(
                MaterialPageRoute(
                  builder: (onboardingRouteContext) => OnboardingScreen(
                    onDone: () async {
                      await AppPrefs.setOnboardingDone(true);
                      if (!onboardingRouteContext.mounted) return;
                      Navigator.of(onboardingRouteContext).pushReplacement(
                        MaterialPageRoute(
                          builder: (loginRouteContext) => LoginScreen(
                            onLoggedIn: () {
                              if (!loginRouteContext.mounted) return;
                              Navigator.of(loginRouteContext).pushReplacement(
                                MaterialPageRoute(builder: (_) => widget.home),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
              return;
            }

            Navigator.of(languageRouteContext).pushReplacement(
              MaterialPageRoute(
                builder: (loginRouteContext) => LoginScreen(
                  onLoggedIn: () {
                    if (!loginRouteContext.mounted) return;
                    Navigator.of(loginRouteContext).pushReplacement(
                      MaterialPageRoute(builder: (_) => widget.home),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
