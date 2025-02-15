import 'package:app_build_freelance/data/models/customer_models.dart';

class TaskModels {
  final int? id;
  final String? taskName;
  final String? taskDescription;
  final int? taskPrice;
  final DateTime? taskTerm;
  final DateTime? taskCreated;
  final String? taskCity;
  final String? taskStatus;
  final bool? isPublic;
  final CustomerModels? customer;

  TaskModels({
    this.id,
    this.taskName,
    this.taskDescription,
    this.taskPrice,
    this.taskTerm,
    this.taskCreated,
    this.taskCity,
    this.taskStatus,
    this.isPublic,
    this.customer,
  });

  factory TaskModels.fromJson(Map<String, dynamic> json) {
    return TaskModels(
      id: json['id'] as int?,
      taskName: json['taskName'] as String?,
      taskDescription: json['taskDescription'] as String?,
      taskPrice: json['taskPrice'] as int?,
      taskTerm:
          json['taskTerm'] != null ? DateTime.parse(json['taskTerm']) : null,
      taskCreated: json['taskCreated'] != null
          ? DateTime.parse(json['taskCreated'])
          : null,
      taskCity: json['taskCity'] as String?,
      taskStatus: json['taskStatus'] as String?,
      isPublic: json['isPublic'] as bool?,
      customer: json['customer'] != null
          ? CustomerModels.fromJson(json['customer'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'taskName': taskName,
      'taskDescription': taskDescription,
      'taskPrice': taskPrice,
      'taskTerm': taskTerm?.toIso8601String(),
      'taskCreated': taskCreated?.toIso8601String(),
      'taskCity': taskCity,
      'taskStatus': taskStatus,
      'isPublic': isPublic,
      'customer': customer?.toJson(),
    };
  }
}
