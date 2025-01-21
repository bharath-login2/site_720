import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit() : super(ForgotPasswordInitial());

  String genOtp = "";
  bool isResendButtonEnabled = true;
  int secondsRemaining = 30;
  Timer? _timer;
  String otpType = "WhatsApp";

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  void togglePasswordVisibility(bool isObscure) {
    emit(ForgotPasswordPasswordVisibilityChanged(!isObscure));
  }

  void verifyPhone(String phone) async {
    // if (otp == genOtp) {
    await sendOtp(phone);
    // } else {
    //   emit(ForgotPasswordFailure("failed"));
    // }
  }

  Future<void> sendOtp(String username) async {
    if (!isResendButtonEnabled) return;
    try {
      final random = Random();
      genOtp = (1000 + random.nextInt(9000)).toString();
      print("OTP====  $genOtp  =====");
      emit(OtpSent("Otp sent to your WhatsApp", genOtp));
    } catch (e) {
      emit(ForgotPasswordFailure("Failed to send OTP. Please try again."));
    }
  }

  void startTimer() {
    _timer?.cancel();
    secondsRemaining = 60;
    isResendButtonEnabled = false;

    emit(ForgotPasswordTimerUpdated(secondsRemaining, isResendButtonEnabled));

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        secondsRemaining--;
        emit(ForgotPasswordTimerUpdated(
            secondsRemaining, isResendButtonEnabled));
      } else {
        timer.cancel();
        isResendButtonEnabled = true;
        emit(ForgotPasswordTimerUpdated(
            secondsRemaining, isResendButtonEnabled));
      }
    });
  }

  void verifyOtp(String otp, String gOtp) {
    if (otp == gOtp) {
      emit(OtpVerified());
    } else {
      emit(OtpVerificationFailed());
    }
  }
}
