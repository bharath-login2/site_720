import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/models/project_list/add_project_response.dart';
import '../../../data/models/project_list/project_data_model.dart';
import '../../../data/services/http_services.dart';
import 'project_list_state.dart';

class AddProjectCubit extends Cubit<ProjectListState> {
  AddProjectCubit() : super(ProjectListInitial()) {
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
      AddProjectResponse response = await HttpServices.addProject(
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
