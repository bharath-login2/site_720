class VisitTaskResponse {
  final bool status;
  final String message;
  final VisitTaskData? data;

  VisitTaskResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory VisitTaskResponse.fromJson(Map<String, dynamic> json) {
    return VisitTaskResponse(
      status: json['status'] ?? false,
      message: json['message']?.toString() ?? '',
      data: json['data'] != null ? VisitTaskData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.toJson(),
      };
}

class VisitTaskData {
  final int completedCount;
  final int pendingCount;
  final int totalCount;
  final List<VisitTask> lists;

  VisitTaskData({
    required this.completedCount,
    required this.pendingCount,
    required this.totalCount,
    required this.lists,
  });

  factory VisitTaskData.fromJson(Map<String, dynamic> json) {
    return VisitTaskData(
      completedCount: _toInt(json['completed_count']),
      pendingCount: _toInt(json['pending_count']),
      totalCount: _toInt(json['total_count']),
      lists: (json['lists'] as List<dynamic>? ?? [])
          .map((e) => VisitTask.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'completed_count': completedCount,
        'pending_count': pendingCount,
        'total_count': totalCount,
        'lists': lists.map((e) => e.toJson()).toList(),
      };
}

class VisitTask {
  final String id;
  final String visitId;
  final String projectId;
  final String taskTitle;
  final String staffId;
  final String fromDate; // format: dd-MM-yyyy
  final String toDate; // format: dd-MM-yyyy
  final String description;
  final String? priority;
  final String projectName;
  final String stageName;
  final String status;
  final String staffName;

  VisitTask({
    required this.id,
    required this.visitId,
    required this.projectId,
    required this.taskTitle,
    required this.staffId,
    required this.fromDate,
    required this.toDate,
    required this.description,
    this.priority,
    required this.projectName,
    required this.stageName,
    required this.status,
    required this.staffName,
  });

  factory VisitTask.fromJson(Map<String, dynamic> json) {
    return VisitTask(
      id: json['id']?.toString() ?? '',
      visitId: json['visit_id']?.toString() ?? '',
      projectId: json['project_id']?.toString() ?? '',
      taskTitle: json['task_title']?.toString() ?? '',
      staffId: json['staff_id']?.toString() ?? '',
      fromDate: json['from_date']?.toString() ?? '',
      toDate: json['to_date']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      priority: json['priority']?.toString(),
      projectName: json['project_name']?.toString() ?? '',
      stageName: json['stage_name']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      staffName: json['staff_name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'visit_id': visitId,
        'project_id': projectId,
        'task_title': taskTitle,
        'staff_id': staffId,
        'from_date': fromDate,
        'to_date': toDate,
        'description': description,
        'priority': priority,
        'project_name': projectName,
        'stage_name': stageName,
        'status': status,
        'staff_name': staffName,
      };

  bool get isPending => status.toLowerCase() == 'pending';
}

int _toInt(dynamic v) => v is int ? v : int.tryParse(v?.toString() ?? '') ?? 0;

// Usage:
// final response = VisitTaskResponse.fromJson(jsonDecode(body));
// final tasks = response.data?.lists ?? [];