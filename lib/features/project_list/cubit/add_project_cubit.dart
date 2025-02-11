import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:site_720/data/models/succes_response/success_response.dart';
import '../../../data/models/project_list/project_data_model.dart';
import '../../../data/services/http_services.dart';
import 'project_list_state.dart';

class AddProjectCubit extends Cubit<ProjectListState> {
  AddProjectCubit() : super(ProjectListInitial()) {
    getAddDetails();
  }

  List planImages = [];
  List elevationImages = [];

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

  selectMultiImage(ImageSource? source, type) async {
    try {
      if (source != null) {
        final XFile? selectedImages =
            await ImagePicker().pickImage(source: source);

        if (type == "plan") {
          if (selectedImages != null) {
            planImages.add(selectedImages);
          }
          emit(PlanSuccess(planImages));
        } else {
          if (selectedImages != null) {
            elevationImages.add(selectedImages);
          }
          emit(ElevationSuccess(elevationImages));
        }
      } else {
        final List<XFile> images = await ImagePicker().pickMultiImage();

        if (type == "plan") {
          if (images.isNotEmpty) {
            planImages.addAll(images);
          }
          emit(PlanSuccess(planImages));
        } else {
          if (images.isNotEmpty) {
            elevationImages.addAll(images);
          }
          emit(ElevationSuccess(elevationImages));
        }
      }
    } catch (e) {
      emit(ImageFailure("Failed to get image, Please Select once again.."));
    }
  }

  updatePriority(String value) {
    emit(PriorityUpdated(value));
  }

  deletePlan(int i) {
    planImages.removeAt(i);
    emit(PlanSuccess(planImages));
  }

  deleteElevation(int i) {
    elevationImages.removeAt(i);
    emit(ElevationSuccess(elevationImages));
  }

  Future<void> addProject(
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
    List planImg,
    List elevImg,
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
      SuccessResponse response = await HttpServices.addProject(
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
        emit(AddProjectSuccess(response.message));
      } else {
        emit(AddProjectFailed(response.message));
      }
    } catch (e) {
      emit(AddProjectFailed('Failed to fetch data: ${e.toString()}'));
    }
  }


}
