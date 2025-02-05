import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/models/project_list/project_data_model.dart';
import '../../../data/models/project_list/project_list_model.dart';
import '../../../data/services/http_services.dart';
import 'project_list_state.dart';

class ProjectListCubit extends Cubit<ProjectListState> {
  ProjectListCubit(String status, String searchKey, String type)
      : super(ProjectListInitial()) {
    if (type == "list") {
      getProjectList(status, searchKey);
    } else {
      getAddDetails();
    }
  }

  List imageList = [];

  Future<void> getProjectList(String status, String searchKey) async {
    emit(ProjectListLoading());
    try {
      ProjectListModel response =
          await HttpServices.getProjectList(status, searchKey);
      if (response.status == true) {
        emit(ProjectListSuccess(response));
      }
    } catch (e) {
      emit(ProjectListFailure('Failed to fetch data: ${e.toString()}'));
    }
  }

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

  selectMultiImage(
    ImageSource? source,
  ) async {
    try {
      if (source != null) {
        final XFile? selectedImages =
            await ImagePicker().pickImage(source: source);
        if (selectedImages != null) {
          imageList.add(selectedImages);
        }
        emit(ImageSuccess(imageList));
      } else {
        final List<XFile> images = await ImagePicker().pickMultiImage();
        if (images.isNotEmpty) {
          imageList.addAll(images);
        }
        emit(ImageSuccess(imageList));
      }
    } catch (e) {
      emit(ImageFailure("Failed to get image, Please Select once again.."));
    }
  }

  updatePriority(String value) {
    emit(PriorityUpdated(value));
  }
}
