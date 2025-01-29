// To parse this JSON data, do
//
//     final contractorListModel = contractorListModelFromJson(jsonString);

import 'dart:convert';

ContractorListModel contractorListModelFromJson(String str) => ContractorListModel.fromJson(json.decode(str));

String contractorListModelToJson(ContractorListModel data) => json.encode(data.toJson());

class ContractorListModel {
    List<ContractorList> data;
    String message;
    bool status;

    ContractorListModel({
        required this.data,
        required this.message,
        required this.status,
    });

    factory ContractorListModel.fromJson(Map<String, dynamic> json) => ContractorListModel(
        data: List<ContractorList>.from(json["data"].map((x) => ContractorList.fromJson(x))),
        message: json["message"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "status": status,
    };
}

class ContractorList {
    String name;
    String phone;
    String address;

    ContractorList({
        required this.name,
        required this.phone,
        required this.address,
    });

    factory ContractorList.fromJson(Map<String, dynamic> json) => ContractorList(
        name: json["name"],
        phone: json["phone"],
        address: json["address"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "phone": phone,
        "address": address,
    };
}
