// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:site_720/data/models/succes_response/success_response.dart';
// import 'package:site_720/features/visit/cubit/visit_details_state.dart';
// import '../../../data/models/task/task_status.dart';
// import '../../../data/models/visit/visit_details_model.dart';
// import '../../../data/services/http_services.dart';

// class VisitDetailsCubit extends Cubit<VisitDetailsState> {
//   VisitDetailsCubit(this.visitId) : super(VisitDetailInitial()) {
//     getVisitalldetails(visitId);
//   }
//  final String visitId;
//   Future<void> getVisitalldetails(String visitId) async {
//     emit(VisitDetailLoading());
//     try {
//       ListVisitDetailsModel  response = await HttpServices.getVisitalldetails(visitId);

//       if (response.status == true) {
//         emit(VisitDetailSuccess(response));
//        // await getTaskStatus();
//       } else {
//         emit(VisitDetailFailure(response.message));
//       }
//     } catch (e) {
//       emit(VisitDetailFailure('Failed to fetch data: ${e.toString()}'));
//     }
//   }

//   Future<void> getTaskStatus() async {
//     emit(VisitDetailLoading());
//     try {
//       TaskStatusModel response = await HttpServices.getTaskStatus();
//       if (response.status == true) {
//        // emit(VisitStatusSuccess(response));
//       } else {
//       //  emit(VisitStatusFailure(response.message));
//       }
//     } catch (e) {
//      // emit(VisitStatusFailure('Failed to fetch data: ${e.toString()}'));
//     }
//   }

// Future<void> updateVisitStatus(
//   String visitId,
//   String comment,
//   String status,
// ) async {
//   try {
//     emit(VisitDetailLoading());
//      SuccessResponse response = await HttpServices.updateVisitStatus(
//       visitId, comment, status,
//     );
//     if (response.status == true) {
//    emit(VisitDetailSuccessWithMessage(response.message));
//     }else {
//       emit(VisitDetailFailure(response.message ?? 'Error occurred'));
//     }
//   } catch (e) {
//     emit(VisitDetailFailure('Failed to update status: ${e.toString()}'));
//   }
// }

//     XFile? image;

//     selectImage(
//       ImageSource source,
//     ) async {
//       try {
//         final XFile? selectedImage =
//             await ImagePicker().pickImage(source: source);
//         if (selectedImage != null) {
//           image = selectedImage;
//         }
//       // emit(ImageSuccess(image!));
//       } catch (e) {
//       //  emit(ImageFailure("Failed to get image, Please Select once again.."));
//       }
//     }

// }
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/services/http_services.dart';
import 'package:site_720/features/visit/cubit/visit_details_state.dart';
export 'package:site_720/features/visit/cubit/visit_details_state.dart';

class VisitTaskCubit extends Cubit<VisitTaskState> {
  final String visitId;

  VisitTaskCubit(this.visitId) : super(VisitTaskLoading()) {
    load();
  }

  Future<void> load() async {
    emit(VisitTaskLoading());
    try {
      final res = await HttpServices.getVisitQuestions(visitId);
      if (res == null) {
        emit(VisitTaskFailure('Failed to fetch data'));
      } else if (res.status == true) {
        emit(VisitTaskLoaded(res.data));
      } else {
        emit(VisitTaskFailure(res.message));
      }
    } catch (e) {
      emit(VisitTaskFailure('Failed to fetch data: $e'));
    }
  }

  Future<void> save({
    required String status,
    required List<Map<String, dynamic>> answers,
    required Map<int, String> files,
  }) async {
    emit(VisitTaskSaving());
    try {
      final res = await HttpServices.saveVisitAnswers(
        visitId: visitId,
        status: status,
        answers: answers,
        files: files,
      );
      if (res != null && res['status'] == true) {
        emit(VisitTaskSaved(res['message']?.toString().isNotEmpty == true
            ? res['message'].toString()
            : 'Saved successfully'));
      } else {
        emit(VisitTaskSaveFailed(
            res?['message']?.toString() ?? 'Failed to save'));
      }
    } catch (e) {
      emit(VisitTaskSaveFailed('Failed to save: $e'));
    }
  }
}
