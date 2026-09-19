import 'dart:convert';

StageListModel stageListModelFromJson(String str) =>
    StageListModel.fromJson(json.decode(str));

String stageListModelToJson(StageListModel data) => json.encode(data.toJson());

class StageListModel {
  final List<StageData> data;
  final bool status;
  final String message;

  StageListModel({
    required this.data,
    required this.status,
    required this.message,
  });

  factory StageListModel.fromJson(Map<String, dynamic> json) {
    return StageListModel(
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => StageData.fromJson(e))
              .toList() ??
          [],
      status: json['status'] ?? false,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => e.toJson()).toList(),
      'status': status,
      'message': message,
    };
  }
}

class StageData {
  final String stageId;
  final String stageName;

  StageData({
    required this.stageId,
    required this.stageName,
  });

  factory StageData.fromJson(Map<String, dynamic> json) {
    return StageData(
      stageId: json['stage_id']?.toString() ?? '',
      stageName: json['stage_name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stage_id': stageId,
      'stage_name': stageName,
    };
  }
}
