import 'package:app_build_freelance/router/app_router.gr.dart';
import 'package:app_build_freelance/src/components/ui/Btn.dart';
import 'package:app_build_freelance/src/components/ui/Divider.dart';
import 'package:app_build_freelance/src/components/ui/info_row.dart';
import 'package:app_build_freelance/src/constants/app_colors.dart';
import 'package:app_build_freelance/src/provider/UserNotifier.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class ProfileUserDataScreen extends ConsumerWidget {
  const ProfileUserDataScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);

    if (userState.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (userState.errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Text(
            userState.errorMessage!,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }


    final user = userState.user;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Личные данные'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.white, 
                  width: 4, 
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.yellow,
                foregroundImage: AssetImage('assets/images/splash.png'),
              ),
            ),
            Square(),
             Text(
              '${user!.firstName} ${user.lastName}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            InfoRow(label: 'Телефон', value: '+7 (999) 999-99-99', hasBottomBorder: true,),
            InfoRow(label: 'О себе', value: 'Для современного мира разбавленное изрядной долей эмпатии, рациональное мышление создаёт предпосылки для кластеризации усилий.', hasBottomBorder: true, isValueBelow: true,),
            const SizedBox(height: 24),
            SizedBox(width: double.infinity, child: Btn(text: 'Редактировать', onPressed: () {
              AutoRouter.of(context).push(ProfileEditRoute());
            }, theme: 'violet')),
            Square(),
            SizedBox(width: double.infinity, child: Btn(text: 'Привязать соцсети', onPressed: () {}, theme: 'white')),
          ],
        ),
      ),
    );
  }
}