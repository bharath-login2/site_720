// To parse this JSON data, do
//
//     final clientDetailsModel = clientDetailsModelFromJson(jsonString);

import 'dart:convert';

ClientDetailsModel clientDetailsModelFromJson(String str) =>
    ClientDetailsModel.fromJson(json.decode(str));

String clientDetailsModelToJson(ClientDetailsModel data) =>
    json.encode(data.toJson());

class ClientDetailsModel {
  Data data;
  String message;
  bool status;

  ClientDetailsModel({
    required this.data,
    required this.message,
    required this.status,
  });

  factory ClientDetailsModel.fromJson(Map<String, dynamic> json) =>
      ClientDetailsModel(
        data: Data.fromJson(json["data"]),
        message: json["message"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "message": message,
        "status": status,
      };
}

class Data {
  String id;
  String clientName;
  String contactPerson;
  String phoneNumber;
  String whatsappNumber;
  String companyName;
  String emailId;
  String address;
  String civilId;
  String gstNo;
  String stateId;
  String clinetTypeId;
  String stateTitle;
  String districtId;
  String districtTitle;
  String clientType;

  Data({
    required this.id,
    required this.clientName,
    required this.contactPerson,
    required this.phoneNumber,
    required this.whatsappNumber,
    required this.companyName,
    required this.emailId,
    required this.address,
    required this.civilId,
    required this.gstNo,
    required this.stateId,
    required this.clinetTypeId,
    required this.stateTitle,
    required this.districtId,
    required this.districtTitle,
    required this.clientType,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"] ?? "",
        clientName: json["client_name"] ?? "",
        contactPerson: json["contact_person"] ?? "",
        phoneNumber: json["phone_number"] ?? "",
        whatsappNumber: json["whatsapp_number"] ?? "",
        companyName: json["company_name"] ?? "",
        emailId: json["email_id"] ?? "",
        address: json["address"] ?? "",
        civilId: json["civil_id"] ?? "",
        gstNo: json["gst_no"] ?? "",
        stateId: json["state_id"] ?? "",
        clinetTypeId: json["clinet_type_id"] ?? "",
        stateTitle: json["state_title"] ?? "",
        districtId: json["district_id"] ?? "",
        districtTitle: json["district_title"] ?? "",
        clientType: json["client_type"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "client_name": clientName,
        "contact_person": contactPerson,
        "phone_number": phoneNumber,
        "whatsapp_number": whatsappNumber,
        "company_name": companyName,
        "email_id": emailId,
        "address": address,
        "civil_id": civilId,
        "gst_no": gstNo,
        "state_id": stateId,
        "clinet_type_id": clinetTypeId,
        "state_title": stateTitle,
        "district_id": districtId,
        "district_title": districtTitle,
        "client_type": clientType,
      };
}
