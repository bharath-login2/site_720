import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:site_720/data/models/succes_response/success_response.dart';
import 'package:site_720/data/models/visit/visit_history_model.dart';
import 'package:site_720/features/visit/cubit/visit_history_state.dart';
import '../../../data/models/task/task_status.dart';
import '../../../data/services/http_services.dart';

class VisitHistoryCubit extends Cubit<VisitHistoryState> {
  final String visitId;  // Declare visitId

  VisitHistoryCubit(this.visitId) : super(VisitHistoryInitial()) {
    getVisitHistoryDetails();
  }
 Future<void> getVisitHistoryDetails() async {
    emit(VisitHistoryLoading());
    try {
      
      VisitHistoryDetailsModel response = await HttpServices.getVisitHistoryDetails(visitId);

      if (response.status == true) {
        emit(VisitHistoryDetailsSuccess(response));
      } else {
        emit(VisitHistoryDetailsFailure(response.message));
      }
    } catch (e) {
      emit(VisitHistoryDetailsFailure("Error fetching visit details"));
    }
  }


  Future<void> getTaskStatus() async {
    emit(VisitHistoryLoading());
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
  emit(VisitHistoryLoading());
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
      emit(VisitHistoryDetailsSuccessWithMessage(response.message));
      await getTaskStatus();
    } else {
      emit(VisitHistoryDetailsFailure(response.message));
    }
  } catch (e) {
    emit(VisitHistoryDetailsFailure('Failed to fetch data: ${e.toString()}'));
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
     // emit(ImageSuccess(image!));
    } catch (e) {
    //  emit(ImageFailure("Failed to get image, Please Select once again.."));
    }
  }

  
}
