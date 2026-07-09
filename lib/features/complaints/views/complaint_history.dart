// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:site_720/core/widgets/appbar.dart';
import 'package:site_720/features/payment_details/widgets/amount_container.dart';
import '../../../core/constants/colors.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/connectivity_dialog.dart';
import '../../../core/widgets/shimmer.dart';
import '../../../core/widgets/snack_bar.dart';
import '../../../data/models/complaint/complaintStatus_model.dart';
import '../../../data/models/complaint/complaint_history_model.dart';
import '../../../data/models/task/task_status.dart';
import '../../connectivity/cubit/connectivity_cubit.dart';
import '../../connectivity/cubit/connectivity_state.dart';
import '../cubit/complaint_history_cubit.dart';
import '../cubit/complaint_history_state.dart';

class ComplaintHistoryPage extends StatelessWidget {
  ComplaintHistoryPage({super.key});

  List<ComplaintHistory>? complaintHistory;

  final formKey = GlobalKey<FormState>();
  String? selectedStatus;
  List<AvailableStatus> statusList = [];
  TextEditingController comment = TextEditingController();
  XFile? image;
  String complaintId = "";
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
    complaintId = args["complaint_id"]!;
    return BlocProvider(
      create: (context) => ComplaintHistoryCubit(complaintId),
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
          BlocListener<ComplaintHistoryCubit, ComplaintHistoryState>(
            listener: (context, state) {
              if (state is ComplaintHistorySuccess) {
                complaintHistory = state.response.data;
              }
              //   else if (state is TaskStatusSuccess) {
              //   statusList = state.response.data.availableStatuses;
              // }
              else if (state is ImageHistorySuccess) {
                image = state.image;
              } else if (state is ComplaintHistoryStatusUpdated) {
                snackBar(context, state.response.message, Colors.green);
              } else if (state is ComplaintHistoryStatusupdateFailed) {
                snackBar(context, state.message, Colors.red);
              }
            },
          ),
          BlocListener<ComplaintHistoryCubit, ComplaintHistoryState>(
            listener: (context, state) {
              if (state is ComplaintHistoryDetailsSuccessWithMessage) {
                snackBar(context, state.message, Colors.green);
              } else if (state is ComplaintHistoryFailure) {
                snackBar(context, state.message, Colors.red);
              }
            },
          ),
        ],
        child: BlocBuilder<ComplaintHistoryCubit, ComplaintHistoryState>(
          builder: (context, state) {
            final cubit = context.read<ComplaintHistoryCubit>();
            return Scaffold(
              appBar: simpleAppbar(context, "Complaint History", true),
              body: state is ComplaintHistoryLoading
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
                                              complaintHistory![0].customerName,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            if (complaintHistory![0]
                                                    .contactNumber !=
                                                "")
                                              Text(
                                                complaintHistory![0]
                                                    .contactNumber,
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                          ],
                                        ),
                                        InkWell(
                                          onTap: () {
                                            // updateStatus(context, cubit);
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
                                                  const Icon(
                                                    Icons.calendar_month,
                                                    size: 14,
                                                  ),
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  Text(
                                                    complaintHistory![0].date,
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
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
                                          title: "Incident Date",
                                          amount:
                                              complaintHistory![0].incidentDate,
                                          valueColor: AppColors.primaryColor,
                                        ),
                                        const SizedBox(width: 8),
                                        AmountContainer(
                                          title: "Complaint Nature",
                                          amount: complaintHistory![0]
                                              .complaintNature,
                                          valueColor: AppColors.primaryColor,
                                        ),
                                        const SizedBox(width: 8),
                                        InkWell(
                                          onTap: () {
                                            updateStatus(context, cubit);
                                          },
                                          child: Container(
                                            width: 98,
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
                                                    complaintHistory![0]
                                                        .complaintStatus,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: complaintHistory![
                                                                      0]
                                                                  .complaintStatus ==
                                                              "IN-PROGRESS"
                                                          ? Colors.orange
                                                          : complaintHistory![0]
                                                                      .complaintStatus ==
                                                                  "COMPLETED"
                                                              ? Colors.green
                                                              : complaintHistory![
                                                                              0]
                                                                          .complaintStatus ==
                                                                      "REJECTED"
                                                                  ? Colors.red
                                                                  : Colors.blue,
                                                    ),
                                                  ),
                                                  // const SizedBox(
                                                  //   width: 8,
                                                  // ),
                                                  // const Icon(
                                                  //   Icons.arrow_forward_ios,
                                                  //   size: 14,
                                                  // )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Container(
                                        //   padding: const EdgeInsets.all(12),
                                        //   decoration: BoxDecoration(
                                        //     color: Colors.white,
                                        //     borderRadius:
                                        //         BorderRadius.circular(12),
                                        //     boxShadow: [
                                        //       BoxShadow(
                                        //         color: Colors.grey
                                        //             .withOpacity(0.5),
                                        //         blurRadius: 6,
                                        //         offset: const Offset(0, 2),
                                        //       ),
                                        //     ],
                                        //   ),
                                        //   child: Column(
                                        //     crossAxisAlignment:
                                        //         CrossAxisAlignment.start,
                                        //     children: [
                                        //       const Text(
                                        //         "Comment",
                                        //         style: TextStyle(
                                        //           fontSize: 14,
                                        //           fontWeight: FontWeight.bold,
                                        //         ),
                                        //       ),
                                        //       Text(
                                        //         complaintHistory![0]
                                        //             .description,
                                        //         style: const TextStyle(
                                        //           fontSize: 12,
                                        //           color: AppColors.primaryColor,
                                        //         ),
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, right: 16.0, top: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Description:",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  complaintHistory![0].description,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  "Added Image:",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                complaintHistory![0].fileUrl.trim().isEmpty
                                    ? Container(
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey.shade300),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.grey.shade100,
                                        ),
                                        child: const Center(
                                          child: Text(
                                            "No Image Found",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            '/imageViewer',
                                            arguments: {
                                              "image":
                                                  complaintHistory![0].fileUrl,
                                              "title": "Complaint Image",
                                            },
                                          );
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                complaintHistory![0].fileUrl,
                                            height: 100,
                                            width: 100,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                const SizedBox(
                                              height: 100,
                                              width: 100,
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Container(
                                              height: 100,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: Colors.grey.shade100,
                                              ),
                                              child: const Center(
                                                child: Text(
                                                  "No Image Found",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
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
    );
  }

  Future<void> updateStatus(
    BuildContext context,
    ComplaintHistoryCubit cubit,
  ) async {
    await cubit.getComplaintStatuses();

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return BlocBuilder<ComplaintHistoryCubit, ComplaintHistoryState>(
          builder: (context, state) {
            return StatefulBuilder(
              builder: (context, setState) {
                List<ComplaintStatus> statusList = [];
                if (state is ComplaintStatusSuccess) {
                  statusList = state.statuses;
                }

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
                                    value: data.id,
                                    child: Text(data.name),
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
                            const SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              // onTap: () async {
                              //   if (formKey.currentState!.validate()) {
                              //     cubit.updateComplaintStatus(
                              //         complaintId,
                              //         comment.text,
                              //         selectedStatus!);
                              //     image = null;
                              //     selectedStatus = null;
                              //     comment.clear();
                              //     Navigator.pop(context);
                              //   }
                              // },
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
      },
    );
  }
}
