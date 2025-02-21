// To parse this JSON data, do
//
//     final stockListModel = stockListModelFromJson(jsonString);

import 'dart:convert';

StockListModel stockListModelFromJson(String str) => StockListModel.fromJson(json.decode(str));

String stockListModelToJson(StockListModel data) => json.encode(data.toJson());

class StockListModel {
    List<Stocks> data;
    String message;
    bool status;

    StockListModel({
        required this.data,
        required this.message,
        required this.status,
    });

    factory StockListModel.fromJson(Map<String, dynamic> json) => StockListModel(
        data: List<Stocks>.from(json["data"].map((x) => Stocks.fromJson(x))),
        message: json["message"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "status": status,
    };
}

class Stocks {
    String materialName;
    String supplierName;
    String unitPrice;
    String quantity;

    Stocks({
        required this.materialName,
        required this.supplierName,
        required this.unitPrice,
        required this.quantity,
    });

    factory Stocks.fromJson(Map<String, dynamic> json) => Stocks(
        materialName: json["material_name"],
        supplierName: json["supplier_name"],
        unitPrice: json["unit_price"],
        quantity: json["quantity"],
    );

    Map<String, dynamic> toJson() => {
        "material_name": materialName,
        "supplier_name": supplierName,
        "unit_price": unitPrice,
        "quantity": quantity,
    };
}
