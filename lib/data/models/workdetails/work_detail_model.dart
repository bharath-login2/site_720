// To parse this JSON data, do
//
//     final workDetailModel = workDetailModelFromJson(jsonString);

import 'dart:convert';

WorkDetailModel workDetailModelFromJson(String str) => WorkDetailModel.fromJson(json.decode(str));

String workDetailModelToJson(WorkDetailModel data) => json.encode(data.toJson());

class WorkDetailModel {
    List<WorkDetails> data;
    String message;
    bool status;

    WorkDetailModel({
        required this.data,
        required this.message,
        required this.status,
    });

    factory WorkDetailModel.fromJson(Map<String, dynamic> json) => WorkDetailModel(
        data: List<WorkDetails>.from(json["data"].map((x) => WorkDetails.fromJson(x))),
        message: json["message"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "status": status,
    };
}

class WorkDetails {
    String id;
    String clientId;
    String isWorking;
    String workDate;
    String description;
    String workDay;
    String workMonth;
    String workYear;
    String laboursNo;
    String workStatusId;
    String workStatus;
    String createdBy;
    String stageName;
    String stageId;
    String workMonthName;

    WorkDetails({
        required this.id,
        required this.clientId,
        required this.isWorking,
        required this.workDate,
        required this.description,
        required this.workDay,
        required this.workMonth,
        required this.workYear,
        required this.laboursNo,
        required this.workStatusId,
        required this.workStatus,
        required this.createdBy,
         required this.stageName,
          required this.stageId,
        required this.workMonthName,
    });

    factory WorkDetails.fromJson(Map<String, dynamic> json) => WorkDetails(
        id: json["id"]??"",
        clientId: json["client_id"]??"",
        isWorking: json["is_working"]??"",
        workDate: json["work_date"]??"",
        description: json["description"]??"",
        workDay: json["work_day"]??"",
        workMonth: json["work_month"]??"",
        workYear: json["work_year"]??"",
        laboursNo: json["labours_no"]??"",
        workStatusId: json["work_status_id"]??"",
        workStatus: json["work_status"]??"",
         createdBy: json["created_by"]??"",
         stageName: json["stage_name"]??"",
          stageId: json["stage_id"]??"",
        workMonthName: json["work_month_name"]??"",
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "client_id": clientId,
        "is_working": isWorking,
        "work_date": workDate,
        "description": description,
        "work_day": workDay,
        "work_month": workMonth,
        "work_year": workYear,
        "labours_no": laboursNo,
        "work_status_id": workStatusId,
        "work_status": workStatus,
         "created_by": createdBy,
          "stage_name": stageName,
           "stage_id": stageId,
        "work_month_name": workMonthName,
    };
}
