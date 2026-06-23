import 'dart:convert';

class ExternalWorkModel {
  bool status;
  String message;
  List<ExternalWorkItem> data;

  ExternalWorkModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ExternalWorkModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ExternalWorkModel(
      status: json["status"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null
          ? []
          : List<ExternalWorkItem>.from(
              json["data"].map(
                (x) => ExternalWorkItem.fromJson(x),
              ),
            ),
    );
  }
}

class ExternalWorkItem {
  String slNo;
  String clientId;
  String projectId;
  String projectName;
  String workDate;
  String isWorking;
  String laboursNo;
  String description;
  String workStatus;
  String updatedAt;
  String updateStatus;

  ExternalWorkItem({
    required this.slNo,
    required this.clientId,
    required this.projectId,
    required this.projectName,
    required this.workDate,
    required this.isWorking,
    required this.laboursNo,
    required this.description,
    required this.workStatus,
    required this.updatedAt,
    required this.updateStatus,
  });

  factory ExternalWorkItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return ExternalWorkItem(
      slNo: json["sl_no"]?.toString() ?? "",
      clientId: json["client_id"]?.toString() ?? "",
      projectId: json["project_id"]?.toString() ?? "",
      projectName: json["project_name"]?.toString() ?? "",
      workDate: json["work_date"]?.toString() ?? "",
      isWorking: json["is_working"]?.toString() ?? "",
      laboursNo: json["labours_no"]?.toString() ?? "",
      description: json["description"]?.toString() ?? "",
      workStatus: json["work_status"]?.toString() ?? "",
      updatedAt: json["updated_at"]?.toString() ?? "",
      updateStatus: json["update_status"]?.toString() ?? "",
    );
  }
}
