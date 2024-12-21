import 'package:app_build_freelance/router/app_router.gr.dart';
import 'package:app_build_freelance/src/components/ui/Btn.dart';
import 'package:app_build_freelance/src/components/ui/Divider.dart';
import 'package:app_build_freelance/src/components/ui/info_row.dart';
import 'package:app_build_freelance/src/constants/app_colors.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class TaskDetailExecutorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('О задании'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.bg,
          border: Border(
            top: BorderSide(
              width: 1,
              color: AppColors.border,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Название задания до 40 символов',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Square(),
                  const Text(
                    'В своём стремлении повысить качество жизни...',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Square(height: 32,),
                  InfoRow(
                    label: 'Стоимость',
                    value: '1000 ₽',
                    hasTopBorder: true,
                    hasBottomBorder: true,
                  ),
                  InfoRow(
                    label: 'Срок выполнения',
                    value: '4 ч',
                    hasBottomBorder: true,
                  ),
                  InfoRow(
                    label: 'Размещено',
                    value: '20 сентября в 20:40',
                    hasBottomBorder: true,
                  ),
                  InfoRow(
                    label: 'Статус',
                    value: 'Поиск исполнителя',
                    hasBottomBorder: true,
                  ),
                  Square(),
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: AppColors.violet,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('Заказчик'),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          AutoRouter.of(context).push(TaskCustomerProfileRoute());
                        },
                        child: const Text(
                          'Подробнее',
                          style: TextStyle(color: AppColors.violet, fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Square(),
            Btn(text: 'Пожаловаться', onPressed: () {}, theme: 'white', textColor: AppColors.red),
            Spacer(), 
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Btn(text: 'Отказаться', theme: 'white', onPressed: () {}),
                Btn(text: 'Согласиться', onPressed: () {}, theme: 'violet'),
              ],
            ),
            Square(height: 32,)
          ],
        ),
      ),
    );
  }
}
