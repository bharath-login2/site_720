import 'dart:convert';

StageDropdownModel stageDropdownModelFromJson(String str) =>
    StageDropdownModel.fromJson(json.decode(str));

class StageDropdownModel {
  bool status;
  String message;
  List<StageData> data;

  StageDropdownModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory StageDropdownModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      StageDropdownModel(
        status: json["status"] ?? false,
        message: json["message"] ?? "",
        data: List<StageData>.from(
          (json["data"] ?? []).map(
            (x) => StageData.fromJson(x),
          ),
        ),
      );
}

class StageData {
  String stageId;
  String stageName;

  StageData({
    required this.stageId,
    required this.stageName,
  });

  factory StageData.fromJson(
    Map<String, dynamic> json,
  ) {
    return StageData(
      stageId: json["stage_id"]?.toString() ?? "",
      stageName: json["stage_name"] ?? "",
    );
  }
}
