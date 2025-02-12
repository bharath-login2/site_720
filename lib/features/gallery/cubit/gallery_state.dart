import 'package:image_picker/image_picker.dart';

import '../../../data/models/galery/galery_list_model.dart';
import '../../../data/models/galery/stage_pro_model.dart';

class GalleryState {
  GalleryState();
}

class GalleryInitial extends GalleryState {}

class GalleryLoading extends GalleryState {}

class GallerySuccess extends GalleryState {
  final GalleryListModel response;
  GallerySuccess(this.response);
}

class GalleryFailure extends GalleryState {
  final String message;
  GalleryFailure(this.message);
}

class ImageSuccess extends GalleryState {
  final List<XFile> imageList;
  ImageSuccess(this.imageList);
}

class ImageFailure extends GalleryState {
  final String message;
  ImageFailure(this.message);
}

class StageSuccess extends GalleryState {
  final SatgeProModel response;
  StageSuccess(this.response);
}

class StageFailure extends GalleryState {
  final String message;
  StageFailure(this.message);
}

class GalleryPosted extends GalleryState {
  final String message;
  GalleryPosted(this.message);
}
