import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadProfile();
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

  Future<void> loadProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('profiles')
        .doc(user.uid)
        .get();

    if (!doc.exists) return;

    final data = doc.data();
    if (data == null) return;

    nameController.text = data['name'] ?? '';
    cityController.text = data['city'] ?? '';
    skillsController.text = data['skills'] ?? '';
    interestController.text = data['interest'] ?? '';
    aboutController.text = data['about'] ?? '';
    contactController.text = data['contact'] ?? '';
  }

  Future<void> saveProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('profiles')
          .doc(user.uid)
          .set({
        'uid': user.uid,
        'email': user.email,
        'name': nameController.text.trim(),
        'city': cityController.text.trim(),
        'skills': skillsController.text.trim(),
        'interest': interestController.text.trim(),
        'about': aboutController.text.trim(),
        'contact': contactController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

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
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.lang == 'kk'
                ? 'Қате пайда болды'
                : 'Произошла ошибка',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
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
                hintText: 'маркетинг, SMM, Flutter',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: interestController,
              decoration: InputDecoration(
                labelText: isKk ? 'Қызығушылық' : 'Интерес',
                hintText: isKk
                    ? 'кофейня, beauty-бизнес'
                    : 'кофейня, beauty-бизнес',
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
              decoration: const InputDecoration(
                labelText: 'Telegram / Email',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isLoading ? null : saveProfile,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : Text(isKk ? 'Сақтау' : 'Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}