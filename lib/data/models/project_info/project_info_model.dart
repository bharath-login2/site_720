import 'dart:convert';

ProjectInfoModel projectInfoModelFromJson(String str) =>
    ProjectInfoModel.fromJson(json.decode(str));

String projectInfoModelToJson(ProjectInfoModel data) => json.encode(data);

class ProjectInfoModel {
  final bool status;
  final String message;
  final ProjectInfoData data;

  ProjectInfoModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ProjectInfoModel.fromJson(Map<String, dynamic> json) {
    return ProjectInfoModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: ProjectInfoData.fromJson(json['data'] ?? {}),
    );
  }
}

class ProjectInfoData {
  final ProjectDetails projectDetails;
  final List<ProjectMedia> planImages;
  final List<ProjectMedia> elevationImages;
  final List<SquareFeet> squareFeet;

  ProjectInfoData({
    required this.projectDetails,
    required this.planImages,
    required this.elevationImages,
    required this.squareFeet,
  });

  factory ProjectInfoData.fromJson(Map<String, dynamic> json) {
    return ProjectInfoData(
      projectDetails: ProjectDetails.fromJson(json['project_details'] ?? {}),
      planImages: (json['plan_images'] as List? ?? [])
          .map((e) => ProjectMedia.fromJson(e))
          .toList(),
      elevationImages: (json['elevation_images'] as List? ?? [])
          .map((e) => ProjectMedia.fromJson(e))
          .toList(),
      squareFeet: (json['square_feet'] as List? ?? [])
          .map((e) => SquareFeet.fromJson(e))
          .toList(),
    );
  }
}

class ProjectDetails {
  final String id;
  final String fixedRate;
  final String projectName;
  final String location;
  final String clientName;
  final String whatsappNumber;
  final String emailId;
  final String phoneNumber;
  final String address;
  final String civilId;
  final String workStatus;
  final String packageId;
  final String totalEstimateAmount;
  final String referenceNo;
  final String locationArea;
  final String startingDate;
  final String completionDate;
  final String bhkNo;
  final String projectDescription;
  final String lpoNo;
  final String orderNo;
  final String cctvId;
  final String projectType;
  final String packageName;
  final String categoryName;
  final String priorityId;
  final String isFixed;
  final String isInstallment;
  final String latitude;
  final String longtitude;

  ProjectDetails({
    required this.id,
    required this.fixedRate,
    required this.projectName,
    required this.location,
    required this.clientName,
    required this.whatsappNumber,
    required this.emailId,
    required this.phoneNumber,
    required this.address,
    required this.civilId,
    required this.workStatus,
    required this.packageId,
    required this.totalEstimateAmount,
    required this.referenceNo,
    required this.locationArea,
    required this.startingDate,
    required this.completionDate,
    required this.bhkNo,
    required this.projectDescription,
    required this.lpoNo,
    required this.orderNo,
    required this.cctvId,
    required this.projectType,
    required this.packageName,
    required this.categoryName,
    required this.priorityId,
    required this.isFixed,
    required this.isInstallment,
    required this.latitude,
    required this.longtitude,
  });

  factory ProjectDetails.fromJson(Map<String, dynamic> json) {
    return ProjectDetails(
      id: json['id']?.toString() ?? '',
      fixedRate: json['fixed_rate']?.toString() ?? '',
      projectName: json['project_name']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      clientName: json['client_name']?.toString() ?? '',
      whatsappNumber: json['whatsapp_number']?.toString() ?? '',
      emailId: json['email_id']?.toString() ?? '',
      phoneNumber: json['phone_number']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      civilId: json['civil_id']?.toString() ?? '',
      workStatus: json['work_status']?.toString() ?? '',
      packageId: json['package_id']?.toString() ?? '',
      totalEstimateAmount: json['total_estimate_amount']?.toString() ?? '',
      referenceNo: json['reference_no']?.toString() ?? '',
      locationArea: json['location_area']?.toString() ?? '',
      startingDate: json['starting_date']?.toString() ?? '',
      completionDate: json['completion_date']?.toString() ?? '',
      bhkNo: json['bhk_no']?.toString() ?? '',
      projectDescription: json['project_description']?.toString() ?? '',
      lpoNo: json['lpo_no']?.toString() ?? '',
      orderNo: json['order_no']?.toString() ?? '',
      cctvId: json['cctv_id']?.toString() ?? '',
      projectType: json['project_type']?.toString() ?? '',
      packageName: json['package_name']?.toString() ?? '',
      categoryName: json['category_name']?.toString() ?? '',
      priorityId: json['priority_id']?.toString() ?? '',
      isFixed: json['is_fixed']?.toString() ?? '',
      isInstallment: json['is_installment']?.toString() ?? '',
      latitude: json['latitude']?.toString() ?? '',
      longtitude: json['longtitude']?.toString() ?? '',
    );
  }
}

class ProjectMedia {
  final String id;
  final String projectId;
  final String fileName;
  final String fileType;
  final String mediaUrl;

  ProjectMedia({
    required this.id,
    required this.projectId,
    required this.fileName,
    required this.fileType,
    required this.mediaUrl,
  });

  factory ProjectMedia.fromJson(Map<String, dynamic> json) {
    return ProjectMedia(
      id: json['id']?.toString() ?? '',
      projectId: json['project_id']?.toString() ?? '',
      fileName: json['file_name']?.toString() ?? '',
      fileType: json['file_type']?.toString() ?? '',
      mediaUrl: json['media_url']?.toString() ?? '',
    );
  }
}

class SquareFeet {
  final String id;
  final String sqftName;
  final String sqftVal;
  final String sqftRate;
  final String sqftTotal;

  SquareFeet({
    required this.id,
    required this.sqftName,
    required this.sqftVal,
    required this.sqftRate,
    required this.sqftTotal,
  });

  factory SquareFeet.fromJson(Map<String, dynamic> json) {
    return SquareFeet(
      id: json['id']?.toString() ?? '',
      sqftName: json['sqft_name']?.toString() ?? '',
      sqftVal: json['sqft_val']?.toString() ?? '',
      sqftRate: json['sqft_rate']?.toString() ?? '',
      sqftTotal: json['sqft_total']?.toString() ?? '',
    );
  }
}
