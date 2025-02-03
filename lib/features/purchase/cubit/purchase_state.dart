import '../../../data/models/purchasebilllist/purchasebill_list_model.dart';

class PurchaseState {
  final DateTime? fromDate;
  final DateTime? toDate;

  PurchaseState({this.fromDate, this.toDate});

  PurchaseState copyWith({String? fromDate, String? toDate}) {
    return PurchaseState(
      fromDate: this.fromDate,
      toDate: this.toDate,
    );
  }
}

class PurchaseInitial extends PurchaseState {}

class PurchaseLoading extends PurchaseState {}

class PurchaseSuccess extends PurchaseState {
  PurchaseBillListModel response;
  PurchaseSuccess(this.response);
}

class PurchaseFailure extends PurchaseState {
  final String message;
  PurchaseFailure(this.message);
}

class ImageSuccess extends  PurchaseState {
  final List imageList;
  ImageSuccess(this.imageList);
}

class ImageFailure extends  PurchaseState {
  final String message;
  ImageFailure(this.message);
}
