import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:statefulclickcounter/features/customer/home/screens/home_screen.dart';
import 'package:statefulclickcounter/features/customer/hotels/screens/address_search_screen.dart';
import 'package:statefulclickcounter/features/customer/home/screens/proprety/property_details_screen.dart';
import 'package:statefulclickcounter/features/onboarding/app_start.dart';

class AppRoutes {
  static const home = '/';
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

class AppRouter {
  static final router = GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        pageBuilder: (context, state) => sharedAxisPage<void>(
          key: state.pageKey,
          transitionType: SharedAxisTransitionType.scaled,
          child: const AppStart(home: HomeScreen()),
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
              imagePath: extra.imagePath,
              title: extra.title,
              location: extra.location,
              price: extra.price,
              beds: extra.beds,
              baths: extra.baths,
              kitchens: extra.kitchens,
            ),
          );
        },
      ),
    ],
  );
}

class PropertyDetailsArgs {
  const PropertyDetailsArgs({
    required this.imagePath,
    required this.title,
    required this.location,
    required this.price,
    required this.beds,
    required this.baths,
    required this.kitchens,
  });

  final String imagePath;
  final String title;
  final String location;
  final String price;
  final int beds;
  final int baths;
  final int kitchens;
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
