import 'package:image_picker/image_picker.dart';

import '../../../data/models/succes_response/success_response.dart';
import '../../../data/models/visit/visit_list_model.dart';

class VisitState {
  VisitState();
}

class VisitInitial extends VisitState {}

class VisitLoading extends VisitState {}

class VisitSuccess extends VisitState {
  ListVisitModel response;
  VisitSuccess(this.response);
}

class VisitFailure extends VisitState {
  final String message;
  VisitFailure(this.message);
}

class VisitDetailsSuccess extends VisitState {
  final List<VisitItem> items; // every page loaded so far
  final List<StatusModel> statuses;
  final bool hasMore; // false once the last page has loaded
  final bool loadingMore; // true while the next page is loading

  VisitDetailsSuccess({
    required this.items,
    this.statuses = const [],
    this.hasMore = false,
    this.loadingMore = false,
  });
}

class VisitDetailsFailure extends VisitState {
  final String message;
  VisitDetailsFailure(this.message);
}

class VisitDetailsSuccessWithMessage extends VisitState {
  final String message;

  VisitDetailsSuccessWithMessage(this.message);
}

// class AttendanceUpdated extends VisitState {
//   SuccessResponse response;
//   AttendanceUpdated(this.response);
// }

// class AttendanceFailed extends VisitState {
//   final String message;
//   AttendanceFailed(this.message);
// }

// class ImageSuccess extends VisitState {
//   final XFile image;
//   ImageSuccess(this.image);
// }

// class ImageFailure extends VisitState {
//   final String message;
//   ImageFailure(this.message);
// }
