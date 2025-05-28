import 'dart:convert';

ListVisitDetailsModel listVisitDetailsModelFromJson(String str) =>
    ListVisitDetailsModel.fromJson(json.decode(str));

String listVisitDetailsModelToJson(ListVisitDetailsModel data) =>
    json.encode(data.toJson());

class ListVisitDetailsModel {
  final ListVisitDetailsModelData data;
  final String message;
  final bool status;

  ListVisitDetailsModel({
    required this.data,
    required this.message,
    required this.status,
  });

  factory ListVisitDetailsModel.fromJson(Map<String, dynamic> json) =>
      ListVisitDetailsModel(
        data: ListVisitDetailsModelData.fromJson(json["data"]),
        message: json["message"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "message": message,
        "status": status,
      };
}

class ListVisitDetailsModelData {
  final bool status;
  final String message;
  final DataData data;

  ListVisitDetailsModelData({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ListVisitDetailsModelData.fromJson(Map<String, dynamic> json) =>
      ListVisitDetailsModelData(
        status: json["status"],
        message: json["message"],
        data: DataData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class DataData {
  final VisitDetailsAll visitDetails;
  final List<Question> questions;
  final List<AddedDetails> addedDetails;

  DataData({
    required this.visitDetails,
    required this.questions,
    required this.addedDetails,
  });

  factory DataData.fromJson(Map<String, dynamic> json) => DataData(
        visitDetails: VisitDetailsAll.fromJson(json["visit_details"]),
        questions: json["questions"] != null
            ? List<Question>.from(
                json["questions"].map((x) => Question.fromJson(x)))
            : [],
        addedDetails: json["added_details"] != null
            ? List<AddedDetails>.from(
                json["added_details"].map((x) => AddedDetails.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "visit_details": visitDetails.toJson(),
        "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
        "added_details": List<dynamic>.from(addedDetails.map((x) => x.toJson())),
      };
}

class Question {
  final String questionId;
  final String questionNumber;
  final String question;
  final String answerType;
  final List<String> checkboxOptions;

  Question({
    required this.questionId,
    required this.questionNumber,
    required this.question,
    required this.answerType,
    required this.checkboxOptions,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        questionId: json["question_id"] ?? "",
        questionNumber: json["question_number"] ?? "",
        question: json["question"] ?? "",
        answerType: json["answer_type"] ?? "",
        checkboxOptions: json["checkbox_options"] != null
            ? List<String>.from(json["checkbox_options"].map((x) => x))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "question_id": questionId,
        "question_number": questionNumber,
        "question": question,
        "answer_type": answerType,
        "checkbox_options": List<dynamic>.from(checkboxOptions.map((x) => x)),
      };
}

class VisitDetailsAll {
  final String visitId;
  final String visitName;
  final DateTime fromDate;
  final DateTime toDate;
  final String description;
   final String visitStatus;
  final String priority;
  final String staffName;
  final String projectName;
  final String stageName;
  final String sqftName;
  final String addedQuestionId;
  final String addedQuestionNumber;
  final String addedQuestion;
  final String addedAnswer;

  VisitDetailsAll({
    required this.visitId,
    required this.visitName,
    required this.fromDate,
    required this.toDate,
    required this.description,
    required this.visitStatus,
    required this.priority,
    required this.staffName,
    required this.projectName,
    required this.stageName,
    required this.sqftName,
    required this.addedQuestionId,
    required this.addedQuestionNumber,
    required this.addedQuestion,
    required this.addedAnswer,
  });

  factory VisitDetailsAll.fromJson(Map<String, dynamic> json) =>
      VisitDetailsAll(
        visitId: json["visit_id"] ?? "",
        visitName: json["visit_name"] ?? "",
        fromDate: DateTime.parse(json["from_date"] ?? ""),
        toDate: DateTime.parse(json["to_date"] ?? ""),
        description: json["description"] ?? "",
           visitStatus: json["visit_status"] ?? "",
        priority: json["priority"] ?? "",
        staffName: json["staff_name"] ?? "",
        projectName: json["project_name"] ?? "",
        stageName: json["stage_name"] ?? "",
        sqftName: json["sqft_name"] ?? "",
        addedQuestionId: json["added_question_id"] ?? "",
        addedQuestionNumber: json["added_question_number"] ?? "",
        addedQuestion: json["added_question"] ?? "",
        addedAnswer: json["added_answer"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "visit_id": visitId,
        "visit_name": visitName,
        "from_date":
            "${fromDate.year.toString().padLeft(4, '0')}-${fromDate.month.toString().padLeft(2, '0')}-${fromDate.day.toString().padLeft(2, '0')}",
        "to_date":
            "${toDate.year.toString().padLeft(4, '0')}-${toDate.month.toString().padLeft(2, '0')}-${toDate.day.toString().padLeft(2, '0')}",
        "description": description,
         "visit_status": visitStatus,
        "priority": priority,
        "staff_name": staffName,
        "project_name": projectName,
        "stage_name": stageName,
        "sqft_name": sqftName,
        "added_question_id": addedQuestionId,
        "added_question_number": addedQuestionNumber,
        "added_question": addedQuestion,
        "added_answer": addedAnswer,
      };
}

class AddedDetails {
  final String addedQuestionId;
  final String addedQuestionNumber;
  final String addedQuestion;
  final String addedAnswer;

  AddedDetails({
    required this.addedQuestionId,
    required this.addedQuestionNumber,
    required this.addedQuestion,
    required this.addedAnswer,
  });

  factory AddedDetails.fromJson(Map<String, dynamic> json) => AddedDetails(
        addedQuestionId: json["added_question_id"] ?? "",
        addedQuestionNumber: json["added_question_number"] ?? "",
        addedQuestion: json["added_question"] ?? "",
        addedAnswer: json["added_answer"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "added_question_id": addedQuestionId,
        "added_question_number": addedQuestionNumber,
        "added_question": addedQuestion,
        "added_answer": addedAnswer,
      };
}
