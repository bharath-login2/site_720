// To parse this JSON data, do
//
//     final galleryListModel = galleryListModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

GalleryListModel galleryListModelFromJson(String str) => GalleryListModel.fromJson(json.decode(str));

String galleryListModelToJson(GalleryListModel data) => json.encode(data.toJson());

class GalleryListModel {
    List<GalleryData> data;
    String message;
    bool status;

    GalleryListModel({
        required this.data,
        required this.message,
        required this.status,
    });

    factory GalleryListModel.fromJson(Map<String, dynamic> json) => GalleryListModel(
        data: List<GalleryData>.from(json["data"].map((x) => GalleryData.fromJson(x))),
        message: json["message"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "status": status,
    };
}

class GalleryData {
    String stageId;
    String stageName;
    List<YtLink> ytLinks;
    List<ImageList> images;

    GalleryData({
        required this.stageId,
        required this.stageName,
        required this.ytLinks,
        required this.images,
    });

    factory GalleryData.fromJson(Map<String, dynamic> json) => GalleryData(
        stageId: json["stage_id"],
        stageName: json["stage_name"],
        ytLinks: List<YtLink>.from(json["yt_links"].map((x) => YtLink.fromJson(x))),
        images: List<ImageList>.from(json["images"].map((x) => ImageList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "stage_id": stageId,
        "stage_name": stageName,
        "yt_links": List<dynamic>.from(ytLinks.map((x) => x.toJson())),
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
    };
}

class ImageList {
    String imageId;
    String fileName;

    ImageList({
        required this.imageId,
        required this.fileName,
    });

    factory ImageList.fromJson(Map<String, dynamic> json) => ImageList(
        imageId: json["image_id"],
        fileName: json["file_name"],
    );

    Map<String, dynamic> toJson() => {
        "image_id": imageId,
        "file_name": fileName,
    };
}

class YtLink {
    String id;
    String url;

    YtLink({
        required this.id,
        required this.url,
    });

    factory YtLink.fromJson(Map<String, dynamic> json) => YtLink(
        id: json["id"],
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
    };
}
