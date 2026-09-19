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

  /// GET WORK LIST
  Future<void> getExternalWorkDetailsList({
    int page = 1,
    bool isLoadMore = false,
  }) async {
    print(
      'getExternalWorkDetailsList → page: $page, isLoadMore: $isLoadMore',
    );

    if (isLoadMore) {
      if (isLoadingMore || !hasMoreWork) {
        print(
          'Pagination stopped → isLoadingMore: $isLoadingMore, hasMoreWork: $hasMoreWork',
        );
        return;
      }

      isLoadingMore = true;
      print('Loading more work...');
    } else {
      currentPage = page;
      hasMoreWork = true;

      print('Initial load → page: $page');

      emit(WorkLoading());
    }

    try {
      final response = await HttpServices.getExternalWorkDetailsList(
        page: page,
        pageSize: pageSize,
      );

      final model = ExternalWorkModel.fromJson(response);

      print('API response status: ${model.status}');
      print('Items received: ${model.data.length}');

      if (model.status == true) {
        if (isLoadMore) {
          print('Before add → total work: ${workList.length}');

          workList.addAll(model.data);

          print('After add → total work: ${workList.length}');

          if (model.data.length < pageSize) {
            hasMoreWork = false;
            print('No more work data available.');
          }

          currentPage = page;

          print('Current page updated to: $currentPage');
        } else {
          workList = model.data;

          print('Initial work count: ${workList.length}');

          if (model.data.length < pageSize) {
            hasMoreWork = false;
            print('First page contains less than $pageSize items.');
          }

          currentPage = page;
        }

        emit(
          WorkSuccess(
            workList: workList,
            filteredWorkList: workList,
          ),
        );
      } else {
        print('API returned failure: ${model.message}');
        emit(
          WorkFailure(model.message),
        );
      }
    } catch (e) {
      print('getExternalWorkDetailsList error: $e');

      emit(
        WorkFailure(e.toString()),
      );
    } finally {
      isLoadingMore = false;
      print(
        'Pagination finished → currentPage: $currentPage, '
        'total: ${workList.length}, hasMore: $hasMoreWork',
      );
    }
  }

  void searchProjects(String query) {
    if (state is WorkSuccess) {
      final currentState = state as WorkSuccess;

      if (query.isEmpty) {
        emit(
          WorkSuccess(
            workList: currentState.workList,
            filteredWorkList: currentState.workList,
          ),
        );
        return;
      }

      final filteredList = currentState.workList.where((item) {
        return item.projectName.toLowerCase().contains(query.toLowerCase());
      }).toList();

      emit(
        WorkSuccess(
          workList: currentState.workList,
          filteredWorkList: filteredList,
        ),
      );
    }
  }
}
