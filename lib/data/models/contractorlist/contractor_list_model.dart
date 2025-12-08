// To parse this JSON data, do
//
//     final contractorListModel = contractorListModelFromJson(jsonString);

import 'dart:convert';

ContractorListModel contractorListModelFromJson(String str) =>
    ContractorListModel.fromJson(json.decode(str));

String contractorListModelToJson(ContractorListModel data) =>
    json.encode(data.toJson());

class ContractorListModel {
  List<ContractorList> data;
  String message;
  bool status;

  ContractorListModel({
    required this.data,
    required this.message,
    required this.status,
  });

  factory ContractorListModel.fromJson(Map<String, dynamic> json) =>
      ContractorListModel(
        data: List<ContractorList>.from(
            json["data"].map((x) => ContractorList.fromJson(x))),
        message: json["message"] ?? "",
        status: json["status"] ?? false,
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
  String subContractWorkName;
  String stageName;
  String totalEstimatedAmount;
  String paidAmount;

  ContractorList({
    required this.name,
    required this.phone,
    required this.address,
    required this.subContractWorkName,
    required this.stageName,
    required this.totalEstimatedAmount,
    required this.paidAmount,
  });

  factory ContractorList.fromJson(Map<String, dynamic> json) => ContractorList(
        name: json["name"] ?? "",
        phone: json["phone"] ?? "",
        address: json["address"] ?? "",
        subContractWorkName: json["subcontract_work_name"] ?? "",
        stageName: json["stage_name"] ?? "",
        totalEstimatedAmount: json["total_estimated_amount"] ?? "",
        paidAmount: json["paid_amount"]?.toString() ?? "", // handles null
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "phone": phone,
        "address": address,
        "subcontract_work_name": subContractWorkName,
        "stage_name": stageName,
        "total_estimated_amount": totalEstimatedAmount,
        "paid_amount": paidAmount,
      };
}
