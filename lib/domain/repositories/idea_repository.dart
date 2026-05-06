import '../entities/idea.dart';

abstract class IdeaRepository {
  Future<void> addIdea(Idea idea);
  Future<void> updateIdea(Idea idea);
  Future<void> deleteIdea(String id);
}