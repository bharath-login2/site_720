class SuccessResponseModel {
  final dynamic data;
  final String message;
  final bool status;

  SuccessResponseModel({
    required this.data,
    required this.message,
    required this.status,
  });

  factory SuccessResponseModel.fromJson(Map<String, dynamic> json) {
    final rawStatus = json["status"];

    return SuccessResponseModel(
      data: json["data"],
      message: json["message"] ?? "",
      status: rawStatus is bool
          ? rawStatus
          : rawStatus is int
              ? rawStatus == 1
              : rawStatus is String
                  ? rawStatus.toLowerCase() == "true" || rawStatus == "1"
                  : false,
    );
  }
}
