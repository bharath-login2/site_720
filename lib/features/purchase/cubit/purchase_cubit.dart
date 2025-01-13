import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'purchase_state.dart';

class PurchaseCubit extends Cubit<PurchaseState> {
  PurchaseCubit() : super(PurchaseInitial());

  List imageList = [];


  void startLoading() {
    emit(PurchaseLoading());
  }

  void emitSuccess(String message) {
    emit(PurchaseSuccess(message));
  }

  void emitFailure(String message) {
    emit(PurchaseFailure(message));
  }

  void updateFromDate(String? date) {
    emit(state.copyWith(fromDate: date));
  }

  void updateToDate(String? date) {
    emit(state.copyWith(toDate: date));
  }

  Future<void> addPurchase(String username, String password) async {
    emit(PurchaseLoading());
    try {
      await Future.delayed(const Duration(seconds: 2));

      final success = username == "1" && password == "1";

      if (success) {
        emit(PurchaseSuccess("Client added"));
      } else {
        emit(PurchaseFailure("Failed."));
      }
    } catch (e) {
      emit(PurchaseFailure("An error occurred."));
    }
  }
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
}
