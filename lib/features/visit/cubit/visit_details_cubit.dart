import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:site_720/data/models/succes_response/success_response.dart';
import 'package:site_720/features/visit/cubit/visit_details_state.dart';
import '../../../data/models/task/task_status.dart';
import '../../../data/models/visit/visit_details_model.dart';
import '../../../data/services/http_services.dart';

class VisitDetailsCubit extends Cubit<VisitDetailsState> {
  VisitDetailsCubit(this.visitId) : super(VisitDetailInitial()) {
    getVisitalldetails(visitId);
  }
 final String visitId;
  Future<void> getVisitalldetails(String visitId) async {
    emit(VisitDetailLoading());
    try {
      ListVisitDetailsModel  response = await HttpServices.getVisitalldetails(visitId);

      if (response.status == true) {
        emit(VisitDetailSuccess(response));
       // await getTaskStatus();
      } else {
        emit(VisitDetailFailure(response.message));
      }
    } catch (e) {
      emit(VisitDetailFailure('Failed to fetch data: ${e.toString()}'));
    }
  }

  Future<void> getTaskStatus() async {
    emit(VisitDetailLoading());
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
  //String taskId,
  String visitId,
  List<String> textQuestionNumbers,  
  List<String> textAnswers, 
  List<String> checkboxQuestionNumbers,  
  List<List<String>> checkboxAnswersList,
  List<String> fileQuestionNumbers,  
  List<String> fileAnswers,
  BuildContext context,
) async {
  emit(VisitDetailLoading());
  try {
    SuccessResponse response = await HttpServices.addTaskDetails(
      //taskId,
      visitId,
      textQuestionNumbers,
      textAnswers,
      checkboxQuestionNumbers,
      checkboxAnswersList,
      fileQuestionNumbers,
      fileAnswers,
    );

    if (response.status == true) {
      emit(VisitDetailSuccessWithMessage(response.message));
    //  await getTaskStatus();
    } else {
      emit(VisitDetailFailure(response.message));
    }
  } catch (e) {
    emit(VisitDetailFailure('Failed to fetch data: ${e.toString()}'));
  }
}

// Future<void> updateVisitStatus(
//   String visitId,
//   String comment,
//   String status,
// ) async {
//   try {
//     emit(VisitDetailLoading());
//     SuccessResponse response = await HttpServices.updateVisitStatus(
//       visitId, comment, status);

//     if (response.status == true) {
//       emit(VisitStatusUpdateSuccess(response));
//     } else {
//       emit(VisitDetailFailure(response.message));
//     }
//   } catch (e) {
//     emit(VisitDetailFailure('Failed to update status: ${e.toString()}'));
//   }
// }

Future<void> updateVisitStatus(
  String visitId,
  String comment,
  String status,
) async {
  try {
    emit(VisitDetailLoading());
     SuccessResponse response = await HttpServices.updateVisitStatus(
      visitId, comment, status,
    );
    if (response.status == true) {
   emit(VisitDetailSuccessWithMessage(response.message));
    }else {
      emit(VisitDetailFailure(response.message ?? 'Error occurred'));
    }
  } catch (e) {
    emit(VisitDetailFailure('Failed to update status: ${e.toString()}')); 
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
