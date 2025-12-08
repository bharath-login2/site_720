import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/utilities/shared_preferences.dart';
import 'package:site_720/core/widgets/appbar.dart';
import 'package:site_720/core/widgets/snack_bar.dart';
import 'package:site_720/data/services/http_services.dart';
import 'package:site_720/widgets/taskDialog.dart';
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

  final formKey = GlobalKey<FormState>();
  List<Tasks> taskList = [];
  XFile? image;

  // TAB STATE
  String filterType = "my"; // my | assigned | all

  Future<String> loadUserId() async {
    return await getSharedPreference("userId");
  }

  Map<String, int> getStatusCounts(List<Tasks> list) {
    final counts = {
      "New": 0,
      "Completed": 0,
      "Ongoing": 0,
      "Cancelled": 0,
    };

    for (var task in list) {
      final status = task.status.toLowerCase();

      if (status == "new") {
        counts["New"] = counts["New"]! + 1;
      } else if (status == "completed") {
        counts["Completed"] = counts["Completed"]! + 1;
      } else if (status == "in-progress" || status == "in progress") {
        counts["Ongoing"] = counts["Ongoing"]! + 1;
      } else if (status == "cancelled" || status == "not-started") {
        counts["Cancelled"] = counts["Cancelled"]! + 1;
      }
    }

    return counts;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadUserId(),
      builder: (context, snapshot) {
        final userId = snapshot.data.toString();
        print("USER ID => $userId");
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          // appBar: simpleAppbar(context, "Daily Task", false),
          appBar: AppBar(
            title: const Text("Daily Task"),
            backgroundColor: AppColors.primaryColor,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AddTaskDialog(),
                  );
                },
              )
            ],
          ),

          body: BlocProvider(
            create: (context) => TaskCubit()..getTaskList(),
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
                ),
              ],
              child: BlocBuilder<TaskCubit, TaskState>(
                builder: (context, state) {
                  final cubit = context.read<TaskCubit>();

                  if (state is TaskLoading) {
                    return ListView.builder(
                      itemCount: 7,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      itemBuilder: (_, __) => Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: shimmerContainer(100, 70)),
                    );
                  }

                  /// FILTER TASK LIST
                  List<Tasks> filtered = [];
                  if (filterType == "my") {
                    filtered = taskList
                        .where((t) => t.assignedStaffId == userId)
                        .toList();
                  } else if (filterType == "assigned") {
                    filtered = taskList
                        .where((t) => t.assignedStaffId != userId)
                        .toList();
                  } else {
                    filtered = taskList;
                  }

                  final statusCounts = getStatusCounts(filtered);

                  return RefreshIndicator(
                    onRefresh: () async {
                      cubit.getTaskList();
                    },
                    child: ListView(
                      children: [
                        const SizedBox(height: 10),

                        /// ---------------- TABS ----------------
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _tab("My Tasks", filterType == "my", () {
                              filterType = "my";
                              cubit.emit(TaskInitial());
                            }),
                            _tab("Assigned Tasks", filterType == "assigned",
                                () {
                              filterType = "assigned";
                              cubit.emit(TaskInitial());
                            }),
                            _tab("All Tasks", filterType == "all", () {
                              filterType = "all";
                              cubit.emit(TaskInitial());
                            }),
                          ],
                        ),

                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatusCountCard(
                                  "New", statusCounts["New"]!, Colors.blue),
                              _buildStatusCountCard("Ongoing",
                                  statusCounts["Ongoing"]!, Colors.orange),
                              _buildStatusCountCard("Completed",
                                  statusCounts["Completed"]!, Colors.green),
                              _buildStatusCountCard("Cancelled",
                                  statusCounts["Cancelled"]!, Colors.red),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),

                        /// ---------------- TASK LIST ----------------
                        filtered.isEmpty
                            ? const Center(
                                child: Padding(
                                padding: EdgeInsets.only(top: 60),
                                child: Text("No Tasks Found",
                                    style: TextStyle(fontSize: 16)),
                              ))
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: filtered.length,
                                padding: const EdgeInsets.all(8),
                                itemBuilder: (context, index) {
                                  final task = filtered[index];
                                  return _taskCard(context, cubit, task);
                                },
                              ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _tab(String title, bool selected, Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppColors.primaryColor),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _taskCard(BuildContext context, TaskCubit cubit, Tasks task) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: InkWell(
        onTap: () {
          connStatus = true;
          Navigator.pushNamed(
            context,
            AppRoutes.taskDetails,
            arguments: {"task_id": task.id},
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.grey.shade100,
            boxShadow: [
              BoxShadow(color: Colors.grey.withOpacity(0.8), blurRadius: 3),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.workType,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          task.taskTitle,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (task.staffName != "")
                          Text(
                            task.staffName,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        if (task.stageName != "")
                          Text(
                            task.stageName,
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
                            attendanceDialog(context, cubit, task.id);
                          },
                          child: Container(
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
                            child: const Icon(Icons.person_add,
                                size: 16, color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 7),
                        InkWell(
                          onTap: () {
                            connStatus = true;
                            Navigator.pushNamed(
                              context,
                              AppRoutes.taskHistory,
                              arguments: {"task_id": task.id},
                            );
                          },
                          child: Container(
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
                            child: const Icon(Icons.history,
                                size: 18, color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 7),
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AddTaskDialog(
                                taskId: task.id,
                                onTaskUpdated: () {
                                  cubit.getTaskList();
                                },
                              ),
                            );
                          },
                          child: Container(
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
                            child: const Icon(Icons.edit,
                                size: 18, color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 7),
                        InkWell(
                          onTap: () {
                            _showDeleteConfirmationDialog(context, cubit,
                                task.id); 
                          },
                          child: Container(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.red,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.8),
                                  blurRadius: 6,
                                  offset: const Offset(1, 1),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.delete,
                                size: 18, color: Colors.white),
                          ),
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
                      amount: task.fromDate,
                      valueColor: AppColors.primaryColor,
                    ),
                    AmountContainer(
                      title: "To Date",
                      amount: task.toDate,
                      valueColor: AppColors.primaryColor,
                    ),
                    AmountContainer(
                      title: "Status",
                      amount: task.status,
                      valueColor: _statusColor(task.status),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case "New":
        return Colors.blue;
      case "In-Progress":
      case "In Progress":
        return Colors.orange;
      case "Cancelled":
        return Colors.red;
      case "Completed":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  /// STATUS COUNT CARD
  Widget _buildStatusCountCard(String title, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Column(
        children: [
          Text(title,
              style: TextStyle(fontWeight: FontWeight.bold, color: color)),
          Text(count.toString(),
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, TaskCubit cubit, String taskId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Task"),
        content: const Text(
            "Are you sure you want to delete this task? This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close confirmation dialog
              await _deleteTask(context, cubit, taskId);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteTask(
      BuildContext context, TaskCubit cubit, String taskId) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      final response = await HttpServices.deleteTask(taskId);
      Navigator.pop(context);
      if (response != null && response.status == true) {
        cubit.getTaskList();
        snackBar(context, "Task deleted successfully!", Colors.green);
      } else {
        snackBar(context, "Failed to delete task", Colors.red);
      }
    } catch (e) {
      Navigator.pop(context);
      snackBar(context, "Error deleting task: $e", Colors.red);
    }
  }

  Future<void> attendanceDialog(
      BuildContext context, TaskCubit cubit, String taskId) async {
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
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 16, bottom: 25),
                            child: Text("Attendance",
                                style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
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
                                children: [
                                  const SizedBox(width: 10),
                                  const Icon(Icons.image, color: Colors.grey),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: image != null
                                        ? Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.file(File(image!.path),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .2,
                                                fit: BoxFit.cover),
                                          )
                                        : SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .2,
                                            child: const Center(
                                                child: Text('Upload Selfie',
                                                    style: TextStyle(
                                                        color: Colors.grey))),
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
                            onPressed: () => Navigator.pop(context),
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
