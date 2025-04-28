import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/models/succes_response/success_response.dart';
import '../../../data/models/task/tasklist_model.dart';
import '../../../data/services/http_services.dart';
import 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskInitial()) {
    getTaskList();
  }

  Future<void> getTaskList() async {
    emit(TaskLoading());
    try {
      GetTaskList response = await HttpServices.getTaskList();

      if (response.status == true) {
        emit(TaskSuccess(response));
      } else {
        emit(TaskFailure('Failed to fetch data}'));
      }
    } catch (e) {
      emit(TaskFailure('Failed to fetch data: ${e.toString()}'));
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
    String taskId,
    String imagePath,
  ) async {
     emit(TaskLoading());
    try {
      await getLocation();
      SuccessResponse response = await HttpServices.addAttendance(
          taskId, imagePath, latitude.toString(), longitude.toString());

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
