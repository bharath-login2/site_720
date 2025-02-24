// To parse this JSON data, do
//
//     final clientListModel = clientListModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ClientListModel clientListModelFromJson(String str) =>
    ClientListModel.fromJson(json.decode(str));

String clientListModelToJson(ClientListModel data) =>
    json.encode(data.toJson());

class ClientListModel {
  List<Clients> data;
  String message;
  bool status;

  ClientListModel({
    required this.data,
    required this.message,
    required this.status,
  });

  factory ClientListModel.fromJson(Map<String, dynamic> json) =>
      ClientListModel(
        data: List<Clients>.from(json["data"].map((x) => Clients.fromJson(x))),
        message: json["message"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "status": status,
      };
}

class Clients {
  String id;
  String clientName;
  String phoneNumber;
  String address;
  String stateId;
  String districtId;
  String stateTitle;
  String districtTitle;

  Clients({
    required this.id,
    required this.clientName,
    required this.phoneNumber,
    required this.address,
    required this.stateId,
    required this.districtId,
    required this.stateTitle,
    required this.districtTitle,
  });

  factory Clients.fromJson(Map<String, dynamic> json) => Clients(
        id: json["id"] ?? "",
        clientName: json["client_name"] ?? "",
        phoneNumber: json["phone_number"] ?? "",
        address: json["address"] ?? "",
        stateId: json["state_id"] ?? "",
        districtId: json["district_id"] ?? "",
        stateTitle: json["state_title"] ?? "",
        districtTitle: json["district_title"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "client_name": clientName,
        "phone_number": phoneNumber,
        "address": address,
        "state_id": stateId,
        "district_id": districtId,
        "state_title": stateTitle,
        "district_title": districtTitle,
      };
}
