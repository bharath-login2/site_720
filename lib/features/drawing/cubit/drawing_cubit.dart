import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'drawing_state.dart';

class DrawingCubit extends Cubit<DrawingState> {
  DrawingCubit() : super(DrawingInitial());

  List imageList = [];

  void startLoading() {
    emit(DrawingLoading());
  }

  void emitSuccess(String message) {
    emit(DrawingSuccess(message));
  }

  void emitFailure(String message) {
    emit(DrawingFailure(message));
  }

  selectMultiImage(
    ImageSource? source,
  ) async {
    try {
      if (source != null) {
        final XFile? selectedImages =
            await ImagePicker().pickImage(source: source);
        if (selectedImages != null) {
          imageList.add(selectedImages);
        }
        emit(ImageSuccess(imageList));
      } else {
        final List<XFile> images = await ImagePicker().pickMultiImage();
        if (images.isNotEmpty) {
          imageList.addAll(images);
        }
        emit(ImageSuccess(imageList));
      }
    } catch (e) {
      emit(ImageFailure("Failed to get image, Please Select once again.."));
    }
  }
}
