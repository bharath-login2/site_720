// import 'dart:developer';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:site_720/data/models/task/runningDashboard.dart';
// import '../../../data/models/succes_response/success_response.dart';
// import '../../../data/models/task/tasklist_model.dart';
// import '../../../data/services/http_services.dart';
// import 'task_state.dart';

// class TaskCubit extends Cubit<TaskState> {
//   TaskCubit() : super(TaskInitial()) {
//     // getTaskList();
//     getTaskListRunning();
//   }

//   Future<void> getTaskList({
//     int page = 1,
//     int pageSize = 15,
//     String? fromDate,
//     String? toDate,
//     String? workType,
//     String? category,
//     String? assignedBy,
//     String? assignedTo,
//     String? status,
//     String? viewType,
//     String? taskStatus,
//     bool isLoadMore = false,
//   }) async {
//     if (!isLoadMore) {
//       emit(TaskLoading());
//     }
//     try {
//       GetTaskList response = await HttpServices.getTaskList(
//           page: page,
//           pageSize: pageSize,
//           fromDate: fromDate,
//           toDate: toDate,
//           workType: workType,
//           category: category,
//           assignedBy: assignedBy,
//           assignedTo: assignedTo,
//           status: status,
//           viewType: viewType,
//           taskStatus: taskStatus);

//       if (response.status == true) {
//         emit(TaskSuccess(response));
//       } else {
//         emit(TaskFailure('Failed to fetch data'));
//       }
//     } catch (e) {
//       emit(TaskFailure('Failed to fetch data: ${e.toString()}'));
//     }
//   }

//   Future<void> getTaskListRunning() async {
//     emit(TaskLoading());
//     try {
//       final ProjectWorkModel? response =
//           await HttpServices.getTaskListRunning();
//       if (response != null && response.status == true) {
//         emit(RunningTaskListSuccess(response));
//       } else {
//         emit(TaskFailure('Failed to fetch data'));
//       }
//     } catch (e) {
//       emit(TaskFailure('Failed to fetch data: ${e.toString()}'));
//     }
//   }

//   XFile? image;

//   selectImage(
//     ImageSource source,
//   ) async {
//     try {
//       final XFile? selectedImage = await ImagePicker().pickImage(
//         source: source,
//         preferredCameraDevice: CameraDevice.front,
//       );
//       if (selectedImage != null) {
//         image = selectedImage;
//       }
//       emit(ImageSuccess(image!));
//     } catch (e) {
//       emit(ImageFailure("Failed to get image, Please Select once again.."));
//     }
//   }

//   double latitude = 0;
//   double longitude = 0;

//   getLocation() async {
//     try {
//       LocationPermission permission = await Geolocator.checkPermission();

//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         return;
//       }

//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.best,
//       );

//       latitude = position.latitude;
//       longitude = position.longitude;
//     } catch (e) {
//       log(e.toString());
//     } finally {}
//   }

//   Future<void> addAttendance(
//     BuildContext context,
//     String taskId,
//     String imagePath,
//   ) async {
//     emit(TaskLoading());
//     try {
//       await getLocation();
//       SuccessResponse response = await HttpServices.addAttendance(
//           taskId, imagePath, latitude.toString(), longitude.toString());

//       if (response.status == true) {
//         emit(AttendanceUpdated(response));
//         if (context.mounted) {}
//       } else {
//         emit(AttendanceFailed(response.message));
//       }
//     } catch (e) {
//       log(e.toString());
//       emit(
//           AttendanceFailed("Attendance not added! Please check and try again"));
//     }
//   }
// }

