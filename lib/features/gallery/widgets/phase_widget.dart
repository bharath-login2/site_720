import 'package:flutter/material.dart';
import 'package:site_720/core/constants/colors.dart';

import '../../../data/models/galery/galery_list_model.dart';

Widget stageWidget(context, String title, List<ImageList> images) {
  return ExpansionTile(
    textColor: AppColors.primaryColor,
    collapsedTextColor: AppColors.primaryColor,
    collapsedBackgroundColor: Colors.white,
    backgroundColor: Colors.white,
    title: Text(
      title,
    ),
    children: [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 5, mainAxisSpacing: 5, crossAxisCount: 3),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: images.length,
          itemBuilder: (context, i) {
            return GestureDetector(
              onTap: () {},
              child: Align(
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          image: NetworkImage(images[i].imageId),
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
