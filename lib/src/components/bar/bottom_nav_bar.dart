import 'package:app_build_freelance/src/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:app_build_freelance/router/app_router.gr.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:iconify_flutter/icons/ri.dart';
import 'package:iconify_flutter/icons/vaadin.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: AppColors.white,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.violet,
      unselectedItemColor: AppColors.light,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(
          icon: Iconify(Ic.round_task_alt, size: 25, color: AppColors.gray,),
          label: 'Задания',
        ),
        BottomNavigationBarItem(
          icon: Iconify(Ri.database_2_fill, size: 25, color: AppColors.gray,),
          label: 'Счёт',
        ),
        BottomNavigationBarItem(
          icon: Iconify(Mdi.briefcase_variant, size: 25, color: AppColors.gray,),
          label: 'Вакансии',
        ),
        BottomNavigationBarItem(
          icon: Iconify(Vaadin.ellipsis_dots_h, size: 25, color: AppColors.gray,),
          label: 'Аккаунт',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            context.router.push(const TaskRoute());
            break;
          case 1:
            context.router.push(const ProfileRoute());
            break;
          case 2:
            context.router.push(const TaskRoute());
            break;
          case 3:
            context.router.push(const ProfileRoute());
            break;
        }
      },
    );
  }
}
