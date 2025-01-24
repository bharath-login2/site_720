// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/constants/routes.dart';
import 'package:site_720/core/widgets/connectivity_dialog.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/snack_bar.dart';
import '../../connectivity/cubit/connectivity_cubit.dart';
import '../../connectivity/cubit/connectivity_state.dart';
import '../cubit/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool connStatus = false;
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: MultiBlocListener(
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
          BlocListener<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state is LoginSuccess) {
                snackBar(context, state.message, Colors.green);

                Navigator.of(context).pushReplacementNamed(AppRoutes.home);
              } else if (state is LoginFailure) {
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
                "Login",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  fontFamily: "Lobster",
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Enter your login details",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  fontFamily: "Lobster",
                ),
              ),
              const SizedBox(height: 25),
              BlocBuilder<LoginCubit, LoginState>(
                builder: (context, state) {
                  if (state is LoginPasswordVisibilityChanged) {
                    isObscure = state.isObscure;
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
                            controller: _usernameController,
                            decoration: const InputDecoration(
                              hintText: 'Username',
                              contentPadding: EdgeInsets.all(10),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          height: 45,
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
                            controller: _passwordController,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              suffixIcon: IconButton(
                                onPressed: () {
                                  context
                                      .read<LoginCubit>()
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
                              contentPadding: const EdgeInsets.all(10),
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 25),
              BlocBuilder<LoginCubit, LoginState>(
                builder: (context, state) {
                  if (state is LoginLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return InkWell(
                    onTap: () async {
                      await context.read<ConnectivityCubit>().checkConnection();
                      if (context.mounted) {
                        if (_usernameController.text.isEmpty) {
                          snackBar(context, "Enter username", Colors.red);
                        } else if (_passwordController.text.isEmpty) {
                          snackBar(context, "Enter Password", Colors.red);
                        } else {
                          if (connStatus == true) {
                            context.read<LoginCubit>().login(
                                  _usernameController.text,
                                  _passwordController.text,
                                );
                          }
                        }
                      }
                    },
                    child: LargeButton(
                      title: "Login",
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.phoneNumber);
                },
                child: const Text(
                  "Forgot Password ?",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                    fontFamily: "Lobster",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
