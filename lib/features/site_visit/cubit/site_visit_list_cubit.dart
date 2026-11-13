import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:site_720/features/site_visit/cubit/site_visit_list_state.dart';
import '../../../data/models/visit/visit_list_model.dart';
import '../../../data/models/visit/vist_status_model.dart';
import '../../../data/services/http_services.dart';

class VisitCubit extends Cubit<VisitState> {
  static const int pageSize = 10; // change this to change the page size

  List<StatusModel> statusList = [];

  // paging state
  final List<VisitItem> _items = [];
  int _page = 1;
  bool _hasMore = true;
  bool _loadingMore = false;
  int _requestId = 0; // bumps on every fresh load, to ignore late responses

  // current filters, remembered so "load more" needs no arguments
  String? _statusId;

  // counts shown on the filter chips (null = not known yet)
  int? _allCount;
  int? _pendingCount;
  int? _completedCount;
  Map<String, int> get counts => {
        if (_allCount != null) 'all': _allCount!,
        if (_pendingCount != null) 'pending': _pendingCount!,
        if (_completedCount != null) 'completed': _completedCount!,
      };

  DateTime? _from;
  DateTime? _to;

  VisitCubit() : super(VisitInitial()) {
    getVisitDetails();
  }

  void _emitSuccess() => emit(VisitDetailsSuccess(
        items: List.of(_items),
        statuses: statusList,
        hasMore: _hasMore,
        loadingMore: _loadingMore,
      ));

  //list api
  Future<void> getVisitDetails({
    String? statusId,
    DateTime? fromDate,
    DateTime? toDate,
    bool loadMore = false,
  }) async {
    if (loadMore) {
      if (!_hasMore || _loadingMore || state is! VisitDetailsSuccess) return;
      _loadingMore = true;
      _emitSuccess(); // shows the footer spinner
    } else {
      _requestId++;
      _statusId = statusId;
      _from = fromDate;
      _to = toDate;
      _loadingMore = false;
      emit(VisitLoading());
    }

    final myRequest = _requestId;
    final pageToLoad = loadMore ? _page + 1 : 1;

    try {
      if (statusList.isEmpty) {
        await getVisitStatus();
      }

      // The API returns dates as dd-MM-yyyy, so send the filter in the same format.
      // If the filter returns nothing, try 'yyyy-MM-dd' instead.
      final fmt = DateFormat('dd-MM-yyyy');

      final ListVisitModel? response = await HttpServices.getVisitDetails(
        _statusId,
        fromDate: _from != null ? fmt.format(_from!) : null,
        toDate: _to != null ? fmt.format(_to!) : null,
        page: pageToLoad,
        pageSize: pageSize,
      );

      // A newer filter or refresh started while this request was running.
      if (myRequest != _requestId) return;

      if (response != null && response.status == true) {
        if (!loadMore) _items.clear();
        _items.addAll(response.data);
        _page = pageToLoad;

        // Update the chip counts. Skip responses without counts (older API shape).
        final hasCounts = response.totalCount > 0 ||
            response.pendingCount > 0 ||
            response.completedCount > 0;
        if (hasCounts) {
          _pendingCount = response.pendingCount;
          _completedCount = response.completedCount;
          // "All" only comes from an unfiltered load, because a filtered total may
          // count just the filtered visits.
          if (_statusId == null) {
            _allCount = response.totalCount > 0
                ? response.totalCount
                : response.pendingCount + response.completedCount;
          }
        }

        // More pages exist only if this page was full AND the total says items
        // are still left. If the API sends no total (0), use the full-page check.
        final fullPage = response.data.length >= pageSize;
        final moreByTotal = response.totalCount > 0
            ? _items.length < response.totalCount
            : true;
        _hasMore = fullPage && moreByTotal;

        _loadingMore = false;
        _emitSuccess();
        return;
      }

      _loadingMore = false;
      if (loadMore) {
        _emitSuccess(); // keep the list; scrolling again retries
      } else {
        emit(VisitDetailsFailure(response?.message ?? 'Failed to fetch data'));
      }
    } catch (e) {
      if (myRequest != _requestId) return;
      _loadingMore = false;
      if (loadMore) {
        _emitSuccess();
      } else {
        emit(VisitDetailsFailure('Failed to fetch data: ${e.toString()}'));
      }
    }
  }

  //get status
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
