import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/idea_repository_impl.dart';
import '../../domain/repositories/idea_repository.dart';

import '../../domain/usecases/add_idea_usecase.dart';
import '../../domain/usecases/update_idea_usecase.dart';
import '../../domain/usecases/delete_idea_usecase.dart';

final ideaRepositoryProvider = Provider<IdeaRepository>((ref) {
  return IdeaRepositoryImpl(
    firestore: FirebaseFirestore.instance,
  );
});

final addIdeaUseCaseProvider = Provider<AddIdeaUseCase>((ref) {
  return AddIdeaUseCase(
    ref.read(ideaRepositoryProvider),
  );
});

final updateIdeaUseCaseProvider = Provider<UpdateIdeaUseCase>((ref) {
  return UpdateIdeaUseCase(
    ref.read(ideaRepositoryProvider),
  );
});

final deleteIdeaUseCaseProvider = Provider<DeleteIdeaUseCase>((ref) {
  return DeleteIdeaUseCase(
    ref.read(ideaRepositoryProvider),
  );
});