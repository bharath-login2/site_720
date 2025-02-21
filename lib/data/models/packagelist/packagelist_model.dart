// To parse this JSON data, do
//
//     final getPackageList = getPackageListFromJson(jsonString);

import 'dart:convert';

GetPackageList getPackageListFromJson(String str) => GetPackageList.fromJson(json.decode(str));

String getPackageListToJson(GetPackageList data) => json.encode(data.toJson());

class GetPackageList {
    List<PackageList> data;
    String message;
    bool status;

    GetPackageList({
        required this.data,
        required this.message,
        required this.status,
    });

    factory GetPackageList.fromJson(Map<String, dynamic> json) => GetPackageList(
        data: List<PackageList>.from(json["data"].map((x) => PackageList.fromJson(x))),
        message: json["message"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "status": status,
    };
}

class PackageList {
    String id;
    String packageName;
    String amount;
    String description;

    PackageList({
        required this.id,
        required this.packageName,
        required this.amount,
        required this.description,
    });

    factory PackageList.fromJson(Map<String, dynamic> json) => PackageList(
        id: json["id"]??"",
        packageName: json["package_name"]??"",
        amount: json["amount"]??"",
        description: json["description"]??"",
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "package_name": packageName,
        "amount": amount,
        "description": description,
    };
}
