// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/widgets/buttons.dart';
import 'package:site_720/core/widgets/snack_bar.dart';
import '../../../core/widgets/appbar.dart';
import '../../../data/models/galery/stage_pro_model.dart';
import '../cubit/gallery_state.dart';
import '../cubit/galllery_cubit.dart';
import '../widgets/phase_widget.dart';

class GalleryScreen extends StatelessWidget {
  GalleryScreen({super.key});
  List<StageListPro> stages = [];
  dynamic phase;
  List images = [];

  TextEditingController youtubeLink = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    String projectId = args["id"]!;
    return BlocProvider(
      create: (context) => GalleryCubit(projectId),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: BlocConsumer<GalleryCubit, GalleryState>(
          listener: (context, state) {
            if (state is GallerySuccess) {}
            if (state is StageSuccess) {
              stages = state.response.data;
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Stack(
                children: [
                  SizedBox(
                    child: Column(
                      children: [
                        FloatingAppBar(
                          title: "Gallery",
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .35,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * .92,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: AppColors.lightA,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.8),
                                blurRadius: 3,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16.0),
                            child: Column(
                              children: [
                                const Text(
                                  "Phases",
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SingleChildScrollView(
                                  child: ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: 5,
                                    itemBuilder: (context, index) {
                                      return phaseWidget(
                                        context,
                                        index,
                                        "",
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.16,
                    left: MediaQuery.of(context).size.width * 0.05,
                    child: floatingCard(context),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Container floatingCard(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
            blurRadius: 3,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 12.0),
              child: Text(
                "Upload Gallery",
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .75,
              height: 40,
              child: DropdownButtonFormField(
                value: phase,
                onChanged: (value) {
                  phase = value.toString();
                },
                items: stages.map((data) {
                  return DropdownMenuItem<String>(
                    value: data.stageId,
                    child: Text(data.stageName),
                  );
                }).toList(),
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  labelText: 'Select Phase',
                  labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                  contentPadding: const EdgeInsets.only(left: 10),
                ),
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () async {
                if (images.length < 4) {
                  imageDialog(context);
                } else {
                  snackBar(
                      context,
                      "You can only upload up to 3 images for the gallery.",
                      Colors.red);
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width * .75,
                height: 60,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 10),
                    const Icon(Icons.image, color: Colors.grey),
                    const SizedBox(width: 10),
                    Expanded(
                      child: BlocBuilder<GalleryCubit, GalleryState>(
                        builder: (context, state) {
                          if (state is GalleryLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (state is ImageSuccess) {
                            images = state.imageList;
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: images.length,
                              itemBuilder: (context, index) {
                                final image = images[index];
                                return Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.file(
                                        File(image.path),
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                     Positioned(
                                        right: 0,
                                        child: InkWell(
                                          onTap: () {
                                            
                                          },
                                          child: const Icon(
                                            Icons.cancel_outlined,
                                            color: AppColors.primaryColor,
                                            size: 20,
                                          ),
                                        ))
                                  ],
                                );
                              },
                            );
                          } else if (state is GalleryFailure) {
                            return Center(
                                child: Text(
                              state.message,
                              style: const TextStyle(color: Colors.red),
                            ));
                          } else {
                            return const Text(
                              'Choose Image',
                              style: TextStyle(color: Colors.grey),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width * .75,
              height: 40,
              child: TextFormField(
                controller: youtubeLink,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  labelText: 'YouTube Link',
                  prefixIcon: const Icon(
                    Icons.link,
                    color: Colors.grey,
                    size: 18,
                  ),
                  labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                  contentPadding: const EdgeInsets.only(left: 10),
                ),
              ),
            ),
            const SizedBox(height: 15),
            MediumButton(title: "Submit"),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

  Future<void> imageDialog(
    BuildContext context,
  ) async {
    return showDialog(
      barrierColor: Colors.white.withOpacity(.4),
      context: context,
      builder: (ctx) {
        return Material(
          type: MaterialType.transparency,
          color: Colors.grey.shade200,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(),
                ),
                height: 200,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const CircleAvatar(
                              radius: 10,
                              foregroundColor: AppColors.backgroundColor,
                              backgroundColor: AppColors.primaryColor,
                              child: Center(
                                child: Icon(
                                  Icons.close,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () async {
                            await context
                                .read<GalleryCubit>()
                                .selectMultiImage(ImageSource.camera);
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Camera",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        InkWell(
                          onTap: () async {
                            await context
                                .read<GalleryCubit>()
                                .selectMultiImage(null);
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Gallery",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
}
