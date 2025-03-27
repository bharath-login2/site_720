// To parse this JSON data, do
//
//     final editDataModel = editDataModelFromJson(jsonString);

import 'dart:convert';

EditDataModel editDataModelFromJson(String str) => EditDataModel.fromJson(json.decode(str));

String editDataModelToJson(EditDataModel data) => json.encode(data.toJson());

class EditDataModel {
    EditDetails data;
    String message;
    bool status;

    EditDataModel({
        required this.data,
        required this.message,
        required this.status,
    });

    factory EditDataModel.fromJson(Map<String, dynamic> json) => EditDataModel(
        data: EditDetails.fromJson(json["data"]),
        message: json["message"]??"",
        status: json["status"]??"",
    );

    Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "message": message,
        "status": status,
    };
}

class EditDetails {
    String id;
    String clientId;
    String projectName;
    String projectTypeId;
    String packageId;
    String projectCategoryId;
    String referenceNo;
    String location;
    String locationArea;
    String priorityId;
    String startingDate;
    String completionDate;
    String bhkNo;
    String fixedRate;
    String totalEstimateAmount;
    String projectDescription;
    String lpoNo;
    String orderNo;
    String workStatus;
    String isFreezed;
    String isPaid;
    String isDeleted;
    String companyId;
    String branchId;
    DateTime createdAt;
    String createdBy;
    String updatedAt;
    String updatedBy;
    String cctvId;
    String clientName;
    String projectType;
    String categoryName;
    String priorityName;
    String planImage;
    String elevatedImage;
    String estimatedBudget;
    String gstPercentage;
    String gstAmount;
    String totalAmount;
    List<UnitList> unitList;

    EditDetails({
        required this.id,
        required this.clientId,
        required this.projectName,
        required this.projectTypeId,
        required this.packageId,
        required this.projectCategoryId,
        required this.referenceNo,
        required this.location,
        required this.locationArea,
        required this.priorityId,
        required this.startingDate,
        required this.completionDate,
        required this.bhkNo,
        required this.fixedRate,
        required this.totalEstimateAmount,
        required this.projectDescription,
        required this.lpoNo,
        required this.orderNo,
        required this.workStatus,
        required this.isFreezed,
        required this.isPaid,
        required this.isDeleted,
        required this.companyId,
        required this.branchId,
        required this.createdAt,
        required this.createdBy,
        required this.updatedAt,
        required this.updatedBy,
        required this.cctvId,
        required this.clientName,
        required this.projectType,
        required this.categoryName,
        required this.priorityName,
        required this.planImage,
        required this.elevatedImage,
        required this.estimatedBudget,
        required this.gstPercentage,
        required this.gstAmount,
        required this.totalAmount,
        required this.unitList,
    });

    factory EditDetails.fromJson(Map<String, dynamic> json) => EditDetails(
        id: json["id"]??"",
        clientId: json["client_id"]??"",
        projectName: json["project_name"]??"",
        projectTypeId: json["project_type_id"]??"",
        packageId: json["package_id"]??"",
        projectCategoryId: json["project_category_id"]??"",
        referenceNo: json["reference_no"]??"",
        location: json["location"]??"",
        locationArea: json["location_area"]??"",
        priorityId: json["priority_id"]??"",
        startingDate: json["starting_date"]??"",
        completionDate: json["completion_date"]??"",
        bhkNo: json["bhk_no"]??"",
        fixedRate: json["fixed_rate"]??"",
        totalEstimateAmount: json["total_estimate_amount"]??"",
        projectDescription: json["project_description"]??"",
        lpoNo: json["lpo_no"]??"",
        orderNo: json["order_no"]??"",
        workStatus: json["work_status"]??"",
        isFreezed: json["is_freezed"]??"",
        isPaid: json["is_paid"]??"",
        isDeleted: json["is_deleted"]??"",
        companyId: json["company_id"]??"",
        branchId: json["branch_id"]??"",
        createdAt: DateTime.parse(json["created_at"]),
        createdBy: json["created_by"]??"",
        updatedAt: json["updated_at"]??"",
        updatedBy: json["updated_by"]??"",
        cctvId: json["cctv_id"]??"",
        clientName: json["client_name"]??"",
        projectType: json["project_type"]??"",
        categoryName: json["category_name"]??"",
        priorityName: json["priority_name"]??"",
        planImage: json["plan_image"]??"",
        elevatedImage: json["elevated_image"]??"",
        estimatedBudget: json["estimated_budget"]??"",
        gstPercentage: json["gst_percentage"]??"",
        gstAmount: json["gst_amount"]??"",
        totalAmount: json["total_amount"]??"",
        unitList: List<UnitList>.from(json["unit_list"].map((x) => UnitList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "client_id": clientId,
        "project_name": projectName,
        "project_type_id": projectTypeId,
        "package_id": packageId,
        "project_category_id": projectCategoryId,
        "reference_no": referenceNo,
        "location": location,
        "location_area": locationArea,
        "priority_id": priorityId,
        "starting_date": startingDate,
        "completion_date": completionDate,
        "bhk_no": bhkNo,
        "fixed_rate": fixedRate,
        "total_estimate_amount": totalEstimateAmount,
        "project_description": projectDescription,
        "lpo_no": lpoNo,
        "order_no": orderNo,
        "work_status": workStatus,
        "is_freezed": isFreezed,
        "is_paid": isPaid,
        "is_deleted": isDeleted,
        "company_id": companyId,
        "branch_id": branchId,
        "created_at": createdAt.toIso8601String(),
        "created_by": createdBy,
        "updated_at": updatedAt,
        "updated_by": updatedBy,
        "cctv_id": cctvId,
        "client_name": clientName,
        "project_type": projectType,
        "category_name": categoryName,
        "priority_name": priorityName,
        "plan_image": planImage,
        "elevated_image": elevatedImage,
        "estimated_budget": estimatedBudget,
        "gst_percentage": gstPercentage,
        "gst_amount": gstAmount,
        "total_amount": totalAmount,
        "unit_list": List<dynamic>.from(unitList.map((x) => x.toJson())),
    };
}

class UnitList {
    String sqftName;
    String sqftVal;
    String sqftRate;
    String sqftTotal;

    UnitList({
        required this.sqftName,
        required this.sqftVal,
        required this.sqftRate,
        required this.sqftTotal,
    });

    factory UnitList.fromJson(Map<String, dynamic> json) => UnitList(
        sqftName: json["sqft_name"]??"",
        sqftVal: json["sqft_val"]??"",
        sqftRate: json["sqft_rate"]??"",
        sqftTotal: json["sqft_total"]??"",
    );

    Map<String, dynamic> toJson() => {
        "sqft_name": sqftName,
        "sqft_val": sqftVal,
        "sqft_rate": sqftRate,
        "sqft_total": sqftTotal,
    };
}
