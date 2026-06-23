// To parse this JSON data, do
//
//     final complaintDetailsModel = complaintDetailsModelFromJson(jsonString);

import 'dart:convert';

ComplaintDetailsModel complaintDetailsModelFromJson(String str) =>
    ComplaintDetailsModel.fromJson(json.decode(str));

String complaintDetailsModelToJson(ComplaintDetailsModel data) =>
    json.encode(data.toJson());

class ComplaintDetailsModel {
  Data data;
  String message;
  bool status;

  ComplaintDetailsModel({
    required this.data,
    required this.message,
    required this.status,
  });

  factory ComplaintDetailsModel.fromJson(Map<String, dynamic> json) =>
      ComplaintDetailsModel(
        data: json["data"] != null
            ? Data.fromJson(json["data"])
            : Data(
                reportedBy: [],
                complaintNature: [],
                complaintStatus: [],
                complaintTypes: [],
                staff: []),
        message: json["message"] ?? "",
        status: json["status"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "message": message,
        "status": status,
      };
}

class Data {
  List<ReportedBy> reportedBy;
  List<ComplaintNature> complaintNature;
  List<ComplaintStatus> complaintStatus;
  List<ComplaintType> complaintTypes;
  List<Staff> staff;

  Data({
    required this.reportedBy,
    required this.complaintNature,
    required this.complaintStatus,
    required this.complaintTypes,
    required this.staff,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        reportedBy: json["reported_by"] != null
            ? List<ReportedBy>.from(
                json["reported_by"].map((x) => ReportedBy.fromJson(x)))
            : [],
        complaintNature: json["complaint_nature"] != null
            ? List<ComplaintNature>.from(json["complaint_nature"]
                .map((x) => ComplaintNature.fromJson(x)))
            : [],
        complaintStatus: json["complaint_status"] != null
            ? List<ComplaintStatus>.from(json["complaint_status"]
                .map((x) => ComplaintStatus.fromJson(x)))
            : [],
        complaintTypes: json["complaint_types"] != null
            ? List<ComplaintType>.from(
                json["complaint_types"].map((x) => ComplaintType.fromJson(x)))
            : [],
        staff: json["staff"] != null
            ? List<Staff>.from(json["staff"].map((x) => Staff.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "reported_by": List<dynamic>.from(reportedBy.map((x) => x.toJson())),
        "complaint_nature":
            List<dynamic>.from(complaintNature.map((x) => x.toJson())),
        "complaint_status":
            List<dynamic>.from(complaintStatus.map((x) => x.toJson())),
        "complaint_types":
            List<dynamic>.from(complaintTypes.map((x) => x.toJson())),
        "staff": List<dynamic>.from(staff.map((x) => x.toJson())),
      };
}

class ComplaintNature {
  String id;
  String natureName;

  ComplaintNature({
    required this.id,
    required this.natureName,
  });

  factory ComplaintNature.fromJson(Map<String, dynamic> json) =>
      ComplaintNature(
        id: json["id"]?.toString() ?? "",
        natureName: json["nature_name"]?.toString() ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nature_name": natureName,
      };
}

class ComplaintStatus {
  String id;
  String statusName;

  ComplaintStatus({
    required this.id,
    required this.statusName,
  });

  factory ComplaintStatus.fromJson(Map<String, dynamic> json) =>
      ComplaintStatus(
        id: json["id"]?.toString() ?? "",
        statusName: json["status_name"]?.toString() ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "status_name": statusName,
      };
}

class ComplaintType {
  String id;
  String typeName;
  String description;

  ComplaintType({
    required this.id,
    required this.typeName,
    required this.description,
  });

  factory ComplaintType.fromJson(Map<String, dynamic> json) => ComplaintType(
        id: json["id"]?.toString() ?? "",
        typeName: json["type_name"]?.toString() ?? "",
        description: json["description"]?.toString() ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type_name": typeName,
        "description": description,
      };
}

class ReportedBy {
  String id;
  String reportedBy;

  ReportedBy({
    required this.id,
    required this.reportedBy,
  });

  factory ReportedBy.fromJson(Map<String, dynamic> json) => ReportedBy(
        id: json["id"]?.toString() ?? "",
        reportedBy: json["reported_by"]?.toString() ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "reported_by": reportedBy,
      };
}

class Staff {
  String userId;
  String staffName;

  Staff({
    required this.userId,
    required this.staffName,
  });

  factory Staff.fromJson(Map<String, dynamic> json) => Staff(
        userId: json["user_id"]?.toString() ?? "",
        staffName: json["staff_name"]?.toString() ?? "",
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "staff_name": staffName,
      };
}
