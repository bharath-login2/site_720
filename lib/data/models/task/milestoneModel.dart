// To parse this JSON data, do
//
//     final milestoneModel = milestoneModelFromJson(jsonString);
import 'dart:convert';

MilestoneModel milestoneModelFromJson(String str) => MilestoneModel.fromJson(json.decode(str));

String milestoneModelToJson(MilestoneModel data) => json.encode(data.toJson());

class MilestoneModel {
    final List<Milestone> data;
    final String message;
    final bool status;

    MilestoneModel({
        required this.data,
        required this.message,
        required this.status,
    });

    factory MilestoneModel.fromJson(Map<String, dynamic> json) => MilestoneModel(
        data: List<Milestone>.from(json["data"].map((x) => Milestone.fromJson(x))),
        message: json["message"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "status": status,
    };
}

class Milestone {
    final String id;
    final String milestone;

    Milestone({
        required this.id,
        required this.milestone,
    });

    factory Milestone.fromJson(Map<String, dynamic> json) => Milestone(
        id: json["id"]??"",
        milestone: json["milestone"]??"",
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "milestone": milestone,
    };
}
