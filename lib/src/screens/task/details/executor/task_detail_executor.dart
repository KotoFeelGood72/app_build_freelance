import 'package:app_build_freelance/router/app_router.gr.dart';
import 'package:app_build_freelance/src/components/ui/Btn.dart';
import 'package:app_build_freelance/src/components/ui/Divider.dart';
import 'package:app_build_freelance/src/components/ui/Inputs.dart';
import 'package:app_build_freelance/src/components/ui/info_row.dart';
import 'package:app_build_freelance/src/constants/app_colors.dart';
import 'package:app_build_freelance/src/provider/consumer/TaskNotifier.dart';
import 'package:app_build_freelance/src/utils/modal_utils.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class TaskDetailExecutorScreen extends ConsumerWidget {
  final String taskId;

  const TaskDetailExecutorScreen({super.key, required this.taskId});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskAsyncValue = ref.watch(taskByIdProvider(taskId));
    return Scaffold(
      body: taskAsyncValue.when(
        data: (task) {
          return Container(
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
                      Text(
                        task['taskName'],
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Square(),
                      Text(
                        task['taskDescription'],
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const Square(
                        height: 32,
                      ),
                      InfoRow(
                        label: 'Стоимость',
                        value: '${task['taskPrice']} ₽',
                        hasTopBorder: true,
                        hasBottomBorder: true,
                      ),
                      InfoRow(
                        label: 'Срок выполнения',
                        value: task['taskTerm'],
                        hasBottomBorder: true,
                      ),
                      InfoRow(
                        label: 'Размещено',
                        value: task['taskCreated'],
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
                          Text(
                              '${task['customer']['firstName']} ${task['customer']['lastName']}'),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              AutoRouter.of(context).push(
                                  TaskCustomerProfileRoute(
                                      profileCustomerId: task['customer']
                                          ['id']));
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
                    Expanded(
                        child: Btn(
                            text: 'Отказаться',
                            theme: 'white',
                            onPressed: () {})),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Btn(
                          text: 'Согласиться',
                          onPressed: () =>
                              _openResponseModal(context, ref, taskId),
                          theme: 'violet'),
                    ),
                  ],
                ),
                const Square(
                  height: 32,
                )
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Ошибка: $error')),
      ),
    );
  }
}

void _openResponseModal(BuildContext context, WidgetRef ref, String taskId) {
  final TextEditingController responseController = TextEditingController();

  showCustomModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        color: AppColors.bg,
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
                Expanded(
                  child: Btn(
                    text: 'Отмена',
                    theme: 'white',
                    onPressed: () {
                      Navigator.of(context).pop(); // Закрыть модалку
                    },
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Btn(
                    text: 'Отправить',
                    theme: 'violet',
                    onPressed: () {
                      ref
                          .read(sendTaskResponseProvider({
                        'taskId': taskId,
                        'text': responseController.text,
                      }).future)
                          .then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Отклик успешно отправлен!'),
                          ),
                        );
                        // AutoRouter.of(context).replaceAll([const TaskRoute()]);
                      }).catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Ошибка: $error'),
                          ),
                        );
                      });
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
