// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/widgets/connectivity_dialog.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/snack_bar.dart';
import '../../connectivity/cubit/connectivity_cubit.dart';
import '../../connectivity/cubit/connectivity_state.dart';
import '../cubit/forgot_password_cubit.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});

  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  bool connStatus = false;
  bool isObscure = true;
  bool confirmObscure = true;
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
                  connStatus = false;
                  connectivityDialog(context);
                } else {
                  connStatus = true;
                }
              },
            ),
            BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
              listener: (context, state) {
                if (state is ForgotPasswordSuccess) {
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
                  "Change Password",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    fontFamily: "Lobster",
                  ),
                ),
                // const SizedBox(height: 10),
                // const Text(
                //   "Enter your phoneNumber",
                //   style: TextStyle(
                //     fontSize: 14,
                //     fontWeight: FontWeight.bold,
                //     letterSpacing: 1,
                //     fontFamily: "Lobster",
                //   ),
                // ),
                const SizedBox(height: 35),
                BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
                  builder: (context, state) {
                    if (state is PasswordVisibilityChanged) {
                    isObscure = state.isObscure;
                  }
                  if (state is ConfirmPasswordVisibilityChanged) {
                    confirmObscure = state.confirmObscure;
                  }
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
                              obscureText: isObscure,
                              controller:
                                  passwordController, // Replace with your password controller
                              decoration: InputDecoration(
                                hintText: 'Password',
                                contentPadding: const EdgeInsets.all(10),
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                onPressed: () {
                                  context
                                      .read<ForgotPasswordCubit>()
                                      .togglePasswordVisibility(isObscure);
                                },
                                icon: Icon(
                                  isObscure
                                      ? Icons.remove_red_eye_outlined
                                      : Icons.visibility_off,
                                  color: AppColors.primaryColor,
                                  size: 22,
                                ),
                              ),
                              ),
                            ),
                          ),

                           const SizedBox(height: 10),


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
                              obscureText: confirmObscure,
                              controller:
                                  confirmpasswordController, // Replace with your password controller
                              decoration: InputDecoration(
                                hintText: 'Confirm Password',
                                contentPadding: const EdgeInsets.all(10),
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                onPressed: () {
                                  context
                                      .read<ForgotPasswordCubit>()
                                      .confirmPasswordVisibility(confirmObscure);
                                },
                                icon: Icon(
                                  confirmObscure
                                      ? Icons.remove_red_eye_outlined
                                      : Icons.visibility_off,
                                  color: AppColors.primaryColor,
                                  size: 22,
                                ),
                              ),
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
                          if (passwordController.text.isEmpty) {
                            snackBar(context, "Enter Valid Password",
                                Colors.red);
                          } else {
                            if (connStatus == true) {
                              context.read<ForgotPasswordCubit>().sendOtp(
                                    passwordController.text,
                                  );
                            }
                          }
                          if(passwordController.text.length<8){
                         snackBar(context, "Should Contain atleast 8 characters",
                                Colors.red);
                                return; 
                          }else {
                            if (connStatus == true) {
                              context.read<ForgotPasswordCubit>().sendOtp(
                                    passwordController.text,
                                  );
                            }
                          }
                          if (confirmpasswordController.text.isEmpty) {
                            snackBar(context, "Enter Valid Confirm Password",
                                Colors.red);
                                return; 
                          } else {
                            if (connStatus == true) {
                              context.read<ForgotPasswordCubit>().sendOtp(
                                    confirmpasswordController.text,
                                  );
                            }
                          }
                            if (passwordController.text != confirmpasswordController.text) {
                              snackBar(context, "Password and Confirm Password do not match", Colors.red);
                              return; 
                            }
                            if (connStatus == true) {
                            context.read<ForgotPasswordCubit>().sendOtp(passwordController.text);
                           snackBar(context, "Password Changed Successfully", const Color.fromARGB(255, 83, 199, 89));
                            Navigator.pop(context);
                          }
                        }
                      },
                      child: LargeButton(
                        title: "Submit",
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
