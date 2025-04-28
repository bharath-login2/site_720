import 'dart:convert';

TaskDetailsModel taskDetailsModelFromJson(String str) =>
    TaskDetailsModel.fromJson(json.decode(str));

String taskDetailsModelToJson(TaskDetailsModel data) =>
    json.encode(data.toJson());

class TaskDetailsModel {
  TaskDetailsData data;
  String message;
  bool status;

  TaskDetailsModel({
    required this.data,
    required this.message,
    required this.status,
  });

  factory TaskDetailsModel.fromJson(Map<String, dynamic> json) =>
      TaskDetailsModel(
        data: TaskDetailsData.fromJson(json["data"]),
        message: json["message"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "message": message,
        "status": status,
      };
}

class TaskDetailsData {
  String id;
    String comment;
  String taskTitle;
  String fromDate;
  String toDate;
  String description;
  String location;
  String priority;
  String status;
  String workType;
  String stageName;
  String fileName;
  String visitId;
  String siteName;
  List<String> attachments;
  List<SiteVisitQuestion> siteVisitQuestions;

  TaskDetailsData({
    required this.id,
     required this.comment,
    required this.taskTitle,
    required this.fromDate,
    required this.toDate,
    required this.description,
    required this.location,
    required this.priority,
    required this.status,
    required this.workType,
    required this.stageName,
    required this.fileName,
    required this.visitId,
    required this.siteName,
    required this.attachments,
    required this.siteVisitQuestions,
  });

  factory TaskDetailsData.fromJson(Map<String, dynamic> json) =>
      TaskDetailsData(
        id: json["id"] ?? "",
         comment: json["comment"] ?? "",
        taskTitle: json["task_title"] ?? "",
        fromDate: json["from_date"] ?? "",
        toDate: json["to_date"] ?? "",
        description: json["description"] ?? "",
        location: json["location"] ?? "",
        priority: json["priority"] ?? "",
        status: json["status"] ?? "",
        workType: json["work_type"] ?? "",
        stageName: json["stage_name"] ?? "",
        fileName: json["file_name"] ?? "",
        visitId: json["visit_id"] ?? "",
        siteName: json["site_name"] ?? "",
        attachments: json["attachments"] == null
            ? []
            : List<String>.from(json["attachments"].map((x) => x ?? "")),
        siteVisitQuestions: json["site_visit_questions"] == null
            ? []
            : List<SiteVisitQuestion>.from(json["site_visit_questions"]
                .map((x) => SiteVisitQuestion.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "comment": comment,
        "task_title": taskTitle,
        "from_date": fromDate,
        "to_date": toDate,
        "description": description,
        "location": location,
        "priority": priority,
        "status": status,
        "work_type": workType,
        "stage_name": stageName,
        "file_name": fileName,
        "visit_id": visitId,
        "site_name": siteName,
        "attachments": List<dynamic>.from(attachments.map((x) => x)),
        "site_visit_questions":
            List<dynamic>.from(siteVisitQuestions.map((x) => x.toJson())),
      };
}

class SiteVisitQuestion {
  String visitId;
  String questionNumber;
  String question;
  String answerType;
  List<String>? checkboxOptions;

  SiteVisitQuestion({
    required this.visitId,
    required this.questionNumber,
    required this.question,
    required this.answerType,
    this.checkboxOptions,
  });

  factory SiteVisitQuestion.fromJson(Map<String, dynamic> json) =>
      SiteVisitQuestion(
        visitId: json["visit_id"]??"",
        questionNumber: json["question_number"]??"",
        question: json["question"]??"",
        answerType: json["answer_type"]??"",
        checkboxOptions: json["checkbox_options"] == null
            ? null
            : List<String>.from(json["checkbox_options"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "visit_id": visitId,
        "question_number": questionNumber,
        "question": question,
        "answer_type": answerType,
        if (checkboxOptions != null)
          "checkbox_options":
              List<dynamic>.from(checkboxOptions!.map((x) => x)),
      };
}
