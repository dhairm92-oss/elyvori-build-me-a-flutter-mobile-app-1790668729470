import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'l10n/app_localizations.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: const MohammedDhairApp(),
    ),
  );
}

class MohammedDhairApp extends StatelessWidget {
  const MohammedDhairApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    return MaterialApp(
      title: 'Mohammed Dhair - Gulf Market App',
      debugShowCheckedModeBanner: false, 
      locale: appProvider.locale,
      supportedLocales: const [
        Locale('ar'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
      ],
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFFF7F9FA),
        fontFamily: 'Roboto',
      ),
      home: const DashboardScreen(),
    );
  }
}