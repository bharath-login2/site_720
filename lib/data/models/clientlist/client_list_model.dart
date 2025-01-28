// To parse this JSON data, do
//
//     final clientListModel = clientListModelFromJson(jsonString);

import 'dart:convert';

ClientListModel clientListModelFromJson(String str) => ClientListModel.fromJson(json.decode(str));

String clientListModelToJson(ClientListModel data) => json.encode(data.toJson());

class ClientListModel {
    List<Datum> data;
    String message;
    bool status;

    ClientListModel({
        required this.data,
        required this.message,
        required this.status,
    });

    factory ClientListModel.fromJson(Map<String, dynamic> json) => ClientListModel(
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
    String clientName;
    String projectName;
    String projectStatus;
    String phoneNumber;
    String place;
    String stateId;
    String districtId;
    String stateTitle;
    String districtTitle;

    Datum({
        required this.clientName,
        required this.projectName,
        required this.projectStatus,
        required this.phoneNumber,
        required this.place,
        required this.stateId,
        required this.districtId,
        required this.stateTitle,
        required this.districtTitle,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        clientName: json["client_name"]??"",
        projectName: json["project_name"]??"",
        projectStatus: json["project_status"]??"",
        phoneNumber: json["phone_number"]??"",
        place: json["place"]??"",
        stateId: json["state_id"]??"",
        districtId: json["district_id"]??"",
        stateTitle: json["state_title"]??"",
        districtTitle: json["district_title"]??"",
    );

    Map<String, dynamic> toJson() => {
        "client_name": clientName,
        "project_name": projectName,
        "project_status": projectStatus,
        "phone_number": phoneNumber,
        "place": place,
        "state_id": stateId,
        "district_id": districtId,
        "state_title": stateTitle,
        "district_title": districtTitle,
    };
}


