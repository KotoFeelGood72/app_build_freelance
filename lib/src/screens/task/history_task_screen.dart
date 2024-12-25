import 'package:app_build_freelance/src/components/card/card_task.dart';
import 'package:app_build_freelance/src/components/placeholder/customers_none_tasks.dart';
import 'package:app_build_freelance/src/constants/app_colors.dart';
import 'package:app_build_freelance/src/provider/consumer/TaskNotifier.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class HistoryTaskScreen extends ConsumerStatefulWidget {
  const HistoryTaskScreen({super.key});

  @override
  ConsumerState<HistoryTaskScreen> createState() => _HistoryTaskScreenState();
}

class _HistoryTaskScreenState extends ConsumerState<HistoryTaskScreen> {
  @override
  void initState() {
    super.initState();
    // Загружаем задачи при монтировании экрана
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(taskNotifierProvider.notifier).fetchTasks(filters: 'history');
      // ref.read(taskNotifierProvider.notifier).fetchTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskState = ref.watch(taskNotifierProvider);

    return Container(
      alignment: Alignment.center,
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
          ? const Center(child: CircularProgressIndicator())
          : taskState.tasks.isEmpty
              ? const CustomersNoneTasks()
              : ListView.builder(
                  itemCount: taskState.tasks.length,
                  itemBuilder: (context, index) {
                    final task = taskState.tasks[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: CardTask(
                        task: task,
                        onTap: () => (),
                      ),
                    );
                  },
                ),
    );
  }
}
