import 'package:dio/dio.dart';
import 'package:gestion_chantier/moa/services/api_service.dart';
import 'package:gestion_chantier/moa/models/study_comment.dart';

class StudyCommentService {
  final ApiService _apiService = ApiService();

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
      final response = await _apiService.dio.post(
        '/api/study-requests/comment/study/$studyRequestId/users/$userId',
        data: {'content': content},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return StudyComment.fromJson(response.data);
      } else {
        throw Exception(
          'Erreur lors de l\'envoi du commentaire: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final statusCode = e.response!.statusCode;
        final responseData = e.response!.data;

        String errorMessage = 'Erreur lors de l\'envoi du commentaire';
        if (responseData is Map<String, dynamic>) {
          errorMessage =
              responseData['message'] ?? responseData['error'] ?? errorMessage;
        }

        switch (statusCode) {
          case 400:
            throw Exception('Données invalides: $errorMessage');
          case 401:
            throw Exception('Non autorisé. Veuillez vous reconnecter.');
          case 403:
            throw Exception('Accès refusé pour cette étude.');
          case 404:
            throw Exception('Étude non trouvée.');
          case 500:
            throw Exception('Erreur serveur temporaire');
          default:
            throw Exception('$errorMessage (Code: $statusCode)');
        }
      } else {
        // Erreurs de connexion
        switch (e.type) {
          case DioExceptionType.connectionTimeout:
            throw Exception(
              'Timeout de connexion. Vérifiez votre connexion internet.',
            );
          case DioExceptionType.receiveTimeout:
            throw Exception(
              'Timeout de réception. Vérifiez votre connexion internet.',
            );
          case DioExceptionType.sendTimeout:
            throw Exception(
              'Timeout d\'envoi. Vérifiez votre connexion internet.',
            );
          case DioExceptionType.connectionError:
            throw Exception(
              'Erreur de connexion. Vérifiez votre connexion internet.',
            );
          default:
            throw Exception('Erreur de connexion: ${e.message}');
        }
      }
    } catch (e) {
      throw Exception('Erreur inattendue: $e');
    }
  }

  /// Récupérer les commentaires d'une étude
  ///
  /// [studyRequestId] - ID de la demande d'étude
  Future<List<StudyComment>> getComments(int studyRequestId) async {
    try {
      final response = await _apiService.dio.get(
        '/api/study-requests/$studyRequestId/comments',
      );

      if (response.statusCode == 200) {
        final List<dynamic> commentsData = response.data;
        return commentsData.map((json) => StudyComment.fromJson(json)).toList();
      } else {
        throw Exception(
          'Erreur lors de la récupération des commentaires: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final statusCode = e.response!.statusCode;
        final responseData = e.response!.data;

        String errorMessage = 'Erreur lors de la récupération des commentaires';
        if (responseData is Map<String, dynamic>) {
          errorMessage =
              responseData['message'] ?? responseData['error'] ?? errorMessage;
        }

        switch (statusCode) {
          case 401:
            throw Exception('Non autorisé. Veuillez vous reconnecter.');
          case 403:
            throw Exception('Accès refusé pour cette étude.');
          case 404:
            throw Exception('Étude non trouvée.');
          case 500:
            throw Exception('Erreur serveur temporaire');
          default:
            throw Exception('$errorMessage (Code: $statusCode)');
        }
      } else {
        // Erreurs de connexion
        switch (e.type) {
          case DioExceptionType.connectionTimeout:
            throw Exception(
              'Timeout de connexion. Vérifiez votre connexion internet.',
            );
          case DioExceptionType.receiveTimeout:
            throw Exception(
              'Timeout de réception. Vérifiez votre connexion internet.',
            );
          case DioExceptionType.connectionError:
            throw Exception(
              'Erreur de connexion. Vérifiez votre connexion internet.',
            );
          default:
            throw Exception('Erreur de connexion: ${e.message}');
        }
      }
    } catch (e) {
      throw Exception('Erreur inattendue: $e');
    }
  }
}
