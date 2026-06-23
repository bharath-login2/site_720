import '../../../data/models/paymentschedule/payment_schedule_model.dart';

abstract class PaymentScheduleState {
  const PaymentScheduleState();
}

class PaymentScheduleInitial extends PaymentScheduleState {
  const PaymentScheduleInitial();
}

class PaymentScheduleLoading extends PaymentScheduleState {
  const PaymentScheduleLoading();
}

class PaymentScheduleLoaded extends PaymentScheduleState {
  final List<PaymentScheduleItem> schedules;

  const PaymentScheduleLoaded(this.schedules);
}

class PaymentScheduleError extends PaymentScheduleState {
  final String message;

  const PaymentScheduleError(this.message);
}
