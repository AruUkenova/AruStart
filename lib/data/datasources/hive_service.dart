import 'package:hive/hive.dart';

class HiveService {
  static const String boxName = 'ideasBox';

  Future<Box> openBox() async {
    return await Hive.openBox(boxName);
  }

  Future<void> saveIdea(Map<String, dynamic> idea) async {
    final box = await openBox();
    await box.add(idea);
  }

  Future<List<Map>> getIdeas() async {
    final box = await openBox();
    return box.values.cast<Map>().toList();
  }
}