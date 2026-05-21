import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:site_720/core/widgets/dialogs.dart';
import 'package:site_720/features/complaints/pin_setup_screen.dart';
import 'package:site_720/features/splash/cubit/splash_state.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/routes.dart';
import '../../../core/utilities/shared_preferences.dart';
import '../../../core/widgets/connectivity_dialog.dart';
import '../cubit/splash_cubit.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  Future<void> initSplash(BuildContext context) async {
    final isPinSet = await getSharedPreference("is_pin_set");
    final token = await getSharedPreference("token");

    if (context.mounted) {
      connStatus = true;
      if (isPinSet == "true") {
        if (token == null) {
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        } else {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        }
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PinSetupScreen()),
        );
      }
    }
  }

  void launchAppStore(BuildContext context) async {
    const appStoreUrl = 'https://apps.apple.com/app';
    const playStoreUrl =
        'https://play.google.com/store/apps/details?id=com.site720.supervisor';
    final url = Uri.parse(Theme.of(context).platform == TargetPlatform.iOS
        ? appStoreUrl
        : playStoreUrl);

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    print("✅ Splash screen loaded");

    return BlocProvider(
      create: (context) => SplashCubit(),
      child: Builder(
        builder: (context) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            print("🧪 Calling checkVersion()");
            context.read<SplashCubit>().checkVersion();
          });

          return BlocListener<SplashCubit, SplashState>(
            listener: (context, state) {
              // if (state is VersionSuccess) {
              initSplash(context);
              // } else if (state is LowerVersion) {
              //   forceUpdate(context, () {
              //     launchAppStore(context);
              //   });
              // }
            },
            child: Scaffold(
              backgroundColor: Theme.of(context).primaryColor,
              body: Center(
                child: Container(
                  width: 200,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/site720-white.png"),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
