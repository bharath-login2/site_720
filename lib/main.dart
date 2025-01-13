import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/constants/routes.dart';
import 'package:site_720/features/dashboard/views/dashboard_screen.dart';
import 'package:site_720/features/drawing/views/drawing_screen.dart';
import 'package:site_720/features/extra_work/views/extra_work_screen.dart';
import 'package:site_720/features/gallery/views/gallery_screen.dart';
import 'package:site_720/features/project_details/views/project_details_screen.dart';
import 'package:site_720/features/project_list/views/project_list_screen.dart';
import 'package:site_720/features/purchase/views/add_purchase.dart';
import 'package:site_720/features/purchase/views/purchase_list_screen.dart';
import 'package:site_720/features/site_note/views/site_note_screen.dart';
import 'package:site_720/features/splash/views/splash.dart';
import 'package:site_720/features/sub_contactors/views/sub_contrctor_screen.dart';
import 'features/add_client/views/add_clients.dart';
import 'features/connectivity/cubit/connectivity_cubit.dart';
import 'features/deduction_work/views/deduction_work_screen.dart';
import 'features/login/cubit/login_cubit.dart';
import 'features/login/views/login_screen.dart';
import 'features/stages/views/stages.dart';
import 'features/stages/views/stage_history.dart';
import 'features/work_details/views/work_details_screen.dart';

void main() {
  runApp(MultiBlocProvider(providers: [
    BlocProvider(create: (_) => ConnectivityCubit(Connectivity())),
    BlocProvider(create: (_) => LoginCubit()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Site 720',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      routes: {
        '/splash': (context) => const Splash(),
        '/login': (context) => LoginScreen(),
        '/dashboard': (context) => DashboardScreen(),
        '/projectList': (context) => ProjectList(),
        '/addCilentScreen': (context) => AddCilentScreen(),
        '/projectDetails': (context) => ProjectDetails(),
        '/gallery': (context) => GalleryScreen(),
        '/drawing': (context) => DrawingScreen(),
        '/workDetails': (context) => const WorkDetails(),
        '/siteNote': (context) => const SiteNote(),
        '/stages': (context) => Stages(),
        '/stageHistory': (context) => StageHistory(),
        '/subContractor': (context) => SubContractor(),
        '/extraWork': (context) => ExtraWork(),
        '/deductionWork': (context) => DeductionWork(),
        '/purchase': (context) => const PurchaseList(),
        '/addPurchase': (context) =>  AddPurchase(),
        '/stock': (context) => DeductionWork(),
      },
    );
  }
}
