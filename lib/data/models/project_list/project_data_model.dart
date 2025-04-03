// To parse this JSON data, do
//
//     final projectDataModel = projectDataModelFromJson(jsonString);

import 'dart:convert';

ProjectDataModel projectDataModelFromJson(String str) =>
    ProjectDataModel.fromJson(json.decode(str));

String projectDataModelToJson(ProjectDataModel data) =>
    json.encode(data.toJson());

class ProjectDataModel {
  Data data;
  String message;
  bool status;

  ProjectDataModel({
    required this.data,
    required this.message,
    required this.status,
  });

  factory ProjectDataModel.fromJson(Map<String, dynamic> json) =>
      ProjectDataModel(
        data: Data.fromJson(json["data"]),
        message: json["message"] ?? "",
        status: json["status"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "message": message,
        "status": status,
      };
}

class Data {
  List<Clients> clientList;
  List<ProjectList> projectList;
  List<ProjectCategory> projectCategory;
  List<Package> packages;
  List<Bhk> bhk;

  Data({
    required this.clientList,
    required this.projectList,
    required this.projectCategory,
    required this.packages,
    required this.bhk,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        clientList: List<Clients>.from(
            json["client_list"].map((x) => Clients.fromJson(x))),
        projectList: List<ProjectList>.from(
            json["project_list"].map((x) => ProjectList.fromJson(x))),
        projectCategory: List<ProjectCategory>.from(
            json["project_category"].map((x) => ProjectCategory.fromJson(x))),
        packages: List<Package>.from(
            json["packages"].map((x) => Package.fromJson(x))),
        bhk: List<Bhk>.from(json["bhk"].map((x) => Bhk.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "client_list": List<dynamic>.from(clientList.map((x) => x.toJson())),
        "project_list": List<dynamic>.from(projectList.map((x) => x.toJson())),
        "project_category":
            List<dynamic>.from(projectCategory.map((x) => x.toJson())),
        "packages": List<dynamic>.from(packages.map((x) => x.toJson())),
        "bhk": List<dynamic>.from(bhk.map((x) => x.toJson())),
      };
}

class Bhk {
  String id;
  String name;

  Bhk({
    required this.id,
    required this.name,
  });

  factory Bhk.fromJson(Map<String, dynamic> json) => Bhk(
        id: json["id"] ?? "",
        name: json["name"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class Clients {
  String clientName;
  String id;

  Clients({
    required this.clientName,
    required this.id,
  });

  factory Clients.fromJson(Map<String, dynamic> json) => Clients(
        clientName: json["client_name"] ?? "",
        id: json["id"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "client_name": clientName,
        "id": id,
      };
}

class Package {
  String packageName;
  String id;

  Package({
    required this.packageName,
    required this.id,
  });

  factory Package.fromJson(Map<String, dynamic> json) => Package(
        packageName: json["package_name"] ?? "",
        id: json["id"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "package_name": packageName,
        "id": id,
      };
}

class ProjectCategory {
  String categoryName;
  String id;

  ProjectCategory({
    required this.categoryName,
    required this.id,
  });

  factory ProjectCategory.fromJson(Map<String, dynamic> json) =>
      ProjectCategory(
        categoryName: json["category_name"] ?? "",
        id: json["id"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "category_name": categoryName,
        "id": id,
      };
}

class ProjectList {
  String projectType;
  String id;

  ProjectList({
    required this.projectType,
    required this.id,
  });

  factory ProjectList.fromJson(Map<String, dynamic> json) => ProjectList(
        projectType: json["project_type"] ?? "",
        id: json["id"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "project_type": projectType,
        "id": id,
      };
}
