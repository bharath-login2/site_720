class DrawingState {
  

  DrawingState();


}

class DrawingInitial extends DrawingState {
  
}

class DrawingLoading extends DrawingState {}

class DrawingSuccess extends DrawingState {
  final String message;
  DrawingSuccess(this.message);
}

class DrawingFailure extends DrawingState {
  final String message;
  DrawingFailure(this.message);
}
class ImageSuccess extends DrawingState {
  final List imageList;
  ImageSuccess(this.imageList);
}

class ImageFailure extends DrawingState {
  final String message;
  ImageFailure(this.message);
}