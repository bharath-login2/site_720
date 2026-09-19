import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/models/complaint/complaint_list_model.dart';
import '../../../data/models/complaint/complaint_status_list.dart';
import '../../../data/models/succes_response/success_response.dart';
import '../../../data/services/http_services.dart';
import 'complaint_state.dart';

class ComplaintCubit extends Cubit<ComplaintState> {
  ComplaintCubit() : super(ComplaintInitial()) {
    getComplaintList();
    getComplaintStatus();
  }

  List<ComplaintList> complaints = [];
  List<StatusList> statusList = [];

  int currentPage = 1;
  static const int pageSize = 15;

  bool isLoadingMore = false;
  bool hasMoreComplaints = true;

  Future<void> getComplaintList({
    int page = 1,
    int pageSize = 15,
    bool isLoadMore = false,
  }) async {
    if (isLoadMore) {
      if (isLoadingMore || !hasMoreComplaints) return;

      isLoadingMore = true;
    } else {
      currentPage = 1;
      hasMoreComplaints = true;
      emit(ComplaintLoading());
    }

    try {
      ComplaintListModel response = await HttpServices.getComplaintList(
        page: page,
        pageSize: pageSize,
      );

      if (response.status == true) {
        final newComplaints = response.data;

        if (isLoadMore) {
          final existingIds =
              complaints.map((complaint) => complaint.id).toSet();

          final uniqueComplaints = newComplaints.where((complaint) {
            return existingIds.add(complaint.id);
          }).toList();

          complaints.addAll(uniqueComplaints);

          if (uniqueComplaints.isEmpty || newComplaints.length < pageSize) {
            hasMoreComplaints = false;
          }

          currentPage = page;

          print("PAGE: $page");
          print("RECEIVED: ${newComplaints.length}");
          print("ADDED: ${uniqueComplaints.length}");
          print("TOTAL: ${complaints.length}");

          emit(ComplaintSuccess(response));
        } else {
          complaints = newComplaints;

          if (newComplaints.length < pageSize) {
            hasMoreComplaints = false;
          }

          currentPage = page;

          print("PAGE: $page");
          print("RECEIVED: ${newComplaints.length}");
          print("TOTAL: ${complaints.length}");

          emit(ComplaintSuccess(response));
        }
      }
    } catch (e) {
      emit(
        ComplaintFailure(
          'Failed to fetch data: ${e.toString()}',
        ),
      );
    } finally {
      isLoadingMore = false;
    }
  }

  Future<void> getComplaintStatus() async {
    try {
      ComplaintStatusList response = await HttpServices.getComplaintStatus();

      if (response.status == true) {
        statusList = response.data.statusList;
      }
    } catch (e) {
      emit(ComplaintFailure('Failed to fetch data: ${e.toString()}'));
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

  Future<void> updateComplaintStatus(
    String complaintId,
    String imagePath,
    String comment,
    String status,
  ) async {
    try {
      SuccessResponse response = await HttpServices.updateComplaintStatus(
          complaintId, imagePath, comment, status);

      if (response.status == true) {
        emit(ComplaintStatusUpdated(response));
        getComplaintList();
      } else {
        emit(ComplaintStatusupdateFailed(response.message));
      }
    } catch (e) {
      emit(
          ComplaintStatusupdateFailed('Failed to fetch data: ${e.toString()}'));
    }
  }
}
