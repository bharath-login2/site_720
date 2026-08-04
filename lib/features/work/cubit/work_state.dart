import '../../../data/models/work/work_model.dart';

abstract class WorkState {}

class WorkInitial extends WorkState {}

class WorkLoading extends WorkState {}

class WorkSuccess extends WorkState {
  final List<ExternalWorkItem> workList;
  final List<ExternalWorkItem> filteredWorkList;

   WorkSuccess({
    required this.workList,
    required this.filteredWorkList,
  });
}

class WorkFailure extends WorkState {
  final String error;

  WorkFailure(this.error);
}
