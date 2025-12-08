// estimate_model.dart
class EstimateModel {
  final bool status;
  final String message;
  final List<EstimateData> data;

  EstimateModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory EstimateModel.fromJson(Map<String, dynamic> json) {
    return EstimateModel(
      status: json["status"] ?? false,
      message: json["message"] ?? "",
      data: (json["data"] as List<dynamic>)
          .map((e) => EstimateData.fromJson(e))
          .toList(),
    );
  }
}

class EstimateData {
  final String totalAmount;
  final String remarks;
  final String createdAt;
  final String staffName;
  final String stageName;

  EstimateData({
    required this.totalAmount,
    required this.remarks,
    required this.createdAt,
    required this.staffName,
    required this.stageName,
  });

  factory EstimateData.fromJson(Map<String, dynamic> json) {
    return EstimateData(
      totalAmount: json["total_amount"] ?? "",
      remarks: json["remarks"] ?? "",
      createdAt: json["created_at"] ?? "",
      staffName: json["staff_name"] ?? "",
      stageName: json["stage_name"] ?? "",
    );
  }
}
