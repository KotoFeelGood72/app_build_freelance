import 'package:app_build_freelance/config/dio_config.dart';
import 'package:app_build_freelance/config/token_storage.dart';

class AuthRepository {
  // Запрос для отправки номера телефона
  Future<void> sendPhoneNumber(String phoneNumber, String role) async {
    try {
      final response = await DioConfig().dio.post(
        '/auth',
        data: {'phoneNumber': phoneNumber, 'role': role},
      );
      print('Phone number sent: ${response.statusCode}');
    } catch (e) {
      print('Error sending phone number: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateRole(String role) async {
    try {
      final response = await DioConfig().dio.post(
        '/update_role',
        data: {'role': role},
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Ошибка смены роли: ${e.toString()}');
    }
  }

  // Запрос для проверки кода и получения access и refresh токенов
  Future<Map<String, String>> verifyCode(String verificationCode) async {
    try {
      final response = await DioConfig().dio.post(
        '/verify',
        data: {
          'verificationCode': verificationCode,
        },
      );
      final accessToken = response.data['access_token'];
      final refreshToken = response.data['refresh_token'];

      // Сохраняем токены в TokenStorage
      await TokenStorage.saveToken(accessToken);
      await TokenStorage.saveRefreshToken(refreshToken);

      return {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
      };
    } catch (e) {
      // print('Error verifying code: $e');
      rethrow;
    }
  }

  // Запрос для обновления access токена с использованием refresh токена
  Future<Map<String, String>> refreshAccessToken(
      String refreshTokenBody) async {
    try {
      final response = await DioConfig().dio.post(
        '/refresh_token',
        data: {
          'refresh_token': refreshTokenBody,
        },
      );

      final accessToken = response.data['access_token'] as String;
      final refreshToken = response.data['refresh_token'] as String;

      // Сохраняем новые токены в TokenStorage
      await TokenStorage.saveToken(accessToken);
      await TokenStorage.saveRefreshToken(refreshToken);

      return {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
      };
    } catch (e) {
      // print('Error refreshing token: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await TokenStorage.deleteTokens();
    } catch (e) {}
  }
}
