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
import '../../../data/models/complaint/complaint_status_history_model.dart';
import '../../../data/models/task/task_status.dart';
import '../../connectivity/cubit/connectivity_cubit.dart';
import '../../connectivity/cubit/connectivity_state.dart';
import '../cubit/complaint_history_cubit.dart';
import '../cubit/complaint_history_state.dart';

class ComplaintHistoryPage extends StatelessWidget {
  ComplaintHistoryPage({super.key});

  List<ComplaintHistory>? complaintHistory;
  List<ComplaintStatusHistoryData>? complaintStatusHistory;

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

              if (state is ComplaintStatusHistorySuccess) {
                complaintStatusHistory = state.response.data;
              }

              if (state is ImageHistorySuccess) {
                image = state.image;
              }

              if (state is ComplaintHistoryStatusUpdated) {
                snackBar(
                  context,
                  state.response.message,
                  Colors.green,
                );
              }

              if (state is ComplaintHistoryStatusupdateFailed) {
                snackBar(
                  context,
                  state.message,
                  Colors.red,
                );
              }

              if (state is ComplaintHistoryDetailsSuccessWithMessage) {
                snackBar(
                  context,
                  state.message,
                  Colors.green,
                );
              }

              if (state is ComplaintHistoryFailure) {
                snackBar(
                  context,
                  state.message,
                  Colors.red,
                );
              }

