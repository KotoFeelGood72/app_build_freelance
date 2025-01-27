import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _storage = FlutterSecureStorage();

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _roleKey = 'Executor';

  // Сохранение access токена
  static Future<void> saveToken(String accessToken) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
  }

  // Сохранение роли пользователя
  static Future<void> saveRole(String role) async {
    await _storage.write(key: _roleKey, value: role);
  }

  // Получение роли пользователя
  static Future<String?> getRole() async {
    return await _storage.read(key: _roleKey);
  }

  // Получение access токена
  static Future<String?> getToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  // Сохранение refresh токена
  static Future<void> saveRefreshToken(String refreshToken) async {
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  // Получение refresh токена
  static Future<String?> getRefreshToken() async {
    final token = await _storage.read(key: _refreshTokenKey);
    if (token == null) {
      // print('[DEBUG] Refresh token отсутствует');
    }
    return token;
  }

  // Удаление токенов при выходе из системы
  static Future<void> deleteTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _roleKey);
  }
}
