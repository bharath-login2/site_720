// To parse this JSON data, do
//
//     final galleryListModel = galleryListModelFromJson(jsonString);

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
    List<ImageList> images;

    GalleryData({
        required this.stageId,
        required this.stageName,
        required this.images,
    });

    factory GalleryData.fromJson(Map<String, dynamic> json) => GalleryData(
        stageId: json["stage_id"],
        stageName: json["stage_name"],
        images: List<ImageList>.from(json["images"].map((x) => ImageList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "stage_id": stageId,
        "stage_name": stageName,
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
