import 'dart:convert';

class OfficeCategoryModel {
    List<OfficeCategory> data;
    String message;
    bool status;

    OfficeCategoryModel({
        required this.data,
        required this.message,
        required this.status,
    });

    factory OfficeCategoryModel.fromRawJson(String str) => OfficeCategoryModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory OfficeCategoryModel.fromJson(Map<String, dynamic> json) => OfficeCategoryModel(
        data: List<OfficeCategory>.from(json["data"].map((x) => OfficeCategory.fromJson(x))),
        message: json["message"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "status": status,
    };
}

class OfficeCategory {
    String id;
    String categoryName;

    OfficeCategory({
        required this.id,
        required this.categoryName,
    });

    factory OfficeCategory.fromRawJson(String str) => OfficeCategory.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory OfficeCategory.fromJson(Map<String, dynamic> json) => OfficeCategory(
        id: json["id"],
        categoryName: json["category_name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "category_name": categoryName,
    };
}
