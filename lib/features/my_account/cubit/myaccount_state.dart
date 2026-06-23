import '../../../data/models/my_account/my_account_model.dart';

class SalaryLedgerState {
  final DateTime? fromDate;
  final DateTime? toDate;

  const SalaryLedgerState({
    this.fromDate,
    this.toDate,
  });

  SalaryLedgerState copyWith({
    DateTime? fromDate,
    DateTime? toDate,
  }) {
    return SalaryLedgerState(
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
    );
  }
}

class SalaryLedgerInitial extends SalaryLedgerState {
  const SalaryLedgerInitial();
}

class SalaryLedgerLoading extends SalaryLedgerState {
  const SalaryLedgerLoading();
}

class SalaryLedgerSuccess extends SalaryLedgerState {
  final SalaryLedgerResponse response;

  const SalaryLedgerSuccess(this.response);
}

class SalaryLedgerFailure extends SalaryLedgerState {
  final String message;

  const SalaryLedgerFailure(this.message);
}