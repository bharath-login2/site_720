import 'package:flutter/material.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/widgets/dialogs.dart';
import 'package:site_720/features/gallery/cubit/galllery_cubit.dart';
import 'package:site_720/features/gallery/widgets/youtube_widget.dart';

import '../../../data/models/galery/galery_list_model.dart';

Widget stageWidget(context, String title, List<ImageList> images,
    List<YtLink> ytLinks, GalleryCubit cubit, String projectId) {
  return ExpansionTile(
    textColor: AppColors.primaryColor,
    collapsedTextColor: AppColors.primaryColor,
    collapsedBackgroundColor: Colors.white,
    backgroundColor: Colors.white,
    title: Text(
      title,
    ),
    children: [
      const Text(
        "Images",
        style: TextStyle(
            color: AppColors.primaryColor, fontWeight: FontWeight.bold),
      ),
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
                          image: NetworkImage(images[i].fileName),
                        ),
                        border: Border.all(
                          color: AppColors.lightA,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.all(8),
                    ),
                    Positioned(
                        right: 0,
                        child: InkWell(
                          onTap: () {
                            deleteDialog(context, () {
                              cubit.deleteGallery(projectId, images[i].imageId);
                              Navigator.pop(context);
                            });
                          },
                          child: const Icon(
                            Icons.cancel_outlined,
                            color: Colors.red,
                            size: 22,
                          ),
                        ))
                  ],
                ),
              ),
            );
          },
        ),
      ),
      if (ytLinks.isNotEmpty)
        const Text(
          "YouTube Videos",
          style: TextStyle(
              color: AppColors.primaryColor, fontWeight: FontWeight.bold),
        ),
      ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: ytLinks.length,
        itemBuilder: (context, i) {
          return GestureDetector(
            onTap: () {},
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.lightA,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.all(8),
                    child: YouTubePlayerWidget(
                      videoUrl: ytLinks[i].url,
                    ),
                  ),
                ),
                Positioned(
                    right: 10,
                    top: 10,
                    child: InkWell(
                      onTap: () {
                        deleteDialog(context, () {
                          cubit.deleteGallery(projectId, ytLinks[i].id);
                          Navigator.pop(context);
                        });
                      },
                      child: const Icon(
                        Icons.cancel_outlined,
                        color: Colors.red,
                        size: 22,
                      ),
                    ))
              ],
            ),
          );
        },
      ),
    ],
  );
}
