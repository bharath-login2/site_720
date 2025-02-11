import 'package:flutter/material.dart';
import 'package:site_720/core/constants/routes.dart';
import 'package:site_720/core/utilities/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    splashDelay();
    super.initState();
  }

  void splashDelay() async {
    await Future.delayed(const Duration(seconds: 3));
    final token = await getSharedPreference("token");
    if (token == null) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 200,
          decoration: const BoxDecoration(
              image:
                  DecorationImage(image: AssetImage("assets/images/logo.png"))),
        ),
      ),
    );
  }
}
