class SiteDrawingRequestListResponse {
  final bool status;
  final String message;
  final List<SiteDrawingRequest> data;

  SiteDrawingRequestListResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SiteDrawingRequestListResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return SiteDrawingRequestListResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map(
                (item) => SiteDrawingRequest.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
    );
  }
}

class SiteDrawingRequest {
  final String id;
  final String projectId;
  final String stages;
  final String remark;
  final String status;
  final String createdAt;
  final String createdBy;
  final String updatedAt;
  final String updatedBy;
  final String projectName;
  final String creatorName;
  final String stageNames;

  SiteDrawingRequest({
    required this.id,
    required this.projectId,
    required this.stages,
    required this.remark,
    required this.status,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
    required this.projectName,
    required this.creatorName,
    required this.stageNames,
  });

  factory SiteDrawingRequest.fromJson(Map<String, dynamic> json) {
    return SiteDrawingRequest(
      id: json['id']?.toString() ?? '',
      projectId: json['project_id']?.toString() ?? '',
      stages: json['stages']?.toString() ?? '',
      remark: json['remark']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      createdBy: json['created_by']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      updatedBy: json['updated_by']?.toString() ?? '',
      projectName: json['project_name']?.toString() ?? '',
      creatorName: json['creator_name']?.toString() ?? '',
      stageNames: json['stage_names']?.toString() ?? '',
    );
  }
}
