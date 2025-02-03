// To parse this JSON data, do
//
//     final purchaseBillListModel = purchaseBillListModelFromJson(jsonString);

import 'dart:convert';

PurchaseBillListModel purchaseBillListModelFromJson(String str) => PurchaseBillListModel.fromJson(json.decode(str));

String purchaseBillListModelToJson(PurchaseBillListModel data) => json.encode(data.toJson());

class PurchaseBillListModel {
    List<PurchaseBill> data;
    String message;
    bool status;

    PurchaseBillListModel({
        required this.data,
        required this.message,
        required this.status,
    });

    factory PurchaseBillListModel.fromJson(Map<String, dynamic> json) => PurchaseBillListModel(
        data: List<PurchaseBill>.from(json["data"].map((x) => PurchaseBill.fromJson(x))),
        message: json["message"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "status": status,
    };
}

class PurchaseBill {
    String purchaseBillId;
    DateTime billDate;
    String materialId;
    String quantity;
    String grandTotal;
    String materialName;

    PurchaseBill({
        required this.purchaseBillId,
        required this.billDate,
        required this.materialId,
        required this.quantity,
        required this.grandTotal,
        required this.materialName,
    });

    factory PurchaseBill.fromJson(Map<String, dynamic> json) => PurchaseBill(
        purchaseBillId: json["purchase_bill_id"],
        billDate: DateTime.parse(json["bill_date"]),
        materialId: json["material_id"],
        quantity: json["quantity"],
        grandTotal: json["grand_total"],
        materialName: json["material_name"],
    );

    Map<String, dynamic> toJson() => {
        "purchase_bill_id": purchaseBillId,
        "bill_date": "${billDate.year.toString().padLeft(4, '0')}-${billDate.month.toString().padLeft(2, '0')}-${billDate.day.toString().padLeft(2, '0')}",
        "material_id": materialId,
        "quantity": quantity,
        "grand_total": grandTotal,
        "material_name": materialName,
    };
}
