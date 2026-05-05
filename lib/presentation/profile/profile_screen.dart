import 'package:flutter/material.dart';

import '../../data/datasources/hive_service.dart';

class ProfileScreen extends StatefulWidget {
  final String lang;

  const ProfileScreen({
    super.key,
    required this.lang,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameController = TextEditingController();
  final cityController = TextEditingController();
  final skillsController = TextEditingController();
  final interestController = TextEditingController();
  final aboutController = TextEditingController();
  final contactController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final profile = await HiveService().getProfile();

    if (profile != null) {
      nameController.text = profile['name'] ?? '';
      cityController.text = profile['city'] ?? '';
      skillsController.text = profile['skills'] ?? '';
      interestController.text = profile['interest'] ?? '';
      aboutController.text = profile['about'] ?? '';
      contactController.text = profile['contact'] ?? '';
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    cityController.dispose();
    skillsController.dispose();
    interestController.dispose();
    aboutController.dispose();
    contactController.dispose();
    super.dispose();
  }

  Future<void> saveProfile() async {
    final profile = {
      'name': nameController.text.trim(),
      'city': cityController.text.trim(),
      'skills': skillsController.text.trim(),
      'interest': interestController.text.trim(),
      'about': aboutController.text.trim(),
      'contact': contactController.text.trim(),
    };

    await HiveService().saveProfile(profile);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.lang == 'kk'
              ? 'Профиль сақталды'
              : 'Профиль сохранён',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isKk = widget.lang == 'kk';

    return Scaffold(
      appBar: AppBar(
        title: Text(isKk ? 'Менің профилім' : 'Мой профиль'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: isKk ? 'Атыңыз' : 'Ваше имя',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: cityController,
              decoration: InputDecoration(
                labelText: isKk ? 'Қала' : 'Город',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: skillsController,
              decoration: InputDecoration(
                labelText: isKk ? 'Дағдылар' : 'Навыки',
                hintText: isKk ? 'маркетинг, SMM' : 'маркетинг, SMM',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: interestController,
              decoration: InputDecoration(
                labelText: isKk ? 'Қызығушылық' : 'Интерес',
                hintText: isKk ? 'кофейня, beauty-бизнес' : 'кофейня, beauty-бизнес',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: aboutController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: isKk ? 'Өзіңіз туралы' : 'О себе',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: contactController,
              decoration: InputDecoration(
                labelText: isKk ? 'Байланыс' : 'Контакт',
                hintText: 'Telegram / email',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: saveProfile,
              child: Text(isKk ? 'Сақтау' : 'Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}