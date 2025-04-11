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

  Future<void> getComplaintList() async {
    emit(ComplaintLoading());
    try {
      ComplaintListModel response = await HttpServices.getComplaintList();

      if (response.status == true) {
        complaints = response.data;
        emit(ComplaintSuccess(response));
      }
    } catch (e) {
      emit(ComplaintFailure('Failed to fetch data: ${e.toString()}'));
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
