import 'dart:convert';

MaterialDetailsConsumptionModel materialDetailsConsumptionModelFromJson(
        String str) =>
    MaterialDetailsConsumptionModel.fromJson(
      json.decode(str),
    );

class MaterialDetailsConsumptionModel {
  bool status;
  String message;
  List<MaterialDetails> data;

  MaterialDetailsConsumptionModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory MaterialDetailsConsumptionModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      MaterialDetailsConsumptionModel(
        status: json["status"] ?? false,
        message: json["message"] ?? "",
        data: List<MaterialDetails>.from(
          (json["data"] ?? []).map(
            (x) => MaterialDetails.fromJson(x),
          ),
        ),
      );
}

class MaterialDetails {
  String materialId;
  String materialName;
  String unit;
  String unitId;
  String unitPrice;
  String availableQuantity;
  String supplierId;
  String supplierName;

  MaterialDetails({
    required this.materialId,
    required this.materialName,
    required this.unit,
    required this.unitId,
    required this.unitPrice,
    required this.availableQuantity,
    required this.supplierId,
    required this.supplierName,
  });

  factory MaterialDetails.fromJson(
    Map<String, dynamic> json,
  ) {
    return MaterialDetails(
      materialId: json["material_id"]?.toString() ?? "",
      materialName: json["material_name"] ?? "",
      unit: json["unit"] ?? "",
      unitId: json["unit_id"] ?? "",
      unitPrice: json["unit_price"]?.toString() ?? "",
      availableQuantity: json["available_quantity"]?.toString() ?? "",
      supplierId: json["supplier_id"]?.toString() ?? "",
      supplierName: json["supplier_name"] ?? "",
    );
  }
}
