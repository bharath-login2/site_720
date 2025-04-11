import 'dart:convert';

WorkStagesModel workStagesModelFromJson(String str) => WorkStagesModel.fromJson(json.decode(str));

String workStagesModelToJson(WorkStagesModel data) => json.encode(data.toJson());

class WorkStagesModel {
    List<Workstage> data;
    String message;
    bool status;

    WorkStagesModel({
        required this.data,
        required this.message,
        required this.status,
    });

    factory WorkStagesModel.fromJson(Map<String, dynamic> json) => WorkStagesModel(
        data: List<Workstage>.from(json["data"].map((x) => Workstage.fromJson(x))),
        message: json["message"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "status": status,
    };
}

class Workstage {
    String stageId;
    String stageName;

    Workstage({
        required this.stageId,
        required this.stageName,
    });

    factory Workstage.fromJson(Map<String, dynamic> json) => Workstage(
        stageId: json["stage_id"],
        stageName: json["stage_name"],
    );

    Map<String, dynamic> toJson() => {
        "stage_id": stageId,
        "stage_name": stageName,
    };
}
