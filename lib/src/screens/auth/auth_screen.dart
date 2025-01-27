import 'package:app_build_freelance/router/app_router.gr.dart';
import 'package:app_build_freelance/src/components/ui/Btn.dart';
import 'package:app_build_freelance/src/components/ui/Divider.dart';
import 'package:app_build_freelance/src/components/ui/Inputs.dart';
import 'package:app_build_freelance/src/constants/app_colors.dart';
import 'package:app_build_freelance/src/layouts/empty_layout.dart';
import 'package:app_build_freelance/src/provider/auth/AuthProvider.dart';
import 'package:app_build_freelance/src/utils/clean_phone.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final signInControllerProvider = Provider<MaskedTextController>(
    (ref) => MaskedTextController(mask: '+7 (000) 000-00-00'));

final isButtonEnabledProvider = StateProvider<bool>((_) => false);

@RoutePage()
class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signInController = ref.watch(signInControllerProvider);
    final isButtonEnabled = ref.watch(isButtonEnabledProvider);
    final authState = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.error != null) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text(next.error!)),
        // );
      }

      if (next.codeSent && previous?.codeSent != true) {
        AutoRouter.of(context).push(const ConfirmRoute());
      }
    });

    return EmptyLayout(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Inputs(
              controller: signInController,
              backgroundColor: AppColors.ulight,
              textColor: Colors.black,
              errorMessage: 'Поле обязательно для заполнения',
              fieldType: 'phone',
              onChanged: (value) {
                final isEnabled = value.length == 18; // Длина полного номера
                ref.read(isButtonEnabledProvider.notifier).state = isEnabled;
              },
            ),
            const Square(),
            if (authState.isLoading)
              const CircularProgressIndicator()
            else
              SizedBox(
                width: double.infinity,
                child: Btn(
                  text: 'Выслать код',
                  onPressed: isButtonEnabled
                      ? () {
                          final phoneNumber = CleanPhone.cleanPhoneNumber(
                              signInController.text);
                          authNotifier.setPhoneNumber(phoneNumber);
                          authNotifier.requestCode();
                        }
                      : null,
                  theme: 'violet',
                  disabled: !isButtonEnabled,
                ),
              ),
          ],
        ),
      ),
      title: 'Вход',
    );
  }
}
