import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/travel_expense/travel_expense_model.dart';
import '../../../data/services/http_services.dart';
import 'travel_expense_state.dart';

class TravelExpenseCubit extends Cubit<TravelExpenseState> {
  TravelExpenseCubit() : super(TravelExpenseInitial()) {
    getTravelExpenseList();
  }

  TravelExpenseModel? travelExpenseModel;

  /// GET LIST API
  Future<void> getTravelExpenseList() async {
    emit(TravelExpenseLoading());

    try {
      final TravelExpenseModel? response =
          await HttpServices.getTravelExpenseList();

      if (response != null && response.status == true) {
        travelExpenseModel = response;

        emit(
          TravelExpenseSuccess(
            response,
          ),
        );
      } else {
        emit(
          TravelExpenseFailure(
            "Failed to fetch travel expense list",
          ),
        );
      }
    } catch (e) {
      emit(
        TravelExpenseFailure(
          e.toString(),
        ),
      );
    }
  }

  /// POST TRAVEL EXPENSE
  Future<void> postTravelExpense({
    required String date,
    required String from,
    required String vehicleType,
    required String totalAmount,
    required String remark,
    required List<Map<String, dynamic>> rows,
  }) async {
    emit(TravelExpensePostLoading());

    try {
      final response = await HttpServices.postTravelExpense(
        date: date,
        from: from,
        vehicleType: vehicleType,
        totalAmount: totalAmount,
        remark: remark,
        rows: rows,
      );

      print(response);

      if (response != null && response["status"] == true) {
        emit(
          TravelExpensePostSuccess(
            response["message"],
          ),
        );
      } else {
        emit(
          TravelExpenseFailure(
            response["message"] ?? "Something went wrong",
          ),
        );
      }
    } catch (e) {
      emit(
        TravelExpenseFailure(
          e.toString(),
        ),
      );
    }
  }

  /// GET VEHICLE TYPES
  Future<List<VehicleTypeModel>> getVehicleType() async {
    try {
      final response = await HttpServices.getVehicleType();

      print(response);

      if (response != null && response["status"] == true) {
        List data = response["data"] ?? [];

        return data
            .map(
              (e) => VehicleTypeModel.fromJson(e),
            )
            .toList();
      }

      return [];
    } catch (e) {
      print(e);

      return [];
    }
  }

  /// DELETE
  Future<void> deleteTravelExpense(
    BuildContext context,
    String travelId,
  ) async {
    try {
      final response = await HttpServices.deleteTravelExpense(
        travelId: travelId,
      );

      if (response != null && response["status"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              response["message"],
            ),
          ),
        );

        await getTravelExpenseList();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              response["message"] ?? "Delete failed",
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }
}
