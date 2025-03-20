import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/notification/notification_list.dart';
import '../../../data/services/http_services.dart';
import 'notification_state.dart';

class NotificationListCubit extends Cubit<NotificationState> {
  NotificationListCubit() : super(NotificationInitial()) {
    getNotifications();
  }

  List<NotificationData> notificationList = [];

  Future<void> getNotifications() async {
    emit(NotificationLoading());
    try {
      NotificationListModel response = await HttpServices.getNotifications();
      if (response.status == true) {
        notificationList = response.data;
        emit(NotificationSuccess(response));
      }
    } catch (e) {
      emit(NotificationFailure('Failed to fetch data: ${e.toString()}'));
    }
  }
}
