import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

import 'package:statefulclickcounter/core/di/injection.dart';
import 'package:statefulclickcounter/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:statefulclickcounter/features/auth/screens/login_screen.dart';

import 'package:statefulclickcounter/features/customer/home/screens/home_screen.dart';
import 'package:statefulclickcounter/features/customer/hotels/screens/address_search_screen.dart';
import 'package:statefulclickcounter/features/customer/home/screens/proprety/property_details_screen.dart';
import 'package:statefulclickcounter/features/onboarding/app_start.dart';
import 'package:statefulclickcounter/features/onboarding/language_screen.dart';
import 'package:statefulclickcounter/features/onboarding/onboarding_screen.dart';
import 'package:statefulclickcounter/features/customer/settings/screens/language_settings_screen.dart';
import 'package:statefulclickcounter/core/storage/app_prefs.dart';

class AppRoutes {
  static const start = '/';
  static const home = '/home';
  static const login = '/login';
  static const language = '/language';
  static const onboarding = '/onboarding';
  static const languageSettings = '/language-settings';
  static const addressSearch = '/address-search';
  static const propertyDetails = '/property-details';
}

CustomTransitionPage<T> sharedAxisPage<T>({
  required LocalKey key,
  required Widget child,
  SharedAxisTransitionType transitionType = SharedAxisTransitionType.horizontal,
}) {
  return CustomTransitionPage<T>(
    key: key,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SharedAxisTransition(
        animation: animation,
        secondaryAnimation: secondaryAnimation,
        transitionType: transitionType,
        child: child,
      );
    },
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(this.bloc) {
    _sub = bloc.stream.listen((_) => notifyListeners());
  }

  final AuthBloc bloc;
  late final StreamSubscription<void> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

class AppRouter {
  static final router = GoRouter(
    initialLocation: AppRoutes.start,
    refreshListenable: GoRouterRefreshStream(getIt<AuthBloc>()),
    redirect: (BuildContext? context, GoRouterState state) {
      final authState = getIt<AuthBloc>().state;
      final loggedIn = authState.status == AuthStatus.authenticated;
      final path = state.uri.path;
      final isLoggingIn = path == AppRoutes.login;
      final isStart = path == AppRoutes.start;
      final isPublic = isStart ||
          isLoggingIn ||
          path == AppRoutes.language ||
          path == AppRoutes.onboarding;

      if (!loggedIn && !isPublic) return AppRoutes.login;
      if (loggedIn && (isLoggingIn || isStart)) return AppRoutes.home;
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.start,
        pageBuilder: (context, state) => sharedAxisPage<void>(
          key: state.pageKey,
          transitionType: SharedAxisTransitionType.scaled,
          child: const AppStart(home: HomeScreen()),
        ),
      ),
      GoRoute(
        path: AppRoutes.home,
        pageBuilder: (context, state) => sharedAxisPage<void>(
          key: state.pageKey,
          transitionType: SharedAxisTransitionType.scaled,
          child: const HomeScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.login,
        pageBuilder: (context, state) => sharedAxisPage<void>(
          key: state.pageKey,
          transitionType: SharedAxisTransitionType.horizontal,
          child: LoginScreen(
            onLoggedIn: () {
              if (context.mounted) context.go(AppRoutes.home);
            },
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.language,
        pageBuilder: (context, state) => sharedAxisPage<void>(
          key: state.pageKey,
          transitionType: SharedAxisTransitionType.horizontal,
          child: LanguageScreen(
            onContinue: (code) async {
              await AppPrefs.setLanguageCode(code);
              final onboardingDone = await AppPrefs.isOnboardingDone();
              if (!context.mounted) return;
              if (!onboardingDone) {
                context.go(AppRoutes.onboarding);
                return;
              }
              context.go(AppRoutes.login);
            },
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        pageBuilder: (context, state) => sharedAxisPage<void>(
          key: state.pageKey,
          transitionType: SharedAxisTransitionType.horizontal,
          child: OnboardingScreen(
            onDone: () async {
              await AppPrefs.setOnboardingDone(true);
              if (!context.mounted) return;
              context.go(AppRoutes.login);
            },
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.languageSettings,
        pageBuilder: (context, state) => sharedAxisPage<void>(
          key: state.pageKey,
          transitionType: SharedAxisTransitionType.horizontal,
          child: const LanguageSettingsScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.addressSearch,
        pageBuilder: (context, state) => sharedAxisPage<void>(
          key: state.pageKey,
          transitionType: SharedAxisTransitionType.vertical,
          child: const AddressSearchScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.propertyDetails,
        pageBuilder: (context, state) {
          final extra = state.extra;
          if (extra is! PropertyDetailsArgs) {
            return sharedAxisPage<void>(
              key: state.pageKey,
              transitionType: SharedAxisTransitionType.horizontal,
              child: const _MissingArgsScreen(title: 'Property details'),
            );
          }

          return sharedAxisPage<void>(
            key: state.pageKey,
            transitionType: SharedAxisTransitionType.horizontal,
            child: PropertyDetailsScreen(
              propertyId: extra.propertyId,
              coverImageFallback: extra.coverImageFallback,
              mockTitle: extra.mockTitle,
              mockLocation: extra.mockLocation,
              mockPrice: extra.mockPrice,
              mockDescription: extra.mockDescription,
              mockBeds: extra.mockBeds,
              mockBaths: extra.mockBaths,
              mockKitchens: extra.mockKitchens,
            ),
          );
        },
      ),
    ],
  );
}

class PropertyDetailsArgs {
  const PropertyDetailsArgs({
    required this.propertyId,
    this.coverImageFallback,
    this.mockTitle,
    this.mockLocation,
    this.mockPrice,
    this.mockDescription,
    this.mockBeds,
    this.mockBaths,
    this.mockKitchens,
  });

  final String propertyId;
  final String? coverImageFallback;

  final String? mockTitle;
  final String? mockLocation;
  final String? mockPrice;
  final String? mockDescription;
  final int? mockBeds;
  final int? mockBaths;
  final int? mockKitchens;
}

class _MissingArgsScreen extends StatelessWidget {
  const _MissingArgsScreen({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Text(
            'Missing args for $title',
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
