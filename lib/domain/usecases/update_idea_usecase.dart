import '../entities/idea.dart';
import '../repositories/idea_repository.dart';

class UpdateIdeaUseCase {
  final IdeaRepository repository;

  UpdateIdeaUseCase(this.repository);

  Future<void> call(Idea idea) {
    return repository.updateIdea(idea);
  }
}