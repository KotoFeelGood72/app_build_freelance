import 'package:app_build_freelance/router/app_router.gr.dart';
import 'package:app_build_freelance/src/components/ui/Btn.dart';
import 'package:app_build_freelance/src/components/ui/Divider.dart';
import 'package:app_build_freelance/src/components/ui/Inputs.dart';
import 'package:app_build_freelance/src/constants/app_colors.dart';
import 'package:app_build_freelance/src/layouts/empty_layout.dart';
import 'package:app_build_freelance/src/provider/auth/AuthProvider.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final MaskedTextController _signInController =
      MaskedTextController(mask: '+7 (000) 000-00-00');
  bool isButtonEnabled = false;
  final int requiredLength = 18;

  @override
  void initState() {
    super.initState();
    _signInController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {
      isButtonEnabled = _signInController.text.length == requiredLength;
    });
  }

  @override
  void dispose() {
    _signInController.removeListener(_onTextChanged);
    _signInController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);

    // Слушаем изменения состояния
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!)),
        );
      }

      if (next.codeSent) {
        final currentRoute = AutoRouter.of(context).current.name;
        if (currentRoute != ConfirmRoute.name) {
          AutoRouter.of(context).push(const ConfirmRoute());
        }
      }
    });

    return EmptyLayout(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Inputs(
              controller: _signInController,
              backgroundColor: AppColors.ulight,
              textColor: Colors.black,
              errorMessage: 'Поле обязательно для заполнения',
              fieldType: 'phone',
            ),
            Square(),
            if (authState.isLoading)
              CircularProgressIndicator()
            else
              SizedBox(
                width: double.infinity,
                child: Btn(
                  text: 'Выслать код',
                  onPressed: () {
                    final phoneNumber = _signInController.text.replaceAll(RegExp(r'[^\d+]'), '');
                    authNotifier.setPhoneNumber(phoneNumber);
                    authNotifier.requestCode();
                  },
                  theme: 'violet',
                  disabled: !isButtonEnabled,
                ),
              ),
            Square(),
            Btn(
              text: 'Зарегистрироваться',
              onPressed: () {
                AutoRouter.of(context).push(SignUpRoute());
              },
              theme: 'white',
            ),
          ],
        ),
      ),
      title: 'Вход',
    );
  }
}