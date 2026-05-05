import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StatisticsScreen extends StatelessWidget {
  final String lang;

  const StatisticsScreen({
    super.key,
    required this.lang,
  });

  @override
  Widget build(BuildContext context) {
    final isKk = lang == 'kk';
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(isKk ? 'Статистика' : 'Статистика'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('ideas')
            .where('userId', isEqualTo: user?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return Center(
              child: Text(
                isKk
                    ? 'Әзірге статистика үшін идея жоқ'
                    : 'Пока нет идей для статистики',
              ),
            );
          }

          final Map<String, int> categoryCounts = {};

          for (final doc in docs) {
            final data = doc.data() as Map<String, dynamic>;
            final category = isKk
                ? data['categoryKk'] ?? 'Басқа'
                : data['categoryRu'] ?? 'Другое';

            categoryCounts[category] = (categoryCounts[category] ?? 0) + 1;
          }

          final categories = categoryCounts.keys.toList();
          final values = categoryCounts.values.toList();
          final totalIdeas = docs.length;
          final maxValue = values.reduce((a, b) => a > b ? a : b).toDouble();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7FAF8B),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isKk ? 'Жалпы идеялар' : 'Всего идей',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$totalIdeas',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        isKk
                            ? 'сіздің бизнес идеяларыңыз'
                            : 'ваших бизнес-идей',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            isKk
                                ? 'Категориялар бойынша'
                                : 'По категориям',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 260,
                          child: BarChart(
                            BarChartData(
                              maxY: maxValue + 1,
                              borderData: FlBorderData(show: false),
                              gridData: const FlGridData(show: true),
                              titlesData: FlTitlesData(
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                leftTitles: const AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 28,
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 50,
                                    getTitlesWidget: (value, meta) {
                                      final index = value.toInt();

                                      if (index < 0 ||
                                          index >= categories.length) {
                                        return const SizedBox.shrink();
                                      }

                                      final label = categories[index];

                                      return Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          label.length > 8
                                              ? '${label.substring(0, 8)}...'
                                              : label,
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              barGroups: List.generate(categories.length, (i) {
                                return BarChartGroupData(
                                  x: i,
                                  barRods: [
                                    BarChartRodData(
                                      toY: values[i].toDouble(),
                                      width: 18,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ...categoryCounts.entries.map((entry) {
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.category_outlined),
                      title: Text(entry.key),
                      trailing: Text(
                        '${entry.value}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}