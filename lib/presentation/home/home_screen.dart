import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/app_strings.dart';
import '../../core/localization/language_provider.dart';
import '../../data/datasources/hive_service.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Future<List<Map>>? ideasFuture;

  final titleController = TextEditingController();
  final categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ideasFuture = HiveService().getIdeas();
  }

  @override
  void dispose() {
    titleController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  void refreshIdeas() {
    setState(() {
      ideasFuture = HiveService().getIdeas();
    });
  }

  void showAddIdeaDialog(String lang) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(lang == 'kk' ? 'Идея қосу' : 'Добавить идею'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: lang == 'kk' ? 'Идея атауы' : 'Название идеи',
                ),
              ),
              TextField(
                controller: categoryController,
                decoration: InputDecoration(
                  labelText: lang == 'kk' ? 'Категория' : 'Категория',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                titleController.clear();
                categoryController.clear();
                Navigator.pop(context);
              },
              child: Text(lang == 'kk' ? 'Бас тарту' : 'Отмена'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.trim().isEmpty ||
                    categoryController.text.trim().isEmpty) {
                  return;
                }

                final idea = {
                  'id': DateTime.now().toString(),
                  'title': titleController.text.trim(),
                  'category': categoryController.text.trim(),
                  'description': '',
                };

                await HiveService().saveIdea(idea);

                titleController.clear();
                categoryController.clear();

                if (context.mounted) {
                  Navigator.pop(context);
                }

                refreshIdeas();
              },
              child: Text(lang == 'kk' ? 'Сақтау' : 'Сохранить'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AruStart'),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(languageProvider.notifier).state = const Locale('ru');
            },
            child: const Text('RU'),
          ),
          TextButton(
            onPressed: () {
              ref.read(languageProvider.notifier).state = const Locale('kk');
            },
            child: const Text('KZ'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              AppStrings.appTitle(lang),
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showAddIdeaDialog(lang);
              },
              child: Text(AppStrings.addIdea(lang)),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Map>>(
                future: ideasFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        lang == 'kk' ? 'Әзірге идея жоқ' : 'Пока нет идей',
                      ),
                    );
                  }

                  final ideas = snapshot.data!;

                  return ListView.builder(
                    itemCount: ideas.length,
                    itemBuilder: (context, index) {
                      final idea = ideas[index];

                      return Card(
                        child: ListTile(
                          title: Text(idea['title']),
                          subtitle: Text(idea['category']),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
