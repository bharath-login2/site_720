import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:site_720/core/utilities/shared_preferences.dart';
import '../constants/colors.dart';
import '../constants/routes.dart';
import 'buttons.dart';
import 'connectivity_dialog.dart';

Future<void> deleteDialog(BuildContext context, onTap) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        content: SizedBox(
          height: 200,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 30.0, bottom: 20),
                  child: Text(
                    "Are you sure ?",
                    style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: onTap,
                  child: LargeButton(title: "Delete"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Future<void> exitApp(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        content: SizedBox(
          height: 200,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Padding(
                  padding: EdgeInsets.only(
                      top: 30.0, bottom: 20, left: 20, right: 20),
                  child: Text(
                    "Are you sure ?",
                    style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    SystemNavigator.pop(animated: true);
                  },
                  child: LargeButton(title: "Exit"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

// Future<void> logOut(BuildContext context) async {
//   return showDialog(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         backgroundColor: Colors.white,
//         content: SizedBox(
//           height: 200,
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 const Padding(
//                   padding: EdgeInsets.only(
//                       top: 30.0, bottom: 20, left: 20, right: 20),
//                   child: Text(
//                     "Are you sure ?",
//                     style: TextStyle(
//                         color: AppColors.primaryColor,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     clearSharedPreference();
//                     connStatus = true;
//                     Navigator.pushReplacementNamed(context, AppRoutes.login);
//                   },
//                   child: LargeButton(title: "Logout"),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   child: const Text('Cancel'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }
Future<void> logOut(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        content: SizedBox(
          height: 200,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Padding(
                  padding: EdgeInsets.only(
                    top: 30.0,
                    bottom: 20,
                    left: 20,
                    right: 20,
                  ),
                  child: Text(
                    "Are you sure ?",
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    /// GET SAVED PIN
                    String savedPin = await getSharedPreference("pin") ?? "";

                    /// CLEAR ALL DATA
                    await clearSharedPreference();

                    /// SAVE PIN AGAIN
                    if (savedPin.isNotEmpty) {
                      await saveSharedPreference(
                        "pin",
                        savedPin,
                      );
                    }

                    connStatus = true;

                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.login,
                    );
                  },
                  child: LargeButton(
                    title: "Logout",
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Future<void> forceUpdate(BuildContext context, onTap) async {
  return showDialog(
    context: context,
    builder: (context) {
      return PopScope(
        child: AlertDialog(
          backgroundColor: Colors.white,
          content: SizedBox(
            height: 200,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                        top: 30.0, bottom: 20, left: 10, right: 10),
                    child: Text(
                      "Update Available",
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: LargeButton(title: "Update"),
                  ),
                  TextButton(
                    onPressed: () {
                      SystemNavigator.pop(animated: true);
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

Future<void> permissionDialog(
  BuildContext context,
) async {
  return showDialog(
    context: context,
    builder: (context) {
      return PopScope(
        child: AlertDialog(
          backgroundColor: Colors.white,
          content: SizedBox(
            height: 190,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                        top: 30.0, bottom: 20, left: 10, right: 10),
                    child: Column(
                      children: [
                        Text(
                          "Permission Required ⚠️",
                          style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Text(
                          "Sorry, you don’t have permission to access this feature. Please contact your admin",
                          style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Close',
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
