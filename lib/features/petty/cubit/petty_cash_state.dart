import '../../../data/models/pettycash/petty_cash_model.dart';

class PettyCashState {
  const PettyCashState();
}

class PettyCashInitial extends PettyCashState {
  const PettyCashInitial();
}

class PettyCashLoading extends PettyCashState {
  const PettyCashLoading();
}

class PettyCashSuccess extends PettyCashState {
  final PettyCashResponse response;

  const PettyCashSuccess(this.response);
}

class PettyCashFailure extends PettyCashState {
  final String message;

  const PettyCashFailure(this.message);
}