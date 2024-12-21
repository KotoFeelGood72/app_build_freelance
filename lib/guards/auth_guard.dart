import 'package:app_build_freelance/config/token_storage.dart';
import 'package:auto_route/auto_route.dart';
import 'package:app_build_freelance/router/app_router.gr.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  Future<void> onNavigation(NavigationResolver resolver, StackRouter router) async {
    final token = await TokenStorage.getToken();
    if (token != null) {
      resolver.next(); // Токен существует, доступ к маршруту разрешен
    } else {
      router.push(SignInRoute()); // Перенаправление на экран входа
    }
  }
}

class UnAuthGuard extends AutoRouteGuard {
  @override
  Future<void> onNavigation(NavigationResolver resolver, StackRouter router) async {
    final token = await TokenStorage.getToken();
    if (token == null) {
      resolver.next(); // Токена нет, доступ к маршруту разрешен
    } else {
      router.push(TaskRoute()); // Перенаправление на основной экран, если пользователь авторизован
    }
  }
}
