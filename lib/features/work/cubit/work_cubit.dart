import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/work/work_model.dart';
import '../../../data/services/http_services.dart';
import 'work_state.dart';

class WorkCubit extends Cubit<WorkState> {
  WorkCubit() : super(WorkInitial());

  List<ExternalWorkItem> workList = [];
  int currentPage = 1;
  static const int pageSize = 20;

  bool isLoadingMore = false;
  bool hasMoreWork = true;

  /// STATUS FILTER (null = All, "pending", "updated")
  String? selectedStatus;

  /// Keeps the search text so it survives reloads / pagination
  String _searchQuery = '';

  String get searchQuery => _searchQuery;

  /// SET STATUS FILTER → reloads page 1 from the A PI
  Future<void> setStatusFilter(String? status) async {
    selectedStatus = status;
    await getExternalWorkDetailsList(page: 1, isLoadMore: false);
  }

  /// GET WORK LIST
  Future<void> getExternalWorkDetailsList({
    int page = 1,
    bool isLoadMore = false,
  }) async {
    debugPrint(
      'getExternalWorkDetailsList → page: $page, isLoadMore: $isLoadMore, '
      'status: $selectedStatus',
    );

    if (isLoadMore) {
      if (isLoadingMore || !hasMoreWork) {
        debugPrint(
          'Pagination stopped → isLoadingMore: $isLoadingMore, hasMoreWork: $hasMoreWork',
        );
        return;
      }

      isLoadingMore = true;
      debugPrint('Loading more work...');
    } else {
      currentPage = page;
      hasMoreWork = true;

      debugPrint('Initial load → page: $page');

      emit(WorkLoading());
    }

    try {
      final response = await HttpServices.getExternalWorkDetailsList(
        page: page,
        pageSize: pageSize,
        status: selectedStatus, // <-- passed to API
      );

      final model = ExternalWorkModel.fromJson(response);

      debugPrint('API response status: ${model.status}');
      debugPrint('Items received: ${model.data.length}');

      if (model.status == true) {
        if (isLoadMore) {
          workList.addAll(model.data);

          if (model.data.length < pageSize) {
            hasMoreWork = false;
            debugPrint('No more work data available.');
          }

          currentPage = page;
        } else {
          workList = model.data;

          if (model.data.length < pageSize) {
            hasMoreWork = false;
            debugPrint('First page contains less than $pageSize items.');
          }

          currentPage = page;
        }

        emit(
          WorkSuccess(
            workList: workList,
            filteredWorkList: _applySearch(workList),
          ),
        );
      } else {
        debugPrint('API returned failure: ${model.message}');
        emit(
          WorkFailure(model.message),
        );
      }
    } catch (e) {
      debugPrint('getExternalWorkDetailsList error: $e');

      emit(
        WorkFailure(e.toString()),
      );
    } finally {
      isLoadingMore = false;
      debugPrint(
        'Pagination finished → currentPage: $currentPage, '
        'total: ${workList.length}, hasMore: $hasMoreWork',
      );
    }
  }

  /// LOCAL SEARCH (applied on top of the API-filtered list)
  void searchProjects(String query) {
    _searchQuery = query;

    if (state is WorkSuccess) {
      final currentState = state as WorkSuccess;

      emit(
        WorkSuccess(
          workList: currentState.workList,
          filteredWorkList: _applySearch(currentState.workList),
        ),
      );
    }
  }

  List<ExternalWorkItem> _applySearch(List<ExternalWorkItem> list) {
    if (_searchQuery.isEmpty) return list;

    final q = _searchQuery.toLowerCase();

    return list
        .where((item) => item.projectName.toLowerCase().contains(q))
        .toList();
  }
}
