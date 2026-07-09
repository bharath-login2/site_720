// To parse this JSON data, do
//
//     final complaintListModel = complaintListModelFromJson(jsonString);

import 'dart:convert';

ComplaintListModel complaintListModelFromJson(String str) =>
    ComplaintListModel.fromJson(json.decode(str));

String complaintListModelToJson(ComplaintListModel data) =>
    json.encode(data.toJson());

class ComplaintListModel {
  List<ComplaintList> data;
  String message;
  bool status;

  ComplaintListModel({
    required this.data,
    required this.message,
    required this.status,
  });

  factory ComplaintListModel.fromJson(Map<String, dynamic> json) =>
      ComplaintListModel(
        data: List<ComplaintList>.from(
            json["data"].map((x) => ComplaintList.fromJson(x))),
        message: json["message"] ?? "",
        status: json["status"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "status": status,
      };
}

class ComplaintList {
  String id;
  String customerName;
  String contactNumber;
  String complaintNature;
  String description;
  String incidentDate;
  String complaintStatus;
  String natureName;
  String statusName;
  String reportedBy;

  ComplaintList({
    required this.id,
    required this.customerName,
    required this.contactNumber,
    required this.complaintNature,
    required this.description,
    required this.incidentDate,
    required this.complaintStatus,
    required this.natureName,
    required this.statusName,
    required this.reportedBy,
  });

  factory ComplaintList.fromJson(Map<String, dynamic> json) => ComplaintList(
        id: json["id"] ?? "",
        customerName: json["customer_name"] ?? "",
        contactNumber: json["contact_number"] ?? "",
        complaintNature: json["complaint_nature"] ?? "",
        description: json["description"] ?? "",
        incidentDate: json["incident_date"] ?? "",
        complaintStatus: json["complaint_status"] ?? "",
        natureName: json["nature_name"] ?? "",
        statusName: json["status_name"] ?? "",
        reportedBy: json["reported_by"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_name": customerName,
        "contact_number": contactNumber,
        "complaint_nature": complaintNature,
        "description": description,
        "incident_date": incidentDate,
        "complaint_status": complaintStatus,
        "nature_name": natureName,
        "status_name": statusName,
        "reported_by": reportedBy,
      };
}
