class ProjectWorkModel {
  final Runner? data;
  final String message;
  final bool status;

  ProjectWorkModel({
    required this.data,
    required this.message,
    required this.status,
  });

  factory ProjectWorkModel.fromJson(Map<String, dynamic> json) {
    return ProjectWorkModel(
      data: json['data'] != null ? Runner.fromJson(json['data']) : null,
      message: json['message'] ?? '',
      status: json['status'] ?? false,
    );
  }
}

class Runner {
  final List<Project> project;
  final int pentdingWorks;
  final int totalWorks;

  Runner({
    required this.project,
    required this.pentdingWorks,
    required this.totalWorks,
  });

  factory Runner.fromJson(Map<String, dynamic> json) {
    return Runner(
      project: (json['project'] as List<dynamic>)
          .map((e) => Project.fromJson(e))
          .toList(),
      pentdingWorks: int.tryParse(json['pentding_works'].toString()) ?? 0,
      totalWorks: int.tryParse(json['total_works'].toString()) ?? 0,
    );
  }
}

class Project {
  final String id;
  final String projectName;
   final String clientId;

  Project({
    required this.id,
    required this.projectName,
     required this.clientId,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'].toString(),
      projectName: json['project_name'] ?? '',
        clientId: json['client_id'] ?? '',
    );
  }
}
