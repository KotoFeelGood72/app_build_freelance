import 'package:app_build_freelance/src/components/ui/Divider.dart';
import 'package:app_build_freelance/src/components/ui/avatar_img.dart';
import 'package:app_build_freelance/src/components/ui/info_row.dart';
import 'package:app_build_freelance/src/constants/app_colors.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class TaskCustomerProfileScreen extends StatelessWidget {
  const TaskCustomerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text('Профиль')),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
        color: AppColors.bg,
          border: Border(
            top: BorderSide(
              width: 1,
              color: AppColors.border
            )
          )
        ),
        child: Column(
          children: [
            Square(),
            AvatarImg(firstName: 'firstName', lastName: 'lastName', imageUrl: 'assets/images/splash.png', isLocalImage: true),
            Square(height: 32,),
            InfoRow(label: 'Рейтинг', value: 'Супер-заказчик (Топ-10)', hasBottomBorder: true, ),
            InfoRow(label: 'Создано', value: '1000 заданий', hasBottomBorder: true,),
            Square(),
            Container(
              child: Text('Для современного мира разбавленное изрядной долей эмпатии, рациональное мышление создаёт предпосылки для кластеризации усилий.', style: TextStyle(color: AppColors.gray),),
            )
          ],
        )
      ),
    );
  }
}