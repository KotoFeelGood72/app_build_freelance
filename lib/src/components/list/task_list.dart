import 'package:app_build_freelance/src/components/card/card_task.dart';
import 'package:app_build_freelance/src/components/placeholder/customers_none_tasks.dart';
import 'package:app_build_freelance/src/constants/app_colors.dart';
import 'package:app_build_freelance/src/provider/consumer/TaskNotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskList extends ConsumerWidget {
  final Map<String, dynamic> filter;
  final Function(Map<String, dynamic>)? onTaskTap;

  const TaskList({
    super.key,
    required this.filter,
    this.onTaskTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskListAsyncValue = ref.watch(fetchTasksProvider(filter));

    return taskListAsyncValue.when(
      data: (tasks) {
        // Если задачи успешно загружены
        if (tasks.isEmpty) {
          return const CustomersNoneTasks();
        }

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: CardTask(
                task: task,
                onTap: () {
                  if (onTaskTap != null) {
                    onTaskTap!(task);
                  }
                },
              ),
            );
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => Center(
        child: Text(
          'Ошибка при загрузке задач: $error',
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}
