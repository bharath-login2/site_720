// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:site_720/core/widgets/appbar.dart';
import 'package:site_720/features/payment_details/widgets/amount_container.dart';
import 'package:site_720/features/task_management/cubit/task_state.dart';
import '../../../core/constants/colors.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/connectivity_dialog.dart';
import '../../../core/widgets/milestoneWidget.dart';
import '../../../core/widgets/shimmer.dart';
import '../../../core/widgets/snack_bar.dart';
import '../../../data/models/task/milestoneModel.dart';
import '../../../data/models/task/task_details_model.dart';
import '../../../data/models/task/task_status.dart';
import '../../connectivity/cubit/connectivity_cubit.dart';
import '../../connectivity/cubit/connectivity_state.dart';
import '../cubit/task_details_cubit.dart';

class TaskDetails extends StatelessWidget {
  TaskDetails({super.key});
  TaskDetailsData? taskDetails;
  final formKey = GlobalKey<FormState>();
  String? selectedStatus;

  List<AvailableStatus> statusList = [];
  List<Milestone> milestoneList = [];
  TextEditingController comment = TextEditingController();
  XFile? image;
  String taskId = "";
  String? selectedMilestone;
  bool isExpanded = false;
  FocusNode focusNode = FocusNode();
  TextEditingController textController = TextEditingController();
  Map<int, dynamic> answers = {};
  Map<int, List<String>> checkboxAnswers = {};
  String _getFileName(dynamic answer) {
    try {
      if (answer is String) {
        return answer.split('/').last;
      } else if (answer is Map && answer['path'] != null) {
        return answer['path'].toString().split('/').last;
      }
    } catch (e) {
      print("Error extracting file name: $e");
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    taskId = args["task_id"]!;
    return BlocProvider(
      create: (context) => TaskDetailsCubit(taskId),
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
          BlocListener<TaskDetailsCubit, TaskState>(
            listener: (context, state) {
              if (state is TaskDetailsSuccess) {
                taskDetails = state.response.data;
              } else if (state is TaskStatusSuccess) {
                statusList = state.response.data.availableStatuses;
              }
              if (state is TaskMilestoneSuccess) {
                milestoneList = state.response.data;
              }
              if (state is ImageSuccess) {
                image = state.image;
              } else if (state is TaskStatusUpdated) {
                snackBar(context, state.response.message, Colors.green);
              }
              // else if (state is TaskStatusupdateFailed) {
              //   snackBar(context, state.message, Colors.red);
              // }
            },
          ),
          BlocListener<TaskDetailsCubit, TaskState>(
            listener: (context, state) {
              if (state is TaskDetailsSuccessWithMessage) {
                snackBar(context, state.message, Colors.green);
              }
              // else if (state is TaskDetailsFailure) {
              //   snackBar(context, state.message, Colors.red);
              // }
            },
          ),
        ],
        child: BlocBuilder<TaskDetailsCubit, TaskState>(
          builder: (context, state) {
            final cubit = context.read<TaskDetailsCubit>();
            return Scaffold(
              appBar: simpleAppbar(context, "Task Details", true),
              body: state is TaskLoading
                  ? shimmerWidget(context)
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 16.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: AppColors.secondaryColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.8),
                                    blurRadius: 4,
                                    offset: const Offset(1, 1),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 12.0,
                                    right: 12.0,
                                    top: 16.0,
                                    bottom: 16),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              taskDetails!.taskTitle,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              taskDetails!.staffName,
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                            taskDetails!.workType ==
                                                    "Office Work"
                                                ? Text(
                                                    "Office Category: ${taskDetails!.officeCategoryName}",
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  )
                                                : Text(
                                                    "Site Category: ${taskDetails!.siteCategoryName}",
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                            if (taskDetails!.projectName != "")
                                              Text(
                                                taskDetails!.projectName,
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            if (taskDetails!.stageName != "")
                                              Text(
                                                taskDetails!.stageName,
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                          ],
                                        ),
                                        InkWell(
                                          onTap: () {
                                            updateStatus(context, cubit);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: AppColors.backgroundColor,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.8),
                                                  blurRadius: 6,
                                                  offset: const Offset(1, 1),
                                                ),
                                              ],
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12.0,
                                                      vertical: 4.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    taskDetails!.status,
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  const Icon(
                                                    Icons.arrow_forward_ios,
                                                    size: 14,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        AmountContainer(
                                            title: "From Date",
                                            amount: taskDetails!.fromDate,
                                            valueColor: AppColors.primaryColor),
                                        AmountContainer(
                                            title: "To Date",
                                            amount: taskDetails!.toDate,
                                            valueColor: AppColors.primaryColor),
                                        AmountContainer(
                                            title: "Priority",
                                            amount: taskDetails!.priority,
                                            //  valueColor: taskDetails!.priority=="High"?AppColors.primaryColor),
                                            valueColor: taskDetails!.priority ==
                                                    "High"
                                                ? Colors.red
                                                : taskDetails!.priority == "Low"
                                                    ? Colors.blue
                                                    : Colors.orange),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(
                          //       left: 16.0, right: 16.0, top: 16.0),
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       const Text(
                          //         "Remark :",
                          //         style: TextStyle(
                          //             fontSize: 16,
                          //             fontWeight: FontWeight.bold),
                          //       ),
                          //       Text(
                          //         taskDetails!.description,
                          //         style: const TextStyle(
                          //             fontSize: 12,
                          //             fontWeight: FontWeight.w400),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, right: 16.0, top: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Remark:",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  taskDetails!.description,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                ),
                                taskDetails!.workType == "Site Work" &&
                                        taskDetails!.mileStones != ""
                                    ? const SizedBox(height: 16)
                                    : const SizedBox(),
                                taskDetails!.workType == "Site Work" &&
                                        taskDetails!.mileStones != ""
                                    ? const Text(
                                        "Milestone:",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      )
                                    : const SizedBox(),
                                taskDetails!.workType == "Site Work"
                                    ? const SizedBox(height: 16)
                                    : const SizedBox(),
                                taskDetails!.workType == "Site Work" &&
                                        taskDetails!.mileStones != ""
                                    ? MilestoneWidget(
                                        milestoneList: milestoneList,
                                        currentMilestone:
                                            taskDetails!.mileStones,
                                      )
                                    : const SizedBox(),
                                const SizedBox(height: 16),
                                taskDetails!.workType == "Site Work" &&
                                        taskDetails!.mileStones != ""
                                    ? SizedBox(
                                        width: 120,
                                        height: 30,
                                        child: InkWell(
                                          onTap: () {
                                            updateMilestone(context, cubit);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: AppColors.backgroundColor,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.8),
                                                  blurRadius: 6,
                                                  offset: const Offset(1, 1),
                                                ),
                                              ],
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 4.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      taskDetails!.mileStones,
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      overflow: TextOverflow
                                                          .ellipsis,
                                                      maxLines: 1,
                                                      softWrap: false,
                                                    ),
                                                  ),
                                                  const Icon(
                                                    Icons.arrow_forward_ios,
                                                    size: 14,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox()
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, right: 16.0, top: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Days Left :",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  taskDetails!.daysLeft,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                          taskDetails!.comment != ""
                              ? const SizedBox(height: 8)
                              : const SizedBox(),
                          taskDetails!.comment != ""
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, right: 16.0, top: 16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Comment :",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        taskDetails!.comment,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox(),

                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, right: 16.0, bottom: 16.0),
                            child: Visibility(
                              visible: taskDetails!.attachments.isNotEmpty,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Image :",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ListView.builder(
                                    padding: EdgeInsets.zero,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: taskDetails!.attachments.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 16.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: AppColors.primaryColor,
                                          ),
                                          child: Column(
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                    left: 16.0,
                                                    right: 16.0,
                                                    top: 8.0,
                                                    bottom: 8.0),
                                                child: Row(
                                                  children: [
                                                    // Text(
                                                    //   taskDetails!.attachments[index],
                                                    //   style: TextStyle(
                                                    //     color: AppColors
                                                    //         .lightA,
                                                    //     fontSize: 14,
                                                    //     fontWeight:
                                                    //         FontWeight.bold,
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .35,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    fit: BoxFit.fitWidth,
                                                    image: NetworkImage(
                                                        taskDetails!
                                                                .attachments[
                                                            index]),
                                                  ),
                                                  color: AppColors.lightA,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                              // if (drawingList[index].remarks != "")
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }

  Future<void> updateStatus(
    BuildContext context,
    TaskDetailsCubit cubit,
  ) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              content: SizedBox(
                height: image != null ? 480 : 350,
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
                            items: statusList.map((data) {
                              return DropdownMenuItem<String>(
                                value: data.id.toString(),
                                child: Text(
                                  data.status.toString(),
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
                              cubit.updateTaskStatus(
                                  taskId,
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

  Future<void> updateMilestone(
    BuildContext context,
    TaskDetailsCubit cubit,
  ) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              content: SizedBox(
                height: 250,
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 16.0, bottom: 25),
                          child: Text(
                            "Update Milestone",
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.95,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: DropdownButtonFormField<String>(
                            value: selectedMilestone,
                            items: milestoneList.map((data) {
                              return DropdownMenuItem<String>(
                                value: data.id,
                                child: Text(data.milestone),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedMilestone = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Select a Milestone";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(10),
                              labelText: 'Milestones*',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              prefixIcon: const Icon(Icons.info),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () async {
                            if (formKey.currentState!.validate()) {
                              await cubit.updateTaskMilestone(
                                  taskId, selectedMilestone!);
                              Navigator.pop(context);
                              snackBar(
                                  context,
                                  "Milestone updated successfully",
                                  Colors.green);
                            }
                          },
                          child: LargeButton(
                            title: "Update",
                          ),
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

  Future<void> imageDialog(BuildContext context, TaskDetailsCubit cubit) async {
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
