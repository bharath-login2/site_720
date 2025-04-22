import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/constants/routes.dart';
import 'package:site_720/features/clients/views/edit_client.dart';
import 'package:site_720/features/consumption/views/consumption.dart';
import 'package:site_720/features/dashboard/views/dashboard_screen.dart';
import 'package:site_720/features/drawing/views/drawing_screen.dart';
import 'package:site_720/features/estimation/views/estimation_screen.dart';
import 'package:site_720/features/expense/views/expense_screen.dart';
import 'package:site_720/features/extra_work/views/extra_work_screen.dart';
import 'package:site_720/features/gallery/views/gallery_screen.dart';
import 'package:site_720/features/notifications/views/notification_list.dart';
import 'package:site_720/features/package/views/package.dart';
import 'package:site_720/features/payment_details/views/payment_details_screen.dart';
import 'package:site_720/features/project_details/views/image_view_screen.dart';
import 'package:site_720/features/project_details/views/project_details_screen.dart';
import 'package:site_720/features/project_list/views/edit_project.dart';
import 'package:site_720/features/project_list/views/project_list_screen.dart';
import 'package:site_720/features/purchase/views/purchase_list_screen.dart';
import 'package:site_720/features/splash/views/splash.dart';
import 'package:site_720/features/stock/views/stock.dart';
import 'package:site_720/features/sub_contactors/views/sub_contrctor_screen.dart';
import 'package:site_720/features/work_issues/views/work_issues_screen.dart';
import 'package:site_720/firebase_options.dart';
import 'features/clients/views/add_clients.dart';
import 'features/complaints/views/add_complaint.dart';
import 'features/complaints/views/complaint_list.dart';
import 'features/connectivity/cubit/connectivity_cubit.dart';
import 'features/deduction_work/views/deduction_work_screen.dart';
import 'features/forgot_password/views/change_password_screen.dart';
import 'features/forgot_password/views/phone_number_screen.dart';
import 'features/home/home.dart';
import 'features/login/views/login_screen.dart';
import 'features/notifications/service/notification_channel.dart';
import 'features/project_list/views/add_projects.dart';
import 'features/stages/views/stages.dart';
import 'features/stages/views/stage_history.dart';
import 'features/task_management/views/task_details.dart';
import 'features/task_management/views/task_history.dart';
import 'features/visit/views/visit_detailed_list.dart';
import 'features/visit/views/visit_history.dart';
import 'features/work_details/views/work_details_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize NotificationServices
  final NotificationServices notificationServices = NotificationServices();
  notificationServices.initLocalNotifications();
  await notificationServices.requestNotificationPermission();
  notificationServices.foregroundMessage();
  notificationServices.firebaseInit();

  FirebaseMessaging.onBackgroundMessage(NotificationServices.backgroundMessageHandler);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ConnectivityCubit(Connectivity())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        '/projectList': (context) => ProjectList(fromHome: false),
        '/addCilentScreen': (context) => AddCilentScreen(),
        '/editCilentScreen': (context) => EditCilentScreen(),
        '/projectDetails': (context) => ProjectDetails(),
        '/gallery': (context) => GalleryScreen(),
        '/drawing': (context) => DrawingScreen(),
        '/workDetails': (context) => WorkDetailsScreen(),
        '/stages': (context) => Stages(),
        '/stageHistory': (context) => StageHistory(),
        '/contractor': (context) => Contractor(),
        '/extraWork': (context) => ExtraWork(),
        '/deductionWork': (context) => DeductionWork(),
        '/purchase': (context) => const PurchaseList(),
        '/stock': (context) => Stock(),
        '/expense': (context) => const Expense(),
        '/paymentDetails': (context) => PaymentDetails(),
        '/estimation': (context) => Estimation(),
        '/consumption': (context) => Consumption(),
        '/package': (context) => Package(),
        '/phoneNumber': (context) => PhoneNumberScreen(),
        '/changePasswordScreen': (context) => ChangePasswordScreen(),
        '/addProjectScreen': (context) => AddProjectScreen(fromHome: false),
        '/complaintList': (context) => ComplaintList(),
        '/addComplaints': (context) => AddComplaint(),
        '/imageViewer': (context) => const ImageViewer(),
        '/editProjectScreen': (context) => EditProjectScreen(),
        '/taskDetails': (context) => TaskDetails(),
        '/taskHistoryScreen': (context) => const TaskHistoryScreen(),
        '/notification': (context) => const NotificationList(),
        '/workIssuesList': (context) => WorkIssues(),
          '/visitDetails': (context) => VisitDetails(),
          '/visitHistory': (context) => VisitHistory(),
      },
    );
  }
}