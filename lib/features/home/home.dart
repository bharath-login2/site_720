import 'package:flutter/material.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/widgets/dialogs.dart';
import 'package:site_720/features/dashboard/views/dashboard_screen.dart';
import '../clients/views/client_list.dart';
import '../project_list/views/add_projects.dart';
import '../task_management/views/task_list.dart';
import '../visit/views/visit_details.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(),
    TaskList(),
    AddProjectScreen(fromHome: true),
   VisitList(),

  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        exitApp(context);
      },
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _widgetOptions,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.work),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_pin),
              label: '',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: AppColors.primaryColor,
          backgroundColor: AppColors.secondaryColor,
          onTap: _onItemTapped,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          enableFeedback: false,
        ),
      ),
    );
  }
}
