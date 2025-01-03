import 'package:app_build_freelance/src/components/ui/Icons.dart';
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
  const BottomNavBar({super.key});

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
          icon: IconWidget(
            iconName: 'case',
            color: AppColors.gray,
            size: 25,
          ),
          activeIcon: IconWidget(
            iconName: 'case',
            color: AppColors.violet,
            size: 25,
          ),
          label: 'Задания',
        ),
        BottomNavigationBarItem(
          icon: IconWidget(
            iconName: 'credit',
            color: AppColors.gray,
            size: 25,
          ),
          label: 'Счёт',
        ),
        BottomNavigationBarItem(
          icon: IconWidget(
            iconName: 'vacancy',
            color: AppColors.gray,
            size: 25,
          ),
          label: 'Вакансии',
        ),
        BottomNavigationBarItem(
          icon: IconWidget(
            iconName: 'settings',
            color: AppColors.gray,
            size: 25,
          ),
          label: 'Аккаунт',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            // context.router.push(const TaskRoute());
            break;
          case 1:
            context.router.push(const ProfileRoute());
            break;
          case 2:
            // context.router.push(const TaskRoute());
            break;
          case 3:
            context.router.push(const ProfileRoute());
            break;
        }
      },
    );
  }
}
