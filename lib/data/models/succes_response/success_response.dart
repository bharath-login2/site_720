// To parse this JSON data, do
//
//     final successResponse = successResponseFromJson(jsonString);

import 'dart:convert';

SuccessResponse successResponseFromJson(String str) => SuccessResponse.fromJson(json.decode(str));

String successResponseToJson(SuccessResponse data) => json.encode(data.toJson());

class SuccessResponse {
    bool data;
    String message;
    bool status;

    SuccessResponse({
        required this.data,
        required this.message,
        required this.status,
    });

    factory SuccessResponse.fromJson(Map<String, dynamic> json) => SuccessResponse(
        data: json["data"],
        message: json["message"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "data": data,
        "message": message,
        "status": status,
    };
}
