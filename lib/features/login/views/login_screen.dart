import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:site_720/core/constants/colors.dart';
import '../cubit/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                child: const Center(
                    // child: Image.asset(
                    //   'assets/main/logo.png',
                    //   width: 200,
                    // ),
                    ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Login",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  // color: AppColors.primaryColor,
                  letterSpacing: 1,
                  fontFamily: "Lobster",
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Enter your login details",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  // color: AppColors.primaryColor,
                  letterSpacing: 1,
                  fontFamily: "Lobster",
                ),
              ),
              const SizedBox(height: 25),
              BlocBuilder<LoginCubit, LoginState>(
                builder: (context, state) {
                  bool isObscure = true;
                  if (state is LoginPasswordVisibilityChanged) {
                    isObscure = state.isObscure;
                  }

                  return Form(
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
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
                          width: MediaQuery.of(context).size.width * 0.9,
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
              BlocConsumer<LoginCubit, LoginState>(
                listener: (context, state) {
                  if (state is LoginSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Login successful'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.of(context).pushReplacementNamed('/home');
                  } else if (state is LoginFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is LoginLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return InkWell(
                    onTap: () {
                      if (_usernameController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Enter username"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else if (_passwordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Enter password"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else {
                        context.read<LoginCubit>().login(
                              _usernameController.text,
                              _passwordController.text,
                            );
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: AppColors.primaryColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.8),
                            blurRadius: 6,
                            offset: const Offset(3, 3),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Forgot Password ?",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                  fontFamily: "Lobster",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
