// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/constants/routes.dart';
import 'package:site_720/data/models/work/work_model.dart';
import 'package:site_720/features/work/cubit/work_cubit.dart';
import 'package:site_720/features/work/cubit/work_state.dart';
import '../../../data/services/http_services.dart';

class WorkScreen extends StatelessWidget {
  const WorkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: BlocBuilder<WorkCubit, WorkState>(
        builder: (context, state) {
          /// LOADING
          if (state is WorkLoading) {
            return const _WorkSkeleton();
          }

          /// FAILURE
          if (state is WorkFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.wifi_off_rounded,
                      size: 48,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      state.error,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 16),

                    /// RETRY
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        context.read<WorkCubit>().getExternalWorkDetailsList();
                      },
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text("Retry"),
                    ),
                  ],
                ),
              ),
            );
          }

          /// SUCCESS
          if (state is WorkSuccess) {
            final cubit = context.read<WorkCubit>();
            final workList = state.filteredWorkList;

            return RefreshIndicator(
              onRefresh: () async {
                debugPrint('Refreshing work list...');

                await cubit.getExternalWorkDetailsList(
                  page: 1,
                  isLoadMore: false,
                );

                debugPrint(
                  'Refresh completed → currentPage: ${cubit.currentPage}, '
                  'total: ${cubit.workList.length}',
                );
              },
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollUpdateNotification &&
                      notification.metrics.pixels >=
                          notification.metrics.maxScrollExtent) {
                    debugPrint(
                      'Reached bottom → currentPage: ${cubit.currentPage}, '
                      'hasMoreWork: ${cubit.hasMoreWork}, '
                      'isLoadingMore: ${cubit.isLoadingMore}',
                    );

                    if (!cubit.isLoadingMore && cubit.hasMoreWork) {
                      final nextPage = cubit.currentPage + 1;

                      debugPrint('Loading work page: $nextPage');

                      cubit.getExternalWorkDetailsList(
                        page: nextPage,
                        isLoadMore: true,
                      );
                    }
                  }

                  return false;
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      /// HEADER (date filter is inside)
                      const _WorkHeader(),

                      const SizedBox(height: 20),

                      // ///Search
                      // const _WorkSearchField(),

                      // const SizedBox(height: 14),

                      /// STATUS FILTER (API)
                      /// STATUS FILTER (API)
                      SizedBox(
                        height: 80,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 22),
                          child: Row(
                            children: [
                              Expanded(
                                child: _buildFilterChip(context, "All", null,
                                    cubit.allCount, AppColors.primaryColor),
                              ),
                              Expanded(
                                child: _buildFilterChip(
                                    context,
                                    "Updated",
                                    "updated",
                                    cubit.updatedCount,
                                    Colors.green),
                              ),
                              Expanded(
                                child: _buildFilterChip(
                                    context,
                                    "Pending",
                                    "pending",
                                    cubit.pendingCount,
                                    Colors.orange),
                              ),
                              // Expanded(
                              //   child: _buildFilterChip(context, "Is Working", "Yes",
                              //       cubit.isWorkedCount, Colors.blue),
                              // ),
                              // Expanded(
                              //   child: _buildFilterChip(context, "Not Working", "No",
                              //       cubit.notWorkedCount, Colors.red),
                              // ),
                            ],
                          ),
                        ),
                      ),

                      // / WORKED / NOT WORKED (only when "Updated" is selected)
                      AnimatedSize(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                        child: cubit.selectedStatus == "updated"
                            ? Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(22, 10, 22, 0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        child: _buildSubTab(
                                            context,
                                            "Is Working",
                                            "Yes",
                                            Icons.engineering_outlined,
                                            Colors.green,
                                            cubit.isWorkedCount),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        child: _buildSubTab(
                                            context,
                                            "Not Working",
                                            "No",
                                            Icons.block_rounded,
                                            Colors.red,
                                            cubit.notWorkedCount),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox(width: double.infinity),
                      ),

                      const SizedBox(height: 14),

                      /// EMPTY STATE
                      if (workList.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Text(
                            "No work found",
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ),

                      /// WORK LIST
                      ListView.builder(
                        itemCount: workList.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        itemBuilder: (context, index) {
                          final item = workList[index];

                          return _WorkCard(
                            index: index,
                            item: item,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.workDetails,
                                arguments: {
                                  "id": item.projectId,
                                  "client_id": item.clientId,
                                },
                              ).then((updated) {
                                // reload only when details screen saved an update
                                if (updated == true && context.mounted) {
                                  context
                                      .read<WorkCubit>()
                                      .getExternalWorkDetailsList();
                                }
                              });
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  /// FILTER CHIP
  /// FILTER CHIP (count card style)
  /// FILTER CHIP (count card style)
  Widget _buildFilterChip(
    BuildContext context,
    String label,
    String? status,
    int count,
    Color color,
  ) {
    final cubit = context.read<WorkCubit>();
    final isSelected = cubit.selectedStatus == status;

    return Padding(
      // padding: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Center(
        child: GestureDetector(
          onTap: () {
            if (!isSelected) cubit.setStatusFilter(status);
          },
          child: AnimatedScale(
            // selected tile is slightly bigger
            scale: isSelected ? 1.10 : 1.0,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              width: double.infinity,
              height: 64,
              alignment: Alignment.center,
              // width: 72,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                // light tint of the SAME color, solid for both states
                color: Color.alphaBlend(
                  color.withValues(alpha: 0.14),
                  Colors.white,
                ),
                borderRadius: BorderRadius.circular(14),
                // full color border always; only thickness changes
                border: Border.all(
                  color: color,
                  width: isSelected ? 2.5 : 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: isSelected ? 0.40 : 0.25),
                    blurRadius: isSelected ? 14 : 6,
                    offset: Offset(0, isSelected ? 5 : 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 7),
                  TweenAnimationBuilder<int>(
                    tween: IntTween(begin: 0, end: count),
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, _) {
                      return Text(
                        '$value',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          height: 1,
                          color: color,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 4),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    height: 2.5,
                    width: isSelected ? 18 : 8,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// SUB TAB (Worked / Not Worked)
  Widget _buildSubTab(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
    int count,
  ) {
    final cubit = context.read<WorkCubit>();
    final isSelected = cubit.selectedWorked == value;

    return GestureDetector(
      onTap: () => cubit.setWorkedFilter(value),
      child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          width: 112, // smaller width
          height: 34, // smaller height
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color.withValues(alpha: isSelected ? 0.20 : 0.10),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? color : color.withValues(alpha: 0.30),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: isSelected ? 0.30 : 0.08),
                blurRadius: isSelected ? 10 : 4,
                offset: Offset(0, isSelected ? 3 : 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              const SizedBox(width: 6),

              /// COUNT BADGE
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TweenAnimationBuilder<int>(
                  tween: IntTween(begin: 0, end: count),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, _) => Text(
                    '$value',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  String _getMonth(int month) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];

    return months[month - 1];
  }

  /// ROW
  Widget buildRow(
    IconData icon,
    String text,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: Colors.grey,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(text),
        ),
      ],
    );
  }

  /// POPUP
  /// Pass the screen's BuildContext (replaces State.mounted / this.context)
  // void addWorkPopup(
  //   BuildContext screenContext,
  //   ExternalWorkItem item,
  // ) async {
  //   String? selectedStage;

  //   String workingStatus = "Yes";

  //   String? selectedWorkStatusId;

  //   final TextEditingController dateController = TextEditingController();

  //   final TextEditingController labourController = TextEditingController();

  //   final TextEditingController descriptionController = TextEditingController();

  //   List<dynamic> stageList = [];

  //   List<dynamic> workStatusList = [];

  //   /// GET STAGES API
  //   final stageResponse = await HttpServices.getStagesByprojectId(
  //     projectId: item.projectId,
  //   );

  //   if (stageResponse != null && stageResponse["status"] == true) {
  //     stageList = stageResponse["data"]["stages"] ?? [];
  //   }

  //   /// GET WORK STATUS API
  //   final workStatusResponse = await HttpServices.getWorkStatusID();

  //   if (workStatusResponse != null && workStatusResponse["status"] == true) {
  //     workStatusList = workStatusResponse["data"] ?? [];
  //   }

  //   if (!screenContext.mounted) return;

  //   showDialog(
  //     context: screenContext,
  //     builder: (dialogContext) {
  //       return StatefulBuilder(
  //         builder: (context, setState) {
  //           return AlertDialog(
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(18),
  //             ),
  //             title: Text(
  //               item.projectName,
  //               style: const TextStyle(
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //             content: SingleChildScrollView(
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   /// WORKING STATUS
  //                   const Text(
  //                     "Are You Sure Today is Working?",
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.w600,
  //                     ),
  //                   ),

  //                   Row(
  //                     children: [
  //                       Radio<String>(
  //                         value: "Yes",
  //                         groupValue: workingStatus,
  //                         activeColor: AppColors.primaryColor,
  //                         onChanged: (value) {
  //                           setState(() {
  //                             workingStatus = value!;

  //                             /// RESET
  //                             selectedWorkStatusId = null;
  //                             labourController.clear();
  //                           });
  //                         },
  //                       ),
  //                       const Text("Yes"),
  //                       Radio<String>(
  //                         value: "No",
  //                         groupValue: workingStatus,
  //                         activeColor: AppColors.primaryColor,
  //                         onChanged: (value) {
  //                           setState(() {
  //                             workingStatus = value!;

  //                             /// RESET
  //                             selectedWorkStatusId = null;
  //                             labourController.clear();
  //                           });
  //                         },
  //                       ),
  //                       const Text("No"),
  //                     ],
  //                   ),

  //                   const SizedBox(height: 10),

  //                   /// STAGE DROPDOWN
  //                   DropdownButtonFormField<String>(
  //                     value: selectedStage,
  //                     decoration: InputDecoration(
  //                       labelText: "Stage *",
  //                       border: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(12),
  //                       ),
  //                     ),
  //                     items: stageList.map((e) {
  //                       return DropdownMenuItem<String>(
  //                         value: e["stage_id"].toString(),
  //                         child: Text(
  //                           e["stage_name"].toString(),
  //                         ),
  //                       );
  //                     }).toList(),
  //                     onChanged: (value) {
  //                       setState(() {
  //                         selectedStage = value;
  //                       });
  //                     },
  //                   ),

  //                   const SizedBox(height: 14),

  //                   /// DATE
  //                   TextFormField(
  //                     controller: dateController,
  //                     readOnly: true,
  //                     decoration: InputDecoration(
  //                       labelText: "Date *",
  //                       hintText: "dd-mm-yyyy",
  //                       suffixIcon: const Icon(
  //                         Icons.calendar_month,
  //                       ),
  //                       border: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(12),
  //                       ),
  //                     ),
  //                     onTap: () async {
  //                       DateTime? pickedDate = await showDatePicker(
  //                         context: context,
  //                         initialDate: DateTime.now(),
  //                         firstDate: DateTime(2020),
  //                         lastDate: DateTime(2100),
  //                       );

  //                       if (pickedDate != null) {
  //                         String formattedDate =
  //                             "${pickedDate.day.toString().padLeft(2, '0')}-"
  //                             "${pickedDate.month.toString().padLeft(2, '0')}-"
  //                             "${pickedDate.year}";

  //                         dateController.text = formattedDate;
  //                       }
  //                     },
  //                   ),

  //                   const SizedBox(height: 14),

  //                   /// IF YES SHOW LABOUR FIELD
  //                   if (workingStatus == "Yes")
  //                     TextFormField(
  //                       controller: labourController,
  //                       keyboardType: TextInputType.number,
  //                       decoration: InputDecoration(
  //                         labelText: "No of Labours *",
  //                         border: OutlineInputBorder(
  //                           borderRadius: BorderRadius.circular(12),
  //                         ),
  //                       ),
  //                     ),

  //                   /// IF NO SHOW WORK STATUS
  //                   if (workingStatus == "No")
  //                     DropdownButtonFormField<String>(
  //                       value: selectedWorkStatusId,
  //                       decoration: InputDecoration(
  //                         labelText: "Work Status *",
  //                         border: OutlineInputBorder(
  //                           borderRadius: BorderRadius.circular(12),
  //                         ),
  //                       ),
  //                       items: workStatusList.map((e) {
  //                         return DropdownMenuItem<String>(
  //                           value: e["id"].toString(),
  //                           child: Text(
  //                             e["work_status"].toString(),
  //                           ),
  //                         );
  //                       }).toList(),
  //                       onChanged: (value) {
  //                         setState(() {
  //                           selectedWorkStatusId = value;
  //                         });
  //                       },
  //                     ),

  //                   const SizedBox(height: 14),

  //                   /// DESCRIPTION
  //                   TextFormField(
  //                     controller: descriptionController,
  //                     maxLines: 4,
  //                     decoration: InputDecoration(
  //                       labelText: "Description",
  //                       alignLabelWithHint: true,
  //                       border: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(12),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             actions: [
  //               /// CANCEL
  //               TextButton(
  //                 onPressed: () {
  //                   Navigator.pop(dialogContext);
  //                 },
  //                 child: const Text("Cancel"),
  //               ),

  //               /// SUBMIT
  //               ElevatedButton(
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: AppColors.primaryColor,
  //                 ),
  //                 onPressed: () async {
  //                   /// VALIDATION
  //                   if (selectedStage == null) {
  //                     ScaffoldMessenger.of(context).showSnackBar(
  //                       const SnackBar(
  //                         content: Text("Please Select Stage"),
  //                       ),
  //                     );

  //                     return;
  //                   }

  //                   if (dateController.text.isEmpty) {
  //                     ScaffoldMessenger.of(context).showSnackBar(
  //                       const SnackBar(
  //                         content: Text("Please Select Date"),
  //                       ),
  //                     );

  //                     return;
  //                   }

  //                   /// YES VALIDATION
  //                   if (workingStatus == "Yes" &&
  //                       labourController.text.isEmpty) {
  //                     ScaffoldMessenger.of(context).showSnackBar(
  //                       const SnackBar(
  //                         content: Text("Please Enter Labour Count"),
  //                       ),
  //                     );

  //                     return;
  //                   }

  //                   /// NO VALIDATION
  //                   if (workingStatus == "No" && selectedWorkStatusId == null) {
  //                     ScaffoldMessenger.of(context).showSnackBar(
  //                       const SnackBar(
  //                         content: Text("Please Select Work Status"),
  //                       ),
  //                     );

  //                     return;
  //                   }

  //                   /// API CALL
  //                   final updateResponse =
  //                       await HttpServices.updateExternalWork(
  //                     stageId: selectedStage!,
  //                     projectId: item.projectId,
  //                     clientId: item.clientId,

  //                     /// YES / NO
  //                     workStatus: workingStatus,

  //                     workDate: dateController.text,

  //                     /// YES
  //                     labourCount:
  //                         workingStatus == "Yes" ? labourController.text : "0",

  //                     /// NO
  //                     workStatusId:
  //                         workingStatus == "No" ? selectedWorkStatusId! : "0",

  //                     description: descriptionController.text,
  //                   );

  //                   /// SUCCESS
  //                   if (updateResponse != null &&
  //                       updateResponse["status"] == true) {
  //                     /// CLOSE POPUP
  //                     Navigator.pop(dialogContext);

  //                     /// RELOAD LIST
  //                     if (screenContext.mounted) {
  //                       BlocProvider.of<WorkCubit>(
  //                         screenContext,
  //                       ).getExternalWorkDetailsList();
  //                     }

  //                     /// SUCCESS MESSAGE
  //                     Future.delayed(
  //                       const Duration(milliseconds: 300),
  //                       () {
  //                         if (screenContext.mounted) {
  //                           ScaffoldMessenger.of(screenContext).showSnackBar(
  //                             SnackBar(
  //                               backgroundColor: Colors.green,
  //                               content: Text(
  //                                 updateResponse["message"] ??
  //                                     "Work Updated Successfully",
  //                               ),
  //                             ),
  //                           );
  //                         }
  //                       },
  //                     );
  //                   } else {
  //                     ScaffoldMessenger.of(context).showSnackBar(
  //                       SnackBar(
  //                         backgroundColor: Colors.red,
  //                         content: Text(
  //                           updateResponse?["message"] ??
  //                               "Something went wrong",
  //                         ),
  //                       ),
  //                     );
  //                   }
  //                 },
  //                 child: const Text(
  //                   "Submit",
  //                   style: TextStyle(color: Colors.white),
  //                 ),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  Widget _buildInfoRow(
    IconData icon,
    String title,
    String value, {
    int maxLines = 1,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: AppColors.primaryColor,
        ),
        const SizedBox(width: 8),
        Text(
          "$title: ",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

//Date filter tile (shown in the header)
class _DateFilterTile extends StatelessWidget {
  const _DateFilterTile();

  String _format(DateTime d) {
    return "${d.day.toString().padLeft(2, '0')}-"
        "${d.month.toString().padLeft(2, '0')}-"
        "${d.year}";
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<WorkCubit>();
    final selectedDate = cubit.selectedDate;
    final hasDate = selectedDate != null;

    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
        );

        if (picked != null) cubit.setDateFilter(picked);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: hasDate ? 0.28 : 0.18),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.white.withValues(alpha: hasDate ? 0.9 : 0.4),
            width: hasDate ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.calendar_month_rounded,
              size: 18,
              color: Colors.white,
            ),

            /// DATE TEXT (only when a date is selected)
            if (hasDate) ...[
              const SizedBox(width: 6),
              Text(
                _format(selectedDate),
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 6),

              /// CLEAR
              GestureDetector(
                onTap: () => cubit.setDateFilter(null),
                child: const Icon(
                  Icons.close_rounded,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

//Skelton loading
class _WorkSkeleton extends StatefulWidget {
  const _WorkSkeleton();

  @override
  State<_WorkSkeleton> createState() => _WorkSkeletonState();
}

class _WorkSkeletonState extends State<_WorkSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  late final Animation<double> _pulse =
      Tween<double>(begin: 0.4, end: 1.0).animate(
    CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _bone({double? width, double height = 14, double radius = 8}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  Widget _skeletonCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: FadeTransition(
        opacity: _pulse,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: _bone(height: 18)),
                const SizedBox(width: 40),
                _bone(width: 70, height: 20, radius: 20),
              ],
            ),
            const SizedBox(height: 16),
            _bone(height: 50, radius: 12),
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerRight,
              child: _bone(width: 90, height: 14),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// HEADER (same size as the real one, date hidden while loading)
        const _WorkHeader(showDate: false),

        const SizedBox(height: 20),

        /// SEARCH PLACEHOLDER
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: FadeTransition(
            opacity: _pulse,
            child: _bone(height: 48, radius: 16),
          ),
        ),

        const SizedBox(height: 28),

        /// CARD PLACEHOLDERS
        Expanded(
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 4,
            itemBuilder: (_, __) => _skeletonCard(),
          ),
        ),
      ],
    );
  }
}

//header widget
//Shared header
//header widget
//Shared header
class _WorkHeader extends StatelessWidget {
  final bool showDate;
  final bool showSearch;

  const _WorkHeader({this.showDate = true, this.showSearch = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primaryColor,
        image: DecorationImage(
          image: AssetImage("assets/images/appbar.png"),
          fit: BoxFit.fill,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Work Dashboard",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  /// DATE FILTER
                  if (showDate) const _DateFilterTile(),
                ],
              ),

              const SizedBox(height: 18),

              /// SEARCH (placeholder while loading)
              if (showSearch)
                const _WorkSearchField()
              else
                Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

//Search widget
class _WorkSearchField extends StatefulWidget {
  const _WorkSearchField();

  @override
  State<_WorkSearchField> createState() => _WorkSearchFieldState();
}

class _WorkSearchFieldState extends State<_WorkSearchField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: context.read<WorkCubit>().searchQuery,
    );
    _focusNode = FocusNode()..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFocused = _focusNode.hasFocus;
    const primaryColor = AppColors.primaryColor;

    return Padding(
      // bigger side padding = narrower search box (was 22)
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        height: 44,
        decoration: BoxDecoration(
          // pale tint of the primary color on white (same as the tiles)
          color: Color.alphaBlend(
            primaryColor.withValues(alpha: 0.06),
            Colors.white,
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color:
                isFocused ? primaryColor : primaryColor.withValues(alpha: 0.30),
            width: isFocused ? 1.8 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withValues(alpha: isFocused ? 0.28 : 0.12),
              blurRadius: isFocused ? 14 : 8,
              offset: Offset(0, isFocused ? 5 : 3),
            ),
          ],
        ),
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          textInputAction: TextInputAction.search,
          cursorColor: primaryColor,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
          decoration: InputDecoration(
            isDense: true,
            hintText: "Search projects",
            hintStyle: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),

            /// ICON BADGE
            prefixIcon: Padding(
              padding: const EdgeInsets.all(7),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                width: 30,
                decoration: BoxDecoration(
                  color: isFocused
                      ? primaryColor
                      : primaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.search_rounded,
                  size: 18,
                  color: isFocused ? Colors.white : primaryColor,
                ),
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 44,
              minHeight: 44,
            ),

            /// CLEAR BUTTON
            suffixIcon: ValueListenableBuilder<TextEditingValue>(
              valueListenable: _controller,
              builder: (context, value, _) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: FadeTransition(opacity: animation, child: child),
                    );
                  },
                  child: value.text.isEmpty
                      ? const SizedBox.shrink(key: ValueKey('empty'))
                      : IconButton(
                          key: const ValueKey('clear'),
                          splashRadius: 18,
                          icon: Icon(
                            Icons.close_rounded,
                            color: primaryColor.withValues(alpha: 0.8),
                            size: 19,
                          ),
                          onPressed: () {
                            _controller.clear();
                            context.read<WorkCubit>().searchProjects('');
                          },
                        ),
                );
              },
            ),
          ),
          onChanged: (value) {
            context.read<WorkCubit>().searchProjects(value);
          },
        ),
      ),
    );
  }
}

