import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'gallery_state.dart';

class GalleryCubit extends Cubit<GalleryState> {
  GalleryCubit() : super(GalleryInitial());

  void startLoading() {
    emit(GalleryLoading());
  }

  void emitSuccess(String message) {
    emit(GallerySuccess(message));
  }

  void emitFailure(String message) {
    emit(GalleryFailure(message));
  }

  
}
