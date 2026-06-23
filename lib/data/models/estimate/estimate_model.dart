class EstimateModel {
  final bool status;
  final String message;
  final List<EstimateStage> data;

  EstimateModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory EstimateModel.fromJson(Map<String, dynamic> json) {
    return EstimateModel(
      status: json["status"] ?? false,
      message: json["message"] ?? "",
      data: (json["data"]?["purchase_vs_estimate"] as List? ?? [])
          .map((e) => EstimateStage.fromJson(e))
          .toList(),
    );
  }
}

class EstimateStage {
  final String stageName;
  final String count;
  final List<EstimateMaterial> materials;

  EstimateStage({
    required this.stageName,
    required this.count,
    required this.materials,
  });

  factory EstimateStage.fromJson(Map<String, dynamic> json) {
    return EstimateStage(
      stageName: json["stage_name"]?.toString() ?? "",
      count: json["Count"]?.toString() ?? "0",
      materials: (json["materials"] as List? ?? [])
          .map((e) => EstimateMaterial.fromJson(e))
          .toList(),
    );
  }
}

class EstimateMaterial {
  final String materialName;
  final String unitPrice;
  final String estimationQty;
  final String estimationUnitPrice;
  final String purchaseQty;
  final String purchaseUnitPrice;
  final String variation;
  final String variationPrice;

  EstimateMaterial({
    required this.materialName,
    required this.unitPrice,
    required this.estimationQty,
    required this.estimationUnitPrice,
    required this.purchaseQty,
    required this.purchaseUnitPrice,
    required this.variation,
    required this.variationPrice,
  });

  factory EstimateMaterial.fromJson(Map<String, dynamic> json) {
    return EstimateMaterial(
      materialName: json["material_name"]?.toString() ?? "",
      unitPrice: json["unit_price"]?.toString() ?? "",
      estimationQty: json["estimation_qty"]?.toString() ?? "",
      estimationUnitPrice: json["estimation_unit_price"]?.toString() ?? "",
      purchaseQty: json["purchase_qty"]?.toString() ?? "",
      purchaseUnitPrice: json["purchase_unit_price"]?.toString() ?? "",
      variation: json["variation"]?.toString() ?? "",
      variationPrice: json["variation_price"]?.toString() ?? "",
    );
  }
}
