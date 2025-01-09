class GalleryState {
  

  GalleryState();


}

class GalleryInitial extends GalleryState {
  
}

class GalleryLoading extends GalleryState {}

class GallerySuccess extends GalleryState {
  final String message;
  GallerySuccess(this.message);
}

class GalleryFailure extends GalleryState {
  final String message;
  GalleryFailure(this.message);
}
class ImageSuccess extends GalleryState {
  final List imageList;
  ImageSuccess(this.imageList);
}

class ImageFailure extends GalleryState {
  final String message;
  ImageFailure(this.message);
}