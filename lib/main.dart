import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/constants/routes.dart';
import 'package:site_720/features/consumption/views/consumption.dart';
import 'package:site_720/features/dashboard/views/dashboard_screen.dart';
import 'package:site_720/features/drawing/views/drawing_screen.dart';
import 'package:site_720/features/estimation/views/estimation_screen.dart';
import 'package:site_720/features/expense/views/expense_screen.dart';
import 'package:site_720/features/extra_work/views/extra_work_screen.dart';
import 'package:site_720/features/gallery/views/gallery_screen.dart';
import 'package:site_720/features/package/views/package_detailed_screen.dart';
import 'package:site_720/features/payment_details/views/payment_details_screen.dart';
import 'package:site_720/features/project_details/views/image_view_screen.dart';
import 'package:site_720/features/project_details/views/project_details_screen.dart';
import 'package:site_720/features/project_list/views/project_list_screen.dart';
import 'package:site_720/features/purchase/views/add_purchase.dart';
import 'package:site_720/features/purchase/views/purchase_list_screen.dart';
import 'package:site_720/features/site_note/views/site_note_screen.dart';
import 'package:site_720/features/splash/views/splash.dart';
import 'package:site_720/features/sub_contactors/views/sub_contrctor_screen.dart';
import 'features/clients/views/add_clients.dart';
import 'features/complaints/views/add_complaint.dart';
import 'features/complaints/views/complaint_list.dart';
import 'features/connectivity/cubit/connectivity_cubit.dart';
import 'features/deduction_work/views/deduction_work_screen.dart';
import 'features/forgot_password/views/change_password_screen.dart';
import 'features/forgot_password/views/phone_number_screen.dart';
import 'features/home/home.dart';
import 'features/login/cubit/login_cubit.dart';
import 'features/login/views/login_screen.dart';
import 'features/project_list/views/add_projects.dart';
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
        '/home': (context) => const Home(),
        '/dashboard': (context) => DashboardScreen(),
        '/projectList': (context) => ProjectList(
              fromHome: false,
            ),
        '/addCilentScreen': (context) => AddCilentScreen(),
        '/projectDetails': (context) => ProjectDetails(),
        '/gallery': (context) => GalleryScreen(),
        '/drawing': (context) => DrawingScreen(),
        '/workDetails': (context) => WorkDetailsScreen(),
        '/siteNote': (context) => const SiteNote(),
        '/stages': (context) => Stages(),
        '/stageHistory': (context) => StageHistory(),
        '/subContractor': (context) => SubContractor(),
        '/extraWork': (context) => ExtraWork(),
        '/deductionWork': (context) => DeductionWork(),
        '/purchase': (context) => const PurchaseList(),
        '/addPurchase': (context) => AddPurchase(),
        // '/stock': (context) => DeductionWork(),
        '/expense': (context) => Expense(),
        '/paymentDetails': (context) => const PaymentDetails(),
        '/estimation': (context) => const Estimation(),
        '/consumption': (context) => const Consumption(),
        '/package': (context) => PackageDetailed(),
        '/phoneNumber': (context) => PhoneNumberScreen(),
        // '/otpScreen': (context) => OtpScreen(),
        '/changePasswordScreen': (context) => ChangePasswordScreen(),
        '/addProjectScreen': (context) => AddProjectScreen(),
        '/complaintList': (context) => ComplaintList(),
        '/addComplaints': (context) => AddComplaint(),
        '/imageViewer': (context) => const ImageViewer(),
      },
    );
  }
}
