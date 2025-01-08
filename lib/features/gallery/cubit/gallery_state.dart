class GalleryState {
  final DateTime? fromDate;
  final DateTime? toDate;

  GalleryState({this.fromDate, this.toDate});

  GalleryState copyWith({String? fromDate, String? toDate}) {
    return GalleryState(
      fromDate: this.fromDate,
      toDate: this.toDate,
    );
  }
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
