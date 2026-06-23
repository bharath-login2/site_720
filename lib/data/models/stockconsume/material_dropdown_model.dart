import 'dart:convert';

MaterialDropdownModel materialDropdownModelFromJson(String str) =>
    MaterialDropdownModel.fromJson(json.decode(str));

class MaterialDropdownModel {
  bool status;
  String message;
  List<MaterialData> data;

  MaterialDropdownModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory MaterialDropdownModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      MaterialDropdownModel(
        status: json["status"] ?? false,
        message: json["message"] ?? "",
        data: List<MaterialData>.from(
          (json["data"] ?? []).map(
            (x) => MaterialData.fromJson(x),
          ),
        ),
      );
}

class MaterialData {
  String materialId;
  String materialName;
  String projectId;

  MaterialData({
    required this.materialId,
    required this.materialName,
    required this.projectId,
  });

  factory MaterialData.fromJson(
    Map<String, dynamic> json,
  ) {
    return MaterialData(
      materialId: json["material_id"]?.toString() ?? "",
      materialName: json["material_name"] ?? "",
      projectId: json["project_id"] ?? "",
    );
  }

  @override
  String toString() {
    return materialName;
  }
}
