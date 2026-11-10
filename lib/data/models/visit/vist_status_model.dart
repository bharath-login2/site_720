class VisitStatusModel {
  List<VisitStatusItem> data;
  bool status;
  String message;

  VisitStatusModel({
    required this.data,
    required this.status,
    required this.message,
  });

  factory VisitStatusModel.fromJson(Map<String, dynamic> json) {
    return VisitStatusModel(
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => VisitStatusItem.fromJson(e))
              .toList() ??
          [],
      status: json['status'] ?? false,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => e.toJson()).toList(),
      'status': status,
      'message': message,
    };
  }
}

class VisitStatusItem {
  int id;
  String status;

  VisitStatusItem({
    required this.id,
    required this.status,
  });

  factory VisitStatusItem.fromJson(Map<String, dynamic> json) {
    return VisitStatusItem(
      id: json['id'] ?? 0,
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
    };
  }
}
