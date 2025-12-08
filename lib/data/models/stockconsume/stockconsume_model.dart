// To parse this JSON data, do
//
//     final stockConsumeModel = stockConsumeModelFromJson(jsonString);

import 'dart:convert';

StockConsumeModel stockConsumeModelFromJson(String str) =>
    StockConsumeModel.fromJson(json.decode(str));

String stockConsumeModelToJson(StockConsumeModel data) =>
    json.encode(data.toJson());

class StockConsumeModel {
  List<StockConsume> data;
  String message;
  bool status;

  StockConsumeModel({
    required this.data,
    required this.message,
    required this.status,
  });

  factory StockConsumeModel.fromJson(Map<String, dynamic> json) =>
      StockConsumeModel(
        data: List<StockConsume>.from(
            json["data"].map((x) => StockConsume.fromJson(x))),
        message: json["message"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "status": status,
      };
}

class StockConsume {
  String quantity;
  String unit;
  String inStock;
  String dateConsumed;
  String locationName;
  String materialName;
  String unitPrice;

  StockConsume({
    required this.quantity,
    required this.unit,
    required this.inStock,
    required this.dateConsumed,
    required this.locationName,
    required this.materialName,
    required this.unitPrice,
  });

  factory StockConsume.fromJson(Map<String, dynamic> json) => StockConsume(
        quantity: json["quantity"] ?? "",
        unit: json["unit"] ?? "",
        inStock: json["in_stock"] ?? "",
        dateConsumed: json["date_consumed"] ?? "",
        locationName: json["location_name"] ?? "",
        materialName: json["material_name"] ?? "",
        unitPrice: json["unit_price"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "quantity": quantity,
        "unit": unit,
        "in_stock": inStock,
        "date_consumed": dateConsumed,
        "location_name": locationName,
        "material_name": materialName,
        "unit_price": unitPrice,
      };
}
