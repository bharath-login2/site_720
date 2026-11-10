
class ExternalWorkModel {
  bool status;
  String message;
  List<ExternalWorkItem> data;
  ExternalWorkCounts? counts;

  ExternalWorkModel({
    required this.status,
    required this.message,
    required this.data,
    this.counts,
  });

  factory ExternalWorkModel.fromJson(Map<String, dynamic> json) {
    final responseData = json["data"];

    return ExternalWorkModel(
      status: json["status"] ?? false,
      message: json["message"] ?? "",
      data: responseData == null
          ? []
          : List<ExternalWorkItem>.from(
              (responseData["lists"] ?? []).map(
                (x) => ExternalWorkItem.fromJson(x),
              ),
            ),
      counts: responseData?["counts"] != null
          ? ExternalWorkCounts.fromJson(responseData["counts"])
          : null,
    );
  }
}

class ExternalWorkItem {
  String slNo;
  String projectId;
  String projectName;
  String workDate;
  String isWorking;
  String laboursNo;
  String description;
  String workStatus;
  String updatedAt;
  String updateStatus;
  String clientId;

  ExternalWorkItem({
    required this.slNo,
    required this.projectId,
    required this.projectName,
    required this.workDate,
    required this.isWorking,
    required this.laboursNo,
    required this.description,
    required this.workStatus,
    required this.updatedAt,
    required this.updateStatus,
    required this.clientId,
  });

  factory ExternalWorkItem.fromJson(Map<String, dynamic> json) {
    return ExternalWorkItem(
      slNo: json["sl_no"]?.toString() ?? "",
      projectId: json["project_id"]?.toString() ?? "",
      projectName: json["project_name"]?.toString() ?? "",
      workDate: json["work_date"]?.toString() ?? "",
      isWorking: json["is_working"]?.toString() ?? "",
      laboursNo: json["labours_no"]?.toString() ?? "",
      description: json["description"]?.toString() ?? "",
      workStatus: json["work_status"]?.toString() ?? "",
      updatedAt: json["updated_at"]?.toString() ?? "",
      updateStatus: json["update_status"]?.toString() ?? "",
      clientId: json["client_id"]?.toString() ?? "",
    );
  }
}

class ExternalWorkCounts {
  String workDate;
  int totalProjects;
  int updated;
  int pending;
  int scheduled;
  int notScheduled;

  ExternalWorkCounts({
    required this.workDate,
    required this.totalProjects,
    required this.updated,
    required this.pending,
    required this.scheduled,
    required this.notScheduled,
  });

  factory ExternalWorkCounts.fromJson(Map<String, dynamic> json) {
    return ExternalWorkCounts(
      workDate: json["work_date"]?.toString() ?? "",
      totalProjects: _toInt(json["total_projects"]),
      updated: _toInt(json["updated"]),
      pending: _toInt(json["pending"]),
      scheduled: _toInt(json["scheduled"]),
      notScheduled: _toInt(json["not_scheduled"]),
    );
  }

  static int _toInt(dynamic value) {
    return int.tryParse(value?.toString() ?? "") ?? 0;
  }
}
