import 'package:app_build_freelance/config/token_storage.dart';
import 'package:app_build_freelance/main.dart';
import 'package:app_build_freelance/router/app_router.dart';
import '../router/app_router.gr.dart';

class NavigatorHelper {
  static void redirectToLogin() {
    TokenStorage.deleteTokens();
    getIt<AppRouter>().replaceAll([const WelcomeRoute()]);
  }
}
