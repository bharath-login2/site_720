import 'dart:convert';
import 'dart:developer';

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
  String answeredBy;
  List<VisitQuestion> questions;

  VisitTaskData({
    required this.taskStatus,
    this.answeredBy = "",
    required this.questions,
  });

  bool get isCompleted => taskStatus.toLowerCase() == "completed";

  factory VisitTaskData.fromJson(Map<String, dynamic> json) => VisitTaskData(
        taskStatus: json["task_status"]?.toString() ?? "Pending",
        answeredBy: json["answered_by"]?.toString() ?? "",
        questions: json["questions"] is List
            ? (json["questions"] as List)
                .map(
                    (e) => VisitQuestion.fromJson(Map<String, dynamic>.from(e)))
                .toList()
            : [],
      );
}

/// One uploaded file. Accepts either a plain string or an object.
/// One uploaded file. Accepts either a plain string or an object.
class VisitFile {
  final String id;
  final String name;
  final String url;

  VisitFile({required this.id, required this.name, required this.url});

  static String _firstOf(Map<String, dynamic> m, List<String> keys) {
    for (final k in keys) {
      final v = m[k]?.toString().trim() ?? "";
      if (v.isNotEmpty) return v;
    }
    return "";
  }

  static String _lastSegment(String s) {
    final clean = s.split('?').first;
    return clean.split('/').last;
  }

  static bool _isLink(String s) =>
      s.startsWith('http://') || s.startsWith('https://');

  factory VisitFile.fromJson(dynamic e) {
    if (e is Map) {
      final m = Map<String, dynamic>.from(e);
      var url = _firstOf(m, ['url', 'file_url', 'path', 'file_path']);
      var name = _firstOf(
          m, ['name', 'filename', 'original_name', 'file', 'file_name']);

      // Your API sends the full link inside "file_name".
      if (url.isEmpty && _isLink(name)) url = name;
      // Show only the file name, not the whole link.
      if (_isLink(name)) name = _lastSegment(name);
      if (name.isEmpty && url.isNotEmpty) name = _lastSegment(url);

      return VisitFile(
        id: _firstOf(m, ['id', 'file_id']),
        name: name,
        url: url,
      );
    }
    final s = e?.toString().trim() ?? "";
    return VisitFile(
      id: "",
      name: _lastSegment(s),
      url: _isLink(s) ? s : "",
    );
  }
}

class VisitQuestion {
  int questionId;
  int questionNumber;
  String question;
  String answerType; // text_box | checkbox | file_upload
  List<String> options;
  bool isRequired;
  String answer;
  List<VisitFile> files;

  VisitQuestion({
    required this.questionId,
    required this.questionNumber,
    required this.question,
    required this.answerType,
    required this.options,
    required this.isRequired,
    required this.answer,
    required this.files,
  });

  /// Kept so the screen's existing `q.fileName` code still works.
  /// Multiple files are shown joined with commas.
  String get fileName =>
      files.map((f) => f.name).where((n) => n.isNotEmpty).join(", ");

  bool get hasFiles => files.isNotEmpty;

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
        files: json["files"] is List
            ? (json["files"] as List)
                .map((e) => VisitFile.fromJson(e))
                .where((f) => f.name.isNotEmpty || f.url.isNotEmpty)
                .toList()
            : [],
      );
}