//Work Card widget
class _WorkCard extends StatelessWidget {
  final int index;
  final ExternalWorkItem item;
  final VoidCallback onTap;

  const _WorkCard({
    required this.index,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isPending = item.updateStatus.toLowerCase().trim() == "pending";
    final statusColor = isPending ? Colors.orange : Colors.green;

    final w = item.isWorking.toLowerCase().trim();
    final isWorking = w == "yes" || w == "1" || w == "true";

    final card = Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: statusColor.withValues(alpha: 0.10),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Material(
          color: Colors.white,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TOP: NAME + STATUS (same row)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          item.projectName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16.5,
                            fontWeight: FontWeight.bold,
                            height: 1.25,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isPending
                                  ? Icons.schedule_rounded
                                  : Icons.check_circle_rounded,
                              size: 12,
                              color: statusColor,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              item.updateStatus,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500, // lighter weight
                                color: statusColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  if (isPending)

                    /// PENDING MESSAGE
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.orange.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.info_outline_rounded,
                            size: 18,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Today's update is pending. Open this project "
                              "to add working status, labours and description.",
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.4,
                                color: Colors.orange.shade900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else ...[
                    /// CHIPS: WORKING + LABOURS
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _chip(
                          Icons.engineering_outlined,
                          "Working: ${item.isWorking}",
                          isWorking ? Colors.green : Colors.red,
                        ),
                        isWorking
                            ? _chip(
                                Icons.groups_2_outlined,
                                "${item.laboursNo} Labours",
                                AppColors.primaryColor,
                              )
                            : _chip(
                                Icons.report_problem,
                                "${item.workStatus} ",
                                Colors.red,
                              ),
                      ],
                    ),

                    /// DESCRIPTION (only if present)
                    if (item.description.trim().isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(
                        item.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13.5,
                          height: 1.4,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ],

                  const SizedBox(height: 10),
                  Divider(height: 1, color: Colors.grey.shade200),
                  const SizedBox(height: 8),

                  /// FOOTER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        isPending ? "Open to update" : "View details",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isPending
                              ? Colors.orange.shade800
                              : AppColors.primaryColor,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 20,
                        color: isPending
                            ? Colors.orange.shade800
                            : AppColors.primaryColor,
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
    // small stagger, capped so later pages don't wait long
    final delay = (index > 5 ? 5 : index) * 60;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 350 + delay),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 18),
            child: child,
          ),
        );
      },
      child: card,
    );
  }

  Widget _chip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
