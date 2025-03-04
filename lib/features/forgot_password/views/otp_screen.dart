// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/constants/routes.dart';
import 'package:site_720/core/widgets/connectivity_dialog.dart';
import 'package:site_720/features/forgot_password/widgets/otp_field.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/snack_bar.dart';
import '../../connectivity/cubit/connectivity_cubit.dart';
import '../../connectivity/cubit/connectivity_state.dart';
import '../cubit/forgot_password_cubit.dart';

class OtpScreen extends StatelessWidget {
  String gOtp;
  OtpScreen({super.key, required this.gOtp});

  final TextEditingController f1 = TextEditingController();
  final TextEditingController f2 = TextEditingController();
  final TextEditingController f3 = TextEditingController();
  final TextEditingController f4 = TextEditingController();
  String genOtp = "";

  @override
  Widget build(BuildContext context) {
    if (genOtp == "") {
      genOtp = gOtp;
    }
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ForgotPasswordCubit()),
      ],
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: MultiBlocListener(
              listeners: [
                BlocListener<ConnectivityCubit, ConnectivityState>(
                  listener: (context, state) {
                    if (state is ConnectivityDisconnected) {
                      if (connStatus == true) {
                        connStatus = false;
                        connectivityDialog(context);
                      }
                    }
                  },
                ),
                BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
                  listener: (context, state) {
                    if (state is OtpSent) {
                      genOtp = state.otp;
                      snackBar(context, state.message, Colors.green);
                    } else if (state is OtpVerified) {
                      Navigator.pushReplacementNamed(
                          context, AppRoutes.changePasswordScreen);
                    } else if (state is OtpVerificationFailed) {
                      snackBar(context, "Invalid OTP", Colors.red);
                    }
                  },
                ),
              ],
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * .37,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(100),
                          bottomRight: Radius.circular(15),
                        ),
                        image: DecorationImage(
                          image: AssetImage("assets/images/login.jpg"),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      "Enter OTP",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
                      builder: (context, state) {
                        final otpType =
                            context.read<ForgotPasswordCubit>().otpType;
                        return Text(
                          "OTP sent to your $otpType",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: Colors.green,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 35),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OtpField(f1, true),
                          OtpField(f2, false),
                          OtpField(f3, false),
                          OtpField(f4, false),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
                      builder: (context, state) {
                        if (state is ForgotPasswordLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return InkWell(
                          onTap: () async {
                            await context
                                .read<ConnectivityCubit>()
                                .checkConnection();
                            final otp = f1.text + f2.text + f3.text + f4.text;

                            if (otp.length != 4) {
                              snackBar(context, "Enter valid OTP", Colors.red);
                            } else {
                              context
                                  .read<ForgotPasswordCubit>()
                                  .verifyOtp(otp, genOtp);
                            }
                          },
                          child: LargeButton(
                            title: "Verify",
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
                      builder: (context, state) {
                        final cubit = context.read<ForgotPasswordCubit>();
                        return Column(
                          children: [
                            Text(
                              cubit.isResendButtonEnabled
                                  ? 'You can resend the OTP now.'
                                  : 'Resend OTP in ${cubit.secondsRemaining} seconds',
                              style: const TextStyle(fontSize: 12),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: cubit.isResendButtonEnabled
                                      ? () {
                                          cubit.otpType = "Phone";
                                          cubit.sendOtp("Phone");
                                          cubit.startTimer();
                                        }
                                      : null,
                                  child: Text(
                                    cubit.otpType == "Phone"
                                        ? 'Resend OTP'
                                        : 'Send via SMS',
                                    style: TextStyle(
                                      color: cubit.isResendButtonEnabled
                                          ? Colors.blue
                                          : Colors.grey,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: cubit.isResendButtonEnabled
                                      ? () {
                                          cubit.otpType = "WhatsApp";
                                          cubit.sendOtp("WhatsApp");
                                          cubit.startTimer();
                                        }
                                      : null,
                                  child: Text(
                                    cubit.otpType == "WhatsApp"
                                        ? 'Resend OTP'
                                        : "Send via WhatsApp",
                                    style: TextStyle(
                                      color: cubit.isResendButtonEnabled
                                          ? Colors.green
                                          : Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
