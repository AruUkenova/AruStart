import 'package:flutter/material.dart';
import '../../core/localization/app_strings.dart';

class HomeScreen extends StatelessWidget {
  final Function(Locale) onLanguageChanged;

  const HomeScreen({
    super.key,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AruStart'),
        actions: [
          TextButton(
            onPressed: () => onLanguageChanged(const Locale('ru')),
            child: const Text('RU'),
          ),
          TextButton(
            onPressed: () => onLanguageChanged(const Locale('kk')),
            child: const Text('KZ'),
          ),
        ],
      ),
      body: Center(
        child: Text(
          AppStrings.appTitle(lang),
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}