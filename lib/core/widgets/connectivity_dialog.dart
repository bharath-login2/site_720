import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'buttons.dart';

Future<void> connectivityDialog(BuildContext context) async {
  return showDialog(
    barrierDismissible: false,
    barrierColor: Colors.white.withOpacity(.4),
    context: context,
    builder: (context) {
      return PopScope(
        canPop: false,
        child: Material(
          type: MaterialType.transparency,
          color: Colors.grey.shade200,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: AppColors.primaryColor)),
                  height: 200,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: 60,
                            child: Image.asset("assets/icons/no-internet.png")),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text("Please connect to the internet.."),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: SmallButton(title: "Ok"))
                      ],
                    ),
                  )),
            ),
          ),
        ),
      );
    },
  );
}
