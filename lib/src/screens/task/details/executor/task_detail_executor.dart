import 'package:app_build_freelance/router/app_router.gr.dart';
import 'package:app_build_freelance/src/components/ui/Btn.dart';
import 'package:app_build_freelance/src/components/ui/Divider.dart';
import 'package:app_build_freelance/src/components/ui/Inputs.dart';
import 'package:app_build_freelance/src/components/ui/info_row.dart';
import 'package:app_build_freelance/src/constants/app_colors.dart';
import 'package:app_build_freelance/src/utils/modal_utils.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class TaskDetailExecutorScreen extends StatelessWidget {
  final String taskId;

  const TaskDetailExecutorScreen({super.key, required this.taskId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
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
                  const Square(),
                  const Text(
                    'В своём стремлении повысить качество жизни...',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const Square(
                    height: 32,
                  ),
                  const InfoRow(
                    label: 'Стоимость',
                    value: '1000 ₽',
                    hasTopBorder: true,
                    hasBottomBorder: true,
                  ),
                  const InfoRow(
                    label: 'Срок выполнения',
                    value: '4 ч',
                    hasBottomBorder: true,
                  ),
                  const InfoRow(
                    label: 'Размещено',
                    value: '20 сентября в 20:40',
                    hasBottomBorder: true,
                  ),
                  const InfoRow(
                    label: 'Статус',
                    value: 'Поиск исполнителя',
                    hasBottomBorder: true,
                  ),
                  const Square(),
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
                          AutoRouter.of(context)
                              .push(const TaskCustomerProfileRoute());
                        },
                        child: const Text(
                          'Подробнее',
                          style: TextStyle(
                              color: AppColors.violet,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Square(),
            Btn(
                text: 'Пожаловаться',
                onPressed: () {},
                theme: 'white',
                textColor: AppColors.red),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Btn(text: 'Отказаться', theme: 'white', onPressed: () {}),
                Btn(
                    text: 'Согласиться',
                    onPressed: () => _openResponseModal(context),
                    theme: 'violet'),
              ],
            ),
            const Square(
              height: 32,
            )
          ],
        ),
      ),
    );
  }
}

void _openResponseModal(BuildContext context) {
  final TextEditingController responseController = TextEditingController();

  showCustomModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding:
            const EdgeInsets.only(bottom: 32, left: 16, right: 16, top: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Написать отклик',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 32),
            Inputs(
              backgroundColor: Colors.white,
              textColor: Colors.black,
              controller: responseController,
              label: 'Ваш отклик',
              fieldType: 'text',
              isMultiline: true,
              required: true,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  child: Btn(
                    text: 'Отмена',
                    theme: 'white',
                    onPressed: () {
                      Navigator.of(context).pop(); // Закрыть модалку
                    },
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Btn(
                    text: 'Отправить',
                    theme: 'violet',
                    onPressed: () {
                      // Логика отправки отклика
                      print('Отклик отправлен: ${responseController.text}');
                      Navigator.of(context).pop(); // Закрыть модалку
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
