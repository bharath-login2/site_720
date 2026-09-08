class WorkRequestProject {
  final String id;
  final String clientId;
  final String projectName;

  WorkRequestProject({
    required this.id,
    required this.clientId,
    required this.projectName,
  });

  factory WorkRequestProject.fromJson(Map<String, dynamic> json) {
    return WorkRequestProject(
      id: json['id']?.toString() ?? '',
      clientId: json['client_id']?.toString() ?? '',
      projectName: json['project_name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'project_name': projectName,
    };
  }
}

class WorkRequestProjectResponse {
  final List<WorkRequestProject> data;
  final bool status;
  final String message;

  WorkRequestProjectResponse({
    required this.data,
    required this.status,
    required this.message,
  });

  factory WorkRequestProjectResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return WorkRequestProjectResponse(
      data: json['data'] is List
          ? (json['data'] as List)
              .whereType<Map<String, dynamic>>()
              .map((e) => WorkRequestProject.fromJson(e))
              .toList()
          : [],
      status: json['status'] == true ||
          json['status'] == 'true' ||
          json['status'] == 1,
      message: json['message']?.toString() ?? '',
    );
  }
}