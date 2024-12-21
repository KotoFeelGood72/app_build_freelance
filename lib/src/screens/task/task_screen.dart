import 'package:app_build_freelance/router/app_router.gr.dart';
import 'package:app_build_freelance/src/components/bar/bottom_nav_bar.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:app_build_freelance/src/constants/app_colors.dart';

@RoutePage()
class TaskScreen extends StatelessWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [
        OpenTaskRoute(),
        HistoryTaskRoute(),
      ],
      transitionBuilder: (context, child, animation) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
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
              IconButton(
                icon: const Icon(Icons.add, color: Colors.black),
                onPressed: () {
                  AutoRouter.of(context).push(NewTaskCreateRoute());
                  // Логика для добавления нового задания
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
                              color: tabsRouter.activeIndex == 0 ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(
                              child: Text(
                                'Открытые',
                                style: TextStyle(
                                  color: tabsRouter.activeIndex == 0 ? AppColors.violet : Colors.grey,
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
                              color: tabsRouter.activeIndex == 1 ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(
                              child: Text(
                                'История',
                                style: TextStyle(
                                  color: tabsRouter.activeIndex == 1 ? AppColors.violet : Colors.grey,
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
          // Используем полученный дочерний виджет как содержимое
          body: child,
          bottomNavigationBar: BottomNavBar(),
        );
      },
    );
  }
}
