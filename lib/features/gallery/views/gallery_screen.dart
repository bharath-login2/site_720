// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/widgets/buttons.dart';
import 'package:site_720/core/widgets/snack_bar.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/connectivity_dialog.dart';
import '../../../data/models/galery/galery_list_model.dart';
import '../../../data/models/galery/stage_pro_model.dart';
import '../../connectivity/cubit/connectivity_cubit.dart';
import '../../connectivity/cubit/connectivity_state.dart';
import '../cubit/gallery_state.dart';
import '../cubit/galllery_cubit.dart';
import '../widgets/stage_widget.dart';

class GalleryScreen extends StatelessWidget {
  GalleryScreen({super.key});
  final formKey = GlobalKey<FormState>();
  List<StageListPro> stages = [];
  dynamic stageId;
  List<XFile> images = [];
  String projectId = "";
  String clientId = "";
  List<GalleryData> galleryList = [];
  TextEditingController youtubeLink = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    projectId = args["id"]!;
    clientId = args["client_id"]!;
    return BlocProvider(
      create: (context) => GalleryCubit(projectId),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: BlocListener<ConnectivityCubit, ConnectivityState>(
          listener: (context, state) {
            if (state is ConnectivityDisconnected) {
              if (connStatus == true) {
                connStatus = false;
                connectivityDialog(context);
              }
            } else {
              connStatus = true;
            }
          },
          child: BlocConsumer<GalleryCubit, GalleryState>(
            listener: (context, state) {
              if (state is GallerySuccess) {
                galleryList = state.response.data;
              }
              if (state is StageSuccess) {
                stages = state.response.data;
              }
              if (state is ImageSuccess) {
                images = state.imageList;
              }
              if (state is GalleryPosted) {
                stageId = null;
                images.clear();
                youtubeLink.clear();
                snackBar(context, state.message, AppColors.primaryColor);
              }
            },
            builder: (context, state) {
              final cubit = context.read<GalleryCubit>();
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
                            height: MediaQuery.of(context).size.height * .38,
                          ),
                          if (galleryList.isNotEmpty)
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
                                      "Stages",
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
                                        itemCount: galleryList.length,
                                        itemBuilder: (context, index) {
                                          return stageWidget(
                                              context,
                                              galleryList[index].stageName,
                                              galleryList[index].images,
                                              galleryList[index].ytLinks,
                                              cubit,
                                              projectId);
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
                      child: floatingCard(context, cubit, state),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Container floatingCard(
      BuildContext context, GalleryCubit cubit, GalleryState state) {
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
        child: Form(
          key: formKey,
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
                child: DropdownButtonFormField(
                  value: stageId,
                  onChanged: (value) {
                    stageId = value.toString();
                  },
                  validator: (value) {
                    if (value == null) {
                      return "Select Stage";
                    }
                    return null;
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
                    labelText: 'Select Stage',
                    labelStyle:
                        const TextStyle(color: Colors.grey, fontSize: 14),
                    contentPadding: const EdgeInsets.only(left: 10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () async {
                  if (images.length < 3) {
                    imageDialog(context);
                  } else {
                    snackBar(
                        context,
                        "You can only upload up to 3 images in a single time",
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
                            if (images.isNotEmpty) {
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
                                              cubit.deleteImage(index);
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
                child: TextFormField(
                  controller: youtubeLink,
                  validator: (value) {
                    if (value != "") {
                      if (isValidYouTubeUrl(value!)) {
                      } else {
                        return "Invalid YouTube URL.";
                      }
                    }
                    return null;
                  },
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
                    labelStyle:
                        const TextStyle(color: Colors.grey, fontSize: 14),
                    contentPadding: const EdgeInsets.only(left: 10),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              state is GalleryLoading
                  ? const CircularProgressIndicator()
                  : InkWell(
                      onTap: () {
                        if (formKey.currentState!.validate() &&
                            images.isNotEmpty) {
                          cubit.postGalery(projectId, clientId, stageId, images,
                              youtubeLink.text);
                        } else {
                          snackBar(
                              context, "Select stage and images", Colors.red);
                        }
                      },
                      child: MediumButton(title: "Submit")),
              const SizedBox(height: 4),
            ],
          ),
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

bool isValidYouTubeUrl(String url) {
  final RegExp youtubeRegex = RegExp(
    r"^(https?:\/\/)?(www\.)?(youtube\.com|youtu\.be)\/(watch\?v=)?([a-zA-Z0-9_-]{11})",
  );
  return youtubeRegex.hasMatch(url);
}
