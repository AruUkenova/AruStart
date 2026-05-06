import '../entities/idea.dart';
import '../repositories/idea_repository.dart';

class AddIdeaUseCase {
  final IdeaRepository repository;

  AddIdeaUseCase(this.repository);

  Future<void> call(Idea idea) {
    return repository.addIdea(idea);
  }
}