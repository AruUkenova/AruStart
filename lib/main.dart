import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'presentation/home/home_screen.dart';

void main() {
  runApp(const AruStartApp());
}

class AruStartApp extends StatefulWidget {
  const AruStartApp({super.key});

  @override
  State<AruStartApp> createState() => _AruStartAppState();
}

class _AruStartAppState extends State<AruStartApp> {
  Locale _locale = const Locale('ru');

  void changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AruStart',
      debugShowCheckedModeBanner: false,

      locale: _locale,

      supportedLocales: const [
        Locale('ru'),
        Locale('kk'),
      ],

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8F5EF),
      ),

      home: HomeScreen(
        onLanguageChanged: changeLanguage,
      ),
    );
  }
}