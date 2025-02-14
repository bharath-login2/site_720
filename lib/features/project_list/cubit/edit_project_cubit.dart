import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:site_720/data/models/project_list/edit_data_model.dart';
import 'package:site_720/data/models/succes_response/success_response.dart';
import '../../../data/models/project_list/project_data_model.dart';
import '../../../data/services/http_services.dart';
import 'project_list_state.dart';

class EditProjectCubit extends Cubit<ProjectListState> {
  EditProjectCubit(String projectId) : super(ProjectListInitial()) {
    editDetails(projectId);
    getAddDetails();
  }

  XFile? planImages;
  XFile? elevationImages;

  Future<void> getAddDetails() async {
    emit(ProjectDataLoading());
    try {
      ProjectDataModel response = await HttpServices.getAddProjectDetails();
      if (response.status == true) {
        emit(ProjectDataSuccess(response));
      }
    } catch (e) {
      log(e.toString());
    }
  }

  selectImage(ImageSource? source, type) async {
    try {
      if (source != null) {
        final XFile? selectedImage =
            await ImagePicker().pickImage(source: source);

        if (type == "plan") {
          if (selectedImage != null) {
            planImages = selectedImage;
          }
          emit(PlanSuccess(planImages!));
        } else {
          if (selectedImage != null) {
            elevationImages = selectedImage;
          }
          emit(ElevationSuccess(elevationImages!));
        }
      } else {
        final XFile? selectedImage =
            await ImagePicker().pickImage(source: ImageSource.gallery);

        if (type == "plan") {
          if (selectedImage != null) {
            planImages = selectedImage;
          }
          emit(PlanSuccess(planImages!));
        } else {
          if (selectedImage != null) {
            elevationImages = selectedImage;
          } 
          emit(ElevationSuccess(elevationImages!));
        }
      }
    } catch (e) {
      emit(ImageFailure("Failed to get image, Please Select once again.."));
    }
  }

  updatePriority(String value) {
    emit(PriorityUpdated(value));
  }

  Future<void> updateProject(
    String projectId,
    String clientId,
    String projectName,
    String projectType,
    String projectCategory,
    String referenceNo,
    String location,
    String locationArea,
    String cctvId,
    String priority,
    String packageId,
    String bhkNo,
    String startDate,
    String compDate,
    String planImg,
    String elevImg,
    String fixedRateValue,
    List<Map<String, dynamic>> unitList,
    String estBudAmt,
    String gst,
    String gstAmt,
    String totalAmt,
    String descripion,
    String ipoNo,
    String workOrderNo,
  ) async {
    try {
      SuccessResponse response = await HttpServices.updateProject(
          projectId,
          clientId,
          projectName,
          projectType,
          projectCategory,
          referenceNo,
          location,
          locationArea,
          cctvId,
          priority,
          packageId,
          bhkNo,
          startDate,
          compDate,
          planImg,
          elevImg,
          fixedRateValue,
          unitList,
          estBudAmt,
          gst,
          gstAmt,
          totalAmt,
          descripion,
          ipoNo,
          workOrderNo);
      if (response.status == true) {
        emit(EditProjectSuccess(response.message));
      } else {
        emit(EditProjectFailed(response.message));
      }
    } catch (e) {
      emit(EditProjectFailed('Failed : ${e.toString()}'));
    }
  }

  Future<void> editDetails(String projectId) async {
    try {
      emit(EditDtailsLoading());
      EditDataModel response = await HttpServices.editDetails(projectId);
      if (response.status == true) {
        emit(EditDtailsSuccess(response));
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
