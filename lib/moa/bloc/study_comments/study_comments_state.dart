import 'package:equatable/equatable.dart';
import 'package:gestion_chantier/moa/models/study_comment.dart';

/// États pour la gestion des commentaires d'études
abstract class StudyCommentsState extends Equatable {
  const StudyCommentsState();

  @override
  List<Object?> get props => [];
}

/// État initial
class StudyCommentsInitial extends StudyCommentsState {}

/// Chargement des commentaires
class StudyCommentsLoading extends StudyCommentsState {}

/// Commentaires chargés avec succès
class StudyCommentsLoaded extends StudyCommentsState {
  final List<StudyComment> comments;

  const StudyCommentsLoaded({required this.comments});

  @override
  List<Object> get props => [comments];
}

/// Erreur lors du chargement des commentaires
class StudyCommentsError extends StudyCommentsState {
  final String message;

  const StudyCommentsError({required this.message});

  @override
  List<Object> get props => [message];
}

/// Ajout de commentaire en cours
class StudyCommentAdding extends StudyCommentsState {
  final List<StudyComment> comments;

  const StudyCommentAdding({required this.comments});

  @override
  List<Object> get props => [comments];
}

/// Commentaire ajouté avec succès
class StudyCommentAdded extends StudyCommentsState {
  final List<StudyComment> comments;
  final StudyComment newComment;

  const StudyCommentAdded({required this.comments, required this.newComment});

  @override
  List<Object> get props => [comments, newComment];
}

/// Erreur lors de l'ajout du commentaire
class StudyCommentAddError extends StudyCommentsState {
  final String message;
  final List<StudyComment> comments;

  const StudyCommentAddError({required this.message, required this.comments});

  @override
  List<Object> get props => [message, comments];
}
