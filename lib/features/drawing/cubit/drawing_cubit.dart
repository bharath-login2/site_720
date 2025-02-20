import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:site_720/data/models/succes_response/success_response.dart';
import '../../../data/models/site_drawings/drawing_list.dart';
import '../../../data/services/http_services.dart';
import 'drawing_state.dart';

class DrawingCubit extends Cubit<DrawingState> {
  DrawingCubit(String projectId) : super(DrawingInitial()) {
    getDrawingList(projectId);
  }

  XFile? image;

  selectImage(
    ImageSource source,
  ) async {
    try {
      final XFile? selectedImage =
          await ImagePicker().pickImage(source: source);
      if (selectedImage != null) {
        image = selectedImage;
      }
      emit(ImageSuccess(image!));
    } catch (e) {
      emit(ImageFailure("Failed to get image, Please Select once again.."));
    }
  }

  Future<void> getDrawingList(String projectId) async {
    emit(DrawingLoading());
    try {
      SiteDrawingsList response = await HttpServices.getDrawingList(projectId);
      if (response.status == true) {
        emit(DrawingSuccess(response));
      } else {}
    } catch (e) {
      emit(DrawingFailure('Failed to fetch data: ${e.toString()}'));
    }
  }

  Future<void> uploadDrawings(
      String projectId, String clientId, XFile image, String remark) async {
    try {
      SuccessResponse response =
          await HttpServices.uploadDrawings(projectId, clientId, image, remark);
      if (response.status == true) {
        emit(UploadSuccess());
        getDrawingList(projectId);
      } else {}
    } catch (e) {
      emit(DrawingFailure('Failed to fetch data: ${e.toString()}'));
    }
  }

  Future<void> deleteDrawing(
    String projectId,
    String siteId,
  ) async {
    try {
      SuccessResponse response = await HttpServices.deleteDrawing(siteId);
      if (response.status == true) {
        getDrawingList(projectId);
      } else {}
    } catch (e) {
      emit(DrawingFailure('Failed to fetch data: ${e.toString()}'));
    }
  }
}
