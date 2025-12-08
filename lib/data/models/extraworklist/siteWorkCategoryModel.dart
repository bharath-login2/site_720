import 'dart:convert';

class SiteCategoryModel {
    List<SiteCategory> data;
    String message;
    bool status;

    SiteCategoryModel({
        required this.data,
        required this.message,
        required this.status,
    });

    factory SiteCategoryModel.fromRawJson(String str) => SiteCategoryModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory SiteCategoryModel.fromJson(Map<String, dynamic> json) => SiteCategoryModel(
        data: List<SiteCategory>.from(json["data"].map((x) => SiteCategory.fromJson(x))),
        message: json["message"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "status": status,
    };
}

class SiteCategory {
    String id;
    String categoryName;

    SiteCategory({
        required this.id,
        required this.categoryName,
    });

    factory SiteCategory.fromRawJson(String str) => SiteCategory.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory SiteCategory.fromJson(Map<String, dynamic> json) => SiteCategory(
        id: json["id"],
        categoryName: json["category_name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "category_name": categoryName,
    };
}
