import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/http_services.dart';

part 'add_expense_state.dart';

class AddExpenseCubit extends Cubit<AddExpenseState> {
  AddExpenseCubit() : super(AddExpenseInitial());

  Future<void> addExpense({
    required Map<String, dynamic> body,
  }) async {
    emit(AddExpenseLoading());

    try {
      final response = await HttpServices.addExpense(
        expenseType: body['expense_type'],
        expenseHead: body['expense_head'],
        billNo: body['bill_no'],
        billDate: body['bill_date'],
        gst: body['gst'],
        billAmount: body['bill_amount'],
        description: body['description'],
        gstNo: body['gst_no'],
        payableAmount: body['payable_amount'],
        consignee: body['consignee'],
        billRemarks: body['bill_remarks'],
        paidAmount: body['paid_amount'],
        paidDate: body['paid_date'],
        paidFromAcc: body['paid_from_acc'],
        paymentMode: body['payment_mode'],
        trReferenceNo: body['tr_reference_no'],
        trReferenceDate: body['tr_reference_date'],
        transactionRemarks: body['transaction_remarks'],
        balanceAmount: body['balance_amount'],
        gstAmount: body['gst_amount'],
        billCopy: body['bill_copy'],
      );

      if (response['status'] == true) {
        emit(
          AddExpenseSuccess(
            response['message'],
          ),
        );
      } else {
        emit(
          AddExpenseFailure(
            response['message'],
          ),
        );
      }
    } catch (e) {
      emit(
        AddExpenseFailure(
          e.toString(),
        ),
      );
    }
  }
}
