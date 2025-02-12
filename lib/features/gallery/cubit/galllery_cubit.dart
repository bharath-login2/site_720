import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/models/galery/stage_pro_model.dart';
import '../../../data/services/http_services.dart';
import 'gallery_state.dart';

class GalleryCubit extends Cubit<GalleryState> {
  GalleryCubit(String projectId) : super(GalleryInitial()) {
    getStageList(projectId);
  }

  List imageList = [];

  void startLoading() {
    emit(GalleryLoading());
  }

  void emitSuccess(String message) {
    emit(GallerySuccess(message));
  }

  void emitFailure(String message) {
    emit(GalleryFailure(message));
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

  Future<void> getStageList(String projectId) async {
    try {
      SatgeProModel response = await HttpServices.getStagePro(projectId);
      if (response.status == true) {
        emit(StageSuccess(response));
      }
    } catch (e) {
      emit(StageFailure('Failed to fetch data: ${e.toString()}'));
    }
  }

   Future<void> postGalery(String projectId) async {
    try {
      SatgeProModel response = await HttpServices.getStagePro(projectId);
      if (response.status == true) {
        emit(StageSuccess(response));
      }
    } catch (e) {
      emit(StageFailure('Failed to fetch data: ${e.toString()}'));
    }
  }
}
