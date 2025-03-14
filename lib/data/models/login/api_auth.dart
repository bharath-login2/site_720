// To parse this JSON data, do
//
//     final apiAuth = apiAuthFromJson(jsonString);

import 'dart:convert';

ApiAuth apiAuthFromJson(String str) => ApiAuth.fromJson(json.decode(str));

String apiAuthToJson(ApiAuth data) => json.encode(data.toJson());

class ApiAuth {
    bool status;
    String message;
    Data data;

    ApiAuth({
        required this.status,
        required this.message,
        required this.data,
    });

    factory ApiAuth.fromJson(Map<String, dynamic> json) => ApiAuth(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
    };
}

class Data {
    String currentVersion;
    String minVersion;
    List<Server> server;

    Data({
        required this.currentVersion,
        required this.minVersion,
        required this.server,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        currentVersion: json["currentVersion"],
        minVersion: json["minVersion"],
        server: List<Server>.from(json["server"].map((x) => Server.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "currentVersion": currentVersion,
        "minVersion": minVersion,
        "server": List<dynamic>.from(server.map((x) => x.toJson())),
    };
}

class Server {
    String name;
    String url;

    Server({
        required this.name,
        required this.url,
    });

    factory Server.fromJson(Map<String, dynamic> json) => Server(
        name: json["name"],
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "url": url,
    };
}
