// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../constants/colors.dart';

// PreferredSize simpleAppbar(
//     BuildContext context, String title, bool backButton) {
//   return PreferredSize(
//     preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.2),
//     child: Container(
//       height: MediaQuery.of(context).size.height * .15,
//       width: MediaQuery.of(context).size.width,
//       decoration: const BoxDecoration(
//           image: DecorationImage(
//               image: AssetImage("assets/images/appbar.png"), fit: BoxFit.fill),
//           color: AppColors.primaryColor,
//           borderRadius: BorderRadius.only(
//             bottomLeft: Radius.circular(25),
//             bottomRight: Radius.circular(25),
//           )),
//       child: Padding(
//         padding: const EdgeInsets.only(left: 20.0, top: 35),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             if (backButton)
//               InkWell(
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//                 child: const Icon(
//                   Icons.arrow_back_ios,
//                   color: Colors.white,
//                 ),
//               ),
//             const SizedBox(
//               width: 10,
//             ),
//             Text(
//               title,
//               style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   letterSpacing: 1,
//                   fontFamily: "Lobster",
//                   color: Colors.white),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
PreferredSize simpleAppbar(
  BuildContext context,
  String title,
  bool backButton, {
  List<Widget>? actions,
}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(
      MediaQuery.of(context).size.height * 0.2,
    ),
    child: Container(
      height: MediaQuery.of(context).size.height * .15,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/appbar.png"),
          fit: BoxFit.fill,
        ),
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 15,
          top: 35,
        ),
        child: Row(
          children: [
            if (backButton)
              InkWell(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),

            const SizedBox(width: 10),

            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  fontFamily: "Lobster",
                  color: Colors.white,
                ),
              ),
            ),

            /// Action Buttons
            if (actions != null) ...actions,
          ],
        ),
      ),
    ),
  );
}

class FloatingAppBar extends StatelessWidget {
  String title;
  FloatingAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .22,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/appbar.png"), fit: BoxFit.fill),
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(22),
            bottomRight: Radius.circular(22),
          )),
      child: Padding(
        padding: const EdgeInsets.only(top: 60.0, left: 16.0, right: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      )),
                ),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
