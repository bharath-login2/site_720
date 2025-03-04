// ignore_for_file: must_be_immutable

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/widgets/appbar.dart';
import 'package:site_720/core/widgets/snack_bar.dart';
import '../../../core/constants/routes.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/connectivity_dialog.dart';
import '../../../core/widgets/shimmer.dart';
import '../../../data/models/task/tasklist_model.dart';
import '../../connectivity/cubit/connectivity_cubit.dart';
import '../../connectivity/cubit/connectivity_state.dart';
import '../../payment_details/widgets/amount_container.dart';
import '../cubit/task_cubit.dart';
import '../cubit/task_state.dart';

class TaskList extends StatelessWidget {
  TaskList({super.key});
  List<Tasks> taskList = [];
  final formKey = GlobalKey<FormState>();
  XFile? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: simpleAppbar(context, "Task", false),
        body: BlocProvider(
          create: (context) => TaskCubit(),
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
              BlocListener<TaskCubit, TaskState>(
                listener: (context, state) {
                  if (state is TaskSuccess) {
                    taskList = state.response.data;
                  } else if (state is ImageSuccess) {
                    image = state.image;
                  } else if (state is AttendanceUpdated) {
                    snackBar(context, state.response.message, Colors.green);
                  } else if (state is AttendanceFailed) {
                    snackBar(context, state.message, Colors.red);
                  }
                },
              )
            ],
            child: BlocBuilder<TaskCubit, TaskState>(
              builder: (context, state) {
                final cubit = context.read<TaskCubit>();
                if (state is TaskLoading) {
                  return ListView.builder(
                    itemCount: 7,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: shimmerContainer(100, 70),
                      );
                    },
                  );
                } else if (taskList.isNotEmpty) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      cubit.getTaskList();
                    },
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      itemCount: taskList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AppRoutes.taskDetails,
                                  arguments: {"task_id": taskList[index].id});
                            },
                            child: Container(
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
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * .7,
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
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                taskList[index].taskTitle,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              if (taskList[index].staffName !=
                                                  "")
                                                Text(
                                                  taskList[index].staffName,
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              if (taskList[index].stageName !=
                                                  "")
                                                Text(
                                                  taskList[index].stageName,
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  attendanceDialog(
                                                      context,
                                                      cubit,
                                                      taskList[index].id);
                                                },
                                                child: Container(
                                                  height: 25,
                                                  width: 25,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color:
                                                        AppColors.primaryColor,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.8),
                                                        blurRadius: 6,
                                                        offset:
                                                            const Offset(1, 1),
                                                      ),
                                                    ],
                                                  ),
                                                  child: const Icon(
                                                    Icons.edit,
                                                    size: 18,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 7,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.pushNamed(context,
                                                      AppRoutes.taskHistory,
                                                      arguments: {
                                                        "task_id":
                                                            taskList[index].id
                                                      });
                                                },
                                                child: Container(
                                                  height: 25,
                                                  width: 25,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color:
                                                        AppColors.primaryColor,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.8),
                                                        blurRadius: 6,
                                                        offset:
                                                            const Offset(1, 1),
                                                      ),
                                                    ],
                                                  ),
                                                  child: const Icon(
                                                    Icons.history,
                                                    size: 18,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          AmountContainer(
                                              title: "From Date",
                                              amount: taskList[index].fromDate,
                                              valueColor:
                                                  AppColors.primaryColor),
                                          AmountContainer(
                                              title: "To Date",
                                              amount: taskList[index].toDate,
                                              valueColor:
                                                  AppColors.primaryColor),
                                          AmountContainer(
                                            title: "Status",
                                            amount: taskList[index].status,
                                            valueColor:
                                                taskList[index].status == "New"
                                                    ? Colors.blue
                                                    : taskList[index].status ==
                                                            "Pending"
                                                        ? Colors.orange
                                                        : taskList[index]
                                                                    .status ==
                                                                "Rejected"
                                                            ? Colors.red
                                                            : Colors.green,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return const Center(
                    child: Text("Task is Empty"),
                  );
                }
              },
            ),
          ),
        ));
  }

  Future<void> attendanceDialog(
    BuildContext context,
    TaskCubit cubit, // Pass the cubit directly
    String taskId,
  ) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return BlocProvider.value(
          value: cubit, // Pass the existing cubit instance
          child: StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                backgroundColor: Colors.white,
                content: SizedBox(
                  height: 360,
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 16.0, bottom: 25),
                            child: Text(
                              "Attendance",
                              style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              await cubit.selectImage(ImageSource.camera);
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
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Image.file(
                                                File(image!.path),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .2,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .2,
                                              child: const Center(
                                                child: Text(
                                                  'Upload Selfie',
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
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
                              if (image != null) {
                                Navigator.pop(context);
                                cubit.addAttendance(
                                  context,
                                  taskId,
                                  image!.path,
                                );
                                image = null;
                              }
                            },
                            child: LargeButton(title: "Upload"),
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
          ),
        );
      },
    );
  }
}
