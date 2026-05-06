import '../repositories/idea_repository.dart';

class DeleteIdeaUseCase {
  final IdeaRepository repository;

  DeleteIdeaUseCase(this.repository);

  Future<void> call(String id) {
    return repository.deleteIdea(id);
  }
}