class GetTaskActivityModel {
  final List<TaskActivity> data;
  final String message;
  final bool status;

  GetTaskActivityModel({
    required this.data,
    required this.message,
    required this.status,
  });

  factory GetTaskActivityModel.fromJson(Map<String, dynamic> json) {
    return GetTaskActivityModel(
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => TaskActivity.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      message: json['message'] as String? ?? '',
      status: json['status'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => e.toJson()).toList(),
      'message': message,
      'status': status,
    };
  }
}

class TaskActivity {
  final String id;
  final String activity;
  final String taskId;
  final String doneBy;
  final String doneById;
  final String dateTime;
  final String companyId;

  TaskActivity({
    required this.id,
    required this.activity,
    required this.taskId,
    required this.doneBy,
    required this.doneById,
    required this.dateTime,
    required this.companyId,
  });

  factory TaskActivity.fromJson(Map<String, dynamic> json) {
    return TaskActivity(
      id: json['id'] as String? ?? '',
      activity: json['activity'] as String? ?? '',
      taskId: json['task_id'] as String? ?? '',
      doneBy: json['done_by'] as String? ?? '',
      doneById: json['done_by_id'] as String? ?? '',
      dateTime: json['date_time'] as String? ?? '',
      companyId: json['company_id'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'activity': activity,
      'task_id': taskId,
      'done_by': doneBy,
      'done_by_id': doneById,
      'date_time': dateTime,
      'company_id': companyId,
    };
  }
}