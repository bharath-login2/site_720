class ProjectDocument {
  final String id;
  final String projectId;
  final String uploadFile;
  final String title;
  final String remark;
  final String mediaUrl;

  ProjectDocument({
    required this.id,
    required this.projectId,
    required this.uploadFile,
    required this.title,
    required this.remark,
    required this.mediaUrl,
  });

  factory ProjectDocument.fromJson(Map<String, dynamic> json) {
    return ProjectDocument(
      id: json['id']?.toString() ?? "",
      projectId: json['project_id']?.toString() ?? "",
      uploadFile: json['upload_file']?.toString() ?? "",
      title: json['title']?.toString() ?? "",
      remark: json['remark']?.toString() ?? "",
      mediaUrl: json['media_url']?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "project_id": projectId,
      "upload_file": uploadFile,
      "title": title,
      "remark": remark,
      "media_url": mediaUrl,
    };
  }
}
