// To parse this JSON data, do
//
//     final visitHistoryDetailsModel = visitHistoryDetailsModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

VisitHistoryDetailsModel visitHistoryDetailsModelFromJson(String str) => VisitHistoryDetailsModel.fromJson(json.decode(str));

String visitHistoryDetailsModelToJson(VisitHistoryDetailsModel data) => json.encode(data.toJson());

class VisitHistoryDetailsModel {
    final Data data;
    final String message;
    final bool status;

    VisitHistoryDetailsModel({
        required this.data,
        required this.message,
        required this.status,
    });

    factory VisitHistoryDetailsModel.fromJson(Map<String, dynamic> json) => VisitHistoryDetailsModel(
        data: Data.fromJson(json["data"]),
        message: json["message"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "message": message,
        "status": status,
    };
}

class Data {
    final bool status;
    final String message;
    final List<VisitHistoryMode> data;

    Data({
        required this.status,
        required this.message,
        required this.data,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        status: json["status"],
        message: json["message"],
        data: List<VisitHistoryMode>.from(json["data"].map((x) => VisitHistoryMode.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class VisitHistoryMode {
     final String fileType;
    final String questionId;
    final String questionNumber;
    final String question;
    final String answer;
    final String filePath;

    VisitHistoryMode({
       required this.fileType,
        required this.questionId,
        required this.questionNumber,
        required this.question,
        required this.answer,
        required this.filePath,
    });

    factory VisitHistoryMode.fromJson(Map<String, dynamic> json) => VisitHistoryMode(
         fileType: json["file_type"]??"",
        questionId: json["question_id"]??"",
        questionNumber: json["question_number"]??"",
        question: json["question"]??"",
        answer: json["answer"]??"",
        filePath: json["file_path"]??"",
    );

    Map<String, dynamic> toJson() => {
         "file_type": fileType,
        "question_id": questionId,
        "question_number": questionNumber,
        "question": question,
        "answer": answer,
        "file_path": filePath,
    };
}
