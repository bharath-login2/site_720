// To parse this JSON data, do
//
//     final complaintHistoryModel = complaintHistoryModelFromJson(jsonString);
import 'dart:convert';

ComplaintHistoryModel complaintHistoryModelFromJson(String str) => ComplaintHistoryModel.fromJson(json.decode(str));

String complaintHistoryModelToJson(ComplaintHistoryModel data) => json.encode(data.toJson());

class ComplaintHistoryModel {
    final List<ComplaintHistory> data;
    final String message;
    final bool status;

    ComplaintHistoryModel({
        required this.data,
        required this.message,
        required this.status,
    });

    factory ComplaintHistoryModel.fromJson(Map<String, dynamic> json) => ComplaintHistoryModel(
        data: List<ComplaintHistory>.from(json["data"].map((x) => ComplaintHistory.fromJson(x))),
        message: json["message"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "status": status,
    };
}

class ComplaintHistory {
    final String date;
    final String incidentDate;
    final String customerName;
    final String contactNumber;
    final String description;
    final String fileUrl;

    ComplaintHistory({
        required this.date,
         required this.incidentDate,
        required this.customerName,
        required this.contactNumber,
        required this.description,
        required this.fileUrl,
    });

    factory ComplaintHistory.fromJson(Map<String, dynamic> json) => ComplaintHistory(
        date: json["date"]??"",
         incidentDate: json["incident_date"]??"",
        customerName: json["customer_name"]??"",
        contactNumber: json["contact_number"]??"",
        description: json["description"]??"",
        fileUrl: json["file_url"]??"",
    );

    Map<String, dynamic> toJson() => {
        "date": date,
          "incident_date": incidentDate,
        "customer_name": customerName,
        "contact_number": contactNumber,
        "description": description,
        "file_url": fileUrl,
    };
}
