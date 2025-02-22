import '../../../data/models/stockconsume/stockconsume_model.dart';

class ConsumptionState {
  final DateTime? fromDate;
  final DateTime? toDate;

  ConsumptionState({this.fromDate, this.toDate});

  ConsumptionState copyWith({String? fromDate, String? toDate}) {
    return ConsumptionState(
      fromDate: this.fromDate,
      toDate: this.toDate,
    );
  }
}

class ConsumptionInitial extends ConsumptionState {
  
}

class ConsumptionLoading extends ConsumptionState {}

class ConsumptionSuccess extends ConsumptionState {
   StockConsumeModel response;
  ConsumptionSuccess(this.response);
}

class ConsumptionFailure extends ConsumptionState {
  final String message;
  ConsumptionFailure(this.message);
}
