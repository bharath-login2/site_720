import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/models/site_drawings/drawing_list.dart';
import '../../../data/models/succes_response/success_response.dart';
import '../../../data/services/http_services.dart';
import 'drawing_state.dart';

class DrawingCubit extends Cubit<DrawingState> {
  DrawingCubit(String projectId) : super(DrawingInitial()) {
    getDrawingList(projectId);
  }

  XFile? image;
  PlatformFile? selectedPdf;

  Future<void> selectImage(ImageSource source) async {
    try {
      final XFile? selectedImage =
          await ImagePicker().pickImage(source: source);

      if (selectedImage == null) return;

      image = selectedImage;
      selectedPdf = null;

      emit(ImageSuccess(image!));
    } catch (e) {
      emit(ImageFailure("Failed to select image"));
    }
  }

  Future<void> selectPdf() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result == null) return;

      selectedPdf = result.files.first;
      image = null;

      emit(PdfSuccess(selectedPdf!));
    } catch (e) {
      emit(PdfFailure("Failed to select PDF"));
    }
  }

  Future<void> getDrawingList(String projectId) async {
    emit(DrawingLoading());

    try {
      SiteDrawingsList response = await HttpServices.getDrawingList(projectId);

      if (response.status == true) {
        emit(DrawingSuccess(response));
      } else {
        emit(DrawingFailure("Failed to load drawings"));
      }
    } catch (e) {
      emit(DrawingFailure(e.toString()));
    }
  }

  Future<void> uploadDrawings(
    String projectId,
    String clientId,
    File file,
    String remark,
  ) async {
    try {
      emit(UploadLoading());

      SuccessResponse response = await HttpServices.uploadDrawings(
        projectId,
        clientId,
        file,
        remark,
      );

      if (response.status == true) {
        image = null;
        selectedPdf = null;

        emit(UploadSuccess());

        getDrawingList(projectId);
      } else {
        emit(DrawingFailure(response.message ?? "Upload failed"));
      }
    } catch (e) {
      emit(DrawingFailure(e.toString()));
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
      } else {
        emit(DrawingFailure(response.message ?? "Delete failed"));
      }
    } catch (e) {
      emit(DrawingFailure(e.toString()));
    }
  }
}
