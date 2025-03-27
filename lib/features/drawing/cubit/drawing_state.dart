import 'package:image_picker/image_picker.dart';

import '../../../data/models/site_drawings/drawing_list.dart';

class DrawingState {
  DrawingState();
}

class DrawingInitial extends DrawingState {}

class DrawingLoading extends DrawingState {}

class DrawingSuccess extends DrawingState {
  final SiteDrawingsList response;
  DrawingSuccess(this.response);
}

class DrawingFailure extends DrawingState {
  final String message;
  DrawingFailure(this.message);
}

class ImageSuccess extends DrawingState {
  final XFile image;
  ImageSuccess(this.image);
}

class ImageFailure extends DrawingState {
  final String message;
  ImageFailure(this.message);
}

class UploadSuccess extends DrawingState {}

class UploadLoading extends DrawingState {}
