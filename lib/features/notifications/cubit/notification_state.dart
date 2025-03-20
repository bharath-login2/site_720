
class NotificationState {
  NotificationState();
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationSuccess extends NotificationState {
  final  response;
  NotificationSuccess(this.response);
}

class NotificationFailure extends NotificationState {
  final String message;
  NotificationFailure(this.message);
}
