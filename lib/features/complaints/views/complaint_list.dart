// ignore_for_file: must_be_immutable, prefer_const_constructors_in_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/widgets/shimmer.dart';
import 'package:site_720/features/complaints/cubit/complaint_cubit.dart';
import '../../../core/constants/routes.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/connectivity_dialog.dart';
import '../../../core/widgets/snack_bar.dart';
import '../../connectivity/cubit/connectivity_cubit.dart';
import '../../connectivity/cubit/connectivity_state.dart';
import '../cubit/complaint_state.dart';
import 'chatpage.dart';

class ComplaintList extends StatelessWidget {
  ComplaintList({super.key});

  final formKey = GlobalKey<FormState>();
  String? selectedStatus;
  TextEditingController comment = TextEditingController();
  XFile? image;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ComplaintCubit(),
      child: MultiBlocListener(
        listeners: [
          BlocListener<ConnectivityCubit, ConnectivityState>(
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
          ),
          BlocListener<ComplaintCubit, ComplaintState>(
            listener: (context, state) {
              if (state is ImageSuccess) {
                image = state.image;
              } else if (state is ComplaintStatusUpdated) {
                snackBar(context, state.response.message, Colors.green);
              } else if (state is ComplaintStatusupdateFailed) {
                snackBar(context, state.message, Colors.red);
              }
            },
          ),
        ],
        child: BlocBuilder<ComplaintCubit, ComplaintState>(
          builder: (context, state) {
            ComplaintCubit cubit = context.read<ComplaintCubit>();
            return Scaffold(
                backgroundColor: AppColors.backgroundColor,
                appBar: PreferredSize(
                  preferredSize:
                      Size.fromHeight(MediaQuery.of(context).size.height * 0.2),
                  child: Container(
                    height: MediaQuery.of(context).size.height * .15,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/appbar.png"),
                            fit: BoxFit.fill),
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                        )),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 20.0, top: 35, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                "Complaints List",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                    fontFamily: "Lobster",
                                    color: Colors.white),
                              ),
                            ],
                          ),
                          // InkWell(
                          //   onTap: () {
                          //     Navigator.of(context)
                          //         .pushNamed(AppRoutes.addComplaints);
                          //   },
                          //   child: const CircleAvatar(
                          //     radius: 20,
                          //     backgroundColor: AppColors.lightPrimary,
                          //     child: Icon(
                          //       Icons.add,
                          //       color: Colors.white,
                          //     ),
                          //   ),
                          // )
                        ],
                      ),
                    ),
                  ),
                ),
                body: state is ComplaintFailure
                    ? const Center(
                        child: Text("Something went wrong"),
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          cubit.getComplaintList();
                        },
                        child:ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 6.0),
                          itemCount: cubit.complaints.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: state is ComplaintLoading
                                  ? shimmerContainer(80, 200)
                                  : cubit.complaints.isNotEmpty
                                      ? InkWell(
                                          // onTap: () {
                                          //   Navigator.of(context).pushNamed(
                                          //     AppRoutes.complaintHistory,
                                          //     arguments:
                                          //         cubit.complaints[index].id,
                                          //   );
                                          // },
                                            onTap: () { 
                                            connStatus = true;
                                            Navigator.pushNamed(
                                                context, AppRoutes.complaintHistory,
                                                arguments: {"complaint_id": cubit.complaints[index].id});
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .9,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
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
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .7,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0,
                                                    left: 8.0,
                                                    right: 8.0,
                                                    bottom: 8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            if (cubit
                                                                    .complaints[
                                                                        index]
                                                                    .customerName !=
                                                                '')
                                                              Text(
                                                                cubit
                                                                    .complaints[
                                                                        index]
                                                                    .customerName,
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: AppColors
                                                                        .coffie),
                                                              ),
                                                            if (cubit
                                                                    .complaints[
                                                                        index]
                                                                    .natureName !=
                                                                '')
                                                              Text(
                                                                cubit
                                                                    .complaints[
                                                                        index]
                                                                    .natureName,
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: AppColors
                                                                        .coffie),
                                                              ),
                                                            if (cubit
                                                                    .complaints[
                                                                        index]
                                                                    .description !=
                                                                '')
                                                              Text(
                                                                cubit
                                                                    .complaints[
                                                                        index]
                                                                    .description,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            if (cubit
                                                                    .complaints[
                                                                        index]
                                                                    .incidentDate !=
                                                                '')
                                                              Text(
                                                                cubit
                                                                    .complaints[
                                                                        index]
                                                                    .incidentDate,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            if (cubit
                                                                    .complaints[
                                                                        index]
                                                                    .statusName !=
                                                                '')
                                                              Text(
                                                                cubit
                                                                    .complaints[
                                                                        index]
                                                                    .statusName,
                                                                style: TextStyle(
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: cubit.complaints[index].statusName == "Closed"
                                                                        ? AppColors.primaryColor
                                                                        : cubit.complaints[index].statusName == "NEW"
                                                                            ? Colors.blue
                                                                            : cubit.complaints[index].statusName == "IN-PROGRESS"
                                                                                ? const Color.fromARGB(255, 231, 86, 42)
                                                                                : Colors.green),
                                                              ),
                                                          ],
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Visibility(
                                                                  visible:
                                                                      false,
                                                                  child:
                                                                      InkWell(
                                                                    onTap: () {
                                                                      Navigator
                                                                          .push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              ChatPage(
                                                                            complaintId:
                                                                                int.parse(cubit.complaints[index].id),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          25,
                                                                      width: 25,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(5),
                                                                        color: AppColors
                                                                            .lightBlue,
                                                                        boxShadow: [
                                                                          BoxShadow(
                                                                            color:
                                                                                Colors.grey.withOpacity(0.8),
                                                                            blurRadius:
                                                                                6,
                                                                            offset:
                                                                                const Offset(1, 1),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      child:
                                                                          const Icon(
                                                                        Icons
                                                                            .chat,
                                                                        size:
                                                                            20,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 9,
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    updateStatus(
                                                                        context,
                                                                        cubit,
                                                                        cubit
                                                                            .complaints[index]
                                                                            .id);
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    height: 25,
                                                                    width: 25,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                      color: AppColors
                                                                          .lightBlue,
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color: Colors
                                                                              .grey
                                                                              .withOpacity(0.8),
                                                                          blurRadius:
                                                                              6,
                                                                          offset: const Offset(
                                                                              1,
                                                                              1),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    child:
                                                                        const Icon(
                                                                      Icons
                                                                          .upload,
                                                                      size: 18,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                                // const SizedBox(
                                                                //   width: 7,
                                                                // ),
                                                                // InkWell(
                                                                //   onTap: () {},
                                                                //   child: Container(
                                                                //     height: 25,
                                                                //     width: 25,
                                                                //     decoration: BoxDecoration(
                                                                //       borderRadius:
                                                                //           BorderRadius
                                                                //               .circular(5),
                                                                //       color:
                                                                //           AppColors.lightBlue,
                                                                //       boxShadow: [
                                                                //         BoxShadow(
                                                                //           color: Colors.grey
                                                                //               .withOpacity(
                                                                //                   0.8),
                                                                //           blurRadius: 6,
                                                                //           offset:
                                                                //               const Offset(
                                                                //                   1, 1),
                                                                //         ),
                                                                //       ],
                                                                //     ),
                                                                //     child: const Icon(
                                                                //       Icons.edit,
                                                                //       size: 18,
                                                                //       color: Colors.white,
                                                                //     ),
                                                                //   ),
                                                                // ),
                                                                // const SizedBox(
                                                                //   width: 7,
                                                                // ),
                                                                // InkWell(
                                                                //   onTap: () {
                                                                //     deleteDialog(context, () {
                                                                //       Navigator.pop(context);
                                                                //     });
                                                                //   },
                                                                //   child: Container(
                                                                //     height: 25,
                                                                //     width: 25,
                                                                //     decoration: BoxDecoration(
                                                                //       borderRadius:
                                                                //           BorderRadius
                                                                //               .circular(5),
                                                                //       color: Colors.red,
                                                                //       boxShadow: [
                                                                //         BoxShadow(
                                                                //           color: Colors.grey
                                                                //               .withOpacity(
                                                                //                   0.8),
                                                                //           blurRadius: 6,
                                                                //           offset:
                                                                //               const Offset(
                                                                //                   1, 1),
                                                                //         ),
                                                                //       ],
                                                                //     ),
                                                                //     child: const Icon(
                                                                //       Icons.delete,
                                                                //       size: 18,
                                                                //       color: Colors.white,
                                                                //     ),
                                                                //   ),
                                                                // ),
                                                              ],
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : const Center(
                                          child: Text("Empty..."),
                                        ),
                            );
                          },
                        ),
                      ));
          },
        ),
      ),
    );
  }

  Future<void> updateStatus(
      BuildContext context, ComplaintCubit cubit, String complaintId) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              content: SizedBox(
                height: image != null ? 500 : 370,
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 16.0, bottom: 25),
                          child: Text(
                            "Update Status",
                            style: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.95,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: DropdownButtonFormField<String>(
                            value: selectedStatus,
                            items: cubit.statusList.map((data) {
                              return DropdownMenuItem<String>(
                                value: data.id.toString(),
                                child: Text(
                                  data.name.toString(),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedStatus = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Select a Status";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(10),
                              labelText: 'Status*',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              prefixIcon: const Icon(Icons.info),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.95,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            controller: comment,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(10),
                              labelText: 'Comment',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              prefixIcon: const Icon(Icons.text_fields),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        InkWell(
                          onTap: () async {
                            await imageDialog(context, cubit);
                            setState(() {});
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
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .2,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 20.0),
                                            child: Text(
                                              'Choose Image',
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                          )),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (formKey.currentState!.validate()) {
                              cubit.updateComplaintStatus(
                                  complaintId,
                                  image == null ? "" : image!.path,
                                  comment.text,
                                  selectedStatus!);
                              image = null;
                              selectedStatus = null;
                              comment.clear();
                              Navigator.pop(context);
                            }
                          },
                          child: LargeButton(title: "Update"),
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
              ),
            );
          },
        );
      },
    );
  }

  Future<void> imageDialog(BuildContext context, ComplaintCubit cubit) async {
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
                            await cubit.selectImage(ImageSource.camera);
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
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
                            await cubit.selectImage(ImageSource.gallery);
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
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
