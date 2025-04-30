// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/widgets/appbar.dart';
import '../../../core/constants/routes.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/connectivity_dialog.dart';
import '../../../core/widgets/shimmer.dart';
import '../../../core/widgets/snack_bar.dart';
import '../../../data/models/visit/visit_list_model.dart';
import '../../connectivity/cubit/connectivity_cubit.dart';
import '../../connectivity/cubit/connectivity_state.dart';
import '../../payment_details/widgets/amount_container.dart';
import '../cubit/visit_cubit.dart';
import '../cubit/visit_state.dart';

class VisitList extends StatelessWidget {
  VisitList({super.key});

  final formKey = GlobalKey<FormState>();
  XFile? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: simpleAppbar(context, "Site Visit", false),
      body: BlocProvider(
        create: (context) => VisitCubit()..getVisitDetails(),
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
             BlocListener<VisitCubit, VisitState>(
                listener: (context, state) {
                  if (state is ImageSuccess) {
                    image = state.image;
                  } else if (state is AttendanceUpdated) {
                    snackBar(context, state.response.message, Colors.green);
                      context.read<VisitCubit>().getVisitDetails();
                  } else if (state is AttendanceFailed) {
                    snackBar(context, state.message, Colors.red);
                  }
                },
              )
          ],
          child: BlocBuilder<VisitCubit, VisitState>(
            builder: (context, state) {
              final cubit = context.read<VisitCubit>();

              if (state is VisitLoading) {
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
              }

              if (state is VisitDetailsSuccess &&
                  state.response.data.availableStatus.isNotEmpty) {
                final vistList = state.response.data.availableStatus;

                return RefreshIndicator(
                  onRefresh: () async {
                    cubit.getVisitDetails();
                  },
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    itemCount: vistList.length,
                    itemBuilder: (context, index) {
                      final item = vistList[index];
                      return Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: InkWell(
                          onTap: () {
                            connStatus = true;
                            Navigator.pushNamed(
                              context,
                              AppRoutes.vistDetails,
                              arguments: {"visit_id": item.id},
                            );
                          },
                          child: buildVisitCard(context, cubit, item),
                        ),
                      );
                    },
                  ),
                );
              }

              return const Center(child: Text("Visit is Empty"));
            },
          ),
        ),
      ),
    );
  }

  Widget buildVisitCard(
      BuildContext context, VisitCubit cubit, AvailableStatus item) {
    return Container(
      width: MediaQuery.of(context).size.width * .9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: item.status == "Not-Started"
            ? const Color.fromARGB(255, 241, 237, 237)
            : item.status == "Progress"
                ? const Color.fromARGB(255, 228, 145, 11)
                : item.status == "Completed"
                    ? const Color.fromARGB(255, 25, 219, 41)
                    : Colors.grey.shade50,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
            blurRadius: 3,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.taskTitle,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      item.projectName,
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () =>
                          attendanceDialog(context, cubit, item.visitId),
                      child: iconButton(Icons.person_add),
                    ),
                    const SizedBox(width: 7),
                    InkWell(
                      onTap: () {
                        connStatus = true;
                        Navigator.pushNamed(context, AppRoutes.visitHistory,
                            arguments: {"visit_id": item.id});
                      },
                      child: iconButton(Icons.history),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AmountContainer(
                  title: "From Date",
                  amount: DateFormat('dd-MM-yyyy')
                      .format(item.fromDate), // Formatting date
                  valueColor: AppColors.primaryColor,
                ),
                AmountContainer(
                  title: "To Date",
                  amount: DateFormat('dd-MM-yyyy')
                      .format(item.toDate), // Formatting date
                  valueColor: AppColors.primaryColor,
                ),
                AmountContainer(
                  title: "Status",
                  amount: item.status ?? "Unknown",
                  valueColor: item.status == "Not-Started"
                      ? Colors.blue
                      : item.status == "Progress"
                          ? Colors.orange
                          : item.status == "Completed"
                              ? const Color.fromARGB(255, 10, 233, 103)
                              : Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget iconButton(IconData icon) {
    return Container(
      height: 25,
      width: 25,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColors.primaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
            blurRadius: 6,
            offset: const Offset(1, 1),
          ),
        ],
      ),
      child: Icon(icon, size: 16, color: Colors.white),
    );
  }

  Future<void> attendanceDialog(
    BuildContext context,
    VisitCubit cubit,
    String taskId,
  ) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return BlocProvider.value(
          value: cubit,
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
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              await cubit.selectImage(ImageSource.camera);
                              setState(
                                  () {}); // This should rebuild the widget with the new image
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
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: () async {
                              if (image != null) {
                                Navigator.pop(context);
                                cubit.addAttendance(
                                    context, taskId, image!.path);
                                image = null; // Reset the image after uploading
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
