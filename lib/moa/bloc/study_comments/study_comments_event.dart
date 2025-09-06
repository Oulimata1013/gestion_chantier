import 'package:equatable/equatable.dart';

/// Événements pour la gestion des commentaires d'études
abstract class StudyCommentsEvent extends Equatable {
  const StudyCommentsEvent();

  @override
  List<Object?> get props => [];
}

/// Charger les commentaires d'une étude
class LoadStudyComments extends StudyCommentsEvent {
  final int studyRequestId;

  const LoadStudyComments({required this.studyRequestId});

  @override
  List<Object> get props => [studyRequestId];
}

/// Ajouter un nouveau commentaire
class AddStudyComment extends StudyCommentsEvent {
  final int studyRequestId;
  final int userId;
  final String content;

  const AddStudyComment({
    required this.studyRequestId,
    required this.userId,
    required this.content,
  });

  @override
  List<Object> get props => [studyRequestId, userId, content];
}

/// Rafraîchir les commentaires
class RefreshStudyComments extends StudyCommentsEvent {
  final int studyRequestId;

  const RefreshStudyComments({required this.studyRequestId});

  @override
  List<Object> get props => [studyRequestId];
}
