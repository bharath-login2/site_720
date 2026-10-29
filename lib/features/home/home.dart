// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:site_720/core/constants/colors.dart';
// import 'package:site_720/core/widgets/dialogs.dart';
// import 'package:site_720/features/dashboard/views/dashboard_screen.dart';
// import 'package:site_720/features/work/views/work_screen.dart';
// import 'package:site_720/features/work_details/views/work_details_screen.dart';
// import 'package:site_720/features/work/cubit/work_cubit.dart';
// import 'package:site_720/features/work_details/cubit/work_details_cubit.dart';

// import '../task_management/views/task_list.dart';
// import '../visit/views/visit_details.dart';

// class Home extends StatefulWidget {
//   const Home({super.key});

//   @override
//   State<Home> createState() => _HomeState();
// }

// // class _HomeState extends State<Home> {
// //   int _selectedIndex = 0;

// //   void _onItemTapped(int index) {
// //     setState(() {
// //       _selectedIndex = index;
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final List<Widget> widgetOptions = <Widget>[
// //       /// HOME
// //       DashboardScreen(),

// //       /// WORK
// //       BlocProvider(
// //         create: (_) => WorkCubit()..getExternalWorkDetailsList(),
// //         child: const WorkScreen(),
// //       ),

// //       /// TASK
// //       TaskList(),

// //       /// LOCATION
// //       VisitList(),
// //     ];

// //     return PopScope(
// //       canPop: false,
// //       onPopInvokedWithResult: (didPop, result) {
// //         exitApp(context);
// //       },
// //       child: Scaffold(
// //         body: IndexedStack(
// //           index: _selectedIndex,
// //           children: widgetOptions,
// //         ),
// //         bottomNavigationBar: BottomNavigationBar(
// //           currentIndex: _selectedIndex,
// //           selectedItemColor: AppColors.primaryColor,
// //           backgroundColor: AppColors.secondaryColor,
// //           unselectedItemColor: Colors.grey,
// //           type: BottomNavigationBarType.fixed,
// //           showSelectedLabels: true,
// //           showUnselectedLabels: true,
// //           enableFeedback: false,
// //           onTap: _onItemTapped,
// //           items: const <BottomNavigationBarItem>[
// //             BottomNavigationBarItem(
// //               icon: Icon(Icons.home),
// //               label: 'Home',
// //             ),
// //             BottomNavigationBarItem(
// //               icon: Icon(Icons.work),
// //               label: 'Work',
// //             ),
// //             BottomNavigationBarItem(
// //               icon: Icon(Icons.task_alt),
// //               label: 'Task',
// //             ),
// //             BottomNavigationBarItem(
// //               icon: Icon(Icons.location_pin),
// //               label: 'Location',
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// class _HomeState extends State<Home> {
//   int _selectedIndex = 0;

//   late final List<Widget> widgetOptions;

//   @override
//   void initState() {
//     super.initState();

//     widgetOptions = [
//       DashboardScreen(),
//       BlocProvider(
//         create: (_) => WorkCubit()..getExternalWorkDetailsList(),
//         child: const WorkScreen(),
//       ),
//       TaskList(),
//       VisitList(),
//     ];
//   }

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: false,
//       onPopInvokedWithResult: (didPop, result) {
//         exitApp(context);
//       },
//       child: Scaffold(
//         body: IndexedStack(
//           index: _selectedIndex,
//           children: widgetOptions,
//         ),
//         bottomNavigationBar: BottomNavigationBar(
//           currentIndex: _selectedIndex,
//           selectedItemColor: AppColors.primaryColor,
//           backgroundColor: AppColors.secondaryColor,
//           unselectedItemColor: Colors.grey,
//           type: BottomNavigationBarType.fixed,
//           showSelectedLabels: true,
//           showUnselectedLabels: true,
//           enableFeedback: false,
//           onTap: _onItemTapped,
//           items: const [
//             BottomNavigationBarItem(
//               icon: Icon(Icons.home),
//               label: 'Home',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.work),
//               label: 'Work',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.task_alt),
//               label: 'Task',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.location_pin),
//               label: 'Site Visit',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/widgets/dialogs.dart';
import 'package:site_720/features/dashboard/views/dashboard_screen.dart';
import 'package:site_720/features/dashboard/cubit/dasahboard_cubit.dart';
import 'package:site_720/features/dashboard/cubit/dashboard_state.dart';
import 'package:site_720/features/work/views/work_screen.dart';
import 'package:site_720/features/work/cubit/work_cubit.dart';
import '../../../core/constants/routes.dart';
import '../../../core/utilities/shared_preferences.dart';
import '../task_management/views/task_list.dart';
import '../visit/views/visit_details.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  late final List<Widget> widgetOptions;
  late final DashboardCubit _dashboardCubit;

  @override
  void initState() {
    super.initState();

    _dashboardCubit = DashboardCubit("", "");

    // Initial check on mount
    // _dashboardCubit.checkTokenExpirationStatus();

    widgetOptions = [
      BlocProvider.value(
        value: _dashboardCubit,
        child: const DashboardScreen(),
      ),
      BlocProvider(
        create: (_) => WorkCubit()..getExternalWorkDetailsList(),
        child: const WorkScreen(),
      ),
      TaskList(),
      VisitList(),
    ];
  }

  @override
  void dispose() {
    _dashboardCubit.close();
    super.dispose();
  }

  void _onItemTapped(int index) {
    // Check token expiration every time a tab is switched
    _dashboardCubit.checkTokenExpirationStatus();

    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> logOut(BuildContext context) async {
    await clearSharedPreference(); // Clears the saved token/session

    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DashboardCubit, DashboardState>(
      bloc: _dashboardCubit,
      listener: (context, state) async {
        if (state is DashboardTokenExpired) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Token expired. Please login again.'),
              backgroundColor: Colors.red,
            ),
          );
          if (!context.mounted) return;
          await logOut(context);
        }
      },
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          exitApp(context);
        },
        child: Scaffold(
          body: IndexedStack(
            index: _selectedIndex,
            children: widgetOptions,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            selectedItemColor: AppColors.primaryColor,
            backgroundColor: AppColors.secondaryColor,
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            enableFeedback: false,
            onTap: _onItemTapped,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.work),
                label: 'Work',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.task_alt),
                label: 'Task',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.location_pin),
                label: 'Site Visit',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
