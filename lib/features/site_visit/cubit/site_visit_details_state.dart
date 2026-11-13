import '../../../data/models/visit/visit_questions_model.dart';

abstract class VisitTaskState {}

class VisitTaskLoading extends VisitTaskState {}

class VisitTaskLoaded extends VisitTaskState {
  final VisitTaskData data;
  VisitTaskLoaded(this.data);
}

class VisitTaskFailure extends VisitTaskState {
  final String message;
  VisitTaskFailure(this.message);
}

class VisitTaskSaving extends VisitTaskState {}

class VisitTaskSaved extends VisitTaskState {
  final String message;
  VisitTaskSaved(this.message);
}

class VisitTaskSaveFailed extends VisitTaskState {
  final String message;
  VisitTaskSaveFailed(this.message);
}
