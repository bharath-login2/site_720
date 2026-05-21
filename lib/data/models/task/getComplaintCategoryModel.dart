class GetComplaintCategoryModel {
  final List<dynamic> data;
  final String message;
  final bool status;

  GetComplaintCategoryModel({
    required this.data,
    required this.message,
    required this.status,
  });

  factory GetComplaintCategoryModel.fromJson(Map<String, dynamic> json) {
    return GetComplaintCategoryModel(
      data: json['data'] != null ? List<dynamic>.from(json['data']) : [],
      message: json['message'] ?? '',
      status: json['status'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'message': message,
      'status': status,
    };
  }
}