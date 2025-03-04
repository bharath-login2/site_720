// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/widgets/connectivity_dialog.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/snack_bar.dart';
import '../../connectivity/cubit/connectivity_cubit.dart';
import '../../connectivity/cubit/connectivity_state.dart';
import '../cubit/forgot_password_cubit.dart';
import 'otp_screen.dart';

class PhoneNumberScreen extends StatelessWidget {
  PhoneNumberScreen({super.key});

  final phoneNumberController = TextEditingController();

  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: BlocProvider(
        create: (context) => ForgotPasswordCubit(),
        child: MultiBlocListener(
          listeners: [
            BlocListener<ConnectivityCubit, ConnectivityState>(
              listener: (context, state) {
                if (state is ConnectivityDisconnected) {
                  if (connStatus == true) {
                    connStatus = false;
                    connectivityDialog(context);
                  }
                } else {
                  connStatus = true;
                }
              },
            ),
            BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
              listener: (context, state) {
                if (state is OtpSent) {
                  // Navigator.pushReplacementNamed(context, AppRoutes.otpScreen);
                  log(state.otp);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OtpScreen(gOtp: state.otp),
                      ));
                  snackBar(context, state.message, Colors.green);
                } else if (state is ForgotPasswordFailure) {
                  snackBar(context, state.message, Colors.red);
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
                  "ForgotPassword",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    fontFamily: "Lobster",
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Enter your phoneNumber",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    fontFamily: "Lobster",
                  ),
                ),
                const SizedBox(height: 35),
                BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
                  builder: (context, state) {
                    return Form(
                      child: Column(
                        children: [
                          Container(
                            height: 45,
                            width: MediaQuery.of(context).size.width * 0.85,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.8),
                                  blurRadius: 6,
                                  offset: const Offset(3, 3),
                                ),
                              ],
                            ),
                            child: TextFormField(
                              keyboardType: TextInputType.phone,
                              controller: phoneNumberController,
                              decoration: const InputDecoration(
                                hintText: 'Phone Number',
                                contentPadding: EdgeInsets.all(10),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
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
                        if (context.mounted) {
                          if (phoneNumberController.text.isEmpty) {
                            snackBar(context, "Enter Valid Phone Number",
                                Colors.red);
                          } else {
                            if (connStatus == true) {
                              context
                                  .read<ForgotPasswordCubit>()
                                  .verifyPhone(phoneNumberController.text);
                            }
                          }
                        }
                      },
                      child: LargeButton(
                        title: "Send Otp",
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
