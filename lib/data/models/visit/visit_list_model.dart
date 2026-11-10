// To parse this JSON data, do
//
//     final listVisitModel = listVisitModelFromJson(jsonString);

import 'dart:convert';
import 'package:intl/intl.dart';

ListVisitModel listVisitModelFromJson(String str) =>
    ListVisitModel.fromJson(json.decode(str));

String listVisitModelToJson(ListVisitModel data) => json.encode(data.toJson());

class ListVisitModel {
  List<VisitItem> data;
  String message;
  bool status;

  ListVisitModel({
    required this.data,
    required this.message,
    required this.status,
  });

  factory ListVisitModel.fromJson(Map<String, dynamic> json) => ListVisitModel(
        data: json["data"] is List
            ? List<VisitItem>.from(
                (json["data"] as List).map((x) => VisitItem.fromJson(x)))
            : [],
        message: json["message"]?.toString() ?? "",
        status: json["status"] == true,
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "status": status,
      };
}

class VisitItem {
  String id;
  String visitId;
  String projectId;
  String taskTitle;
  String staffId;
  DateTime? fromDate;
  DateTime? toDate;
  String description;
  String priority;
  String projectName;
  String stageName;
  String status;

  VisitItem({
    required this.id,
    required this.visitId,
    required this.projectId,
    required this.taskTitle,
    required this.staffId,
    required this.fromDate,
    required this.toDate,
    required this.description,
    required this.priority,
    required this.projectName,
    required this.stageName,
    required this.status,
  });

  static final DateFormat _apiDate = DateFormat('dd-MM-yyyy');

  // API sends dates like "10-11-2026"
  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    final text = value.toString().trim();
    if (text.isEmpty) return null;
    try {
      return _apiDate.parseStrict(text);
    } catch (_) {
      return DateTime.tryParse(text); // fallback for yyyy-MM-dd
    }
  }

  factory VisitItem.fromJson(Map<String, dynamic> json) => VisitItem(
        id: json["id"]?.toString() ?? "",
        visitId: json["visit_id"]?.toString() ?? "",
        projectId: json["project_id"]?.toString() ?? "",
        taskTitle: json["task_title"]?.toString() ?? "",
        staffId: json["staff_id"]?.toString() ?? "",
        fromDate: _parseDate(json["from_date"]),
        toDate: _parseDate(json["to_date"]),
        description: json["description"]?.toString() ?? "",
        priority: json["priority"]?.toString() ?? "",
        projectName: (json["project_name"]?.toString() ?? "").trim(),
        stageName: json["stage_name"]?.toString() ?? "",
        status: json["status"]?.toString() ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "visit_id": visitId,
        "project_id": projectId,
        "task_title": taskTitle,
        "staff_id": staffId,
        "from_date": fromDate == null ? null : _apiDate.format(fromDate!),
        "to_date": toDate == null ? null : _apiDate.format(toDate!),
        "description": description,
        "priority": priority,
        "project_name": projectName,
        "stage_name": stageName,
        "status": status,
      };
}

class StatusModel {
  String id;
  String status;

  StatusModel({
    required this.id,
    required this.status,
  });

  factory StatusModel.fromJson(Map<String, dynamic> json) => StatusModel(
        id: json["id"]?.toString() ?? "",
        status: json["status"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
      };
}
