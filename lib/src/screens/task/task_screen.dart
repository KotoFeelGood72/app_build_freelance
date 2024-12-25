import 'package:app_build_freelance/router/app_router.gr.dart';
import 'package:app_build_freelance/src/components/bar/bottom_nav_bar.dart';
import 'package:app_build_freelance/src/components/ui/Btn.dart';
import 'package:app_build_freelance/src/provider/auth/AuthProvider.dart';
import 'package:app_build_freelance/src/provider/consumer/TaskNotifier.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_build_freelance/src/constants/app_colors.dart';

@RoutePage()
class TaskScreen extends ConsumerWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskState = ref.watch(taskNotifierProvider);
    final authState = ref.watch(authProvider);
    final errorMessage = taskState.errorMessage;
    final role = authState.role;

    // Показываем модалку при наличии errorMessage
    if (errorMessage != null && !taskState.isErrorShown) {
      Future.microtask(() {
        showErrorModal(context, 'Заполните профиль, чтобы создать задание');
        ref
            .read(taskNotifierProvider.notifier)
            .clearError(); // Сбрасываем ошибку
      });
    }

    return AutoTabsRouter(
      routes: const [
        OpenTaskRoute(),
        HistoryTaskRoute(),
      ],
      lazyLoad: true, // Инициализация вкладки только при её активации
      transitionBuilder: (context, child, animation) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);

        // Отслеживание переключения вкладок
        tabsRouter.addListener(() {
          if (tabsRouter.activeIndex == 0) {
            // Инициализируем запрос для открытых задач
            ref
                .read(taskNotifierProvider.notifier)
                .fetchTasks(filters: 'tasks');
          } else if (tabsRouter.activeIndex == 1) {
            // Инициализируем запрос для истории задач
            ref
                .read(taskNotifierProvider.notifier)
                .fetchTasks(filters: 'history');
          }
        });

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: const Text(
              'Задания',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            actions: [
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
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => tabsRouter.setActiveIndex(0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: tabsRouter.activeIndex == 0
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(
                              child: Text(
                                role == 'Customer' ? 'Открытые' : 'Новые',
                                style: TextStyle(
                                  color: tabsRouter.activeIndex == 0
                                      ? AppColors.violet
                                      : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => tabsRouter.setActiveIndex(1),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: tabsRouter.activeIndex == 1
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(
                              child: Text(
                                role == 'Customer' ? 'История' : 'Текущие',
                                style: TextStyle(
                                  color: tabsRouter.activeIndex == 1
                                      ? AppColors.violet
                                      : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: child,
          bottomNavigationBar: const BottomNavBar(),
        );
      },
    );
  }

  void showErrorModal(BuildContext context, String message) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error, color: AppColors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: AppColors.red),
              ),
              const SizedBox(height: 16),
              Btn(
                text: 'Перейти в профиль',
                theme: 'violet',
                onPressed: () =>
                    AutoRouter.of(context).push(const ProfileRoute()),
              ),
            ],
          ),
        );
      },
    );
  }
}
