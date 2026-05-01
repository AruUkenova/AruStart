import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/app_strings.dart';
import '../../core/localization/language_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AruStart'),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(languageProvider.notifier).state =
                  const Locale('ru');
            },
            child: const Text('RU'),
          ),
          TextButton(
            onPressed: () {
              ref.read(languageProvider.notifier).state =
                  const Locale('kk');
            },
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