import 'package:flutter/material.dart';
import 'package:site_720/core/constants/colors.dart';

Widget phaseWidget(context, index, data) {
  return ExpansionTile(
    textColor: AppColors.primaryColor,
    collapsedTextColor: AppColors.primaryColor,
    collapsedBackgroundColor: Colors.white,
    backgroundColor: Colors.white,
    title: Text(
      "Phase ${index + 1}",
    ),
    children: [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 5, mainAxisSpacing: 5, crossAxisCount: 3),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 6,
          itemBuilder: (context, childIndex) {
            return GestureDetector(
              onTap: () {},
              child: Align(
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          fit: BoxFit.fitWidth,
                          image:
                              NetworkImage("https://via.placeholder.com/150"),
                        ),
                        border: Border.all(
                          color: AppColors.lightA,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.all(8),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}
