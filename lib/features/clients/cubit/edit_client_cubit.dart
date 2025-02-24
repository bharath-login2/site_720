import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:site_720/data/models/succes_response/success_response.dart';
import '../../../data/models/clientlist/client_details.dart';
import '../../../data/models/clientlist/client_type_list.dart';
import '../../../data/models/clientlist/district_list.dart';
import '../../../data/models/clientlist/state_list_model.dart';
import '../../../data/services/http_services.dart';
import 'client_state.dart';

class EditClientsCubit extends Cubit<ClientsState> {
  EditClientsCubit(String clientId) : super(ClientInitial()) {
    getStates();
    getClientTypes();
    getClientDetails(clientId);
  }

  Future<void> getStates() async {
    emit(ClientDetailsLoading());
    try {
      StateListModel response = await HttpServices.getStates();

      if (response.status == true) {
        emit(StateListFetched(response));
      }
    } catch (e) {
      emit(ClientDetailsFailure('Failed to fetch data: ${e.toString()}'));
    }
  }

  Future<void> getClientTypes() async {
    emit(ClientDetailsLoading());
    try {
      ClientTypeListModel response = await HttpServices.getClientTypes();

      if (response.status == true) {
        emit(ClientTypesFetched(response));
      }
    } catch (e) {
      emit(ClientDetailsFailure('Failed to fetch data: ${e.toString()}'));
    }
  }

  Future<void> getDistricts(String stateId) async {
    emit(ClientDetailsLoading());
    try {
      DistrictListModel response = await HttpServices.getDistricts(stateId);

      if (response.status == true) {
        emit(DistrictListFetched(response));
      }
    } catch (e) {
      emit(ClientDetailsFailure('Failed to fetch data: ${e.toString()}'));
    }
  }

  Future<void> getClientDetails(String clientId) async {
    emit(ClientDetailsLoading());
    try {
      ClientDetailsModel response =
          await HttpServices.getClientDetails(clientId);

      if (response.status == true) {
        emit(EditDetailsSuccess(response));
        if (response.data.districtId != "") {
          getDistricts(response.data.stateId);
        }
      }
    } catch (e) {
      emit(EditDetailsFailure('Failed to fetch data: ${e.toString()}'));
    }
  }

  Future<void> editClient(
      String clientId,
      String clientName,
      String contactPerson,
      String phoneNumber,
      String whatsappNumber,
      String companyName,
      String emailId,
      String address,
      String civil,
      String gstNo,
      String stateId,
      String districtId,
      String clientTypeId) async {
    emit(ClientDetailsLoading());
    try {
      SuccessResponse response = await HttpServices.editClient(
          clientId,
          clientName,
          contactPerson,
          phoneNumber,
          whatsappNumber,
          companyName,
          emailId,
          address,
          civil,
          gstNo,
          stateId,
          districtId,
          clientTypeId);

      if (response.status == true) {
        emit(EditClientSuccess(response.message));
      } else {
        emit(EditClientFailure(response.message));
      }
    } catch (e) {
      emit(EditClientFailure('Failed to fetch data: ${e.toString()}'));
    }
  }
}
