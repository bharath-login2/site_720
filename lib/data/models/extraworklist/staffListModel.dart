
import 'dart:convert';

class StaffListModel {
    List<StaffList> data;
    String message;
    bool status;

    StaffListModel({
        required this.data,
        required this.message,
        required this.status,
    });

    factory StaffListModel.fromRawJson(String str) => StaffListModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory StaffListModel.fromJson(Map<String, dynamic> json) => StaffListModel(
        data: List<StaffList>.from(json["data"].map((x) => StaffList.fromJson(x))),
        message: json["message"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "status": status,
    };
}

class StaffList {
    String staffId;
    String userId;
    String staffName;

    StaffList({
        required this.staffId,
        required this.userId,
        required this.staffName,
    });

    factory StaffList.fromRawJson(String str) => StaffList.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory StaffList.fromJson(Map<String, dynamic> json) => StaffList(
        staffId: json["staff_id"],
        userId: json["user_id"],
        staffName: json["staff_name"],
    );

    Map<String, dynamic> toJson() => {
        "staff_id": staffId,
        "user_id": userId,
        "staff_name": staffName,
    };
}
