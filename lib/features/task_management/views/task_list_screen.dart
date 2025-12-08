import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:site_720/core/constants/routes.dart';
import 'package:site_720/core/widgets/snack_bar.dart';
import 'package:site_720/data/models/task/runningDashboard.dart';
import 'package:site_720/features/task_management/cubit/task_cubit.dart';
import 'package:site_720/features/task_management/cubit/task_state.dart';
import 'package:site_720/core/constants/colors.dart';

bool connStatus = false;

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  ProjectWorkModel? runningTaskData;
  List<Project> projectList = [];
  List<Project> filteredProjectList = [];
  TextEditingController searchController = TextEditingController();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  String? selectedSupervisor;
  
  List<String> supervisors = [
    'All',
    'Sarath Krishna',
    'Ansar Mohammed',
    'Pradeesh',
    'Sruthi',
    'Anju'
  ];

  @override
  void initState() {
    super.initState();
    context.read<TaskCubit>().getTaskListRunning();
    fromDateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now().subtract(const Duration(days: 30)));
    toDateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
  }

  @override
  void dispose() {
    searchController.dispose();
    fromDateController.dispose();
    toDateController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await context.read<TaskCubit>().getTaskListRunning();
  }

  void _filterProjects() {
    setState(() {
      filteredProjectList = projectList.where((project) {
        final nameMatch = project.projectName.toLowerCase().contains(searchController.text.toLowerCase());
        final isAssignedToSupervisor = selectedSupervisor == null || 
                                      selectedSupervisor == 'All' ||
                                      _getRandomSupervisor(project.id) == selectedSupervisor;
        return nameMatch && isAssignedToSupervisor;
      }).toList();
    });
  }

  String _getRandomSupervisor(String projectId) {
    final index = projectId.hashCode % (supervisors.length - 1) + 1;
    return supervisors[index];
  }

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isFromDate 
          ? DateFormat('dd-MM-yyyy').parse(fromDateController.text) 
          : DateFormat('dd-MM-yyyy').parse(toDateController.text),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isFromDate) {
          fromDateController.text = DateFormat('dd-MM-yyyy').format(picked);
        } else {
          toDateController.text = DateFormat('dd-MM-yyyy').format(picked);
        }
        _filterProjects();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: AppBar(
        title: const Text(
          'Daily Work Status',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_rounded),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => _buildFilterBottomSheet(),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<TaskCubit, TaskState>(
        listener: (context, state) {
          if (state is RunningTaskListSuccess) {
            runningTaskData = state.response;
            projectList = state.response.data?.project ?? [];
            filteredProjectList = List.from(projectList);
          } else if (state is AttendanceUpdated) {
            snackBar(context, state.response.message, Colors.green);
          } else if (state is AttendanceFailed) {
            snackBar(context, state.message, Colors.red);
          }
        },
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskFailure) {
            return Center(
              child: Text(state.message,
                  style: const TextStyle(color: AppColors.errorColor)),
            );
          } else if (filteredProjectList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 50, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text("No projects found",
                      style: TextStyle(color: AppColors.coffie)),
                  if (searchController.text.isNotEmpty || 
                      selectedSupervisor != null || 
                      fromDateController.text.isNotEmpty || 
                      toDateController.text.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          searchController.clear();
                          selectedSupervisor = null;
                          fromDateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now().subtract(const Duration(days: 30)));
                          toDateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
                          filteredProjectList = List.from(projectList);
                        });
                      },
                      child: const Text('Clear filters'),
                    ),
                ],
              ),
            );
          } else {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              color: AppColors.primaryColor,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
               
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Search by Project Name',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  searchController.clear();
                                  _filterProjects();
                                });
                              },
                            )
                          : null,
                    ),
                    onChanged: (value) => _filterProjects(),
                  ),
                  const SizedBox(height: 16),
                  _buildStatusHeader(),
                  const SizedBox(height: 20),
                  ...filteredProjectList
                      .map((project) => _buildProjectCard(project))
                      .toList(),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildFilterBottomSheet() {
  return Container(
    padding: EdgeInsets.only(
      bottom: MediaQuery.of(context).viewInsets.bottom,
      left: 16,
      right: 16,
      top: 16,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButtonFormField<String>(
          value: selectedSupervisor,
          decoration: InputDecoration(
            labelText: 'Filter by Supervisor',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            prefixIcon: const Icon(Icons.person),
          ),
          items: supervisors.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedSupervisor = value;
              _filterProjects();
            });
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: fromDateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'From Date',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.calendar_today),
                ),
                onTap: () => _selectDate(context, true),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: toDateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'To Date',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.calendar_today),
                ),
                onTap: () => _selectDate(context, false),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            _filterProjects();
            Navigator.pop(context);
          },
          
          child: const Text('Apply Filters', style: TextStyle(color: Colors.white)),
      
        )
        
      ],
      
    ),
  );
}

  Widget _buildStatusHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatusCountCard("Pending",
            runningTaskData?.data?.pentdingWorks ?? 0, AppColors.lightPrimary),
        _buildStatusCountCard("Total", runningTaskData?.data?.totalWorks ?? 0,
            AppColors.lightBlue),
      ],
    );
  }

  Widget _buildStatusCountCard(String label, int count, Color color) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.42,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Text(
            "$count",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(Project project) {
    final assignedSupervisor = _getRandomSupervisor(project.id);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.lightA,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        leading:
            const Icon(Icons.apartment_outlined, color: AppColors.primaryColor),
        title: Text(
          project.projectName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.coffie,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              // "Supervisor: $assignedSupervisor",
                "Supervisor:",
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.lightPrimary,
              ),
            ),
            Text(
              "Start Date: ${DateFormat('dd-MM-yyyy').format(DateTime.now().subtract(Duration(days: project.id.hashCode % 30)))}",
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.lightPrimary,
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios,
            size: 16, color: AppColors.primaryColor),
        onTap: () {
          connStatus = true;
          Navigator.pushNamed(
            context, AppRoutes.workDetails,
            arguments: {
              "id": project.id,
              "client_id": project.clientId
            },
          );
        },
      ),
    );
  }
}