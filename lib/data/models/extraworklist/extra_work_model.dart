// To parse this JSON data, do
//
//     final extraWorkListModel = extraWorkListModelFromJson(jsonString);

import 'dart:convert';

ExtraWorkListModel extraWorkListModelFromJson(String str) => ExtraWorkListModel.fromJson(json.decode(str));

String extraWorkListModelToJson(ExtraWorkListModel data) => json.encode(data.toJson());

class ExtraWorkListModel {
    List<ExtraWorkList> data;
    String message;
    bool status;

    ExtraWorkListModel({
        required this.data,
        required this.message,
        required this.status,
    });

    factory ExtraWorkListModel.fromJson(Map<String, dynamic> json) => ExtraWorkListModel(
        data: List<ExtraWorkList>.from(json["data"].map((x) => ExtraWorkList.fromJson(x))),
        message: json["message"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "status": status,
    };
}

class ExtraWorkList {
    String id;
    String workName;
    String amount;
    String description;
     String phaseName;
        String stageName;
           String createdAt;

    ExtraWorkList({
        required this.id,
        required this.workName,
        required this.amount,
        required this.description,
         required this.phaseName,
          required this.stageName,
           required this.createdAt,
    });

    factory ExtraWorkList.fromJson(Map<String, dynamic> json) => ExtraWorkList(
        id: json["id"]??"",
        workName: json["work_name"]??"",
        amount: json["amount"]??"",
        description: json["description"]??"",
           phaseName: json["phase_name"]??"",
              stageName: json["stage_name"]??"",
                 createdAt: json["created_at"]??"",
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "work_name": workName,
        "amount": amount,
        "description": description,
         "phase_name": phaseName,
          "stage_name": stageName,
           "created_at": createdAt,
    };
}
