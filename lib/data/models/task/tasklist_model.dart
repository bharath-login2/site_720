// To parse this JSON data, do
//
//     final getTaskList = getTaskListFromJson(jsonString);

import 'dart:convert';

GetTaskList getTaskListFromJson(String str) =>
    GetTaskList.fromJson(json.decode(str));

String getTaskListToJson(GetTaskList data) => json.encode(data.toJson());

class GetTaskList {
  TaskData data;
  String message;
  bool status;

  GetTaskList({
    required this.data,
    required this.message,
    required this.status,
  });

  factory GetTaskList.fromJson(Map<String, dynamic> json) => GetTaskList(
        data: TaskData.fromJson(json["data"]),
        message: json["message"] ?? "",
        status: json["status"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "message": message,
        "status": status,
      };
}

class TaskData {
  List<Tasks> resultData;
  int pendingCount;
  int ongoingCount;
  int completedCount;
  int cancelledCount;

  TaskData({
    required this.resultData,
    required this.pendingCount,
    required this.ongoingCount,
    required this.completedCount,
    required this.cancelledCount,
  });

  factory TaskData.fromJson(Map<String, dynamic> json) => TaskData(
        resultData: json["result_data"] == null
            ? []
            : List<Tasks>.from(
                json["result_data"].map((x) => Tasks.fromJson(x)),
              ),
        pendingCount: json["pending_count"] ?? 0,
        ongoingCount: json["ongoing_count"] ?? 0,
        completedCount: json["completed_count"] ?? 0,
        cancelledCount: json["cancelled_count"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "result_data": List<dynamic>.from(
          resultData.map((x) => x.toJson()),
        ),
        "pending_count": pendingCount,
        "ongoing_count": ongoingCount,
        "completed_count": completedCount,
        "cancelled_count": cancelledCount,
      };
}

// class Tasks {
//   String id;
//   String assignedStaffId;
//   String assignedStaffUserId;
//   String taskTitle;
//   String fromDate;
//   String toDate;
//   String description;
//   String location;
//   String priority;
//   String status;
//   String workType;
//   String staffName;
//   String stageName;

//   Tasks({
//     required this.id,
//     required this.assignedStaffId,
//     required this.assignedStaffUserId,
//     required this.taskTitle,
//     required this.fromDate,
//     required this.toDate,
//     required this.description,
//     required this.location,
//     required this.priority,
//     required this.status,
//     required this.workType,
//     required this.staffName,
//     required this.stageName,
//   });

//   factory Tasks.fromJson(Map<String, dynamic> json) => Tasks(
//         id: json["id"]?.toString() ?? "",
//         assignedStaffId: json["to_staff_id"]?.toString() ?? "",
//         assignedStaffUserId: json["to_user_id"]?.toString() ?? "",
//         taskTitle: json["task_title"]?.toString() ?? "",
//         fromDate: json["from_date"]?.toString() ?? "",
//         toDate: json["to_date"]?.toString() ?? "",
//         description: json["description"]?.toString() ?? "",
//         location: json["location"]?.toString() ?? "",
//         priority: json["priority"]?.toString() ?? "",
//         status: json["status"]?.toString() ?? "",
//         workType: json["work_type"]?.toString() ?? "",
//         staffName: json["staff_name"]?.toString() ?? "",
//         stageName: json["stage_name"]?.toString() ?? "",
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "to_staff_id": assignedStaffId,
//         "to_user_id": assignedStaffUserId,
//         "task_title": taskTitle,
//         "from_date": fromDate,
//         "to_date": toDate,
//         "description": description,
//         "location": location,
//         "priority": priority,
//         "status": status,
//         "work_type": workType,
//         "staff_name": staffName,
//         "stage_name": stageName,
//       };
// }
class Tasks {
  String id;
  String taskTitle;
  String fromDate;
  String toDate;
  String workType;
  String status;
  String staffName;

  Tasks({
    required this.id,
    required this.taskTitle,
    required this.fromDate,
    required this.toDate,
    required this.workType,
    required this.status,
    required this.staffName,
  });

  factory Tasks.fromJson(Map<String, dynamic> json) => Tasks(
        id: json["id"]?.toString() ?? "",
        taskTitle: json["task_title"]?.toString() ?? "",
        fromDate: json["from_date"]?.toString() ?? "",
        toDate: json["to_date"]?.toString() ?? "",
        workType: json["work_type"]?.toString() ?? "",
        status: json["status"]?.toString() ?? "",
        staffName: json["staff_name"]?.toString() ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "task_title": taskTitle,
        "from_date": fromDate,
        "to_date": toDate,
        "work_type": workType,
        "status": status,
        "staff_name": staffName,
      };
}
