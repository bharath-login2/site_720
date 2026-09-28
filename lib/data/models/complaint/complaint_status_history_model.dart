class ComplaintStatusHistoryModel {
  final List<ComplaintStatusHistoryData> data;
  final bool status;
  final String message;

  ComplaintStatusHistoryModel({
    required this.data,
    required this.status,
    required this.message,
  });

  factory ComplaintStatusHistoryModel.fromJson(Map<String, dynamic> json) {
    return ComplaintStatusHistoryModel(
      data: (json['data'] as List<dynamic>?)
              ?.map(
                (e) => ComplaintStatusHistoryData.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      status: json['status'] ?? false,
      message: json['message']?.toString() ?? '',
    );
  }
}

class ComplaintStatusHistoryData {
  final String createdAt;
  final String remarks;
  final String? mediaUrl;
  final String currentSts;
  final String staffName;

  ComplaintStatusHistoryData({
    required this.createdAt,
    required this.remarks,
    this.mediaUrl,
    required this.currentSts,
    required this.staffName,
  });

  factory ComplaintStatusHistoryData.fromJson(
    Map<String, dynamic> json,
  ) {
    return ComplaintStatusHistoryData(
      createdAt: json['created_at']?.toString() ?? '',
      remarks: json['remarks']?.toString() ?? '',
      mediaUrl: json['media_url']?.toString(),
      currentSts: json['current_sts']?.toString() ?? '',
      staffName: json['staff_name']?.toString() ?? '',
    );
  }
}
