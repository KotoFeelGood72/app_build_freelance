import 'package:app_build_freelance/src/screens/task/details/executor/task_detail_executor.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';


@RoutePage()
class TaskDetailScreen extends StatelessWidget {
  final String taskId;

  const TaskDetailScreen({Key? key, @PathParam('taskId') required this.taskId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TaskDetailExecutorScreen();
  }
}
