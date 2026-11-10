import 'dart:convert';

VisitQuestionsModel visitQuestionsModelFromJson(String str) =>
    VisitQuestionsModel.fromJson(json.decode(str));

class VisitQuestionsModel {
  bool status;
  String message;
  VisitTaskData data;

  VisitQuestionsModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory VisitQuestionsModel.fromJson(Map<String, dynamic> json) =>
      VisitQuestionsModel(
        status: json["status"] == true,
        message: json["message"]?.toString() ?? "",
        data: json["data"] is Map
            ? VisitTaskData.fromJson(Map<String, dynamic>.from(json["data"]))
            : VisitTaskData(taskStatus: "Pending", questions: []),
      );
}

class VisitTaskData {
  String taskStatus;
  List<VisitQuestion> questions;

  VisitTaskData({required this.taskStatus, required this.questions});

  bool get isCompleted => taskStatus.toLowerCase() == "completed";

  factory VisitTaskData.fromJson(Map<String, dynamic> json) => VisitTaskData(
        taskStatus: json["task_status"]?.toString() ?? "Pending",
        questions: json["questions"] is List
            ? (json["questions"] as List)
                .map(
                    (e) => VisitQuestion.fromJson(Map<String, dynamic>.from(e)))
                .toList()
            : [],
      );
}

class VisitQuestion {
  int questionId;
  int questionNumber;
  String question;
  String answerType; // text_box | checkbox | file_upload
  List<String> options;
  bool isRequired;
  String answer;
  String fileName;

  VisitQuestion({
    required this.questionId,
    required this.questionNumber,
    required this.question,
    required this.answerType,
    required this.options,
    required this.isRequired,
    required this.answer,
    required this.fileName,
  });

  static bool _bool(dynamic v) =>
      v == true || v == 1 || v == "1" || v.toString().toLowerCase() == "true";

  factory VisitQuestion.fromJson(Map<String, dynamic> json) => VisitQuestion(
        questionId: int.tryParse(json["question_id"].toString()) ?? 0,
        questionNumber: int.tryParse(json["question_number"].toString()) ?? 0,
        question: json["question"]?.toString() ?? "",
        answerType: json["answer_type"]?.toString() ?? "",
        options: json["checkbox_options"] is List
            ? (json["checkbox_options"] as List)
                .map((e) => e.toString())
                .toList()
            : [],
        isRequired: _bool(json["is_ans_required"]),
        answer: json["answer"]?.toString() ?? "",
        fileName: json["file_name"]?.toString() ?? "",
      );
}
