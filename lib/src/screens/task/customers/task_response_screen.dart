import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_build_freelance/src/provider/consumer/TaskNotifier.dart';


@RoutePage()
class TaskResponseScreen extends ConsumerStatefulWidget {
  final String taskId;

  const TaskResponseScreen({super.key, required this.taskId});

  @override
  ConsumerState<TaskResponseScreen> createState() => _TaskResponseScreenState();
}

class _TaskResponseScreenState extends ConsumerState<TaskResponseScreen> {
  @override
  void initState() {
    super.initState();

    // Загружаем отклики после завершения сборки виджета
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(taskNotifierProvider.notifier).fetchTaskResponses(widget.taskId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskState = ref.watch(taskNotifierProvider);

    if (taskState.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (taskState.errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Отклики', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: Center(
          child: Text(taskState.errorMessage!, style: const TextStyle(color: Colors.red)),
        ),
      );
    }

    final responses = taskState.taskResponses;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Отклики', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: responses.length,
        itemBuilder: (context, index) {
          final response = responses[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(response['avatarUrl']),
                  radius: 24,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            response['name'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            response['date'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.add, size: 16, color: Colors.green),
                          const SizedBox(width: 4),
                          Text(
                            response['rating'].toString(),
                            style: const TextStyle(fontSize: 14, color: Colors.green),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        response['text'],
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}