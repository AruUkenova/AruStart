import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/app_strings.dart';
import '../../core/localization/language_provider.dart';
import '../auth/login_screen.dart';
import '../partners/partner_search_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
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
    {'ru': 'Другое', 'kk': 'Басқа'},
  ];

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void resetForm() {
    titleController.clear();
    descriptionController.clear();
    selectedCategoryIndex = 0;
  }

  Future<void> addIdea() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final selectedCategory = categories[selectedCategoryIndex];

    await FirebaseFirestore.instance.collection('ideas').add({
      'userId': user.uid,
      'title': titleController.text.trim(),
      'description': descriptionController.text.trim(),
      'categoryRu': selectedCategory['ru'],
      'categoryKk': selectedCategory['kk'],
      'createdAt': FieldValue.serverTimestamp(),
    });

    resetForm();
  }

  Future<void> updateIdea(String docId) async {
    final selectedCategory = categories[selectedCategoryIndex];

    await FirebaseFirestore.instance.collection('ideas').doc(docId).update({
      'title': titleController.text.trim(),
      'description': descriptionController.text.trim(),
      'categoryRu': selectedCategory['ru'],
      'categoryKk': selectedCategory['kk'],
    });

    resetForm();
  }

  Future<void> deleteIdea(String docId) async {
    await FirebaseFirestore.instance.collection('ideas').doc(docId).delete();
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

                    await addIdea();

                    if (dialogContext.mounted) {
                      Navigator.pop(dialogContext);
                    }
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
    required String docId,
    required Map<String, dynamic> idea,
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

                    await updateIdea(docId);

                    if (dialogContext.mounted) {
                      Navigator.pop(dialogContext);
                    }
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
    final user = FirebaseAuth.instance.currentUser;

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
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();

              if (!context.mounted) return;

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => LoginScreen(lang: lang),
                ),
              );
            },
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
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProfileScreen(lang: lang),
                        ),
                      );
                    },
                    child: const Text('Профиль'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PartnerSearchScreen(lang: lang),
                        ),
                      );
                    },
                    child: Text(lang == 'kk' ? 'Серіктестер' : 'Партнёры'),
                  ),
                ),
              ],
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
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('ideas')
                    .where('userId', isEqualTo: user?.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        lang == 'kk' ? 'Әзірге идея жоқ' : 'Пока нет идей',
                      ),
                    );
                  }

                  final allDocs = snapshot.data!.docs;

                  final docs = filterCategoryIndex == null
                      ? allDocs
                      : allDocs.where((doc) {
                          final idea = doc.data() as Map<String, dynamic>;
                          final selected = categories[filterCategoryIndex!];

                          return idea['categoryRu'] == selected['ru'] &&
                              idea['categoryKk'] == selected['kk'];
                        }).toList();

                  if (docs.isEmpty) {
                    return Center(
                      child: Text(
                        lang == 'kk'
                            ? 'Бұл категорияда идея жоқ'
                            : 'В этой категории нет идей',
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      final idea = doc.data() as Map<String, dynamic>;

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
                              docId: doc.id,
                              idea: idea,
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
                                await deleteIdea(doc.id);
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