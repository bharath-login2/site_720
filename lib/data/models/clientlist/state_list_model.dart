// To parse this JSON data, do
//
//     final stateListModel = stateListModelFromJson(jsonString);

import 'dart:convert';

StateListModel stateListModelFromJson(String str) => StateListModel.fromJson(json.decode(str));

String stateListModelToJson(StateListModel data) => json.encode(data.toJson());

class StateListModel {
    List<States> data;
    String message;
    bool status;

    StateListModel({
        required this.data,
        required this.message,
        required this.status,
    });

    factory StateListModel.fromJson(Map<String, dynamic> json) => StateListModel(
        data: List<States>.from(json["data"].map((x) => States.fromJson(x))),
        message: json["message"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "status": status,
    };
}

class States {
    String stateId;
    String stateTitle;

    States({
        required this.stateId,
        required this.stateTitle,
    });

    factory States.fromJson(Map<String, dynamic> json) => States(
        stateId: json["state_id"],
        stateTitle: json["state_title"],
    );

    Map<String, dynamic> toJson() => {
        "state_id": stateId,
        "state_title": stateTitle,
    };
}
