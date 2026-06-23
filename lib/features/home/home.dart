import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/widgets/dialogs.dart';
import 'package:site_720/features/dashboard/views/dashboard_screen.dart';
import 'package:site_720/features/work/views/work_screen.dart';
import 'package:site_720/features/work/cubit/work_cubit.dart';

import '../task_management/views/task_list.dart';
import '../visit/views/visit_details.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = <Widget>[
      /// HOME
      DashboardScreen(),

      /// WORK
      BlocProvider(
        create: (_) => WorkCubit()..getExternalWorkDetailsList(),
        child: const WorkScreen(),
      ),

      /// TASK
      TaskList(),

      /// LOCATION
      VisitList(),
    ];

    return PopScope(
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
          items: const <BottomNavigationBarItem>[
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
              label: 'Location',
            ),
          ],
        ),
      ),
    );
  }
}
