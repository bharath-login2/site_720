// To parse this JSON data, do
//
//     final projectDetailsModel = projectDetailsModelFromJson(jsonString);

import 'dart:convert';

ProjectDetailsModel projectDetailsModelFromJson(String str) => ProjectDetailsModel.fromJson(json.decode(str));

String projectDetailsModelToJson(ProjectDetailsModel data) => json.encode(data.toJson());

class ProjectDetailsModel {
    Data data;
    String message;
    bool status;

    ProjectDetailsModel({
        required this.data,
        required this.message,
        required this.status,
    });

    factory ProjectDetailsModel.fromJson(Map<String, dynamic> json) => ProjectDetailsModel(
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
    String id;
    String clientId;
    String projectName;
    String projectId;
    String location;
    String locationArea;
    String cctvId;
    String clientName;
    String phoneNumber;
    String address;
    String totalEstimateAmount;
    String startingDate;
    String completionDate;
    String totalWorked;
    String unassignedWorks;
    String companyIssue;
    String companyIssueCount;
    String clientIssue;
    String clientIssueCount;
    String paymentPending;
    String paymentPendingCount;
    String generalIssue;
    String generalIssueCount;
    String elevationImage;
    String planImage;

    Data({
        required this.id,
        required this.clientId,
        required this.projectName,
        required this.projectId,
        required this.location,
        required this.locationArea,
        required this.cctvId,
        required this.clientName,
        required this.phoneNumber,
        required this.address,
        required this.totalEstimateAmount,
        required this.startingDate,
        required this.completionDate,
        required this.totalWorked,
        required this.unassignedWorks,
        required this.companyIssue,
        required this.companyIssueCount,
        required this.clientIssue,
        required this.clientIssueCount,
        required this.paymentPending,
        required this.paymentPendingCount,
        required this.generalIssue,
        required this.generalIssueCount,
        required this.elevationImage,
        required this.planImage,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"]??"",
        clientId: json["client_id"]??"",
        projectName: json["project_name"]??"",
        projectId: json["project_id"]??"",
        location: json["location"]??"",
        locationArea: json["location_area"]??"",
        cctvId: json["cctv_id"]??"",
        clientName: json["client_name"]??"",
        phoneNumber: json["phone_number"]??"",
        address: json["address"]??"",
        totalEstimateAmount: json["total_estimate_amount"]??"",
        startingDate: json["starting_date"]??"",
        completionDate: json["completion_date"]??"",
        totalWorked: json["total_worked"]??"",
        unassignedWorks: json["unassigned_works"]??"",
        companyIssue: json["company_issue"]??"",
        companyIssueCount: json["company_issue_count"]??"",
        clientIssue: json["client_issue"]??"",
        clientIssueCount: json["client_issue_count"]??"",
        paymentPending: json["payment_pending"]??"",
        paymentPendingCount: json["payment_pending_count"]??"",
        generalIssue: json["general_issue"]??"",
        generalIssueCount: json["general_issue_count"]??"",
        elevationImage: json["elevation_image"]??"",
        planImage: json["plan_image"]??"",
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "client_id": clientId,
        "project_name": projectName,
        "project_id": projectId,
        "location": location,
        "location_area": locationArea,
        "cctv_id": cctvId,
        "client_name": clientName,
        "phone_number": phoneNumber,
        "address": address,
        "total_estimate_amount": totalEstimateAmount,
        "starting_date": startingDate,
        "completion_date": completionDate,
        "total_worked": totalWorked,
        "unassigned_works": unassignedWorks,
        "company_issue": companyIssue,
        "company_issue_count": companyIssueCount,
        "client_issue": clientIssue,
        "client_issue_count": clientIssueCount,
        "payment_pending": paymentPending,
        "payment_pending_count": paymentPendingCount,
        "general_issue": generalIssue,
        "general_issue_count": generalIssueCount,
        "elevation_image": elevationImage,
        "plan_image": planImage,
    };
}
