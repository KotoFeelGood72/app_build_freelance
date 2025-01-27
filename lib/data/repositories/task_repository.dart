import 'package:app_build_freelance/config/dio_config.dart';
import 'package:app_build_freelance/data/models/task_models.dart';

class TaskRepository {
  Future<List<TaskModels>> fetchTasks(
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await DioConfig().dio.get(
            '/tasks',
            queryParameters: queryParameters,
          );

      if (response.statusCode == 200) {
        return (response.data as List)
            .map((taskJson) => TaskModels.fromJson(taskJson))
            .toList();
      } else {
        throw Exception("Ошибка при получении задач: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Ошибка при выполнении запроса: $e");
    }
  }

  Future<TaskModels> fetchTaskById(String id) async {
    final response = await DioConfig().dio.get('/tasks/$id');
    return TaskModels.fromJson(response.data);
  }

  Future<void> createTask(TaskModels task) async {
    await DioConfig().dio.post('/tasks', data: task.toJson());
  }
}
