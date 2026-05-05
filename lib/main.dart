import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/localization/language_provider.dart';
import 'presentation/auth/login_screen.dart';
import 'presentation/home/home_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(
    const ProviderScope(
      child: AruStartApp(),
    ),
  );
}

class AruStartApp extends ConsumerWidget {
  const AruStartApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(languageProvider);

    return MaterialApp(
      title: 'AruStart',
      debugShowCheckedModeBanner: false,
      locale: locale,
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
      home: FirebaseAuth.instance.currentUser == null
          ? LoginScreen(lang: locale.languageCode)
          : const HomeScreen(),
    );
  }
}