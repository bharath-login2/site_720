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
              child: Text(
                state.error,
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
                      /// HEADER
                      const _WorkHeader(),

                      const SizedBox(height: 20),

                      ///Search
                      const _WorkSearchField(),

                      const SizedBox(height: 14),

                      /// STATUS FILTER (API)
                      SizedBox(
                        height: 40,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 22),
                          children: [
                            _buildFilterChip(context, "All", null),
                            _buildFilterChip(context, "Pending", "pending"),
                            _buildFilterChip(context, "Updated", "updated"),
                          ],
                        ),
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
                              ).then((_) {
                                if (context.mounted) {
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
  Widget _buildFilterChip(
    BuildContext context,
    String label,
    String? status,
  ) {
    final cubit = context.read<WorkCubit>();
    final isSelected = cubit.selectedStatus == status;

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: AppColors.primaryColor,
        backgroundColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w600,
        ),
        showCheckmark: false,
        onSelected: (_) {
          if (!isSelected) {
            cubit.setStatusFilter(status);
          }
        },
      ),
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
  void addWorkPopup(
    BuildContext screenContext,
    ExternalWorkItem item,
  ) async {
    String? selectedStage;

    String workingStatus = "Yes";

    String? selectedWorkStatusId;

    final TextEditingController dateController = TextEditingController();

    final TextEditingController labourController = TextEditingController();

    final TextEditingController descriptionController = TextEditingController();

    List<dynamic> stageList = [];

    List<dynamic> workStatusList = [];

    /// GET STAGES API
    final stageResponse = await HttpServices.getStagesByprojectId(
      projectId: item.projectId,
    );

    if (stageResponse != null && stageResponse["status"] == true) {
      stageList = stageResponse["data"]["stages"] ?? [];
    }

    /// GET WORK STATUS API
    final workStatusResponse = await HttpServices.getWorkStatusID();

    if (workStatusResponse != null && workStatusResponse["status"] == true) {
      workStatusList = workStatusResponse["data"] ?? [];
    }

    if (!screenContext.mounted) return;

    showDialog(
      context: screenContext,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              title: Text(
                item.projectName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// WORKING STATUS
                    const Text(
                      "Are You Sure Today is Working?",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    Row(
                      children: [
                        Radio<String>(
                          value: "Yes",
                          groupValue: workingStatus,
                          activeColor: AppColors.primaryColor,
                          onChanged: (value) {
                            setState(() {
                              workingStatus = value!;

                              /// RESET
                              selectedWorkStatusId = null;
                              labourController.clear();
                            });
                          },
                        ),
                        const Text("Yes"),
                        Radio<String>(
                          value: "No",
                          groupValue: workingStatus,
                          activeColor: AppColors.primaryColor,
                          onChanged: (value) {
                            setState(() {
                              workingStatus = value!;

                              /// RESET
                              selectedWorkStatusId = null;
                              labourController.clear();
                            });
                          },
                        ),
                        const Text("No"),
                      ],
                    ),

                    const SizedBox(height: 10),

                    /// STAGE DROPDOWN
                    DropdownButtonFormField<String>(
                      value: selectedStage,
                      decoration: InputDecoration(
                        labelText: "Stage *",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: stageList.map((e) {
                        return DropdownMenuItem<String>(
                          value: e["stage_id"].toString(),
                          child: Text(
                            e["stage_name"].toString(),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedStage = value;
                        });
                      },
                    ),

                    const SizedBox(height: 14),

                    /// DATE
                    TextFormField(
                      controller: dateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Date *",
                        hintText: "dd-mm-yyyy",
                        suffixIcon: const Icon(
                          Icons.calendar_month,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );

                        if (pickedDate != null) {
                          String formattedDate =
                              "${pickedDate.day.toString().padLeft(2, '0')}-"
                              "${pickedDate.month.toString().padLeft(2, '0')}-"
                              "${pickedDate.year}";

                          dateController.text = formattedDate;
                        }
                      },
                    ),

                    const SizedBox(height: 14),

                    /// IF YES SHOW LABOUR FIELD
                    if (workingStatus == "Yes")
                      TextFormField(
                        controller: labourController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "No of Labours *",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                    /// IF NO SHOW WORK STATUS
                    if (workingStatus == "No")
                      DropdownButtonFormField<String>(
                        value: selectedWorkStatusId,
                        decoration: InputDecoration(
                          labelText: "Work Status *",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: workStatusList.map((e) {
                          return DropdownMenuItem<String>(
                            value: e["id"].toString(),
                            child: Text(
                              e["work_status"].toString(),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedWorkStatusId = value;
                          });
                        },
                      ),

                    const SizedBox(height: 14),

                    /// DESCRIPTION
                    TextFormField(
                      controller: descriptionController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: "Description",
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                /// CANCEL
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text("Cancel"),
                ),

                /// SUBMIT
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                  ),
                  onPressed: () async {
                    /// VALIDATION
                    if (selectedStage == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please Select Stage"),
                        ),
                      );

                      return;
                    }

                    if (dateController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please Select Date"),
                        ),
                      );

                      return;
                    }

                    /// YES VALIDATION
                    if (workingStatus == "Yes" &&
                        labourController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please Enter Labour Count"),
                        ),
                      );

                      return;
                    }

                    /// NO VALIDATION
                    if (workingStatus == "No" && selectedWorkStatusId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please Select Work Status"),
                        ),
                      );

                      return;
                    }

                    /// API CALL
                    final updateResponse =
                        await HttpServices.updateExternalWork(
                      stageId: selectedStage!,
                      projectId: item.projectId,
                      clientId: item.clientId,

                      /// YES / NO
                      workStatus: workingStatus,

                      workDate: dateController.text,

                      /// YES
                      labourCount:
                          workingStatus == "Yes" ? labourController.text : "0",

                      /// NO
                      workStatusId:
                          workingStatus == "No" ? selectedWorkStatusId! : "0",

                      description: descriptionController.text,
                    );

                    /// SUCCESS
                    if (updateResponse != null &&
                        updateResponse["status"] == true) {
                      /// CLOSE POPUP
                      Navigator.pop(dialogContext);

                      /// RELOAD LIST
                      if (screenContext.mounted) {
                        BlocProvider.of<WorkCubit>(
                          screenContext,
                        ).getExternalWorkDetailsList();
                      }

                      /// SUCCESS MESSAGE
                      Future.delayed(
                        const Duration(milliseconds: 300),
                        () {
                          if (screenContext.mounted) {
                            ScaffoldMessenger.of(screenContext).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.green,
                                content: Text(
                                  updateResponse["message"] ??
                                      "Work Updated Successfully",
                                ),
                              ),
                            );
                          }
                        },
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                            updateResponse?["message"] ??
                                "Something went wrong",
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

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
        /// HEADER (same size as the real one)
        const _WorkHeader(),

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
class _WorkHeader extends StatelessWidget {
  const _WorkHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .20,
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
      child: const SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Work Dashboard",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Icon(
                Icons.work,
                color: Colors.white,
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
    final primaryColor = Theme.of(context).primaryColor;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: AppColors.search,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isFocused
                ? primaryColor.withOpacity(0.6)
                : Colors.grey.withOpacity(0.2),
            width: isFocused ? 1.5 : 1,
          ),
          boxShadow: isFocused
              ? [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          textInputAction: TextInputAction.search,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            // Floating Label behavior
            labelText: "Search projects",
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            labelStyle: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 15,
            ),
            floatingLabelStyle: TextStyle(
              color: primaryColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),

            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 12),

            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 12, right: 8),
              child: Icon(
                Icons.search_rounded,
                color: isFocused ? primaryColor : Colors.grey.shade600,
                size: 22,
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
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
                          icon: Icon(
                            Icons.close_rounded,
                            color: Colors.grey.shade600,
                            size: 20,
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
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  /// STATUS STRIPE
                  Container(width: 5, color: statusColor),

                  Expanded(
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
                                        fontWeight:
                                            FontWeight.w500, // lighter weight
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
                                      "Work update is pending. Please add the working status, "
                                      "number of labours and description.",
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
                                isPending ? "Update now" : "View details",
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
