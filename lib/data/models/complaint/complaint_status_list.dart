// To parse this JSON data, do
//
//     final complaintStatusList = complaintStatusListFromJson(jsonString);

import 'dart:convert';

ComplaintStatusList complaintStatusListFromJson(String str) => ComplaintStatusList.fromJson(json.decode(str));

String complaintStatusListToJson(ComplaintStatusList data) => json.encode(data.toJson());

class ComplaintStatusList {
    bool status;
    String message;
    Data data;

    ComplaintStatusList({
        required this.status,
        required this.message,
        required this.data,
    });

    factory ComplaintStatusList.fromJson(Map<String, dynamic> json) => ComplaintStatusList(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
    };
}

class Data {
    List<StatusList> statusList;

    Data({
        required this.statusList,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        statusList: List<StatusList>.from(json["status_list"].map((x) => StatusList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status_list": List<dynamic>.from(statusList.map((x) => x.toJson())),
    };
}

class StatusList {
    String id;
    String name;

    StatusList({
        required this.id,
        required this.name,
    });

    factory StatusList.fromJson(Map<String, dynamic> json) => StatusList(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
