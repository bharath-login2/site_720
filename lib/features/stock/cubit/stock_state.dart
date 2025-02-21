import '../../../data/models/stock/stock_list.dart';

class StockState {
  StockState();
}

class StockInitial extends StockState {}

class StockLoading extends StockState {}

class StockSuccess extends StockState {
  final StockListModel response;
  StockSuccess(this.response);
}

class StockFailure extends StockState {
  final String message;
  StockFailure(this.message);
}
