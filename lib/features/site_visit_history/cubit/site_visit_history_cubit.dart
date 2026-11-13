import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/site_visit_history/site_visit_history_model.dart';
import '../../../data/models/visit/vist_status_model.dart';
import '../../../data/services/http_services.dart';
import 'site_visit_history_state.dart';

class SiteVisitHistoryCubit extends Cubit<SiteVisitHistoryState> {
  SiteVisitHistoryCubit() : super(const SiteVisitHistoryInitial());

  static const int pageSize = 10; // change this to change the page size

  // Bumped on every fresh load / filter change, so a late response from
  // before is thrown away instead of corrupting the new list.
  int _requestId = 0;

  // Status IDs from the status API (same one the visit list uses),
  // matched by name: "Pending" and "Completed".
  final Map<VisitFilter, String> _statusIds = {};

  Future<bool> _ensureStatusIds() async {
    if (_statusIds.isNotEmpty) return true;
    try {
      final VisitStatusModel res = await HttpServices.getVisitStatus();
      if (res.status == true) {
        for (final e in res.data) {
          final name = e.status.toLowerCase();
          final id = e.id.toString();
          if (name.contains('complet')) {
            _statusIds[VisitFilter.completed] = id;
          } else if (name.contains('pend')) {
            _statusIds[VisitFilter.pending] = id;
          }
        }
      }
    } catch (e) {
      debugPrint('❌ [SiteVisitHistory] status API error: $e');
    }
    return _statusIds.isNotEmpty;
  }

  /// More pages exist only if the page was full AND the total (when the API
  /// sends one) says items are still left.
  bool _moreAvailable(VisitTaskData d, int loadedSoFar) {
    final fullPage = d.lists.length >= pageSize;
    final moreByTotal = d.totalCount > 0 ? loadedSoFar < d.totalCount : true;
    return fullPage && moreByTotal;
  }

  /// Builds the loaded state and updates the header counts the same way the
  /// visit list does: pending/completed come from every response, "All" only
  /// from an unfiltered one (a filtered total may count just that filter).
  SiteVisitHistoryLoaded _buildLoaded({
    required VisitTaskData d,
    required List<VisitTask> items,
    required int page,
    required bool hasMore,
    required VisitFilter filter,
    SiteVisitHistoryLoaded? prev,
  }) {
    var total = prev?.totalCount ?? 0;
    var pending = prev?.pendingCount ?? 0;
    var completed = prev?.completedCount ?? 0;

    final hasCounts =
        d.totalCount > 0 || d.pendingCount > 0 || d.completedCount > 0;
    if (hasCounts) {
      pending = d.pendingCount;
      completed = d.completedCount;
      if (filter == VisitFilter.all) {
        total =
            d.totalCount > 0 ? d.totalCount : d.pendingCount + d.completedCount;
      }
    }

    return SiteVisitHistoryLoaded(
      items: items,
      totalCount: total,
      completedCount: completed,
      pendingCount: pending,
      page: page,
      hasMore: hasMore,
      filter: filter,
    );
  }

  /// Loads page 1 (first open, retry, pull-to-refresh) and keeps the
  /// active filter. [silent] = true keeps the list on screen (pull-to-refresh).
  /// Returns true when the request passed.
  Future<bool> fetchVisits(String projectId, {bool silent = false}) async {
    final previous = state;
    final prevLoaded = previous is SiteVisitHistoryLoaded ? previous : null;
    final filter = prevLoaded?.filter ?? VisitFilter.all;

    final myRequest = ++_requestId;
    if (!silent) emit(const SiteVisitHistoryLoading());
    String? statusId;
    if (filter != VisitFilter.all) {
      await _ensureStatusIds();
      statusId = _statusIds[filter];
      if (statusId == null) {
        if (!silent) {
          emit(const SiteVisitHistoryError(
              'Unable to load data. Please try again.'));
        }
        return false;
      }
    }

    final result = await HttpServices.getSiteVisitHistory(
      projectId,
      page: 1,
      pageSize: pageSize,
      visitStatus: statusId,
    );
    if (myRequest != _requestId) return false; // superseded

    if (result == null) {
      if (!silent) {
        emit(const SiteVisitHistoryError(
            'Unable to load data. Please try again.'));
      }
      return false;
    }

    if (result.status && result.data != null) {
      final d = result.data!;

      emit(_buildLoaded(
        d: d,
        items: d.lists,
        page: 1,
        hasMore: _moreAvailable(d, d.lists.length),
        filter: filter,
        prev: prevLoaded,
      ));
      return true;
    }

    if (!silent) {
      emit(SiteVisitHistoryError(
          result.message.isEmpty ? 'Something went wrong' : result.message));
    }
    return false;
  }

  /// Called when the user taps Total / Done / Pending.
  /// Keeps the header on screen, shows a spinner in the list area, and
  /// reverts to the old list if the request fails. Returns true on success.
  Future<bool> setFilter(String projectId, VisitFilter filter) async {
    final current = state;
    if (current is! SiteVisitHistoryLoaded ||
        current.filter == filter ||
        current.isFilterLoading) {
      return true;
    }

    final myRequest = ++_requestId;
    emit(current.copyWith(
      filter: filter,
      isFilterLoading: true,
      isLoadingMore: false,
      loadMoreFailed: false,
    ));

    String? statusId;
    if (filter != VisitFilter.all) {
      await _ensureStatusIds();
      statusId = _statusIds[filter];
      if (myRequest != _requestId) return false;
      if (statusId == null) {
        emit(current);
        return false;
      }
    }

    final result = await HttpServices.getSiteVisitHistory(
      projectId,
      page: 1,
      pageSize: pageSize,
      visitStatus: statusId,
    );
    if (myRequest != _requestId) return false;

    if (result == null || !result.status || result.data == null) {
      emit(current); // go back to the previous list and filter
      return false;
    }

    final d = result.data!;

    emit(_buildLoaded(
      d: d,
      items: d.lists,
      page: 1,
      hasMore: _moreAvailable(d, d.lists.length),
      filter: filter,
      prev: current,
    ));
    return true;
  }

  /// Loads the next page for the active filter and appends it.
  Future<void> loadMore(String projectId) async {
    final current = state;
    if (current is! SiteVisitHistoryLoaded ||
        !current.hasMore ||
        current.isLoadingMore ||
        current.isFilterLoading) {
      return;
    }

    final myRequest = _requestId;
    final nextPage = current.page + 1;
    emit(current.copyWith(isLoadingMore: true, loadMoreFailed: false));

    final result = await HttpServices.getSiteVisitHistory(
      projectId,
      page: nextPage,
      pageSize: pageSize,
      visitStatus: _statusIds[current.filter], // null for "All"
    );
    if (myRequest != _requestId) return; // refresh / filter change happened

    if (result == null || !result.status || result.data == null) {
      emit(current.copyWith(isLoadingMore: false, loadMoreFailed: true));
      return;
    }

    final d = result.data!;
    final existingIds = current.items.map((e) => e.id).toSet();
    final newItems = d.lists.where((t) => !existingIds.contains(t.id)).toList();
    final allItems = [...current.items, ...newItems];

    emit(_buildLoaded(
      d: d,
      items: allItems,
      page: nextPage,
      hasMore: _moreAvailable(d, allItems.length) && newItems.isNotEmpty,
      filter: current.filter,
      prev: current,
    ));
  }
}
