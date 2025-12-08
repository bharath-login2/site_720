// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:site_720/core/widgets/appbar.dart';
import 'package:site_720/data/models/extraworklist/staffListModel.dart';
import 'package:site_720/data/services/http_services.dart';
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

class TaskDetails extends StatefulWidget {
  TaskDetails({super.key});

  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
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
  List<AvailableStatus> filteredStatusList = [];
  List<StaffList> staffList = [];
  StaffList? selectedTransferStaff;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  List<XFile> multipleImages = [];
  String? _selectedViewMode;
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
              body: state is TaskLoading || taskDetails == null
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
                                              taskDetails?.taskTitle ??
                                                  'No title',
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
                                                      overflow:
                                                          TextOverflow.ellipsis,
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

                          taskDetails!.attachments.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, right: 16.0, bottom: 16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Attachments :",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 10),
                                      ListView.builder(
                                        padding: EdgeInsets.zero,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount:
                                            taskDetails!.attachments.length,
                                        itemBuilder: (context, index) {
                                          String url =
                                              taskDetails!.attachments[index];
                                          String fileName = url.split('/').last;

                                          return GestureDetector(
                                            onTap: () {
                                              _showImageDialog(
                                                  context, url, fileName);
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 16.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  color: AppColors.primaryColor,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 16.0,
                                                              right: 16.0,
                                                              top: 8.0,
                                                              bottom: 8.0),
                                                      child: Text(
                                                        fileName,
                                                        style: const TextStyle(
                                                          color:
                                                              AppColors.lightA,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              .35,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image:
                                                              NetworkImage(url),
                                                        ),
                                                        color: AppColors.lightA,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }

  void _showImageDialog(
      BuildContext context, String imageUrl, String fileName) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black.withOpacity(0.8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // File name
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        fileName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    Expanded(
                      child: InteractiveViewer(
                        panEnabled: true,
                        minScale: 0.5,
                        maxScale: 3.0,
                        child: Center(
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.contain,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.0,
                            vertical: 8.0,
                          ),
                          child: Text(
                            'Close',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.5),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Future<void> updateStatus(
  //   BuildContext context,
  //   TaskDetailsCubit cubit,
  // ) async {
  //   return showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) {
  //       return StatefulBuilder(
  //         builder: (context, setState) {
  //           return AlertDialog(
  //             backgroundColor: Colors.white,
  //             content: SizedBox(
  //               height: image != null ? 480 : 350,
  //               child: SingleChildScrollView(
  //                 child: Form(
  //                   key: formKey,
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                     children: [
  //                       const Padding(
  //                         padding: EdgeInsets.only(top: 16.0, bottom: 25),
  //                         child: Text(
  //                           "Update Status",
  //                           style: TextStyle(
  //                               color: AppColors.primaryColor,
  //                               fontSize: 20,
  //                               fontWeight: FontWeight.bold),
  //                         ),
  //                       ),
  //                       Container(
  //                         width: MediaQuery.of(context).size.width * 0.95,
  //                         decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(5),
  //                         ),
  //                         child: DropdownButtonFormField<String>(
  //                           value: selectedStatus,
  //                           items: statusList.map((data) {
  //                             return DropdownMenuItem<String>(
  //                               value: data.id.toString(),
  //                               child: Text(
  //                                 data.status.toString(),
  //                               ),
  //                             );
  //                           }).toList(),
  //                           onChanged: (value) {
  //                             setState(() {
  //                               selectedStatus = value;
  //                             });
  //                           },
  //                           validator: (value) {
  //                             if (value == null || value.isEmpty) {
  //                               return "Select a Status";
  //                             }
  //                             return null;
  //                           },
  //                           decoration: InputDecoration(
  //                             contentPadding: const EdgeInsets.all(10),
  //                             labelText: 'Status*',
  //                             border: OutlineInputBorder(
  //                               borderRadius: BorderRadius.circular(5),
  //                             ),
  //                             prefixIcon: const Icon(Icons.info),
  //                           ),
  //                         ),
  //                       ),
  //                       const SizedBox(
  //                         height: 12,
  //                       ),
  //                       Container(
  //                         width: MediaQuery.of(context).size.width * 0.95,
  //                         decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(5),
  //                         ),
  //                         child: TextFormField(
  //                           keyboardType: TextInputType.text,
  //                           controller: comment,
  //                           decoration: InputDecoration(
  //                             contentPadding: const EdgeInsets.all(10),
  //                             labelText: 'Comment',
  //                             border: OutlineInputBorder(
  //                               borderRadius: BorderRadius.circular(5),
  //                             ),
  //                             prefixIcon: const Icon(Icons.text_fields),
  //                           ),
  //                         ),
  //                       ),
  //                       const SizedBox(
  //                         height: 12,
  //                       ),
  //                       InkWell(
  //                         onTap: () async {
  //                           await imageDialog(context, cubit);
  //                           setState(() {});
  //                         },
  //                         child: Container(
  //                           width: MediaQuery.of(context).size.width * .75,
  //                           decoration: BoxDecoration(
  //                             border: Border.all(color: Colors.black),
  //                             borderRadius: BorderRadius.circular(5),
  //                           ),
  //                           child: Row(
  //                             crossAxisAlignment: CrossAxisAlignment.center,
  //                             children: [
  //                               const SizedBox(width: 10),
  //                               const Icon(Icons.image, color: Colors.grey),
  //                               const SizedBox(width: 10),
  //                               Expanded(
  //                                   child: image != null
  //                                       ? Padding(
  //                                           padding: const EdgeInsets.all(8.0),
  //                                           child: Image.file(
  //                                             File(image!.path),
  //                                             height: MediaQuery.of(context)
  //                                                     .size
  //                                                     .height *
  //                                                 .2,
  //                                             fit: BoxFit.cover,
  //                                           ),
  //                                         )
  //                                       : const Padding(
  //                                           padding: EdgeInsets.symmetric(
  //                                               vertical: 20.0),
  //                                           child: Text(
  //                                             'Choose Image',
  //                                             style:
  //                                                 TextStyle(color: Colors.grey),
  //                                           ),
  //                                         )),
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //                       const SizedBox(
  //                         height: 20,
  //                       ),
  //                       GestureDetector(
  //                         onTap: () async {
  //                           if (formKey.currentState!.validate()) {
  //                             cubit.updateTaskStatus(
  //                                 taskId,
  //                                 image == null ? "" : image!.path,
  //                                 comment.text,
  //                                 selectedStatus!);
  //                             image = null;
  //                             selectedStatus = null;
  //                             comment.clear();
  //                             Navigator.pop(context);
  //                           }
  //                         },
  //                         child: LargeButton(title: "Update"),
  //                       ),
  //                       TextButton(
  //                         onPressed: () {
  //                           Navigator.pop(context);
  //                         },
  //                         child: const Text('Close'),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  Future<void> updateStatus(
    BuildContext context,
    TaskDetailsCubit cubit,
  ) async {
    final allowedStatuses = [
      "Completed",
      "Cancelled",
      "In-Progress",
      "Transfer"
    ];
    filteredStatusList = statusList
        .where((status) => allowedStatuses.contains(status.status))
        .toList();
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();
    selectedTransferStaff = null;
    multipleImages.clear();
    comment.clear();
    if (filteredStatusList.any((s) => s.status == "Transfer")) {
      await _loadStaffList(context);
    }
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final isCompleted = selectedStatus != null &&
                filteredStatusList
                        .firstWhere(
                          (s) => s.id.toString() == selectedStatus,
                          orElse: () => AvailableStatus(id: '0', status: ''),
                        )
                        .status ==
                    "Completed";

            final isCancelled = selectedStatus != null &&
                filteredStatusList
                        .firstWhere(
                          (s) => s.id.toString() == selectedStatus,
                          orElse: () => AvailableStatus(id: '0', status: ''),
                        )
                        .status ==
                    "Cancelled";

            final isTransfer = selectedStatus != null &&
                filteredStatusList
                        .firstWhere(
                          (s) => s.id.toString() == selectedStatus,
                          orElse: () => AvailableStatus(id: '0', status: ''),
                        )
                        .status ==
                    "Transfer";

            final isInProgress = selectedStatus != null &&
                filteredStatusList
                        .firstWhere(
                          (s) => s.id.toString() == selectedStatus,
                          orElse: () => AvailableStatus(id: '0', status: ''),
                        )
                        .status ==
                    "In-Progress";

            return AlertDialog(
              backgroundColor: Colors.white,
              insetPadding: const EdgeInsets.all(20),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 16.0, bottom: 25),
                        child: Text(
                          "Update Status",
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
                          value: selectedStatus,
                          items: filteredStatusList.map((data) {
                            return DropdownMenuItem<String>(
                              value: data.id.toString(),
                              child: Text(data.status),
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
                      const SizedBox(height: 12),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.95,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.multiline,
                          controller: comment,
                          maxLines: 3,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(10),
                            labelText: 'Comment${isCancelled ? '*' : ''}',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            prefixIcon: const Icon(Icons.comment),
                          ),
                          validator: (value) {
                            if (isCancelled &&
                                (value == null || value.isEmpty)) {
                              return "Comment is required for Cancelled status";
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (isCompleted || isCancelled || isInProgress) ...[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Date & Time*"),
                            InkWell(
                              onTap: () async {
                                await _selectDateTime(context, setState);
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      selectedDate != null &&
                                              selectedTime != null
                                          ? '${DateFormat('dd-MM-yyyy').format(selectedDate!)} ${selectedTime!.format(context)}'
                                          : "Select Date & Time",
                                      style: TextStyle(
                                        color: selectedDate != null &&
                                                selectedTime != null
                                            ? Colors.black
                                            : Colors.grey,
                                      ),
                                    ),
                                    const Icon(Icons.calendar_today, size: 20),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      
                        const SizedBox(height: 12),
                      ],
                      if (isTransfer) ...[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.95,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: DropdownButtonFormField<StaffList>(
                            value: selectedTransferStaff,
                            items: staffList.map((staff) {
                              return DropdownMenuItem<StaffList>(
                                value: staff,
                                child: Text(staff.staffName),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedTransferStaff = value;
                              });
                            },
                            validator: (value) {
                              if (isTransfer && value == null) {
                                return "Select a staff to transfer to";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(10),
                              labelText: 'Transfer To Staff*',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              prefixIcon: const Icon(Icons.person),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      if (isCompleted || isInProgress) ...[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Upload Images"),
                            const SizedBox(height: 8),
                            if (multipleImages.isNotEmpty)
                              SizedBox(
                                height: 120,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: multipleImages.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              image: DecorationImage(
                                                image: FileImage(File(
                                                    multipleImages[index]
                                                        .path)),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 4,
                                            right: 4,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  multipleImages
                                                      .removeAt(index);
                                                });
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.black
                                                      .withOpacity(0.6),
                                                ),
                                                child: const Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            InkWell(
                              onTap: () async {
                                await _showImagePickerDialog(context, setState);
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * .75,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.image, color: Colors.grey),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        multipleImages.isEmpty
                                            ? 'Choose Images (Multiple)'
                                            : '${multipleImages.length} image(s) selected',
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                    if (multipleImages.isNotEmpty)
                                      IconButton(
                                        icon: const Icon(Icons.add,
                                            color: Colors.green),
                                        onPressed: () async {
                                          await _showImagePickerDialog(
                                              context, setState);
                                        },
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                      if (isInProgress) ...[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.95,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: DropdownButtonFormField<String>(
                            value: _selectedViewMode,
                            items: const [
                              DropdownMenuItem(
                                value: 'view_all',
                                child: Text('View All'),
                              ),
                              DropdownMenuItem(
                                value: 'view_only',
                                child: Text('View Only'),
                              ),
                            ].where((item) => item.value != null).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedViewMode = value;
                              });
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(10),
                              labelText: 'File View Mode',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              prefixIcon: const Icon(Icons.visibility),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      GestureDetector(
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            if ((isCompleted || isCancelled || isInProgress) &&
                                (selectedDate == null ||
                                    selectedTime == null)) {
                              snackBar(context, "Please select date and time",
                                  Colors.red);
                              return;
                            }

                            if (isTransfer && selectedTransferStaff == null) {
                              snackBar(
                                  context,
                                  "Please select staff to transfer to",
                                  Colors.red);
                              return;
                            }
                            String? dateTimeString;
                            if (selectedDate != null && selectedTime != null) {
                              final dateTime = DateTime(
                                selectedDate!.year,
                                selectedDate!.month,
                                selectedDate!.day,
                                selectedTime!.hour,
                                selectedTime!.minute,
                              );
                              dateTimeString = DateFormat('yyyy-MM-dd HH:mm:ss')
                                  .format(dateTime);
                            }
                            await cubit.updateTaskStatus(
                              taskId,
                              multipleImages.map((img) => img.path).toList(),
                              comment.text,
                              selectedStatus!,
                              transferStaffId: selectedTransferStaff?.staffId,
                              dateTime: dateTimeString,
                              viewMode: _selectedViewMode,
                            );
                            _resetDialogState();
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          }
                        },
                        child: LargeButton(title: "Update"),
                      ),
                      TextButton(
                        onPressed: () {
                          _resetDialogState();
                          Navigator.pop(context);
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _resetDialogState() {
    selectedStatus = null;
    comment.clear();
    selectedDate = null;
    selectedTime = null;
    selectedTransferStaff = null;
    multipleImages.clear();
    _selectedViewMode = null;
  }

  Future<void> _selectDateTime(BuildContext context, Function setState) async {
    final selectedDateTemp = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDate: selectedDate ?? DateTime.now(),
    );
    if (selectedDateTemp != null) {
      final selectedTimeTemp = await showTimePicker(
        context: context,
        initialTime: selectedTime ?? TimeOfDay.now(),
      );
      if (selectedTimeTemp != null) {
        setState(() {
          selectedDate = selectedDateTemp;
          selectedTime = selectedTimeTemp;
        });
      }
    }
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

  Future<void> _loadStaffList(BuildContext context) async {
    try {
      final response = await HttpServices.getStaffsList();
      if (response != null && response.status) {
        setState(() {
          staffList = response.data;
        });
      } else {
        snackBar(context, "Failed to load staff list", Colors.red);
      }
    } catch (e) {
      snackBar(context, "Error loading staff: $e", Colors.red);
    }
  }

  Future<void> _showImagePickerDialog(
      BuildContext context, Function setState) async {
    return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Select Images"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text("Take Photo"),
                onTap: () async {
                  Navigator.pop(context);
                  final image =
                      await ImagePicker().pickImage(source: ImageSource.camera);
                  if (image != null) {
                    setState(() {
                      multipleImages.add(image);
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Choose from Gallery"),
                onTap: () async {
                  Navigator.pop(context);
                  final images = await ImagePicker().pickMultiImage();
                  if (images.isNotEmpty) {
                    setState(() {
                      multipleImages.addAll(images);
                    });
                  }
                },
              ),
            ],
          ),
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
