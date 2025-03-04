import 'package:flutter/material.dart';
import 'buttons.dart';

bool connStatus = false;

Future<void> connectivityDialog(BuildContext context) async {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        content: SizedBox(
          height: 200,
          child: Center(
            child: SizedBox(
                // decoration: BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: const BorderRadius.all(Radius.circular(10)),
                //     border: Border.all(color: AppColors.primaryColor)),
                height: 200,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          height: 60,
                          child: Image.asset("assets/icons/no-internet.png")),
                      const Text(
                        "Please connect to the internet..",
                        style: TextStyle(fontSize: 12),
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
      );
    },
  );
}
