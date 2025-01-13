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
  final String message;
  PurchaseSuccess(this.message);
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
