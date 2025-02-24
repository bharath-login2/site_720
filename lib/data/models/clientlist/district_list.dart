// To parse this JSON data, do
//
//     final districtListModel = districtListModelFromJson(jsonString);

import 'dart:convert';

DistrictListModel districtListModelFromJson(String str) => DistrictListModel.fromJson(json.decode(str));

String districtListModelToJson(DistrictListModel data) => json.encode(data.toJson());

class DistrictListModel {
    List<Districts> data;
    String message;
    bool status;

    DistrictListModel({
        required this.data,
        required this.message,
        required this.status,
    });

    factory DistrictListModel.fromJson(Map<String, dynamic> json) => DistrictListModel(
        data: List<Districts>.from(json["data"].map((x) => Districts.fromJson(x))),
        message: json["message"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "status": status,
    };
}

class Districts {
    String districtId;
    String districtTitle;

    Districts({
        required this.districtId,
        required this.districtTitle,
    });

    factory Districts.fromJson(Map<String, dynamic> json) => Districts(
        districtId: json["district_id"],
        districtTitle: json["district_title"],
    );

    Map<String, dynamic> toJson() => {
        "district_id": districtId,
        "district_title": districtTitle,
    };
}
