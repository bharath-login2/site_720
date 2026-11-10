import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:site_720/data/models/succes_response/success_response.dart';
import 'package:site_720/features/visit/cubit/visit_state.dart';
import '../../../data/models/task/task_status.dart';
import '../../../data/models/visit/visit_list_model.dart';
import '../../../data/models/visit/vist_status_model.dart';
import '../../../data/services/http_services.dart';

class VisitCubit extends Cubit<VisitState> {
  List<StatusModel> statusList = [];

  VisitCubit() : super(VisitInitial()) {
    getVisitDetails();
  }

  Future<void> getVisitDetails({
    String? statusId,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    emit(VisitLoading());
    try {
      if (statusList.isEmpty) {
        await getVisitStatus();
      }

      // The API returns dates as dd-MM-yyyy, so send the filter in the same format.
      // If the filter returns nothing, try 'yyyy-MM-dd' instead.
      final fmt = DateFormat('dd-MM-yyyy');

      final ListVisitModel? response = await HttpServices.getVisitDetails(
        statusId,
        fromDate: fromDate != null ? fmt.format(fromDate) : null,
        toDate: toDate != null ? fmt.format(toDate) : null,
      );

      if (response == null) {
        emit(VisitDetailsFailure('Failed to fetch data'));
        return;
      }

      if (response.status == true) {
        emit(VisitDetailsSuccess(response, statuses: statusList));
      } else {
        emit(VisitDetailsFailure(response.message));
      }
    } catch (e) {
      emit(VisitDetailsFailure('Failed to fetch data: ${e.toString()}'));
    }
  }

  Future<List<StatusModel>> getVisitStatus() async {
    try {
      final VisitStatusModel response = await HttpServices.getVisitStatus();

      if (response.status == true) {
        print('Visit status api: ${response.status}, '
            'count: ${response.data.length}');

        statusList = response.data
            .map((e) => StatusModel(
                  id: e.id.toString(),
                  status: e.status,
                ))
            .toList();

        return statusList;
      }

      return [];
    } catch (e) {
      log('getVisitStatus error: $e');
      return [];
    }
  }

  // Future<void> getTaskStatus() async {
  //   emit(VisitLoading());
  //   try {
  //     TaskStatusModel response = await HttpServices.getTaskStatus();

  //     if (response.status == true) {
  //      // emit(VisitStatusSuccess(response));
  //     } else {
  //     //  emit(VisitStatusFailure(response.message));
  //     }
  //   } catch (e) {
  //    // emit(VisitStatusFailure('Failed to fetch data: ${e.toString()}'));
  //   }
  // }

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
        await getVisitStatus();
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