import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:site_720/data/models/extraworklist/officeCategoryModel.dart';
import 'package:site_720/data/models/extraworklist/siteWorkCategoryModel.dart';
import 'package:site_720/data/models/extraworklist/staffListModel.dart';
import 'package:site_720/data/models/task/runningDashboard.dart';
import '../../../data/models/succes_response/success_response.dart';
import '../../../data/models/task/tasklist_model.dart';
import '../../../data/services/http_services.dart';
import 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskInitial()) {
    // getTaskList();
    getTaskListRunning();
  }

  // ───────────────────────── LIST + PAGINATION STATE ─────────────────────────
  List<Tasks> taskList = [];
  int currentPage = 1;
  static const int pageSize = 15;
  bool isLoadingMore = false;
  bool hasMoreTasks = true;

  // ───────────────────────────── STATUS COUNTS ──────────────────────────────
  int pendingCount = 0;
  int ongoingCount = 0;
  int completedCount = 0;
  int cancelledCount = 0;

  // ───────────────────────────────── FILTERS ────────────────────────────────
  /// "my" | "assigned" | "all" | "pending" | "ongoing" | "completed" | "cancelled"
  String filterType = "my";

  /// Set only when a status card is tapped ("4" pending, "3" ongoing,
  /// "1" completed, "2" cancelled). null for the My / Assigned / All tabs.
  String? _taskStatusCode;

  DateTime? filterFromDate;
  DateTime? filterToDate;
  String? filterWorkType;
  String? filterCategoryId;
  String? filterAssignedById;
  String? filterAssignedToId;
  List<String> selectedStatuses = [];

  // ──────────────────────────── FILTER SHEET DATA ───────────────────────────
  List<OfficeCategory> officeCategories = [];
  List<SiteCategory> siteCategories = [];
  List<dynamic> complaintCategories = [];
  List<StaffList> staffs = [];

  String? formatDate(DateTime? date) {
    if (date == null) return null;
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return "$day-$month-${date.year}";
  }

  // ───────────────────────────── PUBLIC ACTIONS ─────────────────────────────

  /// Reload page 1 with the current filters (refresh, after add/edit/delete)
  Future<void> reload() => _fetch(page: 1);

  /// Load next page with the current filters
  Future<void> loadMore() async {
    if (isLoadingMore || !hasMoreTasks) return;

    isLoadingMore = true;
    try {
      await _fetch(page: currentPage + 1, isLoadMore: true);
    } finally {
      isLoadingMore = false;
    }
  }

  /// My Tasks / Assigned Tasks / All Tasks tabs
  Future<void> setViewType(String type) {
    filterType = type;
    _taskStatusCode = null;
    return reload();
  }

  /// Pending / Ongoing / Completed / Cancelled cards
  Future<void> setTaskStatusCard(String type, String statusCode) {
    filterType = type;
    _taskStatusCode = statusCode;
    return reload();
  }

  /// Apply button of the filter sheet
  Future<void> applyFilters({
    DateTime? fromDate,
    DateTime? toDate,
    String? workType,
    String? categoryId,
    String? assignedById,
    String? assignedToId,
    required List<String> statuses,
  }) {
    filterFromDate = fromDate;
    filterToDate = toDate;
    filterWorkType = workType;
    filterCategoryId = categoryId;
    filterAssignedById = assignedById;
    filterAssignedToId = assignedToId;
    selectedStatuses = List.from(statuses);
    return reload();
  }

  Future<void> _fetch({required int page, bool isLoadMore = false}) {
    return getTaskList(
      page: page,
      pageSize: pageSize,
      fromDate: formatDate(filterFromDate),
      toDate: formatDate(filterToDate),
      workType: filterWorkType,
      category: filterCategoryId,
      assignedBy: filterAssignedById,
      assignedTo: filterAssignedToId,
      status: selectedStatuses.isEmpty ? null : selectedStatuses.join(','),
      viewType: _taskStatusCode != null ? "" : filterType,
      taskStatus: _taskStatusCode,
      isLoadMore: isLoadMore,
    );
  }

  /// Categories + staff for the filter sheet
  Future<void> loadFilterData() async {
    try {
      final officeRes = await HttpServices.getOfficeCategory();
      if (officeRes != null) officeCategories = officeRes.data;

      final siteRes = await HttpServices.getSiteCategory();
      if (siteRes != null) siteCategories = siteRes.data;

      final staffRes = await HttpServices.getStaffsList();
      if (staffRes != null) staffs = staffRes.data;

      final complaintRes = await HttpServices.getComplaintCategory();
      if (complaintRes != null) complaintCategories = complaintRes.data;
    } catch (e) {
      log("Error loading categories or staffs: $e");
    }
  }

  // ─────────────────────────────── API CALLS ────────────────────────────────

  Future<void> getTaskList({
    int page = 1,
    int pageSize = 15,
    String? fromDate,
    String? toDate,
    String? workType,
    String? category,
    String? assignedBy,
    String? assignedTo,
    String? status,
    String? viewType,
    String? taskStatus,
    bool isLoadMore = false,
  }) async {
    if (!isLoadMore) {
      taskList = [];
      hasMoreTasks = true;
      currentPage = 1;
      emit(TaskLoading());
    }
    try {
      GetTaskList response = await HttpServices.getTaskList(
          page: page,
          pageSize: pageSize,
          fromDate: fromDate,
          toDate: toDate,
          workType: workType,
          category: category,
          assignedBy: assignedBy,
          assignedTo: assignedTo,
          status: status,
          viewType: viewType,
          taskStatus: taskStatus);

      if (response.status == true) {
        final newTasks = response.data.resultData;

        pendingCount = response.data.pendingCount;
        ongoingCount = response.data.ongoingCount;
        completedCount = response.data.completedCount;
        cancelledCount = response.data.cancelledCount;

        if (isLoadMore) {
          taskList = [...taskList, ...newTasks];
        } else {
          taskList = newTasks;
        }
        currentPage = page;

        // fewer than pageSize returned → last page
        hasMoreTasks = newTasks.length >= pageSize;

        emit(TaskSuccess(response));
      } else {
        emit(TaskFailure('Failed to fetch data'));
      }
    } catch (e) {
      emit(TaskFailure('Failed to fetch data: ${e.toString()}'));
    }
  }

  Future<void> getTaskListRunning() async {
    emit(TaskLoading());
    try {
      final ProjectWorkModel? response =
          await HttpServices.getTaskListRunning();
      if (response != null && response.status == true) {
        emit(RunningTaskListSuccess(response));
      } else {
        emit(TaskFailure('Failed to fetch data'));
      }
    } catch (e) {
      emit(TaskFailure('Failed to fetch data: ${e.toString()}'));
    }
  }

  XFile? image;

  void clearImage() {
    image = null;
  }

  selectImage(
    ImageSource source,
  ) async {
    try {
      final XFile? selectedImage = await ImagePicker().pickImage(
        source: source,
        preferredCameraDevice: CameraDevice.front,
      );
      if (selectedImage != null) {
        image = selectedImage;
      }
      emit(ImageSuccess(image!));
    } catch (e) {
      emit(ImageFailure("Failed to get image, Please Select once again.."));
    }
  }

  double latitude = 0;
  double longitude = 0;

  getLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      latitude = position.latitude;
      longitude = position.longitude;
    } catch (e) {
      log(e.toString());
    } finally {}
  }

  Future<void> addAttendance(
    BuildContext context,
    String taskId,
    String imagePath,
  ) async {
    emit(TaskLoading());
    try {
      await getLocation();
      SuccessResponse response = await HttpServices.addAttendance(
          taskId, imagePath, latitude.toString(), longitude.toString());

      if (response.status == true) {
        emit(AttendanceUpdated(response));
        if (context.mounted) {}
      } else {
        emit(AttendanceFailed(response.message));
      }
    } catch (e) {
      log(e.toString());
      emit(
          AttendanceFailed("Attendance not added! Please check and try again"));
    }
  }
}
