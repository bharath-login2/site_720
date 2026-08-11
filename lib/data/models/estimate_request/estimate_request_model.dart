class EstimateRequestResponse {
  final bool status;
  final String message;
  final List<EstimateRequestModel> data;

  EstimateRequestResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory EstimateRequestResponse.fromJson(Map<String, dynamic> json) {
    return EstimateRequestResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => EstimateRequestModel.fromJson(e))
          .toList(),
    );
  }
}

class EstimateRequestModel {
  final String id;
  final String projectId;
  final String stageId;
  final String status;
  final String remark;
  final String createdAt;
  final String updatedAt;
  final String createdBy;
  final String updatedBy;
  final String projectName;
  final String stageName;
  // final String creatorName;
  final List<AssignedStaffModel> assignedStaff;

  EstimateRequestModel({
    required this.id,
    required this.projectId,
    required this.stageId,
    required this.status,
    required this.remark,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
    required this.projectName,
    required this.stageName,
    // required this.creatorName,
    required this.assignedStaff,
  });

  factory EstimateRequestModel.fromJson(Map<String, dynamic> json) {
    return EstimateRequestModel(
      id: json['id'] ?? '',
      projectId: json['project_id']?.toString() ?? '',
      stageId: json['stage_id'] ?? '',
      status: json['status'] ?? '',
      remark: json['remark'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      createdBy: json['created_by_name'] ?? '',
      updatedBy: json['updated_by_name'] ?? '',
      projectName: json['project_name'] ?? '',
      stageName: json['stage_name'] ?? '',
      // creatorName: json['creator_name'] ?? '',
      assignedStaff: (json['assigned_staff'] as List<dynamic>? ?? [])
          .map((e) => AssignedStaffModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project_id': projectId,
      'stage_id': stageId,
      'status': status,
      'remark': remark,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'created_by': createdBy,
      'project_name': projectName,
      'stage_name': stageName,
      // 'creator_name': creatorName,
      'assigned_staff': assignedStaff.map((e) => e.toJson()).toList(),
    };
  }
}

class AssignedStaffModel {
  final String userId;
  final String staffName;

  AssignedStaffModel({
    required this.userId,
    required this.staffName,
  });

  factory AssignedStaffModel.fromJson(Map<String, dynamic> json) {
    return AssignedStaffModel(
      userId: json['user_id'] ?? '',
      staffName: json['staff_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'staff_name': staffName,
    };
  }
}
