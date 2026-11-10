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
import '../../../core/widgets/snack_bar.dart';
import '../../../data/models/visit/visit_list_model.dart';
import '../../connectivity/cubit/connectivity_cubit.dart';
import '../../connectivity/cubit/connectivity_state.dart';
import '../cubit/visit_cubit.dart';
import '../cubit/visit_state.dart';

class VisitList extends StatelessWidget {
  VisitList({super.key});

  final formKey = GlobalKey<FormState>();
  XFile? image;

  final ValueNotifier<String> selectedFilter = ValueNotifier<String>("All");
  final ValueNotifier<String> selectedStatusId = ValueNotifier<String>("");
  final ValueNotifier<DateTime?> fromDate = ValueNotifier<DateTime?>(null);
  final ValueNotifier<DateTime?> toDate = ValueNotifier<DateTime?>(null);

  final DateFormat _dateFmt = DateFormat('dd-MM-yyyy');

  /// Single place that loads the list with the current status + date filters.
  void _load(VisitCubit cubit) {
    cubit.getVisitDetails(
      statusId: selectedStatusId.value.isEmpty ? null : selectedStatusId.value,
      fromDate: fromDate.value,
      toDate: toDate.value,
    );
  }

  /// Keeps visits whose date range overlaps the selected range.
  /// Works even if the backend ignores the date parameters.
  List<VisitItem> _applyDateFilter(List<VisitItem> all) {
    final from = fromDate.value;
    final to = toDate.value;
    return all.where((v) {
      if (from != null && v.toDate != null && v.toDate!.isBefore(from)) {
        return false;
      }
      if (to != null && v.fromDate != null && v.fromDate!.isAfter(to)) {
        return false;
      }
      return true;
    }).toList();
  }

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
                  _load(context.read<VisitCubit>());
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
                return Column(
                  children: [
                    buildFilterSection(context, cubit, cubit.statusList),
                    Expanded(
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(14, 12, 14, 16),
                        itemCount: 4,
                        itemBuilder: (context, index) => const Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: VisitCardSkeleton(),
                        ),
                      ),
                    ),
                  ],
                );
              }

              if (state is VisitDetailsSuccess) {
                final List<VisitItem> visitList =
                    _applyDateFilter(state.response.data);
                final statuses = state.statuses.isNotEmpty
                    ? state.statuses
                    : cubit.statusList;

                return Column(
                  children: [
                    buildFilterSection(context, cubit, statuses),
                    Expanded(
                      child: visitList.isEmpty
                          ? _emptyView()
                          : RefreshIndicator(
                              onRefresh: () async => _load(cubit),
                              child: ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding:
                                    const EdgeInsets.fromLTRB(14, 12, 14, 16),
                                itemCount: visitList.length,
                                itemBuilder: (context, index) {
                                  final item = visitList[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: buildVisitCard(context, cubit, item),
                                  );
                                },
                              ),
                            ),
                    ),
                  ],
                );
              }

              if (state is VisitDetailsFailure) {
                return Column(
                  children: [
                    buildFilterSection(context, cubit, cubit.statusList),
                    Expanded(child: _emptyView()),
                  ],
                );
              }

              return _emptyView();
            },
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // EMPTY VIEW
  // ---------------------------------------------------------------------------
  Widget _emptyView() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 120),
        Icon(Icons.event_busy, size: 56, color: Colors.grey.shade400),
        const SizedBox(height: 12),
        Center(
          child: Text(
            "No visits found",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // STATUS / PRIORITY HELPERS
  // ---------------------------------------------------------------------------
  Color _statusColor(String? status) {
    switch (status) {
      case "Not-Started":
        return Colors.blue;
      case "Pending":
        return Colors.amber.shade800;
      case "Progress":
      case "Inprogress":
        return Colors.orange;
      case "Completed":
        return const Color.fromARGB(255, 10, 180, 90);
      default:
        return Colors.grey;
    }
  }

  Color _priorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case "high":
        return Colors.red;
      case "medium":
        return Colors.orange;
      case "low":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // ---------------------------------------------------------------------------
  // FILTER SECTION (status chips + date range)
  // ---------------------------------------------------------------------------
  Widget buildFilterSection(
      BuildContext context, VisitCubit cubit, List<StatusModel> statuses) {
    final filters = [
      StatusModel(id: "", status: "All"),
      ...statuses,
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 10, bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------- status chips ----------
          SizedBox(
            height: 36,
            child: ValueListenableBuilder<String>(
              valueListenable: selectedFilter,
              builder: (context, selected, _) {
                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  itemCount: filters.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final item = filters[index];
                    final isSelected = selected == item.status;
                    return InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        if (isSelected) return;
                        selectedFilter.value = item.status;
                        selectedStatusId.value = item.id;
                        _load(cubit);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryColor
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primaryColor
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Text(
                          item.status,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // ---------- date range ----------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: ValueListenableBuilder<DateTime?>(
              valueListenable: fromDate,
              builder: (context, from, _) {
                return ValueListenableBuilder<DateTime?>(
                  valueListenable: toDate,
                  builder: (context, to, _) {
                    final hasFilter = from != null || to != null;
                    return Row(
                      children: [
                        Expanded(
                          child: _dateField(
                            label: "From Date",
                            value: from,
                            onTap: () =>
                                _pickDate(context, cubit, isFrom: true),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _dateField(
                            label: "To Date",
                            value: to,
                            onTap: () =>
                                _pickDate(context, cubit, isFrom: false),
                          ),
                        ),
                        if (hasFilter) ...[
                          const SizedBox(width: 8),
                          InkWell(
                            borderRadius: BorderRadius.circular(22),
                            onTap: () {
                              fromDate.value = null;
                              toDate.value = null;
                              _load(cubit);
                            },
                            child: Container(
                              height: 44,
                              width: 44,
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close,
                                  size: 20, color: Colors.red),
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateField({
    required String label,
    required DateTime? value,
    required VoidCallback onTap,
  }) {
    final hasValue = value != null;
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: hasValue ? AppColors.primaryColor : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_month_outlined,
              size: 18,
              color: hasValue ? AppColors.primaryColor : Colors.grey,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 9,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    hasValue ? _dateFmt.format(value) : "Select",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: hasValue ? Colors.black87 : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Opens a separate calendar for From or To, so each one is chosen on its own.
  Future<void> _pickDate(
    BuildContext context,
    VisitCubit cubit, {
    required bool isFrom,
  }) async {
    final from = fromDate.value;
    final to = toDate.value;

    // To Date calendar can't go before From Date
    final firstDate = isFrom ? DateTime(2020) : (from ?? DateTime(2020));
    final initial =
        isFrom ? (from ?? DateTime.now()) : (to ?? from ?? DateTime.now());

    final picked = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(firstDate) ? firstDate : initial,
      firstDate: firstDate,
      lastDate: DateTime(2100),
      helpText: isFrom ? "Select From Date" : "Select To Date",
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(primary: AppColors.primaryColor),
        ),
        child: child!,
      ),
    );

    if (picked == null) return;

    if (isFrom) {
      fromDate.value = picked;
      // if the old To Date is now before From Date, clear it
      if (to != null && to.isBefore(picked)) {
        toDate.value = null;
      }
    } else {
      toDate.value = picked;
    }

    _load(cubit);
  }

  // ---------------------------------------------------------------------------
  // VISIT CARD (uniform height)
  // ---------------------------------------------------------------------------
  Widget buildVisitCard(
      BuildContext context, VisitCubit cubit, VisitItem item) {
    final color = _statusColor(item.status);
    final priorityColor = _priorityColor(item.priority);

    String fmt(DateTime? d) => d == null ? "-" : _dateFmt.format(d);
    final hasRemarks = item.description.trim().isNotEmpty;

    return Container(
      width: MediaQuery.of(context).size.width * .9,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
            blurRadius: 3,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              connStatus = true;
              Navigator.pushNamed(
                context,
                AppRoutes.vistDetails,
                arguments: item.toJson(),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // title + project + status chip
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.taskTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Icon(Icons.apartment,
                                    size: 13, color: Colors.grey.shade600),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    item.projectName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      _statusChip(
                          item.status.isEmpty ? "Unknown" : item.status, color),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // stage + priority (labeled, fixed height, always reserved)
                  SizedBox(
                    height: 22,
                    child: Row(
                      children: [
                        if (item.stageName.isNotEmpty)
                          Flexible(
                            child: _labelTag(
                                "Stage", item.stageName, Colors.blueGrey),
                          ),
                        if (item.stageName.isNotEmpty &&
                            item.priority.isNotEmpty)
                          const SizedBox(width: 6),
                        if (item.priority.isNotEmpty)
                          _labelTag("Priority", item.priority, priorityColor),
                      ],
                    ),
                  ),

                  const SizedBox(height: 6),

                  // remarks: always exactly one line
                  Text(
                    hasRemarks ? item.description.trim() : "No remarks",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      fontStyle:
                          hasRemarks ? FontStyle.normal : FontStyle.italic,
                      color: hasRemarks
                          ? Colors.grey.shade700
                          : Colors.grey.shade400,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // date range
                  Row(
                    children: [
                      Expanded(child: _dateInfo("From", fmt(item.fromDate))),
                      Icon(Icons.arrow_forward,
                          size: 16, color: Colors.grey.shade400),
                      Expanded(
                        child:
                            _dateInfo("To", fmt(item.toDate), alignEnd: true),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  Divider(height: 1, color: Colors.grey.shade200),
                  // const SizedBox(height: 8),

                  // actions
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     _actionButton(
                  //       icon: Icons.person_add_alt_1,
                  //       label: "Attendance",
                  //       onTap: () =>
                  //           attendanceDialog(context, cubit, item.visitId),
                  //     ),
                  //     const SizedBox(width: 8),
                  //     _actionButton(
                  //       icon: Icons.history,
                  //       label: "History",
                  //       onTap: () {
                  //         connStatus = true;
                  //         Navigator.pushNamed(
                  //           context,
                  //           AppRoutes.visitHistory,
                  //           arguments: {"visit_id": item.id},
                  //         );
                  //       },
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _labelTag(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "$label: ",
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          Flexible(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  Widget _dateInfo(String label, String value, {bool alignEnd = false}) {
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, size: 15, color: AppColors.primaryColor),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ATTENDANCE DIALOG (unchanged)
  // ---------------------------------------------------------------------------
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

// -----------------------------------------------------------------------------
// SKELETON: mirrors the layout and height of the visit card
// -----------------------------------------------------------------------------
class VisitCardSkeleton extends StatefulWidget {
  const VisitCardSkeleton({super.key});

  @override
  State<VisitCardSkeleton> createState() => _VisitCardSkeletonState();
}

class _VisitCardSkeletonState extends State<VisitCardSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Color?> _color;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _color = ColorTween(
      begin: Colors.grey.shade200,
      end: Colors.grey.shade300,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _box({double? width, required double height, double radius = 4}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: _color.value,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _color,
      builder: (context, _) {
        return Container(
          width: MediaQuery.of(context).size.width * .9,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.8),
                blurRadius: 3,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // title + project + status chip
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _box(width: 150, height: 18),
                          const SizedBox(height: 2),
                          _box(width: 200, height: 14),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    _box(width: 70, height: 24, radius: 20),
                  ],
                ),
                const SizedBox(height: 8),

                // stage + priority
                Row(
                  children: [
                    _box(width: 90, height: 22, radius: 6),
                    const SizedBox(width: 6),
                    _box(width: 80, height: 22, radius: 6),
                  ],
                ),
                const SizedBox(height: 6),

                // remarks
                _box(width: 170, height: 14),
                const SizedBox(height: 12),

                // dates
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _box(width: 30, height: 12),
                          const SizedBox(height: 2),
                          _box(width: 80, height: 16),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _box(width: 30, height: 12),
                          const SizedBox(height: 2),
                          _box(width: 80, height: 16),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                Divider(height: 1, color: Colors.grey.shade200),
                const SizedBox(height: 8),

                // action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _box(width: 95, height: 28, radius: 8),
                    const SizedBox(width: 8),
                    _box(width: 75, height: 28, radius: 8),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
