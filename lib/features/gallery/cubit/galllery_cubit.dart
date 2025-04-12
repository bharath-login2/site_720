import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:site_720/data/models/succes_response/success_response.dart';
import '../../../data/models/galery/galery_list_model.dart';
import '../../../data/models/galery/stage_pro_model.dart';
import '../../../data/services/http_services.dart';
import 'gallery_state.dart';

class GalleryCubit extends Cubit<GalleryState> {
  GalleryCubit(String projectId) : super(GalleryInitial()) {
    getStageList(projectId);
    galleryList(projectId);
  }

  List<XFile> imageList = [];


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

  deleteImage(int i) {
    imageList.removeAt(i);
    emit(ImageSuccess(imageList));                   
  }

  Future<void> postGalery(
    String projectId,
    String clientId,
    String stageId,
    List<XFile> images,
    String ytLink,
  ) async {
    emit(GalleryLoading());
    try {
      SuccessResponse response = await HttpServices.postGallery(
          projectId, clientId, stageId, images, ytLink);
      if (response.status == true) {
        emit(GalleryPosted(response.message));
        images.clear();
        galleryList(projectId);
      }
    } catch (e) {
      emit(GalleryFailure('Failed to fetch data: ${e.toString()}'));
    }
  }

  Future<void> galleryList(
    String projectId,
  ) async {
    try {
      GalleryListModel response = await HttpServices.galleryList(projectId);
      if (response.status == true) {
        emit(GallerySuccess(response));
      }
    } catch (e) {
      emit(GalleryFailure('Failed to fetch data: ${e.toString()}'));
    }
  }

  Future<void> deleteGallery(
    String projectId,
    String id,
  ) async {
    try {
      SuccessResponse response = await HttpServices.deleteGalery(id);
      if (response.status == true) {
        galleryList(projectId);
      }
    } catch (e) {
      emit(GalleryFailure(e.toString()));
    }
  }
}
