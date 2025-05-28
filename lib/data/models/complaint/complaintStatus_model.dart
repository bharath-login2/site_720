// To parse this JSON data, do
//
import 'dart:convert';

ComplaintStatusModel complaintStatusModelFromJson(String str) => ComplaintStatusModel.fromJson(json.decode(str));

String complaintStatusModelToJson(ComplaintStatusModel data) => json.encode(data.toJson());

class ComplaintStatusModel {
    List<ComplaintStatus> data;
    String message;
    bool status;

    ComplaintStatusModel({
        required this.data,
        required this.message,
        required this.status,
    });

    factory ComplaintStatusModel.fromJson(Map<String, dynamic> json) => ComplaintStatusModel(
        data: List<ComplaintStatus>.from(json["data"].map((x) => ComplaintStatus.fromJson(x))),
        message: json["message"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "status": status,
    };
}

class ComplaintStatus {
    String id;
    String name;

    ComplaintStatus({
        required this.id,
        required this.name,
    });

    factory ComplaintStatus.fromJson(Map<String, dynamic> json) => ComplaintStatus(
        id: json["id"]??"",
        name: json["name"]??"",
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
