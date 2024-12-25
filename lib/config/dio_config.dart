import 'package:app_build_freelance/router/app_router.gr.dart';
import 'package:app_build_freelance/src/repositories/auth/auth_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:talker/talker.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:auto_route/auto_route.dart';
import 'token_storage.dart';

final talker = TalkerFlutter.init();

class DioConfig {
  static final DioConfig _instance = DioConfig._internal();
  late Dio dio;

  factory DioConfig() {
    return _instance;
  }

  final talkerDioLogger = TalkerDioLogger(
    talker: talker,
    settings: TalkerDioLoggerSettings(
      printRequestHeaders: true,
      printResponseMessage: true,
      requestPen: AnsiPen()..blue(),
      responsePen: AnsiPen()..green(),
      errorPen: AnsiPen()..red(),
      requestFilter: (options) => options.data is! FormData,
    ),
  );

  DioConfig._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env['API_URL'] ?? '',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
        validateStatus: (status) =>
            status != null &&
            (status >= 200 && status < 300 || status == 401 || status == 404),
      ),
    );

    dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Добавляем перехватчики
    dio.interceptors.addAll([
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await TokenStorage.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          final customContentType = options.extra['contentType'] as String?;
          if (customContentType != null) {
            options.headers['Content-Type'] = customContentType;
          }

          // Проверка на FormData
          if (options.data is FormData) {
            print('[DIO LOG] FormData скрыто из логов');
            options.extra['skipLog'] =
                true; // Отмечаем, что не нужно логировать
          }

          return handler.next(options);
        },
        onResponse: (response, handler) async {
          if (response.statusCode == 401) {
            print('[DEBUG] Unauthorized (401) detected');

            // Пытаемся обновить токен
            final isRefreshed =
                await _handleTokenRefresh(response.requestOptions);

            if (isRefreshed) {
              try {
                // Если токен обновлен, повторяем запрос
                final retryResponse =
                    await _retryRequest(response.requestOptions);
                return handler
                    .resolve(retryResponse); // Успешно завершаем обработку
              } catch (retryError) {
                print('[DEBUG] Ошибка при повторном запросе: $retryError');
                return handler.reject(DioException(
                  requestOptions: response.requestOptions,
                  response: response,
                  type: DioExceptionType.badResponse,
                  error: 'Ошибка при повторном запросе',
                ));
              }
            } else {
              // Если не удалось обновить токен, редиректим на страницу входа
              _redirectToLogin();
              return handler.reject(DioException(
                requestOptions: response.requestOptions,
                response: response,
                type: DioExceptionType.badResponse,
                error: 'Требуется повторный вход',
              ));
            }
          }

          // Если статус не 401, продолжаем обработку
          handler.next(response);
        },
        onError: (DioException e, handler) async {
          print(
              'Ошибка запроса: ${e.type}, Код ответа: ${e.response?.statusCode}');
          String errorMessage;

          // Обработка различных типов ошибок
          if (e.type == DioExceptionType.connectionTimeout) {
            errorMessage =
                'Время ожидания соединения истекло. Проверьте подключение.';
          } else if (e.type == DioExceptionType.receiveTimeout) {
            errorMessage = 'Время ожидания ответа от сервера истекло.';
          } else if (e.type == DioExceptionType.sendTimeout) {
            errorMessage = 'Время отправки запроса истекло.';
          } else if (e.type == DioExceptionType.badCertificate) {
            errorMessage = 'Ошибка сертификата безопасности.';
          } else if (e.type == DioExceptionType.connectionError) {
            errorMessage = 'Проблема с подключением. Проверьте интернет.';
          } else if (e.response != null) {
            switch (e.response?.statusCode) {
              case 400:
                errorMessage =
                    'Некорректный запрос. Проверьте введенные данные.';
                break;
              case 401:
                errorMessage = 'Сессия истекла. Переподключение...';
                final isRefreshed = await _handleTokenRefresh(e.requestOptions);
                if (isRefreshed) {
                  try {
                    final retryRequest = await _retryRequest(e.requestOptions);
                    return handler.resolve(retryRequest);
                  } catch (retryError) {
                    errorMessage = 'Ошибка при повторном запросе.';
                  }
                } else {
                  _redirectToLogin();
                  errorMessage =
                      'Не удалось обновить токен. Перейдите на страницу входа.';
                }
                break;
              case 403:
                errorMessage = 'Доступ запрещен. Проверьте свои права.';
                break;
              case 404:
                errorMessage = 'Ресурс не найден. Проверьте URL.';
                break;
              case 500:
                errorMessage = 'Ошибка сервера. Повторите позже.';
                break;
              default:
                errorMessage = 'Неизвестная ошибка: ${e.response?.statusCode}';
            }
          } else {
            errorMessage =
                'Произошла неизвестная ошибка. Повторите попытку позже.';
          }

          _showSnackBar(errorMessage);
          handler.next(e); // Продолжаем обработку ошибки
        },
      ),
      talkerDioLogger, // Логгер запросов
    ]);
  }

  // Метод для обновления токена
  static Future<bool> _handleTokenRefresh(RequestOptions requestOptions) async {
    try {
      final refreshToken = await TokenStorage.getRefreshToken();
      if (refreshToken == null) return false;

      final newTokens = await AuthRepository().refreshAccessToken(refreshToken);
      await TokenStorage.saveToken(newTokens['accessToken']!);
      await TokenStorage.saveRefreshToken(newTokens['refreshToken']!);
      return true;
    } catch (e) {
      print('Token refresh failed: $e');
      return false;
    }
  }

  // Метод для повторного выполнения запроса
  static Future<Response> _retryRequest(RequestOptions requestOptions) async {
    final dio = DioConfig().dio;
    try {
      return await dio.request(
        requestOptions.path,
        options: Options(
          method: requestOptions.method,
          headers: requestOptions.headers,
        ),
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Метод для редиректа на страницу входа
  static void _redirectToLogin() {
    final context = globalNavigatorKey.currentContext;
    if (context != null) {
      AutoRouter.of(context).replace(const WelcomeRoute());
    }
  }

  // Метод для показа SnackBar
  static void _showSnackBar(String message) {
    final context = globalNavigatorKey.currentContext;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Закрыть',
            onPressed: ScaffoldMessenger.of(context).hideCurrentSnackBar,
          ),
        ),
      );
    }
  }
}

// Глобальный navigatorKey для доступа к текущему контексту
final GlobalKey<NavigatorState> globalNavigatorKey =
    GlobalKey<NavigatorState>();
