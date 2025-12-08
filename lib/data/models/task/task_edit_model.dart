import 'dart:convert';

TaskEditModel taskEditModelFromJson(String str) =>
    TaskEditModel.fromJson(json.decode(str));

String taskEditModelToJson(TaskEditModel data) =>
    json.encode(data.toJson());

class TaskEditModel {
  TaskEditData data;
  String message;
  bool status;

  TaskEditModel({
    required this.data,
    required this.message,
    required this.status,
  });

  factory TaskEditModel.fromJson(Map<String, dynamic> json) =>
      TaskEditModel(
        data: TaskEditData.fromJson(json["data"]),
        message: json["message"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "message": message,
        "status": status,
      };
}

class TaskEditData {
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
  String officeCategoryName;
  String siteCategoryName;
  String staffName;
  List<Milestone> milestones; // Changed from String to List<Milestone>
  String projectName;
  List<Attachment> attachments; // Changed from List<String> to List<Attachment>
  List<SiteVisitQuestion> siteVisitQuestions;
  String daysLeft;

  TaskEditData({
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
    required this.officeCategoryName,
    required this.siteCategoryName,
    required this.staffName,
    required this.milestones,
    required this.projectName,
    required this.attachments,
    required this.siteVisitQuestions,
    required this.daysLeft,
  });

  factory TaskEditData.fromJson(Map<String, dynamic> json) =>
      TaskEditData(
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
        officeCategoryName: json["office_category_name"] ?? "",
        siteCategoryName: json["site_category_name"] ?? "",
        staffName: json["staff_name"] ?? "",
        milestones: json["milestones"] == null
            ? []
            : List<Milestone>.from(
                json["milestones"].map((x) => Milestone.fromJson(x))),
        projectName: json["project_name"] ?? "",
        attachments: json["attachments"] == null
            ? []
            : List<Attachment>.from(
                json["attachments"].map((x) => Attachment.fromJson(x))),
        siteVisitQuestions: json["site_visit_questions"] == null
            ? []
            : List<SiteVisitQuestion>.from(json["site_visit_questions"]
                .map((x) => SiteVisitQuestion.fromJson(x))),
        daysLeft: json["days_left"] ?? "",
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
        "office_category_name": officeCategoryName,
        "site_category_name": siteCategoryName,
        "staff_name": staffName,
        "milestones": List<dynamic>.from(milestones.map((x) => x.toJson())),
        "project_name": projectName,
        "attachments": List<dynamic>.from(attachments.map((x) => x.toJson())),
        "site_visit_questions":
            List<dynamic>.from(siteVisitQuestions.map((x) => x.toJson())),
        "days_left": daysLeft,
      };

  // Helper method to get milestone string (for backward compatibility)
  String get mileStonesString => 
      milestones.map((m) => m.milestone).join(', ');
}

class Attachment {
  String id;
  String url;

  Attachment({
    required this.id,
    required this.url,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
        id: json["id"]?.toString() ?? "",
        url: json["url"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
      };
}

class Milestone {
  String id;
  String milestone;

  Milestone({
    required this.id,
    required this.milestone,
  });

  factory Milestone.fromJson(Map<String, dynamic> json) => Milestone(
        id: json["id"]?.toString() ?? "",
        milestone: json["milestone"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "milestone": milestone,
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