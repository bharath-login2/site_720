// To parse this JSON data, do
//
//     final getDeductionWork = getDeductionWorkFromJson(jsonString);

import 'dart:convert';

GetDeductionWork getDeductionWorkFromJson(String str) => GetDeductionWork.fromJson(json.decode(str));

String getDeductionWorkToJson(GetDeductionWork data) => json.encode(data.toJson());

class GetDeductionWork {
    List<DeductionWorkist> data;
    String message;
    bool status;

    GetDeductionWork({
        required this.data,
        required this.message,
        required this.status,
    });

    factory GetDeductionWork.fromJson(Map<String, dynamic> json) => GetDeductionWork(
        data: List<DeductionWorkist>.from(json["data"].map((x) => DeductionWorkist.fromJson(x))),
        message: json["message"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "status": status,
    };
}

class DeductionWorkist {
    String id;
    String workName;
    String percentage;
    String phaseId;
    String amount;
    String description;
    DateTime createdAt;
    String stageName;
    String phaseName;

    DeductionWorkist({
        required this.id,
        required this.workName,
        required this.percentage,
        required this.phaseId,
        required this.amount,
        required this.description,
        required this.createdAt,
        required this.stageName,
        required this.phaseName,
    });

    factory DeductionWorkist.fromJson(Map<String, dynamic> json) => DeductionWorkist(
        id: json["id"]??"",
        workName: json["work_name"]??"",
        percentage: json["percentage"]??"",
        phaseId: json["phase_id"]??"",
        amount: json["amount"]??"",
        description: json["description"]??"",
        createdAt: DateTime.parse(json["created_at"]),
        stageName: json["stage_name"]??"",
        phaseName: json["phase_name"]??"",
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "work_name": workName,
        "percentage": percentage,
        "phase_id": phaseId,
        "amount": amount,
        "description": description,
        "created_at": createdAt.toIso8601String(),
        "stage_name": stageName,
        "phase_name": phaseName,
    };
}
