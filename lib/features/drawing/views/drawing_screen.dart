// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/widgets/buttons.dart';
import 'package:site_720/core/widgets/shimmer.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/connectivity_dialog.dart';
import '../../../core/widgets/dialogs.dart';
import '../../../core/widgets/snack_bar.dart';
import '../../../data/models/site_drawings/drawing_list.dart';
import '../../connectivity/cubit/connectivity_cubit.dart';
import '../../connectivity/cubit/connectivity_state.dart';
import '../cubit/drawing_state.dart';
import '../cubit/drawing_cubit.dart';

class DrawingScreen extends StatelessWidget {
  DrawingScreen({super.key});
  String projectId = "";
  String clientId = "";
  TextEditingController remark = TextEditingController();
  List<Drawings> drawingList = [];
  XFile? image;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    projectId = args["id"]!;
    clientId = args["client_id"]!;
    return BlocProvider(
      create: (context) => DrawingCubit(projectId),
      child: BlocListener<ConnectivityCubit, ConnectivityState>(
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
        child: Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: BlocConsumer<DrawingCubit, DrawingState>(
            listener: (context, state) {
              if (state is DrawingSuccess) {
                drawingList = state.response.data;
              } else if (state is ImageSuccess) {
                image = state.image;
              } else if (state is UploadSuccess) {
                image = null;
                snackBar(context, "Drawing Uploaded", Colors.green);
              }
            },
            builder: (context, state) {
              final cubit = context.read<DrawingCubit>();

              return SingleChildScrollView(
                child: Stack(
                  children: [
                    SizedBox(
                      child: Column(
                        children: [
                          FloatingAppBar(
                            title: "Drawing",
                          ),
                          SizedBox(
                            height: image == null
                                ? MediaQuery.of(context).size.height * .28
                                : MediaQuery.of(context).size.height * .42,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16.0),
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: drawingList.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: state is DrawingLoading
                                      ? shimmerContainer(
                                          MediaQuery.of(context).size.height *
                                              .35,
                                          MediaQuery.of(context).size.width *
                                              .9,
                                        )
                                      : Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.8),
                                                blurRadius: 3,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .35,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    fit: BoxFit.fitWidth,
                                                    image: NetworkImage(
                                                        drawingList[index]
                                                            .fileName),
                                                  ),
                                                  border: Border.all(
                                                    color: AppColors.lightA,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                margin: const EdgeInsets.all(8),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16.0,
                                                    right: 16.0,
                                                    top: 4.0,
                                                    bottom: 8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    if (drawingList[index]
                                                            .remarks !=
                                                        "")
                                                      Text(
                                                        drawingList[index]
                                                            .remarks,
                                                        style: const TextStyle(
                                                          color: AppColors
                                                              .primaryColor,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      )
                                                    else
                                                      const SizedBox(),
                                                    InkWell(
                                                      onTap: () {
                                                        deleteDialog(context,
                                                            () {
                                                          cubit.deleteDrawing(
                                                              projectId,
                                                              drawingList[index]
                                                                  .id);
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      },
                                                      child: const Icon(
                                                        Icons.delete,
                                                        color: Colors.red,
                                                        size: 22,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.16,
                      left: MediaQuery.of(context).size.width * 0.05,
                      child: floatingCard(context, state),
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

  Container floatingCard(BuildContext context, DrawingState state) {
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
                "Upload Drawing",
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                imageDialog(context);
              },
              child: Container(
                width: MediaQuery.of(context).size.width * .75,
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
                        child: image != null
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.file(
                                  File(image!.path),
                                  height:
                                      MediaQuery.of(context).size.height * .2,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                child: Text(
                                  'Choose Image',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width * .75,
              child: TextFormField(
                controller: remark,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  labelText: 'Remarks',
                  prefixIcon: const Icon(
                    Icons.text_fields,
                    color: Colors.grey,
                    size: 18,
                  ),
                  labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                  contentPadding: const EdgeInsets.only(left: 10),
                ),
              ),
            ),
            const SizedBox(height: 15),
            state is UploadLoading
                ? const CircularProgressIndicator()
                : InkWell(
                    onTap: () async {
                      await context.read<DrawingCubit>().uploadDrawings(
                          projectId, clientId, image!, remark.text);
                    },
                    child: MediumButton(title: "Submit")),
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
                                .read<DrawingCubit>()
                                .selectImage(ImageSource.camera);
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
                                .read<DrawingCubit>()
                                .selectImage(ImageSource.gallery);
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
