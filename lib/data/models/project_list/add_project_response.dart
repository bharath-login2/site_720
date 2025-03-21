// To parse this JSON data, do
//
//     final addProjectResponse = addProjectResponseFromJson(jsonString);

import 'dart:convert';

AddProjectResponse addProjectResponseFromJson(String str) => AddProjectResponse.fromJson(json.decode(str));

String addProjectResponseToJson(AddProjectResponse data) => json.encode(data.toJson());

class AddProjectResponse {
    String message;
    bool status;
    Data data;

    AddProjectResponse({
        required this.message,
        required this.status,
        required this.data,
    });

    factory AddProjectResponse.fromJson(Map<String, dynamic> json) => AddProjectResponse(
        message: json["message"],
        status: json["status"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "status": status,
        "data": data.toJson(),
    };
}

class Data {
    bool status;
    String message;
    String userId;
    int insertId;

    Data({
        required this.status,
        required this.message,
        required this.userId,
        required this.insertId,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        status: json["status"],
        message: json["message"],
        userId: json["user_id"],
        insertId: json["insert_id"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "user_id": userId,
        "insert_id": insertId,
    };
}
