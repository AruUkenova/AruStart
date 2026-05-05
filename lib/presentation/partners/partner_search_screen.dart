import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PartnerSearchScreen extends StatefulWidget {
  final String lang;

  const PartnerSearchScreen({
    super.key,
    required this.lang,
  });

  @override
  State<PartnerSearchScreen> createState() => _PartnerSearchScreenState();
}

class _PartnerSearchScreenState extends State<PartnerSearchScreen> {
  String cityFilter = '';
  String skillFilter = '';

  @override
  Widget build(BuildContext context) {
    final isKk = widget.lang == 'kk';
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(isKk ? 'Серіктес іздеу' : 'Поиск партнёров'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: isKk ? 'Қала бойынша іздеу' : 'Поиск по городу',
              ),
              onChanged: (value) {
                setState(() {
                  cityFilter = value.trim().toLowerCase();
                });
              },
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: isKk ? 'Дағды бойынша іздеу' : 'Поиск по навыкам',
              ),
              onChanged: (value) {
                setState(() {
                  skillFilter = value.trim().toLowerCase();
                });
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('profiles')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        isKk ? 'Профильдер жоқ' : 'Профилей пока нет',
                      ),
                    );
                  }

                  final profiles = snapshot.data!.docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;

                    if (currentUser != null && data['uid'] == currentUser.uid) {
                      return false;
                    }

                    final city = (data['city'] ?? '').toString().toLowerCase();
                    final skills =
                        (data['skills'] ?? '').toString().toLowerCase();

                    final matchesCity =
                        cityFilter.isEmpty || city.contains(cityFilter);

                    final matchesSkill =
                        skillFilter.isEmpty || skills.contains(skillFilter);

                    return matchesCity && matchesSkill;
                  }).toList();

                  if (profiles.isEmpty) {
                    return Center(
                      child: Text(
                        isKk
                            ? 'Серіктес табылмады'
                            : 'Партнёры не найдены',
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: profiles.length,
                    itemBuilder: (context, index) {
                      final data =
                          profiles[index].data() as Map<String, dynamic>;

                      final name = data['name'] ?? '';
                      final city = data['city'] ?? '';
                      final skills = data['skills'] ?? '';
                      final interest = data['interest'] ?? '';
                      final about = data['about'] ?? '';
                      final contact = data['contact'] ?? '';
                      final email = data['email'] ?? '';

                      return Card(
                        child: ListTile(
                          title: Text(name),
                          subtitle: Text(
                            '${isKk ? 'Қала' : 'Город'}: $city\n'
                            '${isKk ? 'Дағдылар' : 'Навыки'}: $skills\n'
                            '${isKk ? 'Қызығушылық' : 'Интерес'}: $interest',
                          ),
                          trailing: TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (dialogContext) {
                                  return AlertDialog(
                                    title: Text(name),
                                    content: Text(
                                      '${isKk ? 'Өзі туралы' : 'О себе'}: $about\n\n'
                                      '${isKk ? 'Байланыс' : 'Контакт'}: $contact\n'
                                      'Email: $email',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(dialogContext);
                                        },
                                        child: Text(
                                          isKk ? 'Жабу' : 'Закрыть',
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text(
                              isKk ? 'Профиль' : 'Профиль',
                              style: const TextStyle(fontSize: 12),
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