import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:statefulclickcounter/features/customer/home/screens/home_screen.dart';

import 'features/onboarding/app_start.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('fr'),
        Locale('en'),
        Locale('es'),
        Locale('de'),
        Locale('hi'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('fr'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const String _title = 'Flutter Stateful Clicker Counter';
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      theme: ThemeData(
        // useMaterial3: false,
        primarySwatch: Colors.blue,
      ),
      home: const AppStart(home: HomeScreen()),
    );
  }
}
