import 'package:app_build_freelance/router/app_router.gr.dart';
import 'package:app_build_freelance/src/components/ui/Btn.dart';
import 'package:app_build_freelance/src/components/ui/Inputs.dart';
import 'package:app_build_freelance/src/constants/app_colors.dart';
import 'package:app_build_freelance/src/provider/consumer/TaskNotifier.dart';
import 'package:app_build_freelance/src/utils/modal_utils.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void openResponseModal(BuildContext context, WidgetRef ref, String taskId) {
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
                    textColor: AppColors.red,
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
                        AutoRouter.of(context).replaceAll([const TaskRoute()]);
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
