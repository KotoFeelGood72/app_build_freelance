import 'package:app_build_freelance/config/dio_config.dart';
import 'package:app_build_freelance/src/provider/consumer/TaskState.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskNotifier extends StateNotifier<TaskState> {
  TaskNotifier() : super(TaskState());

  void updateTaskName(String taskName) {
    state = state.copyWith(taskName: taskName);
  }

  void updateTaskPrice(int taskPrice) {
    // taskPrice как int
    state = state.copyWith(taskPrice: taskPrice);
  }

  void updateTaskTerm(DateTime? taskTerm) {
    print("Дата обновлена через updateTaskTerm: $taskTerm");
    state = state.copyWith(taskTerm: taskTerm);
  }

  void updateTaskCity(String taskCity) {
    state = state.copyWith(taskCity: taskCity);
  }

  void updateTaskDescription(String taskDescription) {
    state = state.copyWith(taskDescription: taskDescription);
  }

  void clearTaskForm() {
    state = TaskState();
  }

  void validateTaskForm() {
    if (state.taskName.isEmpty) {
      state = state.copyWith(
        isValid: false,
        errorMessage: 'Название задачи обязательно.',
        isErrorShown: false, // Сбрасываем флаг для повторного показа ошибки
      );
    } else if (state.taskPrice <= 0) {
      state = state.copyWith(
        isValid: false,
        errorMessage: 'Стоимость должна быть больше 0.',
        isErrorShown: false,
      );
    } else if (state.taskTerm == null) {
      state = state.copyWith(
        isValid: false,
        errorMessage: 'Необходимо указать срок.',
        isErrorShown: false,
      );
    } else if (state.taskCity.isEmpty) {
      state = state.copyWith(
        isValid: false,
        errorMessage: 'Необходимо указать город.',
        isErrorShown: false,
      );
    } else {
      state = state.copyWith(
        isValid: true,
        errorMessage: null,
      );
    }
  }

  Future<void> submitTask() async {
    validateTaskForm();
    if (!state.isValid) {
      return;
    }

    state = state.copyWith(
        isLoading: true, errorMessage: null, isErrorShown: false);

    try {
      final Map<String, dynamic> taskData = {
        "taskName": state.taskName,
        "taskPrice": state.taskPrice,
        "taskTerm": state.taskTerm?.toIso8601String(),
        "taskCity": state.taskCity,
        "taskDescription": state.taskDescription,
      };

      final response = await DioConfig().dio.post(
            '/tasks',
            data: taskData,
          );

      if (response.statusCode == 201) {
        state = state.copyWith(
          isLoading: false,
          successMessage: 'Задача успешно создана!',
          errorMessage: null,
          isErrorShown: false,
        );
        clearTaskForm();
      } else {
        throw Exception("Ошибка при создании задачи: ${response.statusCode}");
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Ошибка при создании задачи: $e',
        isErrorShown: false,
      );
    }
  }

  Future<void> fetchTaskResponses(String taskId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await DioConfig().dio.get(
            '/tasks/$taskId/response',
          );

      if (response.statusCode == 200) {
        final List<dynamic> responses = response.data; // Список откликов
        state = state.copyWith(
          isLoading: false,
          taskResponses: responses, // Обновляем состояние откликов
          errorMessage: null,
        );
      } else {
        throw Exception(
            "Ошибка при получении откликов: ${response.statusCode}");
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Ошибка при получении откликов: $e',
      );
    }
  }

  void clearError() {
    state = state.copyWith(
      errorMessage: null,
      isErrorShown: true, // Помечаем ошибку как обработанную
    );
  }

  Future<void> fetchTasks({String filters = 'tasks'}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // Передача query параметров
      final response = await DioConfig().dio.get(
        '/tasks',
        queryParameters: {
          'filters': filters, // Добавляем фильтры
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> tasks = response.data; // Список задач из ответа
        state = state.copyWith(
          isLoading: false,
          tasks: tasks, // Обновляем состояние задач
          errorMessage: null,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Ошибка при получении задач',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Ошибка при получении задач: $e',
      );
    }
  }
}

final taskNotifierProvider =
    StateNotifierProvider<TaskNotifier, TaskState>((ref) {
  return TaskNotifier();
});
