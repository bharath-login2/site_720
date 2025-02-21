// To parse this JSON data, do
//
//     final stagePhaseList = stagePhaseListFromJson(jsonString);

import 'dart:convert';

StagePhaseList stagePhaseListFromJson(String str) => StagePhaseList.fromJson(json.decode(str));

String stagePhaseListToJson(StagePhaseList data) => json.encode(data.toJson());

class StagePhaseList {
    List<StagePhase> data;
    String message;
    bool status;

    StagePhaseList({
        required this.data,
        required this.message,
        required this.status,
    });

    factory StagePhaseList.fromJson(Map<String, dynamic> json) => StagePhaseList(
        data: List<StagePhase>.from(json["data"].map((x) => StagePhase.fromJson(x))),
        message: json["message"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "status": status,
    };
}

class StagePhase {
    String id;
    String phaseName;

    StagePhase({
        required this.id,
        required this.phaseName,
    });

    factory StagePhase.fromJson(Map<String, dynamic> json) => StagePhase(
        id: json["id"]??"",
        phaseName: json["phase_name"]??"",
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "phase_name": phaseName,
    };
}
