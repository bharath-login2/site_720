import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:site_720/data/models/succes_response/success_response.dart';
import 'package:site_720/features/visit/cubit/visit_state.dart';
import '../../../data/models/task/task_status.dart';
import '../../../data/models/visit/visit_list_model.dart';
import '../../../data/services/http_services.dart';

class VisitCubit extends Cubit<VisitState> {
  VisitCubit() : super(VisitInitial()) {
    getVisitDetails();
  }

  Future<void> getVisitDetails() async {
    emit(VisitLoading());
    try {
      ListVisitModel  response = await HttpServices.getVisitDetails();

      if (response.status == true) {
        emit(VisitDetailsSuccess(response));
       // await getTaskStatus();
      } else {
        emit(VisitDetailsFailure(response.message));
      }
    } catch (e) {
      emit(VisitDetailsFailure('Failed to fetch data: ${e.toString()}'));
    }
  }

  Future<void> getTaskStatus() async {
    emit(VisitLoading());
    try {
      TaskStatusModel response = await HttpServices.getTaskStatus();

      if (response.status == true) {
       // emit(VisitStatusSuccess(response));
      } else {
      //  emit(VisitStatusFailure(response.message));
      }
    } catch (e) {
     // emit(VisitStatusFailure('Failed to fetch data: ${e.toString()}'));
    }
  }

Future<void> addTaskDetails(
  String taskId,
  String visitId,
  List<String> textQuestionNumbers,  
  List<String> textAnswers, 
  List<String> checkboxQuestionNumbers,  
  List<List<String>> checkboxAnswersList,
  List<String> fileQuestionNumbers,  
  List<String> fileAnswers,
  BuildContext context,
) async {
  emit(VisitLoading());
  try {
    SuccessResponse response = await HttpServices.addTaskDetails(
     // taskId,
      visitId,
      textQuestionNumbers,
      textAnswers,
      checkboxQuestionNumbers,
      checkboxAnswersList,
      fileQuestionNumbers,
      fileAnswers,
    );

    if (response.status == true) {
      emit(VisitDetailsSuccessWithMessage(response.message));
      await getTaskStatus();
    } else {
      emit(VisitDetailsFailure(response.message));
    }
  } catch (e) {
    emit(VisitDetailsFailure('Failed to fetch data: ${e.toString()}'));
  }
}


  XFile? image;

  selectImage(
    ImageSource source,
  ) async {
    try {
      final XFile? selectedImage = await ImagePicker().pickImage(
        source: source,
        preferredCameraDevice: CameraDevice.front,
      );
      if (selectedImage != null) {
        image = selectedImage;
      }
      emit(ImageSuccess(image!));
    } catch (e) {
      emit(ImageFailure("Failed to get image, Please Select once again.."));
    }
  }


  double latitude = 0;
  double longitude = 0;


  getLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      latitude = position.latitude;
      longitude = position.longitude;
    } catch (e) {
      log(e.toString());
    } finally {}
  }


  Future<void> addAttendance(
    BuildContext context,
    String visitId,
    String imagePath,
  ) async {
    emit(VisitLoading());
    try {
      await getLocation();
      SuccessResponse response = await HttpServices.addAttendanceVisit(
          visitId, imagePath, latitude.toString(), longitude.toString());

      if (response.status == true) {
        emit(AttendanceUpdated(response));
        if (context.mounted) {}
      } else {
        emit(AttendanceFailed(response.message));
      }
    } catch (e) {
      log(e.toString());
      emit(
          AttendanceFailed("Attendance not added! Please check and try again"));
    }
  }


}
