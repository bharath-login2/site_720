import 'dart:convert';

ProjectDropdownModel projectDropdownModelFromJson(String str) =>
    ProjectDropdownModel.fromJson(json.decode(str));

class ProjectDropdownModel {
  bool status;
  String message;
  List<ProjectData> data;

  ProjectDropdownModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ProjectDropdownModel.fromJson(Map<String, dynamic> json) =>
      ProjectDropdownModel(
        status: json["status"] ?? false,
        message: json["message"] ?? "",
        data: List<ProjectData>.from(
          (json["data"] ?? []).map(
            (x) => ProjectData.fromJson(x),
          ),
        ),
      );
}

class ProjectData {
  String locationId;
  String projectId;
  String locationName;
  String locationType;

  ProjectData({
    required this.locationId,
    required this.projectId,
    required this.locationName,
    required this.locationType,
  });

  factory ProjectData.fromJson(Map<String, dynamic> json) => ProjectData(
        locationId: json["location_id"]?.toString() ?? "",
        projectId: json["project_id"]?.toString() ?? "",
        locationName: json["location_name"] ?? "",
        locationType: json["location_type"]?.toString() ?? "",
      );
}
