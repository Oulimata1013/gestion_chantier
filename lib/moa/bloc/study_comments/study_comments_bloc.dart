import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_chantier/moa/bloc/study_comments/study_comments_event.dart';
import 'package:gestion_chantier/moa/bloc/study_comments/study_comments_state.dart';
import 'package:gestion_chantier/moa/repository/study_comment_repository.dart';
import 'package:gestion_chantier/moa/models/study_comment.dart';

/// BLoC pour la gestion des commentaires d'études
class StudyCommentsBloc extends Bloc<StudyCommentsEvent, StudyCommentsState> {
  final StudyCommentRepository _repository;

  StudyCommentsBloc({required StudyCommentRepository repository})
    : _repository = repository,
      super(StudyCommentsInitial()) {
    // Charger les commentaires
    on<LoadStudyComments>(_onLoadStudyComments);

    // Ajouter un commentaire
    on<AddStudyComment>(_onAddStudyComment);

    // Rafraîchir les commentaires
    on<RefreshStudyComments>(_onRefreshStudyComments);
  }

  /// Charger les commentaires d'une étude
  Future<void> _onLoadStudyComments(
    LoadStudyComments event,
    Emitter<StudyCommentsState> emit,
  ) async {
    try {
      emit(StudyCommentsLoading());

      final comments = await _repository.getComments(event.studyRequestId);

      emit(StudyCommentsLoaded(comments: comments));
    } catch (e) {
      emit(StudyCommentsError(message: e.toString()));
    }
  }

  /// Ajouter un nouveau commentaire
  Future<void> _onAddStudyComment(
    AddStudyComment event,
    Emitter<StudyCommentsState> emit,
  ) async {
    try {
      // Si on a déjà des commentaires, on passe en mode ajout
      if (state is StudyCommentsLoaded) {
        final currentComments = (state as StudyCommentsLoaded).comments;
        emit(StudyCommentAdding(comments: currentComments));
      } else {
        emit(StudyCommentAdding(comments: []));
      }

      // Ajouter le commentaire
      final newComment = await _repository.addComment(
        studyRequestId: event.studyRequestId,
        userId: event.userId,
        content: event.content,
      );

      // Récupérer la liste mise à jour des commentaires
      final updatedComments = await _repository.getComments(
        event.studyRequestId,
      );

      emit(
        StudyCommentAdded(comments: updatedComments, newComment: newComment),
      );
    } catch (e) {
      // En cas d'erreur, on garde les commentaires existants
      List<StudyComment> existingComments = [];
      if (state is StudyCommentsLoaded) {
        existingComments = (state as StudyCommentsLoaded).comments;
      } else if (state is StudyCommentAdding) {
        existingComments = (state as StudyCommentAdding).comments;
      }

      emit(
        StudyCommentAddError(message: e.toString(), comments: existingComments),
      );
    }
  }

  /// Rafraîchir les commentaires
  Future<void> _onRefreshStudyComments(
    RefreshStudyComments event,
    Emitter<StudyCommentsState> emit,
  ) async {
    // Recharger les commentaires
    add(LoadStudyComments(studyRequestId: event.studyRequestId));
  }
}
