import 'package:app_build_freelance/router/app_router.gr.dart';
import 'package:app_build_freelance/src/layouts/empty_layout.dart';
import 'package:app_build_freelance/src/components/ui/Btn.dart';
import 'package:app_build_freelance/src/constants/app_colors.dart';
import 'package:app_build_freelance/src/provider/auth/AuthProvider.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class ConfirmScreen extends ConsumerWidget {
  const ConfirmScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);
WidgetsBinding.instance.addPostFrameCallback((_) {
      if (authState.codeSent == false && authState.error == null && !authState.isLoading) {
        AutoRouter.of(context).replace(const TaskRoute()); // Перенаправление на нужный экран
      }
    });
    return EmptyLayout(
      title: 'Ввод кода',
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OtpTextField(
              filled: true,
              fillColor: AppColors.ulight,
              numberOfFields: 4,
              borderColor: AppColors.border,
              borderWidth: 1,
              focusedBorderColor: AppColors.violet,
              showFieldAsBox: true,
              fieldWidth: 70,
              fieldHeight: 48,
              onSubmit: (code) => authNotifier.verifyCode(code),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
            const SizedBox(height: 12),
            if (authState.error != null)
              Text(
                authState.error!,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 12),
            if (!authState.codeSent)
              Text(
                'Вы сможете запросить код через ${authNotifier.remainingSeconds} секунд',
                style: const TextStyle(color: Colors.grey),
              ),
            if (authState.codeSent)
              Btn(
                text: 'Выслать код ещё раз',
                theme: 'white',
                onPressed: authNotifier.resendCode,
              ),
          ],
        ),
      ),
    );
  }
}