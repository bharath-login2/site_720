import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/utilities/shared_preferences.dart';
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
import 'package:site_720/data/models/extraworklist/officeCategoryModel.dart';
import 'package:site_720/data/models/extraworklist/siteWorkCategoryModel.dart';
import 'package:site_720/data/models/extraworklist/staffListModel.dart';
import 'task_activity.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  final formKey = GlobalKey<FormState>();
  List<Tasks> taskList = [];
  XFile? image;
  String filterType = "my";
  String? userId;
  TaskCubit? _cubitReference;

  DateTime? _filterFromDate;
  DateTime? _filterToDate;
  String? _filterWorkType;
  String? _filterCategoryId; // Changed from _filterCategory
  String? _filterAssignedById; // Changed from _filterAssignedBy
  String? _filterAssignedToId; // Changed from _filterAssignedTo
  List<String> _selectedStatuses = [];

  List<OfficeCategory> _officeCategories = [];
  List<SiteCategory> _siteCategories = [];
  List<dynamic> _complaintCategories = [];
  List<StaffList> _staffs = [];
  String? _userName;

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  DateTime? _parseTaskDate(String dateStr) {
    if (dateStr.isEmpty) return null;
    final parts = dateStr.split('-');
    if (parts.length == 3) {
      try {
        return DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  String? _formatDate(DateTime? date) {
    if (date == null) return null;
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return "$day-$month-${date.year}";
  }

  void _showFilterBottomSheet() {
    DateTime? tempFromDate = _filterFromDate;
    DateTime? tempToDate = _filterToDate;
    String? tempWorkType = _filterWorkType;
    String? tempCategoryId = _filterCategoryId;
    String? tempAssignedById = _filterAssignedById;
    String? tempAssignedToId = _filterAssignedToId;
    List<String> tempSelectedStatuses = List.from(_selectedStatuses);

    List<String> statuses = ["ongoing", "pending", "cancelled", "completed"];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Filter Tasks", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: tempFromDate ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (date != null) {
                                setModalState(() => tempFromDate = date);
                              }
                            },
                            child: InputDecorator(
                              decoration: const InputDecoration(labelText: 'From Date', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
                              child: Text(tempFromDate != null ? "${tempFromDate!.day}-${tempFromDate!.month}-${tempFromDate!.year}" : "Select Date"),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: tempToDate ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (date != null) {
                                setModalState(() => tempToDate = date);
                              }
                            },
                            child: InputDecorator(
                              decoration: const InputDecoration(labelText: 'To Date', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
                              child: Text(tempToDate != null ? "${tempToDate!.day}-${tempToDate!.month}-${tempToDate!.year}" : "Select Date"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    const Text("Work Type", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _tab("Office", tempWorkType == "office", () {
                            setModalState(() {
                              tempWorkType = "office";
                              tempCategoryId = null;
                            });
                          }),
                          const SizedBox(width: 8),
                          _tab("Site", tempWorkType == "site", () {
                            setModalState(() {
                              tempWorkType = "site";
                              tempCategoryId = null;
                            });
                          }),
                          const SizedBox(width: 8),
                          _tab("Complaint", tempWorkType == "complaint", () {
                            setModalState(() {
                              tempWorkType = "complaint";
                              tempCategoryId = null;
                            });
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text("Category", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _tab("All", tempCategoryId == null, () {
                          setModalState(() => tempCategoryId = null);
                        }),
                        ...((tempWorkType == "office"
                                ? _officeCategories.map((e) => MapEntry(e.id, e.categoryName))
                                : tempWorkType == "site"
                                    ? _siteCategories.map((e) => MapEntry(e.id, e.categoryName))
                                    : tempWorkType == "complaint"
                                        ? _complaintCategories.where((e) => e != null && e is Map).map((e) => MapEntry((e['id'] ?? '').toString(), (e['category_name'] ?? '').toString()))
                                        : <MapEntry<String, String>>[])
                            .map((e) => _tab(e.value, tempCategoryId == e.key, () {
                                  setModalState(() => tempCategoryId = e.key);
                                }))),
                      ],
                    ),
                    const SizedBox(height: 15),
                    if (filterType == "my" || filterType == "all") ...[
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Assigned By', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                        value: tempAssignedById,
                        items: [
                          const DropdownMenuItem(value: null, child: Text("All")),
                          ..._staffs.map((e) => DropdownMenuItem(value: e.userId, child: Text(e.staffName))),
                        ],
                        onChanged: (val) {
                          setModalState(() => tempAssignedById = val);
                        },
                      ),
                      const SizedBox(height: 15),
                    ],
                    if (filterType == "assigned" || filterType == "all") ...[
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Assigned To', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                        value: tempAssignedToId,
                        items: [
                          const DropdownMenuItem(value: null, child: Text("All")),
                          ..._staffs.map((e) => DropdownMenuItem(value: e.userId, child: Text(e.staffName))),
                        ],
                        onChanged: (val) {
                          setModalState(() => tempAssignedToId = val);
                        },
                      ),
                      const SizedBox(height: 15),
                    ],
                    const Text("Status", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _tab("All", tempSelectedStatuses.isEmpty, () {
                          setModalState(() => tempSelectedStatuses.clear());
                        }),
                        ...statuses.map((e) => _tab(e, tempSelectedStatuses.contains(e), () {
                              setModalState(() {
                                if (tempSelectedStatuses.contains(e)) {
                                  tempSelectedStatuses.remove(e);
                                } else {
                                  tempSelectedStatuses.add(e);
                                }
                              });
                            })),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setModalState(() {
                                tempFromDate = null;
                                tempToDate = null;
                                tempWorkType = null;
                                tempCategoryId = null;
                                tempAssignedById = null;
                                tempAssignedToId = null;
                                tempSelectedStatuses.clear();
                              });
                            },
                            child: const Text("Clear Filters"),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor, foregroundColor: Colors.white),
                            onPressed: () {
                              setState(() {
                                _filterFromDate = tempFromDate;
                                _filterToDate = tempToDate;
                                _filterWorkType = tempWorkType;
                                _filterCategoryId = tempCategoryId;
                                _filterAssignedById = tempAssignedById;
                                _filterAssignedToId = tempAssignedToId;
                                _selectedStatuses = List.from(tempSelectedStatuses);
                              });

                               _cubitReference?.getTaskList(
                                fromDate: _formatDate(_filterFromDate),
                                toDate: _formatDate(_filterToDate),
                                workType: _filterWorkType,
                                category: _filterCategoryId,
                                assignedBy: _filterAssignedById,
                                assignedTo: _filterAssignedToId,
                                status: _selectedStatuses.isEmpty ? null : _selectedStatuses.join(','),
                                viewType: filterType,
                              );
                              Navigator.pop(context);
                            },
                            child: const Text("Apply Filter"),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    userId = await getSharedPreference("userId");
    _userName = await getSharedPreference("name");
    print("USER ID => $userId");
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final officeRes = await HttpServices.getOfficeCategory();
      if (officeRes != null) {
        if (mounted) {
          setState(() {
            _officeCategories = officeRes.data;
          });
        }
      }
      final siteRes = await HttpServices.getSiteCategory();
      if (siteRes != null) {
        if (mounted) {
          setState(() {
            _siteCategories = siteRes.data;
          });
        }
      }
      final staffRes = await HttpServices.getStaffsList();
      if (staffRes != null) {
        if (mounted) {
          setState(() {
            _staffs = staffRes.data;
          });
        }
      }
      final complaintRes = await HttpServices.getComplaintCategory();
      if (complaintRes != null) {
        if (mounted) {
          setState(() {
            _complaintCategories = complaintRes.data;
          });
        }
      }
    } catch (e) {
      print("Error loading categories or staffs: $e");
    }
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

      if (status == "new" || status == "pending") {
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

  // Callback method to refresh task list
  void _refreshTaskList() {
    if (_cubitReference != null) {
      _cubitReference!.getTaskList(
        fromDate: _formatDate(_filterFromDate),
        toDate: _formatDate(_filterToDate),
        workType: _filterWorkType,
        category: _filterCategoryId,
        assignedBy: _filterAssignedById,
        assignedTo: _filterAssignedToId,
        status: _selectedStatuses.isEmpty ? null : _selectedStatuses.join(','),
        viewType: filterType,
      );
      print("🔄 Task list refreshed from callback with filters");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text("Daily Task"),
        backgroundColor: const Color.fromARGB(247, 100, 38, 53),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: _showFilterBottomSheet,
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AddTaskDialog(
                  onTaskUpdated: _refreshTaskList,
                ),
              );
            },
          ),

           IconButton(
            icon: const Icon(Icons.note_alt_sharp, color: Colors.white),
             onPressed: () {
               Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => const TaskActivityPage()),
               );
             },
          )
        ],
      ),
      body: userId == null
          ? const Center(child: CircularProgressIndicator())
          : BlocProvider(
              create: (context) {
                final cubit = TaskCubit()..getTaskList(viewType: filterType);
                _cubitReference = cubit;
                return cubit;
              },
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
                        setState(() {
                          taskList = state.response.data;
                        });
                        print("📊 Task list updated: ${taskList.length} tasks");
                      } else if (state is ImageSuccess) {
                        setState(() {
                          image = state.image;
                        });
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
                    _cubitReference = cubit;

                    if (state is TaskLoading) {
                      return ListView.builder(
                        itemCount: 7,
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        itemBuilder: (_, __) => Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: shimmerContainer(100, 70),
                        ),
                      );
                    }

                    // Since the API already handles filtering, we use the taskList directly.
                    // The sub-tabs (My/Assigned/All) also trigger an API call with viewType.
                    List<Tasks> filtered = taskList;

                    final statusCounts = getStatusCounts(filtered);

                    return RefreshIndicator(
                      onRefresh: () async {
                        cubit.getTaskList(
                          fromDate: _formatDate(_filterFromDate),
                          toDate: _formatDate(_filterToDate),
                          workType: _filterWorkType,
                          category: _filterCategoryId,
                          assignedBy: _filterAssignedById,
                          assignedTo: _filterAssignedToId,
                          status: _selectedStatuses.isEmpty ? null : _selectedStatuses.join(','),
                          viewType: filterType,
                        );
                        print("🔃 Manual refresh triggered with filters");
                      },
                      child: ListView(
                        children: [
                          const SizedBox(height: 10),

                          // TABS
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _tab("My Tasks", filterType == "my", () {
                                setState(() {
                                  filterType = "my";
                                });
                                cubit.getTaskList(
                                  fromDate: _formatDate(_filterFromDate),
                                  toDate: _formatDate(_filterToDate),
                                  workType: _filterWorkType,
                                  category: _filterCategoryId,
                                  assignedBy: _filterAssignedById,
                                  assignedTo: _filterAssignedToId,
                                  status: _selectedStatuses.isEmpty ? null : _selectedStatuses.join(','),
                                  viewType: "my",
                                );
                              }),
                              _tab("Assigned Tasks", filterType == "assigned",
                                  () {
                                setState(() {
                                  filterType = "assigned";
                                });
                                cubit.getTaskList(
                                  fromDate: _formatDate(_filterFromDate),
                                  toDate: _formatDate(_filterToDate),
                                  workType: _filterWorkType,
                                  category: _filterCategoryId,
                                  assignedBy: _filterAssignedById,
                                  assignedTo: _filterAssignedToId,
                                  status: _selectedStatuses.isEmpty ? null : _selectedStatuses.join(','),
                                  viewType: "assigned",
                                );
                              }),
                              _tab("All Tasks", filterType == "all", () {
                                setState(() {
                                  filterType = "all";
                                });
                                cubit.getTaskList(
                                  fromDate: _formatDate(_filterFromDate),
                                  toDate: _formatDate(_filterToDate),
                                  workType: _filterWorkType,
                                  category: _filterCategoryId,
                                  assignedBy: _filterAssignedById,
                                  assignedTo: _filterAssignedToId,
                                  status: _selectedStatuses.isEmpty ? null : _selectedStatuses.join(','),
                                  viewType: "all",
                                );
                              }),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // STATUS COUNTS
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildStatusCountCard("Pending",
                                    statusCounts["New"]!, Colors.blue),
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

                          // TASK LIST
                          filtered.isEmpty
                              ? const Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 60),
                                    child: Text("No Tasks Found",
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                )
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
                        // Attendance button
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

                        // History button
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

                        // Edit button - WITH CALLBACK
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AddTaskDialog(
                                taskId: task.id,
                                onTaskUpdated: _refreshTaskList,
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
        content: const Text("Are you sure you want to delete this task?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteTask(context, cubit, taskId);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Delete"),
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
      if (Navigator.canPop(context)) Navigator.pop(context);
      await Future.delayed(const Duration(milliseconds: 100));
      if (response.status) {
        cubit.getTaskList();
        snackBar(context, response.message, Colors.green);
      } else {
        snackBar(context, response.message, Colors.red);
      }
    } catch (e) {
      if (Navigator.canPop(context)) Navigator.pop(context);
      await Future.delayed(const Duration(milliseconds: 100));
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
                                setState(() {
                                  image = null;
                                });
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