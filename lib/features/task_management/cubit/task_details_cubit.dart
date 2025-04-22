import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:site_720/data/models/succes_response/success_response.dart';
import '../../../data/models/task/task_details_model.dart';
import '../../../data/models/task/task_status.dart';
import '../../../data/services/http_services.dart';
import 'task_state.dart';

class TaskDetailsCubit extends Cubit<TaskState> {
  TaskDetailsCubit(String taskId) : super(TaskInitial()) {
    getTaskDetails(taskId);
  }

  Future<void> getTaskDetails(String taskId) async {
    emit(TaskLoading());
    try {
      TaskDetailsModel response = await HttpServices.getTaskDetails(taskId);

      if (response.status == true) {
        emit(TaskDetailsSuccess(response));
        await getTaskStatus();
      } else {
        emit(TaskDetailsFailure(response.message));
      }
    } catch (e) {
      emit(TaskDetailsFailure('Failed to fetch data: ${e.toString()}'));
    }
  }

  Future<void> getTaskStatus() async {
    emit(TaskLoading());
    try {
      TaskStatusModel response = await HttpServices.getTaskStatus();

      if (response.status == true) {
        emit(TaskStatusSuccess(response));
      } else {
        emit(TaskStatusFailure(response.message));
      }
    } catch (e) {
      emit(TaskStatusFailure('Failed to fetch data: ${e.toString()}'));
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
  emit(TaskLoading());
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
      emit(TaskDetailsSuccessWithMessage(response.message));
      await getTaskStatus();
    } else {
      emit(TaskDetailsFailure(response.message));
    }
  } catch (e) {
    emit(TaskDetailsFailure('Failed to fetch data: ${e.toString()}'));
  }
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

  Future<void> updateTaskStatus(
    String taskId,
    String imagePath,
    String comment,
    String status,
  ) async {
    try {
      SuccessResponse response = await HttpServices.updateTaskStatus(
          taskId, imagePath, comment, status);

      if (response.status == true) {
        emit(TaskStatusUpdated(response));
        getTaskDetails(taskId);
      } else {
        emit(TaskStatusupdateFailed(response.message));
      }
    } catch (e) {
      emit(TaskStatusupdateFailed('Failed to fetch data: ${e.toString()}'));
    }
  }
}
