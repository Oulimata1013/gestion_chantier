import 'package:shared_preferences/shared_preferences.dart';

/// Service pour gérer les informations de l'utilisateur actuel
class UserService {
  static const String _userIdKey = 'user_id';
  static const String _userNameKey = 'user_name';

  /// Récupérer l'ID de l'utilisateur connecté
  static Future<int?> getCurrentUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_userIdKey);
    } catch (e) {
      print('Erreur lors de la récupération de l\'ID utilisateur: $e');
      return null;
    }
  }

  /// Récupérer le nom de l'utilisateur connecté
  static Future<String?> getCurrentUserName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userNameKey);
    } catch (e) {
      print('Erreur lors de la récupération du nom utilisateur: $e');
      return null;
    }
  }

  /// Sauvegarder l'ID de l'utilisateur
  static Future<bool> saveUserId(int userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setInt(_userIdKey, userId);
    } catch (e) {
      print('Erreur lors de la sauvegarde de l\'ID utilisateur: $e');
      return false;
    }
  }

  /// Sauvegarder le nom de l'utilisateur
  static Future<bool> saveUserName(String userName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_userNameKey, userName);
    } catch (e) {
      print('Erreur lors de la sauvegarde du nom utilisateur: $e');
      return false;
    }
  }

  /// Vérifier si un utilisateur est connecté
  static Future<bool> isUserLoggedIn() async {
    final userId = await getCurrentUserId();
    return userId != null;
  }

  /// Déconnecter l'utilisateur (supprimer les données)
  static Future<bool> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userIdKey);
      await prefs.remove(_userNameKey);
      return true;
    } catch (e) {
      print('Erreur lors de la déconnexion: $e');
      return false;
    }
  }
}
