import 'dart:io';
import 'package:dio/dio.dart';

/// Script de test pour l'API de commentaires d'études
///
/// Usage: dart test_comment_api.dart
void main() async {
  print('🧪 Test de l\'API de commentaires d\'études');
  print('=' * 50);

  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://wakana.online',
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 60),
      headers: {
        "User-Agent": "curl/7.64.1",
        "Content-Type": "application/json",
        "Accept": "*/*",
      },
    ),
  );

  // Test 1: Ajouter un commentaire
  print('\n📝 Test 1: Ajouter un commentaire');
  try {
    final response = await dio.post(
      '/api/study-requests/comment/study/6/users/36',
      data: {'content': 'Test de commentaire depuis Dart - ${DateTime.now()}'},
    );

    print('✅ Succès!');
    print('Status Code: ${response.statusCode}');
    print('Response: ${response.data}');
  } catch (e) {
    print('❌ Erreur: $e');
    if (e is DioException && e.response != null) {
      print('Status Code: ${e.response!.statusCode}');
      print('Response: ${e.response!.data}');
    }
  }

  // Test 2: Récupérer les commentaires
  print('\n📋 Test 2: Récupérer les commentaires');
  try {
    final response = await dio.get('/api/study-requests/6/comments');

    print('✅ Succès!');
    print('Status Code: ${response.statusCode}');
    print('Nombre de commentaires: ${(response.data as List).length}');
    print('Response: ${response.data}');
  } catch (e) {
    print('❌ Erreur: $e');
    if (e is DioException && e.response != null) {
      print('Status Code: ${e.response!.statusCode}');
      print('Response: ${e.response!.data}');
    }
  }

  print('\n🏁 Tests terminés');
}
