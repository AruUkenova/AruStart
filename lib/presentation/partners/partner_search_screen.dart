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

  final partners = [
    {
      'name': 'Amina',
      'city': 'Алматы',
      'skills': 'маркетинг, SMM',
      'interest': 'кофейня, beauty-бизнес',
      'about': 'Бизнес бастағысы келетін SMM маманы.',
      'contact': '@amina_start',
    },
    {
      'name': 'Dias',
      'city': 'Астана',
      'skills': 'Flutter, UI/UX',
      'interest': 'IT startup',
      'about': 'Мобильді қосымша жасаумен айналысады.',
      'contact': '@dias_dev',
    },
    {
      'name': 'Aruzhan',
      'city': 'Шымкент',
      'skills': 'сату, клиентпен жұмыс',
      'interest': 'онлайн дүкен',
      'about': 'Онлайн сауда бағытын дамытқысы келеді.',
      'contact': '@aruzhan_biz',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isKk = widget.lang == 'kk';

    final filteredPartners = partners.where((partner) {
      final city = partner['city']!.toLowerCase();
      final skills = partner['skills']!.toLowerCase();

      final matchesCity = cityFilter.isEmpty ||
          city.contains(cityFilter.toLowerCase());

      final matchesSkill = skillFilter.isEmpty ||
          skills.contains(skillFilter.toLowerCase());

      return matchesCity && matchesSkill;
    }).toList();

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
                  cityFilter = value;
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
                  skillFilter = value;
                });
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: filteredPartners.isEmpty
                  ? Center(
                      child: Text(
                        isKk ? 'Серіктес табылмады' : 'Партнёры не найдены',
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredPartners.length,
                      itemBuilder: (context, index) {
                        final partner = filteredPartners[index];

                        return Card(
                          child: ListTile(
                            title: Text(partner['name']!),
                            subtitle: Text(
                              '${isKk ? 'Қала' : 'Город'}: ${partner['city']}\n'
                              '${isKk ? 'Дағдылар' : 'Навыки'}: ${partner['skills']}\n'
                              '${isKk ? 'Қызығушылық' : 'Интерес'}: ${partner['interest']}',
                            ),
                            trailing: TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(partner['name']!),
                                      content: Text(
                                        '${partner['about']}\n\n'
                                        '${isKk ? 'Байланыс' : 'Контакт'}: ${partner['contact']}',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(isKk ? 'Жабу' : 'Закрыть'),
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
                    ),
            ),
          ],
        ),
      ),
    );
  }
}