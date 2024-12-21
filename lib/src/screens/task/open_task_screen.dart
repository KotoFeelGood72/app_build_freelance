import 'package:app_build_freelance/router/app_router.gr.dart';
import 'package:app_build_freelance/src/components/card/card_task.dart';
import 'package:app_build_freelance/src/components/placeholder/customers_none_tasks.dart';
import 'package:app_build_freelance/src/constants/app_colors.dart';
import 'package:app_build_freelance/src/provider/auth/AuthProvider.dart';
import 'package:app_build_freelance/src/provider/consumer/TaskNotifier.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class OpenTaskScreen extends ConsumerStatefulWidget {
  const OpenTaskScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<OpenTaskScreen> createState() => _OpenTaskScreenState();
}

class _OpenTaskScreenState extends ConsumerState<OpenTaskScreen> {
  @override
  void initState() {
    super.initState();
    // Загружаем задачи при монтировании экрана
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(taskNotifierProvider.notifier).fetchTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskState = ref.watch(taskNotifierProvider);
    final authState = ref.watch(authProvider);

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.bg,
        border: Border(
          top: BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),
      ),
      child: taskState.isLoading
          ? const Center(child: CircularProgressIndicator()) // Показываем загрузку
          : taskState.tasks.isEmpty
              ? const CustomersNoneTasks() // Показываем placeholder, если задач нет
              : ListView.builder( // Отображаем список задач
                  itemCount: taskState.tasks.length,
                  itemBuilder: (context, index) {
                    final task = taskState.tasks[index];
                    return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0), // Отступ снизу
                  child: CardTask(task: task, onTap: () {
                      
                    if (authState.role == 'Customer') {
                      AutoRouter.of(context).push(
                        TaskResponseRoute(taskId: task['id'].toString()), // Преобразуем int в String
                      );
                    } else {
                      AutoRouter.of(context).push(
                        TaskDetailRoute(taskId: task['id'].toString()), // Преобразуем int в String
                      );
                    }
                  },),
                );
                  },
                ),
    );
  }
}