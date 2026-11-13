import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/services/http_services.dart';
import 'package:site_720/features/site_visit/cubit/site_visit_details_state.dart';
import '../../../data/models/visit/vist_status_model.dart';
import '../../../data/models/visit/visit_list_model.dart';

class VisitTaskCubit extends Cubit<VisitTaskState> {
  final String visitId;
  List<StatusModel> statusList = [];

  VisitTaskCubit(this.visitId) : super(VisitTaskLoading()) {
    load();
  }

  //get details
  Future<void> load() async {
    emit(VisitTaskLoading());
    try {
      // Questions and statuses load together. A failed status call does not
      // block the page, because save() tries it again.
      final results = await Future.wait([
        HttpServices.getVisitQuestions(visitId),
        if (statusList.isEmpty) getVisitStatus(),
      ]);
      final res = results.first as dynamic;

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

  //refresh
  Future<bool> refresh() async {
    try {
      final res = await HttpServices.getVisitQuestions(visitId);
      if (res != null && res.status == true) {
        emit(VisitTaskLoaded(res.data));
        return true;
      }
    } catch (_) {}
    return false;
  }

  //delete files
  Future<bool> deleteFile(String fileId) async {
    try {
      return await HttpServices.deleteVisitFile(
        visitId: visitId,
        fileId: fileId,
      );
    } catch (_) {
      return false;
    }
  }

  /// "Pending" / "Completed" (sent by the screen) -> id from the API.
  String? _statusId(String name) {
    final wanted = name.trim().toLowerCase();
    for (final s in statusList) {
      if (s.status.trim().toLowerCase() == wanted) return s.id;
    }
    return null;
  }

  //save items
  Future<void> save({
    required String status,
    required List<Map<String, dynamic>> answers,
    required Map<int, List<String>> files,
  }) async {
    emit(VisitTaskSaving());

    // The status call may have failed earlier, so try again before saving.
    if (statusList.isEmpty) await getVisitStatus();

    final statusId = _statusId(status);
    if (statusId == null) {
      // Never guess an id: a wrong one would save the visit with the wrong status.
     
      emit(VisitTaskSaveFailed('Could not find the "$status" status. '
          'Please check your connection and try again.'));
      return;
    }

    try {
      final res = await HttpServices.saveVisitAnswers(
        visitId: visitId,
        statusId: statusId,
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

  //status id
  Future<List<StatusModel>> getVisitStatus() async {
    try {
      final VisitStatusModel response = await HttpServices.getVisitStatus();

      if (response.status == true) {
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
      
      return [];
    }
  }
}
