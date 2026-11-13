import '../../../data/models/site_visit_history/site_visit_history_model.dart';

/// Filter chosen by tapping Total / Done / Pending in the summary header.
enum VisitFilter { all, completed, pending }

extension VisitFilterX on VisitFilter {
  String get label {
    switch (this) {
      case VisitFilter.all:
        return 'All';
      case VisitFilter.completed:
        return 'Completed';
      case VisitFilter.pending:
        return 'Pending';
    }
  }
}

abstract class SiteVisitHistoryState {
  const SiteVisitHistoryState();
}

class SiteVisitHistoryInitial extends SiteVisitHistoryState {
  const SiteVisitHistoryInitial();
}

class SiteVisitHistoryLoading extends SiteVisitHistoryState {
  const SiteVisitHistoryLoading();
}

class SiteVisitHistoryLoaded extends SiteVisitHistoryState {
  final List<VisitTask> items;
  final int totalCount;
  final int completedCount;
  final int pendingCount;
  final int page; // last page loaded
  final bool hasMore; // is there another page to load?
  final bool isLoadingMore; // footer spinner
  final bool loadMoreFailed; // footer retry button
  final VisitFilter filter; // active filter
  final bool isFilterLoading; // list area spinner while switching filter

  const SiteVisitHistoryLoaded({
    required this.items,
    required this.totalCount,
    required this.completedCount,
    required this.pendingCount,
    required this.page,
    required this.hasMore,
    this.isLoadingMore = false,
    this.loadMoreFailed = false,
    this.filter = VisitFilter.all,
    this.isFilterLoading = false,
  });

  SiteVisitHistoryLoaded copyWith({
    List<VisitTask>? items,
    int? totalCount,
    int? completedCount,
    int? pendingCount,
    int? page,
    bool? hasMore,
    bool? isLoadingMore,
    bool? loadMoreFailed,
    VisitFilter? filter,
    bool? isFilterLoading,
  }) {
    return SiteVisitHistoryLoaded(
      items: items ?? this.items,
      totalCount: totalCount ?? this.totalCount,
      completedCount: completedCount ?? this.completedCount,
      pendingCount: pendingCount ?? this.pendingCount,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreFailed: loadMoreFailed ?? this.loadMoreFailed,
      filter: filter ?? this.filter,
      isFilterLoading: isFilterLoading ?? this.isFilterLoading,
    );
  }
}

class SiteVisitHistoryError extends SiteVisitHistoryState {
  final String message;
  const SiteVisitHistoryError(this.message);
}
