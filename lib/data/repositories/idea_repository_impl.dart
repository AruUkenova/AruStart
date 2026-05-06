import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/idea.dart';
import '../../domain/repositories/idea_repository.dart';

class IdeaRepositoryImpl implements IdeaRepository {
  final FirebaseFirestore firestore;

  IdeaRepositoryImpl({
    required this.firestore,
  });

  @override
  Future<void> addIdea(Idea idea) async {
    await firestore.collection('ideas').add({
      'userId': idea.userId,
      'title': idea.title,
      'description': idea.description,
      'categoryRu': idea.categoryRu,
      'categoryKk': idea.categoryKk,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> updateIdea(Idea idea) async {
    await firestore.collection('ideas').doc(idea.id).update({
      'title': idea.title,
      'description': idea.description,
      'categoryRu': idea.categoryRu,
      'categoryKk': idea.categoryKk,
    });
  }

  @override
  Future<void> deleteIdea(String id) async {
    await firestore.collection('ideas').doc(id).delete();
  }
}