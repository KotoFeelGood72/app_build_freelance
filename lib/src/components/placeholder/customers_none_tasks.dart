import 'package:app_build_freelance/router/app_router.gr.dart';
import 'package:app_build_freelance/src/components/ui/Btn.dart';
import 'package:app_build_freelance/src/provider/auth/AuthProvider.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomersNoneTasks extends ConsumerWidget {
  const CustomersNoneTasks({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final role = authState.role;

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            margin: const EdgeInsets.only(bottom: 16),
            width: 72,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/splash.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const Text('У вас сейчас нет заданий'),
          const Text('Открытые задания появятся здесь'),
          if (role == 'Customer') // Проверка роли
            Btn(
              text: 'Создать задание',
              theme: 'white',
              onPressed: () {
                AutoRouter.of(context).push(const NewTaskCreateRoute());
                // Добавьте логику создания задания
              },
            ),
        ],
      ),
    );
  }
}
