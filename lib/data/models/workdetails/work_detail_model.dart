// To parse this JSON data, do
//
//     final workDetailModel = workDetailModelFromJson(jsonString);

import 'dart:convert';

WorkDetailModel workDetailModelFromJson(String str) => WorkDetailModel.fromJson(json.decode(str));

String workDetailModelToJson(WorkDetailModel data) => json.encode(data.toJson());

class WorkDetailModel {
    List<Datum> data;
    String message;
    bool status;

    WorkDetailModel({
        required this.data,
        required this.message,
        required this.status,
    });

    factory WorkDetailModel.fromJson(Map<String, dynamic> json) => WorkDetailModel(
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
    String clientId;
    String isWorking;
    DateTime workDate;
    String description;
    String workDay;
    String workMonth;
    String workYear;
    String laboursNo;
    String workStatusId;
    String workStatus;
    String workMonthName;

    Datum({
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
        required this.workMonthName,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        clientId: json["client_id"]??"",
        isWorking: json["is_working"]??"",
        workDate: DateTime.parse(json["work_date"]??""),
        description: json["description"]??"",
        workDay: json["work_day"]??"",
        workMonth: json["work_month"]??"",
        workYear: json["work_year"]??"",
        laboursNo: json["labours_no"]??"",
        workStatusId: json["work_status_id"]??"",
        workStatus: json["work_status"]??"",
        workMonthName: json["work_month_name"]??"",
    );

    Map<String, dynamic> toJson() => {
        "client_id": clientId,
        "is_working": isWorking,
        "work_date": "${workDate.year.toString().padLeft(4, '0')}-${workDate.month.toString().padLeft(2, '0')}-${workDate.day.toString().padLeft(2, '0')}",
        "description": description,
        "work_day": workDay,
        "work_month": workMonth,
        "work_year": workYear,
        "labours_no": laboursNo,
        "work_status_id": workStatusId,
        "work_status": workStatus,
        "work_month_name": workMonthName,
    };
}
