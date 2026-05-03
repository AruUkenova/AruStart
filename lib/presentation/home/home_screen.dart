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
  final descriptionController = TextEditingController();

  int selectedCategoryIndex = 0;
  int? filterCategoryIndex;

  final categories = [
    {'ru': 'IT и технологии', 'kk': 'IT және технология'},
    {'ru': 'Онлайн бизнес', 'kk': 'Онлайн бизнес'},
    {'ru': 'Маркетинг и SMM', 'kk': 'Маркетинг және SMM'},
    {'ru': 'Торговля', 'kk': 'Сауда'},
    {'ru': 'Одежда и мода', 'kk': 'Киім және сән'},
    {'ru': 'Beauty', 'kk': 'Beauty және сұлулық'},
    {'ru': 'Здоровье', 'kk': 'Денсаулық'},
    {'ru': 'Фитнес и спорт', 'kk': 'Фитнес және спорт'},
    {'ru': 'Еда и кафе', 'kk': 'Тамақ және кафе'},
    {'ru': 'Образование', 'kk': 'Білім беру'},
    {'ru': 'Научные проекты', 'kk': 'Ғылыми жобалар'},
    {'ru': 'Детские услуги', 'kk': 'Балаларға арналған қызмет'},
    {'ru': 'Финансы', 'kk': 'Қаржы'},
    {'ru': 'Недвижимость', 'kk': 'Жылжымайтын мүлік'},
    {'ru': 'Туризм', 'kk': 'Туризм'},
    {'ru': 'Логистика', 'kk': 'Логистика'},
    {'ru': 'Сельское хозяйство', 'kk': 'Ауыл шаруашылығы'},
    {'ru': 'Ремесло', 'kk': 'Қолөнер'},
    {'ru': 'Производство', 'kk': 'Өндіріс'},
    {'ru': 'Услуги', 'kk': 'Қызмет көрсету'},
    {'ru': 'Мероприятия', 'kk': 'Іс-шаралар'},
    {'ru': 'Медиа и контент', 'kk': 'Медиа және контент'},
    {'ru': 'Авто бизнес', 'kk': 'Авто бизнес'},
    {'ru': 'Экология', 'kk': 'Экология'},
    {'ru': 'Животные', 'kk': 'Үй жануарлары'},
    {'ru': 'Другое', 'kk': 'Басқа'},
  ];

  @override
  void initState() {
    super.initState();
    ideasFuture = HiveService().getIdeas();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void refreshIdeas() {
    setState(() {
      ideasFuture = HiveService().getIdeas();
    });
  }

  void resetForm() {
    titleController.clear();
    descriptionController.clear();
    selectedCategoryIndex = 0;
  }

  void showAddIdeaDialog(String lang) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
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
                  const SizedBox(height: 12),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: lang == 'kk' ? 'Сипаттама' : 'Описание',
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButton<int>(
                    value: selectedCategoryIndex,
                    isExpanded: true,
                    items: List.generate(categories.length, (index) {
                      final category = categories[index];

                      return DropdownMenuItem<int>(
                        value: index,
                        child: Text(category[lang] ?? ''),
                      );
                    }),
                    onChanged: (value) {
                      if (value == null) return;

                      setDialogState(() {
                        selectedCategoryIndex = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    resetForm();
                    Navigator.pop(dialogContext);
                  },
                  child: Text(lang == 'kk' ? 'Бас тарту' : 'Отмена'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (titleController.text.trim().isEmpty ||
                        descriptionController.text.trim().isEmpty) {
                      return;
                    }

                    final selectedCategory = categories[selectedCategoryIndex];

                    final idea = {
                      'id': DateTime.now().toString(),
                      'title': titleController.text.trim(),
                      'categoryRu': selectedCategory['ru'],
                      'categoryKk': selectedCategory['kk'],
                      'description': descriptionController.text.trim(),
                    };

                    await HiveService().saveIdea(idea);

                    resetForm();

                    if (dialogContext.mounted) {
                      Navigator.pop(dialogContext);
                    }

                    refreshIdeas();
                  },
                  child: Text(lang == 'kk' ? 'Сақтау' : 'Сохранить'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void showEditIdeaDialog({
    required String lang,
    required Map idea,
    required int index,
  }) {
    titleController.text = idea['title'] ?? '';
    descriptionController.text = idea['description'] ?? '';

    final currentCategoryIndex = categories.indexWhere((category) {
      return category['ru'] == idea['categoryRu'] &&
          category['kk'] == idea['categoryKk'];
    });

    selectedCategoryIndex = currentCategoryIndex == -1 ? 0 : currentCategoryIndex;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                lang == 'kk' ? 'Идеяны өзгерту' : 'Редактировать идею',
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: lang == 'kk' ? 'Идея атауы' : 'Название идеи',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: lang == 'kk' ? 'Сипаттама' : 'Описание',
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButton<int>(
                    value: selectedCategoryIndex,
                    isExpanded: true,
                    items: List.generate(categories.length, (i) {
                      final category = categories[i];

                      return DropdownMenuItem<int>(
                        value: i,
                        child: Text(category[lang] ?? ''),
                      );
                    }),
                    onChanged: (value) {
                      if (value == null) return;

                      setDialogState(() {
                        selectedCategoryIndex = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    resetForm();
                    Navigator.pop(dialogContext);
                  },
                  child: Text(lang == 'kk' ? 'Бас тарту' : 'Отмена'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (titleController.text.trim().isEmpty ||
                        descriptionController.text.trim().isEmpty) {
                      return;
                    }

                    final selectedCategory = categories[selectedCategoryIndex];

                    final updatedIdea = {
                      'id': idea['id'],
                      'title': titleController.text.trim(),
                      'categoryRu': selectedCategory['ru'],
                      'categoryKk': selectedCategory['kk'],
                      'description': descriptionController.text.trim(),
                    };

                    await HiveService().updateIdea(index, updatedIdea);

                    resetForm();

                    if (dialogContext.mounted) {
                      Navigator.pop(dialogContext);
                    }

                    refreshIdeas();
                  },
                  child: Text(lang == 'kk' ? 'Сақтау' : 'Сохранить'),
                ),
              ],
            );
          },
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
            DropdownButton<int?>(
              value: filterCategoryIndex,
              isExpanded: true,
              hint: Text(
                lang == 'kk'
                    ? 'Категория бойынша сүзу'
                    : 'Фильтр по категории',
              ),
              items: [
                DropdownMenuItem<int?>(
                  value: null,
                  child: Text(lang == 'kk' ? 'Барлығы' : 'Все'),
                ),
                ...List.generate(categories.length, (index) {
                  final category = categories[index];

                  return DropdownMenuItem<int?>(
                    value: index,
                    child: Text(category[lang] ?? ''),
                  );
                }),
              ],
              onChanged: (value) {
                setState(() {
                  filterCategoryIndex = value;
                });
              },
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

                  final allIdeas = snapshot.data!;

                  final ideas = filterCategoryIndex == null
                      ? allIdeas
                      : allIdeas.where((idea) {
                          final selected = categories[filterCategoryIndex!];

                          return idea['categoryRu'] == selected['ru'] &&
                              idea['categoryKk'] == selected['kk'];
                        }).toList();

                  if (ideas.isEmpty) {
                    return Center(
                      child: Text(
                        lang == 'kk'
                            ? 'Бұл категорияда идея жоқ'
                            : 'В этой категории нет идей',
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: ideas.length,
                    itemBuilder: (context, index) {
                      final idea = ideas[index];

                      final category = lang == 'kk'
                          ? idea['categoryKk']
                          : idea['categoryRu'];

                      return Card(
                        child: ListTile(
                          contentPadding: const EdgeInsets.only(
                            left: 16,
                            right: 4,
                            top: 8,
                            bottom: 8,
                          ),
                          title: Text(idea['title'] ?? ''),
                          subtitle: Text(
                            '${category ?? ''}\n${idea['description'] ?? ''}',
                          ),
                          onTap: () {
                            showEditIdeaDialog(
                              lang: lang,
                              idea: idea,
                              index: index,
                            );
                          },
                          trailing: SizedBox(
                            width: 32,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              iconSize: 20,
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () async {
                                await HiveService().deleteIdea(index);
                                refreshIdeas();
                              },
                            ),
                          ),
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