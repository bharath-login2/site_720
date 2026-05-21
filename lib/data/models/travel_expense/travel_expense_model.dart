import 'dart:convert';

TravelExpenseModel travelExpenseModelFromJson(String str) =>
    TravelExpenseModel.fromJson(json.decode(str));

String travelExpenseModelToJson(TravelExpenseModel data) =>
    json.encode(data.toJson());

class TravelExpenseModel {
  bool status;
  String message;
  TravelExpenseData data;

  TravelExpenseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory TravelExpenseModel.fromJson(Map<String, dynamic> json) =>
      TravelExpenseModel(
        status: json["status"] ?? false,
        message: json["message"] ?? "",
        data: TravelExpenseData.fromJson(json["data"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class TravelExpenseData {
  int totalRequest;
  int pendingRequest;
  int approvedRequest;
  int rejectedRequest;
  List<TravelExpenseItem> travelExpenseList;

  TravelExpenseData({
    required this.totalRequest,
    required this.pendingRequest,
    required this.approvedRequest,
    required this.rejectedRequest,
    required this.travelExpenseList,
  });

  factory TravelExpenseData.fromJson(Map<String, dynamic> json) =>
      TravelExpenseData(
        totalRequest: json["total_request"] ?? 0,
        pendingRequest: json["pending_request"] ?? 0,
        approvedRequest: json["approved_request"] ?? 0,
        rejectedRequest: json["rejected_request"] ?? 0,
        travelExpenseList: json["travel_expense_list"] == null
            ? []
            : List<TravelExpenseItem>.from(
                json["travel_expense_list"]
                    .map((x) => TravelExpenseItem.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
        "total_request": totalRequest,
        "pending_request": pendingRequest,
        "approved_request": approvedRequest,
        "rejected_request": rejectedRequest,
        "travel_expense_list":
            List<dynamic>.from(travelExpenseList.map((x) => x.toJson())),
      };
}

class TravelExpenseItem {
  int sl;
  String travelId;
  String name;
  String date;
  String from;
  String to;
  String km;
  String status;
  String remark;
  String totalAmount;
  String vehicleType;
  String vehicleId;
  List<dynamic> files;

  TravelExpenseItem({
    required this.sl,
    required this.travelId,
    required this.name,
    required this.date,
    required this.from,
    required this.to,
    required this.km,
    required this.status,
    required this.remark,
    required this.totalAmount,
    required this.vehicleType,
    required this.vehicleId,
    required this.files,
  });

  factory TravelExpenseItem.fromJson(
    Map<String, dynamic> json,
  ) =>
      TravelExpenseItem(
        sl: json["sl"] ?? 0,
        travelId: json["travel_id"]?.toString() ?? "",
        name: json["name"] ?? "",
        date: json["date"] ?? "",
        from: json["from"] ?? "",
        to: json["to"] ?? "",
        km: json["km"]?.toString() ?? "",
        status: json["status"] ?? "",
        remark: json["remark"] ?? "",
        totalAmount: json["total_amount"]?.toString() ?? "",
        vehicleType: json["vehicle_type"]?.toString() ?? "",
        vehicleId: json["vehicle_id"]?.toString() ?? "",
        files: json["files"] == null
            ? []
            : List<dynamic>.from(
                json["files"].map((x) => x),
              ),
      );

  Map<String, dynamic> toJson() => {
        "sl": sl,
        "travel_id": travelId,
        "name": name,
        "date": date,
        "from": from,
        "to": to,
        "km": km,
        "status": status,
        "remark": remark,
        "total_amount": totalAmount,
        "vehicle_type": vehicleType,
        "vehicle_id": vehicleId,
        "files": List<dynamic>.from(
          files.map(
            (x) => x,
          ),
        ),
      };
}

class VehicleTypeModel {
  String id;
  String vehicleType;
  String ratePerKm;

  VehicleTypeModel({
    required this.id,
    required this.vehicleType,
    required this.ratePerKm,
  });

  factory VehicleTypeModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return VehicleTypeModel(
      id: json["id"].toString(),
      vehicleType: json["vehicle_type"].toString(),
      ratePerKm: json["rate_per_km"].toString(),
    );
  }
}
