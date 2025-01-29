// To parse this JSON data, do
//
//     final complaintListModel = complaintListModelFromJson(jsonString);

import 'dart:convert';

ComplaintListModel complaintListModelFromJson(String str) => ComplaintListModel.fromJson(json.decode(str));

String complaintListModelToJson(ComplaintListModel data) => json.encode(data.toJson());

class ComplaintListModel {
    List<ComplaintList> data;
    String message;
    bool status;

    ComplaintListModel({
        required this.data,
        required this.message,
        required this.status,
    });

    factory ComplaintListModel.fromJson(Map<String, dynamic> json) => ComplaintListModel(
        data: List<ComplaintList>.from(json["data"].map((x) => ComplaintList.fromJson(x))),
        message: json["message"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "status": status,
    };
}

class ComplaintList {
    String complaintNatureIds;
    String description;
    String incidentDate;
    String complaintStatusId;
    String natureName;
    String statusName;

    ComplaintList({
        required this.complaintNatureIds,
        required this.description,
        required this.incidentDate,
        required this.complaintStatusId,
        required this.natureName,
        required this.statusName,
    });

    factory ComplaintList.fromJson(Map<String, dynamic> json) => ComplaintList(
        complaintNatureIds: json["complaint_nature_ids"],
        description: json["description"],
        incidentDate: json["incident_date"],
        complaintStatusId: json["complaint_status_id"],
        natureName: json["nature_name"],
        statusName: json["status_name"],
    );

    Map<String, dynamic> toJson() => {
        "complaint_nature_ids": complaintNatureIds,
        "description": description,
        "incident_date": incidentDate,
        "complaint_status_id": complaintStatusId,
        "nature_name": natureName,
        "status_name": statusName,
    };
}
