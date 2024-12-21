import 'package:app_build_freelance/router/app_router.dart';
import 'package:app_build_freelance/src/constants/app_colors.dart';
import 'package:app_build_freelance/src/themes/text_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker/talker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger_observer.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger_settings.dart';
final talker = Talker();

void main() async {
  await dotenv.load(fileName: 'assets/.env');
  final appRouter = AppRouter();
  runApp(
    ProviderScope(
      observers: [
        TalkerRiverpodObserver(
          settings: TalkerRiverpodLoggerSettings(
            enabled: true,
            printStateFullData: false,
            printProviderAdded: true,
            printProviderUpdated: true,
            printProviderDisposed: true,
            printProviderFailed: true,
          ),
        )
      ],
      child: MyApp(appRouter: appRouter)),
  );
}


class MyApp extends StatelessWidget {
  final AppRouter appRouter;
  MyApp({super.key, required this.appRouter});
  final _appRouter = AppRouter();


  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      
      // routerConfig: _appRouter.config(),
      routerConfig: _appRouter.config(
        navigatorObservers: () => [
          TalkerRouteObserver(talker),
        ],
      ),
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shadowColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSwatch(
        primarySwatch: MaterialColor(
          AppColors.violet.value,
          {
            50: AppColors.violet.withOpacity(0.1),
            100: AppColors.violet.withOpacity(0.2),
            200: AppColors.violet.withOpacity(0.3),
            300: AppColors.violet.withOpacity(0.4),
            400: AppColors.violet.withOpacity(0.5),
            500: AppColors.violet,
            600: AppColors.violet.withOpacity(0.7),
            700: AppColors.violet.withOpacity(0.8),
            800: AppColors.violet.withOpacity(0.9),
            900: AppColors.violet,
          },
        ),
      ),
        primarySwatch: Colors.blue,
        textTheme: buildTextTheme(),
        
      ),
      locale: const Locale('ru', 'RU'), // Устанавливаем локаль
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ru', 'RU'), // Русский
        Locale('en', 'US'), // Английский (или другие, если нужны)
      ],
    );
  }
}
