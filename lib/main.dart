import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:statefulclickcounter/core/di/injection.dart';
import 'package:statefulclickcounter/core/navigation/app_router.dart';
import 'package:statefulclickcounter/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:statefulclickcounter/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await EasyLocalization.ensureInitialized();
  await configureDependencies();

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
  static const String _title = 'UBAX';

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<AuthBloc>()..add(const AuthStarted()),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: _title,
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        theme: AppTheme.light(),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
