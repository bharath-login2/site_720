class LiveMapModel {
  final bool status;
  final String message;
  final Stats stats;
  final List<LiveMapData> data;

  LiveMapModel({
    required this.status,
    required this.message,
    required this.stats,
    required this.data,
  });

  factory LiveMapModel.fromJson(Map<String, dynamic> json) {
    return LiveMapModel(
      status: json['status'],
      message: json['message'],
      stats: Stats.fromJson(json['stats']),
      data: (json['data'] as List).map((e) => LiveMapData.fromJson(e)).toList(),
    );
  }
}

class Stats {
  final int total;
  final int running;
  final int upcoming;
  final int pending;

  Stats({
    required this.total,
    required this.running,
    required this.upcoming,
    required this.pending,
  });

  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(
      total: json['total'],
      running: json['running'],
      upcoming: json['upcoming'],
      pending: json['pending'],
    );
  }
}

class LiveMapData {
  final String id;
  final String projectId;
  final String projectName;
  final String location;
  final String district;
  final String projectType;
  final String supervisor;
  final String status;
  final double? latitude;
  final double? longitude;

  LiveMapData({
    required this.id,
    required this.projectId,
    required this.projectName,
    required this.location,
    required this.district,
    required this.projectType,
    required this.supervisor,
    required this.status,
    required this.latitude,
    required this.longitude,
  });

  factory LiveMapData.fromJson(Map<String, dynamic> json) {
    return LiveMapData(
      id: json['id'] ?? '',
      projectId: json['project_id'] ?? '',
      projectName: json['project_name'] ?? '',
      location: json['location'] ?? '',
      district: json['district'] ?? '',
      projectType: json['project_type'] ?? '',
      supervisor: json['supervisor'] ?? '',
      status: json['status'] ?? '',
      latitude: json['latitude'] == ""
          ? null
          : double.parse(json['latitude'].toString()),
      longitude: json['longitude'] == ""
          ? null
          : double.parse(json['longitude'].toString()),
    );
  }
}
