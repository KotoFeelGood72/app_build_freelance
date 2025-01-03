import 'package:app_build_freelance/router/app_router.gr.dart';
import 'package:app_build_freelance/src/components/bar/bottom_nav_bar.dart';
import 'package:app_build_freelance/src/components/list/task_list.dart';
import 'package:app_build_freelance/src/constants/app_colors.dart';
import 'package:app_build_freelance/src/provider/auth/AuthProvider.dart';
import 'package:app_build_freelance/src/provider/consumer/TaskNotifier.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class TaskScreen extends ConsumerWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final role = authState.role;

    // Заголовки вкладок
    final tabTitles = role == 'Executor'
        ? ['Новые', 'Открытые', 'История']
        : ['Открытые', 'История'];

    // Фильтры задач
    final filters = role == 'Executor'
        ? [
            {'filter': 'new'},
            {'filter': 'open'},
            {'filter': 'history'},
          ]
        : [
            {'filter': 'tasks'},
            {'filter': 'history'},
          ];

    final selectedTabIndex = ref.watch(selectedTabIndexProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Задания',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          if (role != 'Executor') // Кнопка добавления задачи для заказчиков
            IconButton(
              icon: const Icon(Icons.add, color: Colors.black),
              onPressed: () {
                AutoRouter.of(context).push(const NewTaskCreateRoute());
              },
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.ulight,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: List.generate(tabTitles.length, (index) {
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // Переключение вкладки
                        ref.read(selectedTabIndexProvider.notifier).state =
                            index;
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: selectedTabIndex == index
                              ? Colors.white
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            tabTitles[index],
                            style: TextStyle(
                              color: selectedTabIndex == index
                                  ? AppColors.violet
                                  : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final currentFilter = filters[selectedTabIndex];
          await ref.refresh(fetchTasksProvider(currentFilter).future);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TaskList(
            filter: filters[selectedTabIndex],
            onTaskTap: (task) {
              if (role == 'Executor') {
                AutoRouter.of(context).push(
                  TaskDetailRoute(taskId: task['id'].toString()),
                );
              } else {
                AutoRouter.of(context).push(
                  TaskResponseRoute(taskId: task['id'].toString()),
                );
              }
            },
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

// Провайдер для активной вкладки
final selectedTabIndexProvider = StateProvider<int>((ref) => 0);
