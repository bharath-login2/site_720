// To parse this JSON data, do
//
//     final clientTypeListModel = clientTypeListModelFromJson(jsonString);

import 'dart:convert';

ClientTypeListModel clientTypeListModelFromJson(String str) => ClientTypeListModel.fromJson(json.decode(str));

String clientTypeListModelToJson(ClientTypeListModel data) => json.encode(data.toJson());

class ClientTypeListModel {
    List<ClientTypes> data;
    String message;
    bool status;

    ClientTypeListModel({
        required this.data,
        required this.message,
        required this.status,
    });

    factory ClientTypeListModel.fromJson(Map<String, dynamic> json) => ClientTypeListModel(
        data: List<ClientTypes>.from(json["data"].map((x) => ClientTypes.fromJson(x))),
        message: json["message"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "status": status,
    };
}

class ClientTypes {
    String id;
    String clientType;

    ClientTypes({
        required this.id,
        required this.clientType,
    });

    factory ClientTypes.fromJson(Map<String, dynamic> json) => ClientTypes(
        id: json["id"],
        clientType: json["client_type"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "client_type": clientType,
    };
}
