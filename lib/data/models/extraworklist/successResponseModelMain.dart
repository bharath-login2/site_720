class SuccessResponseMain {
  final bool status;
  final String message;
  dynamic data;

  SuccessResponseMain({
    required this.status,
    required this.message,
    this.data,
  });

  factory SuccessResponseMain.fromJson(
    Map<String, dynamic> json,
  ) {
    return SuccessResponseMain(
      status: json["status"] ?? false,
      message: json["message"] ?? "",
      data: json["data"],
    );
  }
}
