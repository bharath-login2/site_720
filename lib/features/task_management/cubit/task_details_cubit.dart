import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/models/tasklist/task_details_model.dart';
import '../../../data/models/tasklist/task_status.dart';
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
}
