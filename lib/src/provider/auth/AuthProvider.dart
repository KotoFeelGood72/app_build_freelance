import 'dart:async';

import 'package:app_build_freelance/router/app_router.dart';
import 'package:app_build_freelance/router/app_router.gr.dart';
import 'package:app_build_freelance/src/repositories/auth/auth_repository.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final bool isLoading;
  final String? error;
  final bool codeSent;
  final String? phoneNumber;
  final String? role;

  const AuthState({
    this.role,
    this.isLoading = false,
    this.error,
    this.codeSent = false,
    this.phoneNumber,
  });

  // Создаём копию состояния с изменёнными полями (immutability)
  AuthState copyWith({
    bool? isLoading,
    String? error,
    bool? codeSent,
    String? phoneNumber,
    String? role,
  }) {
    return AuthState(
      role: role ?? this.role,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      codeSent: codeSent ?? this.codeSent,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  late final AuthRepository _authRepository;
  Timer? _timer;
  int remainingSeconds = 60;

  @override
  AuthState build() {
    _authRepository = ref.read(authRepositoryProvider);
    return const AuthState();
  }

  void setPhoneNumber(String phoneNumber) {
    state = state.copyWith(phoneNumber: phoneNumber);
  }

  // Новый метод для смены роли
  Future<void> updateRole(String newRole) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _authRepository.updateRole(newRole); // Логика репозитория
      state = state.copyWith(isLoading: false, role: newRole);
    } catch (e) {
      state = state.copyWith(
          isLoading: false, error: 'Ошибка смены роли: ${e.toString()}');
    }
  }

  Future<void> requestCode() async {
    final phoneNumber = state.phoneNumber;
    final role = state.role;

    if (phoneNumber == null || phoneNumber.isEmpty) {
      state = state.copyWith(error: 'Номер телефона не указан');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);
    try {
      await _authRepository.sendPhoneNumber(phoneNumber, role!);
      state = state.copyWith(isLoading: false, codeSent: true);
      startTimer();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> verifyCode(String code) async {
    if (code.isEmpty) {
      state = state.copyWith(error: 'Код не может быть пустым');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);
    try {
      await _authRepository.verifyCode(code);
      state = state.copyWith(isLoading: false, error: null, codeSent: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> resendCode() async {
    final phoneNumber = state.phoneNumber;
    final role = state.role;

    if (phoneNumber == null || phoneNumber.isEmpty) {
      state = state.copyWith(error: 'Номер телефона не указан');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);
    try {
      await _authRepository.sendPhoneNumber(phoneNumber, role!);
      state = state.copyWith(isLoading: false, codeSent: true);
      startTimer();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void startTimer() {
    remainingSeconds = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        remainingSeconds--;
      } else {
        timer.cancel();
        state = state.copyWith(error: 'Можете запросить код ещё раз.');
      }
    });
  }

  void setRole(String role) {
    state = state.copyWith(role: role);
  }

  final autoRouterProvider = Provider<StackRouter>((ref) {
    return AppRouter();
  });

  Future<void> onSignOut() async {
    try {
      await _authRepository.logout();
      state = const AuthState(); // Сбрасываем состояние
      print('Ошибка при выходе: ');
      // Перенаправляем на WelcomeRoute
      final router = ref.read(autoRouterProvider);
      router.replaceAll([const WelcomeRoute()]);
    } catch (e, stacktrace) {
      print('Ошибка при выходе: $e');
      print(stacktrace);
      state = state.copyWith(error: 'Ошибка выхода: ${e.toString()}');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
  }
}

final autoRouterProvider = Provider<AutoRouter>((ref) => const AutoRouter());

// Провайдер для AuthNotifier
final authProvider =
    NotifierProvider<AuthNotifier, AuthState>(() => AuthNotifier());

// Репозиторий
final authRepositoryProvider =
    Provider<AuthRepository>((ref) => AuthRepository());
