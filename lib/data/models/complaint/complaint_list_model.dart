// To parse this JSON data, do
//
//     final complaintListModel = complaintListModelFromJson(jsonString);

import 'dart:convert';

ComplaintListModel complaintListModelFromJson(String str) =>
    ComplaintListModel.fromJson(json.decode(str));

String complaintListModelToJson(ComplaintListModel data) =>
    json.encode(data.toJson());

class ComplaintListModel {
  List<Datum> data;
  String message;
  bool status;

  ComplaintListModel({
    required this.data,
    required this.message,
    required this.status,
  });

  factory ComplaintListModel.fromJson(Map<String, dynamic> json) =>
      ComplaintListModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        message: json["message"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "status": status,
      };
}

class Datum {
  String complaintNature;
  String description;
  String incidentDate;
  String complaintStatus;
  String natureName;
  String statusName;

  Datum({
    required this.complaintNature,
    required this.description,
    required this.incidentDate,
    required this.complaintStatus,
    required this.natureName,
    required this.statusName,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        complaintNature: json["complaint_nature"],
        description: json["description"],
        incidentDate: json["incident_date"],
        complaintStatus: json["complaint_status"],
        natureName: json["nature_name"],
        statusName: json["status_name"],
      );

  Map<String, dynamic> toJson() => {
        "complaint_nature": complaintNature,
        "description": description,
        "incident_date": incidentDate,
        "complaint_status": complaintStatus,
        "nature_name": natureName,
        "status_name": statusName,
      };
}
