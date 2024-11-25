import 'package:flutter/material.dart';
import 'package:frontend/routing/app_routing.dart';
import 'package:frontend/theme/default_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MeetingApp extends StatelessWidget {
  MeetingApp({super.key});
  final navigatorKey = GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Meet Now',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('de', 'DE'),
      ],
      theme: AppTheme().lightTheme,
      routerDelegate: AppRouting.router.routerDelegate,
      routeInformationParser: AppRouting.router.routeInformationParser,
      routeInformationProvider: AppRouting.router.routeInformationProvider,
    );
  }
}
