// To parse this JSON data, do
//
//     final listVisitModel = listVisitModelFromJson(jsonString);

import 'dart:convert';
import 'package:intl/intl.dart';

ListVisitModel listVisitModelFromJson(String str) =>
    ListVisitModel.fromJson(json.decode(str));

String listVisitModelToJson(ListVisitModel data) => json.encode(data.toJson());

class ListVisitModel {
  List<VisitItem> data; // the items, read from data.lists
  int completedCount;
  int pendingCount;
  int totalCount;
  String message;
  bool status;

  ListVisitModel({
    required this.data,
    this.completedCount = 0,
    this.pendingCount = 0,
    this.totalCount = 0,
    required this.message,
    required this.status,
  });

  static int _toInt(dynamic v) => int.tryParse(v?.toString() ?? '') ?? 0;

  static List<VisitItem> _items(dynamic raw) => raw is List
      ? raw
          .whereType<Map>()
          .map((x) => VisitItem.fromJson(Map<String, dynamic>.from(x)))
          .toList()
      : <VisitItem>[];

  factory ListVisitModel.fromJson(Map<String, dynamic> json) {
    final d = json["data"];

    // New shape: data is an object with counts and "lists".
    if (d is Map) {
      return ListVisitModel(
        data: _items(d["lists"]),
        completedCount: _toInt(d["completed_count"]),
        pendingCount: _toInt(d["pending_count"]),
        totalCount: _toInt(d["total_count"]),
        message: json["message"]?.toString() ?? "",
        status: json["status"] == true,
      );
    }

    // Old shape: data is the list itself.
    return ListVisitModel(
      data: _items(d),
      message: json["message"]?.toString() ?? "",
      status: json["status"] == true,
    );
  }

  Map<String, dynamic> toJson() => {
        "data": {
          "completed_count": completedCount,
          "pending_count": pendingCount,
          "total_count": totalCount,
          "lists": data.map((x) => x.toJson()).toList(),
        },
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
  String staffName;
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
    required this.staffName,
    required this.status,
  });

  static final DateFormat _apiDate = DateFormat('dd-MM-yyyy');

  // API sends dates like "10-11-2026", and "00-00-0000" when there is no date.
  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    final text = value.toString().trim();
    if (text.isEmpty || text.startsWith('00-00') || text.startsWith('0000')) {
      return null;
    }
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
        staffName: json["staff_name"]?.toString() ?? "",
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
        "staff_name": staffName,
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
