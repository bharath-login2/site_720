import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/models/complaint/complaintStatus_model.dart';
import '../../../data/models/complaint/complaint_history_model.dart';
import '../../../data/services/http_services.dart';
import 'complaint_history_state.dart';


class ComplaintHistoryCubit extends Cubit<ComplaintHistoryState> {
  ComplaintHistoryCubit(String complaintId) : super(ComplaintHistoryInitial()) {
    getComplaintHistory(complaintId);
  }

  Future<void> getComplaintHistory(String complaintId) async {
    emit(ComplaintHistoryLoading());
    try {
      ComplaintHistoryModel response = await HttpServices.getComplaintHistory(complaintId);

      if (response.status == true) {
        emit(ComplaintHistorySuccess(response));
      //  await getTaskStatus();
      } else {
        emit(ComplaintHistoryFailure(response.message));
      }
    } catch (e) {
      emit(ComplaintHistoryFailure('Failed to fetch data: ${e.toString()}'));
    }
  }


  
  Future<void> getComplaintStatuses() async {
    emit(ComplaintStatusLoading());
    try {
      ComplaintStatusModel response = await HttpServices.getComplaintHistoryStatus();

      if (response.status == true) {
        emit(ComplaintStatusSuccess(response.data));
      } 
    } catch (e) {
       emit(ComplaintStatusFailure(e.toString()));
    }
  }

  // Future<void> getTaskStatus() async {
  //   emit(TaskLoading());
  //   try {
  //     TaskStatusModel response = await HttpServices.getTaskStatus();

  //     if (response.status == true) {
  //       emit(TaskStatusSuccess(response));
  //     } else {
  //       emit(TaskStatusFailure(response.message));
  //     }
  //   } catch (e) {
  //     emit(TaskStatusFailure('Failed to fetch data: ${e.toString()}'));
  //   }
  // }

// Future<void> addTaskDetails(
//   String taskId,
//   String visitId,
//   List<String> textQuestionNumbers,  
//   List<String> textAnswers, 
//   List<String> checkboxQuestionNumbers,  
//   List<List<String>> checkboxAnswersList,
//   List<String> fileQuestionNumbers,  
//   List<String> fileAnswers,
//   BuildContext context,
// ) async {
//   emit(TaskLoading());
//   try {
//     SuccessResponse response = await HttpServices.addTaskDetails(
//      // taskId,
//       visitId,
//       textQuestionNumbers,
//       textAnswers,
//       checkboxQuestionNumbers,
//       checkboxAnswersList,
//       fileQuestionNumbers,
//       fileAnswers,
//     );

//     if (response.status == true) {
//       emit(TaskDetailsSuccessWithMessage(response.message));
//       await getTaskStatus();
//     } else {
//       emit(TaskDetailsFailure(response.message));
//     }
//   } catch (e) {
//     emit(TaskDetailsFailure('Failed to fetch data: ${e.toString()}'));
//   }
// }



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
      emit(ImageHistorySuccess(image!));
    } catch (e) {
      emit(ImageFailure("Failed to get image, Please Select once again.."));
    }
  }

  // Future<void> updateTaskStatus(
  //   String taskId,
  //   String imagePath,
  //   String comment,
  //   String status,
  // ) async {
  //   try {
  //     SuccessResponse response = await HttpServices.updateTaskStatus(
  //         taskId, imagePath, comment, status);

  //     if (response.status == true) {
  //       emit(ComplaintHistoryStatusUpdated(response));
  //       getComplaintHistory(complaintId);
  //     } else {
  //       emit(ComplaintHistoryStatusupdateFailed(response.message));
  //     }
  //   } catch (e) {
  //     emit(ComplaintHistoryStatusupdateFailed('Failed to fetch data: ${e.toString()}'));
  //   }
  // }
}
