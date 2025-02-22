// To parse this JSON data, do
//
//     final stockConsumeModel = stockConsumeModelFromJson(jsonString);

import 'dart:convert';

StockConsumeModel stockConsumeModelFromJson(String str) => StockConsumeModel.fromJson(json.decode(str));

String stockConsumeModelToJson(StockConsumeModel data) => json.encode(data.toJson());

class StockConsumeModel {
    List<StockConsume> data;
    String message;
    bool status;

    StockConsumeModel({
        required this.data,
        required this.message,
        required this.status,
    });

    factory StockConsumeModel.fromJson(Map<String, dynamic> json) => StockConsumeModel(
        data: List<StockConsume>.from(json["data"].map((x) => StockConsume.fromJson(x))),
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
    String materialName;
    String supplierName;
    String unitPrice;
    String quantity;
    String totalAmount;

    StockConsume({
        required this.materialName,
        required this.supplierName,
        required this.unitPrice,
        required this.quantity,
        required this.totalAmount,
    });

    factory StockConsume.fromJson(Map<String, dynamic> json) => StockConsume(
        materialName: json["material_name"]??"",
        supplierName: json["supplier_name"]??"",
        unitPrice: json["unit_price"]??"",
        quantity: json["quantity"]??"",
        totalAmount: json["total_amount"]??"",
    );

    Map<String, dynamic> toJson() => {
        "material_name": materialName,
        "supplier_name": supplierName,
        "unit_price": unitPrice,
        "quantity": quantity,
    };
}
