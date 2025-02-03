import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/models/purchasebilllist/purchasebill_list_model.dart';
import '../../../data/services/http_services.dart';
import 'purchase_state.dart';

class PurchaseCubit extends Cubit<PurchaseState> {
  PurchaseCubit(String projectId) : super(PurchaseInitial()){
    getPurchaseBillList(projectId);
  }

  List imageList = [];

  void startLoading() {
    emit(PurchaseLoading());
  }

  void emitFailure(String message) {
    emit(PurchaseFailure(message));
  }

  void updatePurchasedDate(String? date) {
    emit(state.copyWith(fromDate: date));
  }

  // Future<void> addPurchase(String username, String password) async {
  //   emit(PurchaseLoading());
  //   try {
  //     await Future.delayed(const Duration(seconds: 2));

  //     final success = username == "1" && password == "1";

  //     if (success) {
  //       emit(PurchaseSuccess("Client added"));
  //     } else {
  //       emit(PurchaseFailure("Failed."));
  //     }
  //   } catch (e) {
  //     emit(PurchaseFailure("An error occurred."));
  //   }
  // }

  selectMultiImage(
    ImageSource? source,
  ) async {
    try {
      if (source != null) {
        final XFile? selectedImages =
            await ImagePicker().pickImage(source: source);
        if (selectedImages != null) {
          imageList.add(selectedImages);
        }
        emit(ImageSuccess(imageList));
      } else {
        final List<XFile> images = await ImagePicker().pickMultiImage();
        if (images.isNotEmpty) {
          imageList.addAll(images);
        }
        emit(ImageSuccess(imageList));
      }
    } catch (e) {
      emit(ImageFailure("Failed to get image, Please Select once again.."));
    }
  }

    Future<void> getPurchaseBillList(String projectId) async {
      emit(PurchaseLoading());
      try {
        PurchaseBillListModel response = await HttpServices.getPurchaseBillList(projectId);
        
        if (response.status == true) {
          emit(PurchaseSuccess(response));
        }else{
        emit(PurchaseFailure('Failed to fetch data}'));
        }
      } catch (e) {
        emit(PurchaseFailure('Failed to fetch data: ${e.toString()}'));
      }
    }
}
