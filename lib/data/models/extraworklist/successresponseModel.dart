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
    return SuccessResponseModel(
      data: json["data"],
      message: json["message"] ?? "",
      status: json["status"] is bool
          ? json["status"]
          : json["status"] == 1,   // handle int also
    );
  }
}
