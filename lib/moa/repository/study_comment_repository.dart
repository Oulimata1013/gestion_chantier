import 'package:gestion_chantier/moa/models/study_comment.dart';
import 'package:gestion_chantier/moa/services/StudyCommentService.dart';

class StudyCommentRepository {
  final StudyCommentService _studyCommentService = StudyCommentService();

  /// Envoyer un commentaire sur une étude
  ///
  /// [studyRequestId] - ID de la demande d'étude
  /// [userId] - ID de l'utilisateur connecté
  /// [content] - Contenu du commentaire
  Future<StudyComment> addComment({
    required int studyRequestId,
    required int userId,
    required String content,
  }) async {
    try {
      return await _studyCommentService.addComment(
        studyRequestId: studyRequestId,
        userId: userId,
        content: content,
      );
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout du commentaire: $e');
    }
  }

  /// Récupérer les commentaires d'une étude
  ///
  /// [studyRequestId] - ID de la demande d'étude
  Future<List<StudyComment>> getComments(int studyRequestId) async {
    try {
      return await _studyCommentService.getComments(studyRequestId);
    } catch (e) {
      throw Exception('Erreur lors de la récupération des commentaires: $e');
    }
  }
}
