import 'package:hive/hive.dart';

class HiveService {
  static const String ideasBoxName = 'ideasBox';
  static const String profileBoxName = 'profileBox';

  Future<Box> openIdeasBox() async {
    return await Hive.openBox(ideasBoxName);
  }

  Future<Box> openProfileBox() async {
    return await Hive.openBox(profileBoxName);
  }

  Future<void> saveIdea(Map<String, dynamic> idea) async {
    final box = await openIdeasBox();
    await box.add(idea);
  }

  Future<List<Map>> getIdeas() async {
    final box = await openIdeasBox();
    return box.values.cast<Map>().toList();
  }

  Future<void> deleteIdea(int index) async {
    final box = await openIdeasBox();
    await box.deleteAt(index);
  }

  Future<void> updateIdea(int index, Map<String, dynamic> idea) async {
    final box = await openIdeasBox();
    await box.putAt(index, idea);
  }

  Future<void> saveProfile(Map<String, dynamic> profile) async {
    final box = await openProfileBox();
    await box.put('userProfile', profile);
  }

  Future<Map?> getProfile() async {
    final box = await openProfileBox();
    final profile = box.get('userProfile');
    if (profile == null) return null;
    return Map.from(profile);
  }
}
