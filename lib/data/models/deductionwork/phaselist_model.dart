// To parse this JSON data, do
//
//     final phaseList = phaseListFromJson(jsonString);

import 'dart:convert';

PhaseList phaseListFromJson(String str) => PhaseList.fromJson(json.decode(str));

String phaseListToJson(PhaseList data) => json.encode(data.toJson());

class PhaseList {
    List<Phases> data;
    String message;
    bool status;

    PhaseList({
        required this.data,
        required this.message,
        required this.status,
    });

    factory PhaseList.fromJson(Map<String, dynamic> json) => PhaseList(
        data: List<Phases>.from(json["data"].map((x) => Phases.fromJson(x))),
        message: json["message"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "status": status,
    };
}

class Phases {
    String id;
    String phaseName;

    Phases({
        required this.id,
        required this.phaseName,
    });

    factory Phases.fromJson(Map<String, dynamic> json) => Phases(
        id: json["id"]??"",
        phaseName: json["phase_name"]??"",
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "phase_name": phaseName,
    };
}