              if (state is ComplaintStatusHistoryFailure) {
                snackBar(
                  context,
                  state.message,
                  Colors.red,
                );
              }
            },
          ),
        ],
        child: BlocBuilder<ComplaintHistoryCubit, ComplaintHistoryState>(
          builder: (context, state) {
            final cubit = context.read<ComplaintHistoryCubit>();

            if (state is ComplaintHistoryLoading) {
              return Scaffold(
                appBar: simpleAppbar(
                  context,
                  "Complaint History",
                  true,
                ),
                body: shimmerWidget(context),
              );
            }

            if (complaintHistory == null || complaintHistory!.isEmpty) {
              return Scaffold(
                appBar: simpleAppbar(
                  context,
                  "Complaint History",
                  true,
                ),
                body: const Center(
                  child: Text(
                    "No complaint history found",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                ),
              );
            }

            final complaint = complaintHistory![0];

            return Scaffold(
              appBar: simpleAppbar(
                context,
                "Complaint History",
                true,
              ),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ---------------------------------------------------------
                    // COMPLAINT SUMMARY
                    // ---------------------------------------------------------
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                        right: 8.0,
                        top: 16.0,
                      ),
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
                            bottom: 16,
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          complaint.customerName,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        if (complaint.contactNumber != "")
                                          Text(
                                            complaint.contactNumber,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(width: 8),

                                  // Date
                                  InkWell(
                                    onTap: () {
                                      // updateStatus(context, cubit);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: AppColors.backgroundColor,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.8),
                                            blurRadius: 6,
                                            offset: const Offset(1, 1),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0,
                                          vertical: 4.0,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.calendar_month,
                                              size: 14,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              complaint.date,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 15),

                              // ------------------------------------------------
                              // INCIDENT DATE / NATURE / STATUS
                              // ------------------------------------------------
                              Row(
                                children: [
                                  Expanded(
                                    child: AmountContainer(
                                      title: "Incident Date",
                                      amount: complaint.incidentDate,
                                      valueColor: AppColors.primaryColor,
                                    ),
                                  ),

                                  const SizedBox(width: 8),

                                  Expanded(
                                    child: AmountContainer(
                                      title: "Complaint Nature",
                                      amount: complaint.complaintNature,
                                      valueColor: AppColors.primaryColor,
                                    ),
                                  ),

                                  const SizedBox(width: 8),

                                  // Status
                                  InkWell(
                                    onTap: () {
                                      updateStatus(
                                        context,
                                        cubit,
                                      );
                                    },
                                    child: Container(
                                      width: 98,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: AppColors.backgroundColor,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.8),
                                            blurRadius: 6,
                                            offset: const Offset(1, 1),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0,
                                          vertical: 4.0,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                complaint.complaintStatus,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      _getComplaintStatusColor(
                                                    complaint.complaintStatus,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
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

                    // ---------------------------------------------------------
                    // DESCRIPTION + IMAGE
                    // ---------------------------------------------------------
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16.0,
                        right: 16.0,
                        top: 16.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Description:",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            complaint.description,
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

                          // Complaint image
                          complaint.fileUrl.trim().isEmpty
                              ? Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
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
                                        "image": complaint.fileUrl,
                                        "title": "Complaint Image",
                                      },
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: CachedNetworkImage(
                                      imageUrl: complaint.fileUrl,
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) {
                                        return const SizedBox(
                                          height: 100,
                                          width: 100,
                                          child: Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      },
                                      errorWidget: (context, url, error) {
                                        return Container(
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
                                        );
                                      },
                                    ),
                                  ),
                                ),

                          // ---------------------------------------------------
                          // STATUS HISTORY
                          // ---------------------------------------------------
                          if (complaintStatusHistory != null &&
                              complaintStatusHistory!.isNotEmpty) ...[
                            const SizedBox(height: 24),
                            const Text(
                              "Status History",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ComplaintStatusTimeline(
                              history: complaintStatusHistory!,
                            ),
                          ],
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

  Color _getComplaintStatusColor(String status) {
    switch (status.toUpperCase().trim()) {
      case "IN-PROGRESS":
      case "IN PROGRESS":
        return Colors.orange;

      case "COMPLETED":
        return Colors.green;

      case "REJECTED":
        return Colors.red;

      case "PENDING":
        return Colors.blue;

      default:
        return Colors.blue;
    }
  }

  Future<void> updateStatus(
    BuildContext context,
    ComplaintHistoryCubit cubit,
  ) async {
    await cubit.getComplaintStatuses();

    if (!context.mounted) {
      return;
    }

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return BlocBuilder<ComplaintHistoryCubit, ComplaintHistoryState>(
          bloc: cubit,
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
                    height: 350,
                    width: MediaQuery.of(context).size.width * 0.95,
                    child: SingleChildScrollView(
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(
                                top: 16.0,
                                bottom: 25,
                              ),
                              child: Text(
                                "Update Status",
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            // ----------------------------------------------
                            // STATUS DROPDOWN
                            // ----------------------------------------------
                            DropdownButtonFormField<String>(
                              value: selectedStatus,
                              isExpanded: true,
                              items: statusList.map((data) {
                                return DropdownMenuItem<String>(
                                  value: data.id,
                                  child: Text(
                                    data.name,
                                    overflow: TextOverflow.ellipsis,
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

                            const SizedBox(height: 12),

                            // ----------------------------------------------
                            // COMMENT
                            // ----------------------------------------------
                            TextFormField(
                              keyboardType: TextInputType.text,
                              controller: comment,
                              maxLines: 3,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(10),
                                labelText: 'Comment',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                prefixIcon: const Icon(
                                  Icons.text_fields,
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // ----------------------------------------------
                            // UPDATE BUTTON
                            // ----------------------------------------------
                            GestureDetector(
                              // onTap: () async {
                              //   if (formKey.currentState!.validate()) {
                              //     await cubit.updateComplaintStatus(
                              //       complaintId,
                              //       comment.text,
                              //       selectedStatus!,
                              //     );

                              //     if (!context.mounted) {
                              //       return;
                              //     }

                              //     image = null;
                              //     selectedStatus = null;
                              //     comment.clear();

                              //     Navigator.pop(context);
                              //   }
                              // },
                              child: LargeButton(
                                title: "Update",
                              ),
                            ),

                            // ----------------------------------------------
                            // CLOSE
                            // ----------------------------------------------
                            TextButton(
                              onPressed: () {
                                selectedStatus = null;
                                comment.clear();

                                Navigator.pop(context);
                              },
                              child: const Text("Close"),
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

// ============================================================================
// COMPLAINT STATUS TIMELINE
// ============================================================================

class ComplaintStatusTimeline extends StatelessWidget {
  final List<ComplaintStatusHistoryData> history;

  const ComplaintStatusTimeline({
    super.key,
    required this.history,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase().trim()) {
      case 'completed':
        return Colors.green;

      case 'in-progress':
      case 'in progress':
        return Colors.orange;

      case 'pending':
        return Colors.blue;

      case 'rejected':
      case 'cancelled':
      case 'canceled':
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: history.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final item = history[index];

        final statusColor = _getStatusColor(item.currentSts);

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -------------------------------------------------------------
              // LEFT: STAFF + DATE
              // -------------------------------------------------------------
              SizedBox(
                width: 85,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      item.staffName,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.createdAt,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // -------------------------------------------------------------
              // CENTER: DOT + LINE
              // -------------------------------------------------------------
              SizedBox(
                width: 18,
                child: Column(
                  children: [
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: statusColor,
                        border: Border.all(
                          color: statusColor.withOpacity(0.25),
                          width: 4,
                        ),
                      ),
                    ),
                    if (index != history.length - 1)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: Colors.grey.shade300,
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // -------------------------------------------------------------
              // RIGHT: STATUS + REMARK + IMAGE
              // -------------------------------------------------------------
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(
                    bottom: 24,
                  ),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: statusColor.withOpacity(0.20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status
                      Text(
                        item.currentSts,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      // Remark
                      Text(
                        item.remarks,
                        style: const TextStyle(
                          fontSize: 13,
                        ),
                      ),

                      // -----------------------------------------------------
                      // MEDIA IMAGE
                      // -----------------------------------------------------
                      if (item.mediaUrl != null &&
                          item.mediaUrl!.trim().isNotEmpty) ...[
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/imageViewer',
                              arguments: {
                                "image": item.mediaUrl!,
                                "title": "Complaint Image",
                              },
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: item.mediaUrl!,
                              width: double.infinity,
                              height: 150,
                              fit: BoxFit.cover,
                              placeholder: (context, url) {
                                return const SizedBox(
                                  height: 150,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              },
                              errorWidget: (context, url, error) {
                                return Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Image not available",
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
