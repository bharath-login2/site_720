// To parse this JSON data, do
//
// final purchaseBillListModel = purchaseBillListModelFromJson(jsonString);

import 'dart:convert';

PurchaseBillListModel purchaseBillListModelFromJson(String str) =>
    PurchaseBillListModel.fromJson(json.decode(str));

String purchaseBillListModelToJson(PurchaseBillListModel data) =>
    json.encode(data.toJson());

class PurchaseBillListModel {
  List<PurchaseBill> data;
  String message;
  bool status;

  PurchaseBillListModel({
    required this.data,
    required this.message,
    required this.status,
  });

  factory PurchaseBillListModel.fromJson(Map<String, dynamic> json) {
    final dataContainer = json["data"] ?? {};

    return PurchaseBillListModel(
      data: List<PurchaseBill>.from(
        (dataContainer["data"] ?? []).map(
          (x) => PurchaseBill.fromJson(x),
        ),
      ),
      message: json["message"]?.toString() ?? "",
      status: json["status"] ?? false,
    );
  }
  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "status": status,
      };
}

class PurchaseBill {
  String purchaseBillId;
  DateTime billDate;
  String supplierId;
  String supplierName;
  String stages;
  List<MaterialItem> materials;
  int totalQuantity;
  num totalAmount;

  PurchaseBill({
    required this.purchaseBillId,
    required this.billDate,
    required this.supplierId,
    required this.supplierName,
    required this.stages,
    required this.materials,
    required this.totalQuantity,
    required this.totalAmount,
  });

  factory PurchaseBill.fromJson(Map<String, dynamic> json) {
    return PurchaseBill(
      purchaseBillId: json["purchase_bill_id"]?.toString() ?? "",
      billDate: DateTime.parse(
        json["bill_date"]?.toString() ?? DateTime.now().toString(),
      ),
      supplierId: json["supplier_id"]?.toString() ?? "",
      supplierName: json["supplier_name"]?.toString() ?? "",
      stages: json["stage_name"]?.toString() ?? "",
      materials: List<MaterialItem>.from(
        (json["materials"] ?? []).map(
          (e) => MaterialItem.fromJson(e),
        ),
      ),
      totalQuantity:
          int.tryParse(json["total_quantity"]?.toString() ?? "0") ?? 0,
      totalAmount: num.tryParse(json["total_amount"]?.toString() ?? "0") ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "purchase_bill_id": purchaseBillId,
        "bill_date":
            "${billDate.year.toString().padLeft(4, '0')}-${billDate.month.toString().padLeft(2, '0')}-${billDate.day.toString().padLeft(2, '0')}",
        "supplier_id": supplierId,
        "supplier_name": supplierName,
        "materials": List<dynamic>.from(
          materials.map((x) => x.toJson()),
        ),
        "total_quantity": totalQuantity,
        "total_amount": totalAmount,
      };
}

class MaterialItem {
  String materialId;
  String materialName;
  String quantity;
  String amount;

  MaterialItem({
    required this.materialId,
    required this.materialName,
    required this.quantity,
    required this.amount,
  });

  factory MaterialItem.fromJson(Map<String, dynamic> json) {
    return MaterialItem(
      materialId: json["material_id"]?.toString() ?? "",
      materialName: json["material_name"]?.toString() ?? "",
      quantity: json["quantity"]?.toString() ?? "",
      amount: json["amount"]?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "material_id": materialId,
        "material_name": materialName,
        "quantity": quantity,
        "amount": amount,
      };
}
