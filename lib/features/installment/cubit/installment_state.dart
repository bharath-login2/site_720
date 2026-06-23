import '../../../data/models/installment/installment_model.dart';

abstract class InstallmentState {
  const InstallmentState();
}

class InstallmentInitial extends InstallmentState {
  const InstallmentInitial();
}

class InstallmentLoading extends InstallmentState {
  const InstallmentLoading();
}

class InstallmentLoaded extends InstallmentState {
  final List<InstallmentItem> installments;

  const InstallmentLoaded(this.installments);
}

class InstallmentError extends InstallmentState {
  final String message;

  const InstallmentError(this.message);
}
