import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/widgets/snack_bar.dart';
import 'package:site_720/data/models/extraworklist/officeCategoryModel.dart';
import 'package:site_720/data/models/extraworklist/siteWorkCategoryModel.dart';
import 'package:site_720/data/models/extraworklist/staffListModel.dart';
import 'package:site_720/data/models/project_list/project_list_model.dart';
import 'package:site_720/data/models/task/task_edit_model.dart';
import 'package:site_720/data/models/workdetails/work_stage_model.dart';
import 'package:site_720/data/services/http_services.dart';
class AddTaskDialog extends StatefulWidget {
  final String? taskId;
  final Function? onTaskUpdated;
  const AddTaskDialog({super.key, this.taskId, this.onTaskUpdated});
  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}
class _AddTaskDialogState extends State<AddTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditMode = false;
  TaskEditData? _taskDetails;
  String workType = "office";
  String priority = "";
  ProjectList? selectedProject;
  List<ProjectList> projectList = [];
  DateTime? startDate;
  DateTime? endDate;
  Workstage? selectedStage;
  final taskNameController = TextEditingController();
  final remarksController = TextEditingController();
  List<StaffList> staffList = [];
  StaffList? selectedStaff;
  List<Map<String, dynamic>> stageList = [];
  List<OfficeCategory> officeCategories = [];
  List<SiteCategory> siteCategories = [];
  OfficeCategory? selectedOfficeCategory;
  SiteCategory? selectedSiteCategory;
  bool isCategoryLoading = false;
  List<TextEditingController> milestoneControllers = [TextEditingController()];
  List<XFile?> attachments = [null];
  List<Attachment> existingAttachments = [];
  final ImagePicker picker = ImagePicker();
  bool isSubmitting = false;
  bool isLoading = false;
  bool _staffLoaded = false;
  bool _officeCategoriesLoaded = false;
  bool _siteCategoriesLoaded = false;
  bool _projectsLoaded = false;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.taskId != null;

    if (_isEditMode) {
      loadTaskDetails();
    } else {
      _loadInitialData();
    }
  }

  Future<void> _loadInitialData() async {
    await Future.wait([
      loadStaffs(),
      loadOfficeCategories(),
      loadProjects(),
    ]);
  }

  Future<void> loadTaskDetails() async {
    if (widget.taskId == null) return;
    setState(() => isLoading = true);
    try {
      final response = await HttpServices.getTaskEdit(widget.taskId!);
      if (response != null && response.status) {
        _taskDetails = response.data;
        workType = _taskDetails!.workType.toLowerCase().contains("office")
            ? "office"
            : "site";
        await Future.wait([
          loadStaffs(),
          loadProjects(),
          workType == "office" ? loadOfficeCategories() : loadSiteCategories(),
        ]);

        _populateFormWithTaskData();
      } else {
        snackBar(context, "Failed to load task details", Colors.red);
      }
    } catch (e) {
      snackBar(context, "Error loading task: $e", Colors.red);
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _populateFormWithTaskData() {
    if (_taskDetails == null) return;

    taskNameController.text = _taskDetails!.taskTitle;
    remarksController.text = _taskDetails!.description;
    priority = _taskDetails!.priority;

    _parseDates();
    existingAttachments = _taskDetails!.attachments;
    milestoneControllers.clear();
    if (_taskDetails!.milestones.isNotEmpty) {
      for (var milestone in _taskDetails!.milestones) {
        milestoneControllers
            .add(TextEditingController(text: milestone.milestone));
      }
    } else {
      milestoneControllers.add(TextEditingController());
    }

    _setStaffFromTask();
    _setCategoryFromTask();

    if (workType == "site" && _taskDetails!.projectName.isNotEmpty) {
      _setProjectAndStageFromTask();
    }

    setState(() {});
  }

  void _parseDates() {
    final fromParts = _taskDetails!.fromDate.split('-');
    if (fromParts.length == 3) {
      startDate = DateTime(
        int.parse(fromParts[2]),
        int.parse(fromParts[1]),
        int.parse(fromParts[0]),
      );
    }

    final toParts = _taskDetails!.toDate.split('-');
    if (toParts.length == 3) {
      endDate = DateTime(
        int.parse(toParts[2]),
        int.parse(toParts[1]),
        int.parse(toParts[0]),
      );
    }
  }

  void _setStaffFromTask() {
    final staffName = _taskDetails!.staffName;
    final foundStaff = staffList.firstWhere(
      (s) => s.staffName == staffName,
      orElse: () => StaffList(staffId: '', userId: '', staffName: ''),
    );
    if (foundStaff.staffId.isNotEmpty) {
      selectedStaff = foundStaff;
    }
  }

  void _setCategoryFromTask() {
    if (workType == "office") {
      final categoryName = _taskDetails!.officeCategoryName;
      final foundCategory = officeCategories.firstWhere(
        (c) => c.categoryName == categoryName,
        orElse: () => OfficeCategory(id: '', categoryName: ''),
      );
      if (foundCategory.id.isNotEmpty) {
        selectedOfficeCategory = foundCategory;
      }
    } else {
      final categoryName = _taskDetails!.siteCategoryName;
      final foundCategory = siteCategories.firstWhere(
        (c) => c.categoryName == categoryName,
        orElse: () => SiteCategory(id: '', categoryName: ''),
      );
      if (foundCategory.id.isNotEmpty) {
        selectedSiteCategory = foundCategory;
      }
    }
  }

  void _setProjectAndStageFromTask() {
    final projectName = _taskDetails!.projectName;
    final foundProject = projectList.firstWhere(
      (p) => p.projectName == projectName,
      orElse: () => ProjectList(
        id: '',
        projectName: '',
        location: '',
        clientId: '',
        workStatus: '',
        startingDate: '',
        completionDate: '',
        totalAmount: '',
        paymentStatus: false,
      ),
    );
    if (foundProject.id.isNotEmpty) {
      selectedProject = foundProject;
      loadStagesForProject(foundProject.id);
    }
  }

  Future<void> loadProjects() async {
    final res = await HttpServices.getProjectList("all", "");
    if (res != null && res.data != null) {
      setState(() {
        projectList = res.data.projectList;
        _projectsLoaded = true;
      });
    }
  }

  Future<void> loadOfficeCategories() async {
    setState(() => isCategoryLoading = true);
    final res = await HttpServices.getOfficeCategory();
    if (res != null && res.data.isNotEmpty) {
      setState(() {
        officeCategories = res.data;
        _officeCategoriesLoaded = true;
        isCategoryLoading = false;
      });
    } else {
      setState(() => isCategoryLoading = false);
    }
  }

  Future<void> loadSiteCategories() async {
    setState(() => isCategoryLoading = true);
    final res = await HttpServices.getSiteCategory();
    if (res != null && res.data.isNotEmpty) {
      setState(() {
        siteCategories = res.data;
        _siteCategoriesLoaded = true;
        isCategoryLoading = false;
      });
    } else {
      setState(() => isCategoryLoading = false);
    }
  }

  Future<void> loadStaffs() async {
    final res = await HttpServices.getStaffsList();
    if (res != null && res.status == true) {
      setState(() {
        staffList = res.data;
        _staffLoaded = true;
      });
    }
  }

  Future<void> loadStagesForProject(String projectId) async {
    final response = await HttpServices.getWorkStages(projectId);
    if (response != null) {
      setState(() {
        stageList = response.data;
        if (_isEditMode &&
            _taskDetails != null &&
            _taskDetails!.stageName.isNotEmpty) {
          final stageData = stageList.firstWhere(
            (s) => s['stage_name'] == _taskDetails!.stageName,
            orElse: () => {},
          );
          if (stageData.isNotEmpty) {
            selectedStage = Workstage(
              stageId: stageData['id']?.toString() ?? '',
              stageName: stageData['stage_name'] ?? '',
            );
          }
        }
      });
    }
  }

  Future<void> loadCategories() async {
    setState(() => isCategoryLoading = true);

    if (workType == "office") {
      await loadOfficeCategories();
    } else {
      await loadSiteCategories();
    }
  }

  Widget _buildExistingAttachments() {
    if (existingAttachments.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        const Text("Existing Attachments",
            style: TextStyle(fontWeight: FontWeight.bold)),
        Column(
          children: existingAttachments.map((attachment) {
            final fileName = attachment.url.split('/').last;
            return ListTile(
              leading: const Icon(Icons.attach_file),
              title: Text(fileName),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    existingAttachments.remove(attachment);
                  });
                },
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  bool get _categoriesLoaded =>
      workType == "office" ? _officeCategoriesLoaded : _siteCategoriesLoaded;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(15),
      backgroundColor: Colors.white,
      child: isLoading
          ? const SizedBox(
              height: 300,
              child: Center(child: CircularProgressIndicator()),
            )
          : SizedBox(
              width: MediaQuery.of(context).size.width * 0.95,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(18),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _isEditMode ? "Edit Task" : "Assign New Task",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.black),
                            onPressed: () => Navigator.pop(context),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (_isEditMode) ...[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            "Task ID: ${widget.taskId}",
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                      const Text("Work Type:",
                          style: TextStyle(color: Colors.black)),
                      Row(
                        children: [
                          Radio(
                            activeColor: AppColors.primaryColor,
                            value: "office",
                            groupValue: workType,
                            onChanged: _isEditMode
                                ? null
                                : (val) {
                                    setState(() {
                                      workType = val.toString();
                                      selectedOfficeCategory = null;
                                      selectedSiteCategory = null;
                                      selectedProject = null;
                                      selectedStage = null;
                                      stageList = [];
                                    });
                                    loadCategories();
                                  },
                          ),
                          const Text("Office Work"),
                          const SizedBox(width: 20),
                          Radio(
                            activeColor: AppColors.primaryColor,
                            value: "site",
                            groupValue: workType,
                            onChanged: _isEditMode
                                ? null
                                : (val) {
                                    setState(() {
                                      workType = val.toString();
                                      selectedOfficeCategory = null;
                                      selectedSiteCategory = null;
                                      selectedProject = null;
                                      selectedStage = null;
                                      stageList = [];
                                    });
                                    loadCategories();
                                  },
                          ),
                          const Text("Site Work"),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text("Task Name*",
                          style: TextStyle(color: Colors.black)),
                      TextFormField(
                        controller: taskNameController,
                        decoration: const InputDecoration(
                          hintText: "Enter task",
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => v!.isEmpty ? "Task required" : null,
                      ),
                      const SizedBox(height: 15),
                      if (!_staffLoaded)
                        const Center(child: CircularProgressIndicator())
                      else ...[
                        const Text("Staff*",
                            style: TextStyle(color: Colors.black)),
                        DropdownButtonFormField<StaffList>(
                          decoration: const InputDecoration(
                            labelText: "Select Staff",
                            border: OutlineInputBorder(),
                          ),
                          value: selectedStaff,
                          items: staffList.map((s) {
                            return DropdownMenuItem<StaffList>(
                              value: s,
                              child: Text(s.staffName),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedStaff = value;
                            });
                          },
                          validator: (v) => v == null ? "Select staff" : null,
                        ),
                        const SizedBox(height: 15),
                      ],
                      if (workType == "site") ...[
                        const SizedBox(height: 15),
                        const Text("Select Project*",
                            style: TextStyle(color: Colors.black)),
                        DropdownButtonFormField<ProjectList>(
                          decoration: const InputDecoration(
                            labelText: "Select Project",
                            border: OutlineInputBorder(),
                          ),
                          value: selectedProject,
                          items: projectList.map((proj) {
                            return DropdownMenuItem<ProjectList>(
                              value: proj,
                              child: Text(proj.projectName),
                            );
                          }).toList(),
                          onChanged: (value) async {
                            setState(() {
                              selectedProject = value;
                              selectedStage = null;
                              stageList = [];
                            });
                            if (value != null) {
                              await loadStagesForProject(value.id);
                            }
                          },
                          validator: (v) => (workType == "site" && v == null)
                              ? "Select project"
                              : null,
                        ),
                        const SizedBox(height: 15),
                        if (stageList.isNotEmpty) ...[
                          const Text("Select Stage",
                              style: TextStyle(color: Colors.black)),
                          DropdownButtonFormField<Workstage>(
                            value: selectedStage,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Select Stage",
                            ),
                            items: stageList.map((stage) {
                              return DropdownMenuItem<Workstage>(
                                value: Workstage(
                                  stageId: stage['id']?.toString() ?? '',
                                  stageName: stage['stage_name'] ?? '',
                                ),
                                child: Text(stage['stage_name'] ?? ''),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedStage = value;
                              });
                            },
                          ),
                          const SizedBox(height: 15),
                        ],
                      ],
                      const SizedBox(height: 15),
                      const Text("Priority",
                          style: TextStyle(color: Colors.black)),
                      Row(
                        children: [
                          Radio(
                            activeColor: AppColors.primaryColor,
                            value: "High",
                            groupValue: priority,
                            onChanged: (v) =>
                                setState(() => priority = v.toString()),
                          ),
                          const Text("High"),
                          Radio(
                            activeColor: AppColors.primaryColor,
                            value: "Medium",
                            groupValue: priority,
                            onChanged: (v) =>
                                setState(() => priority = v.toString()),
                          ),
                          const Text("Medium"),
                          Radio(
                            activeColor: AppColors.primaryColor,
                            value: "Low",
                            groupValue: priority,
                            onChanged: (v) =>
                                setState(() => priority = v.toString()),
                          ),
                          const Text("Low"),
                        ],
                      ),
                      const SizedBox(height: 15),
                      if (isCategoryLoading)
                        const Center(child: CircularProgressIndicator())
                      else if (!_categoriesLoaded)
                        const Center(child: Text("Loading categories..."))
                      else ...[
                        const Text("Category*",
                            style: TextStyle(color: Colors.black)),
                        DropdownButtonFormField<dynamic>(
                          value: workType == "office"
                              ? selectedOfficeCategory
                              : selectedSiteCategory,
                          decoration: const InputDecoration(
                            hintText: "Select Category",
                            border: OutlineInputBorder(),
                          ),
                          items: workType == "office"
                              ? officeCategories
                                  .map((cat) => DropdownMenuItem(
                                        value: cat,
                                        child: Text(cat.categoryName),
                                      ))
                                  .toList()
                              : siteCategories
                                  .map((cat) => DropdownMenuItem(
                                        value: cat,
                                        child: Text(cat.categoryName),
                                      ))
                                  .toList(),
                          onChanged: (v) {
                            setState(() {
                              if (workType == "office") {
                                selectedOfficeCategory = v as OfficeCategory?;
                              } else {
                                selectedSiteCategory = v as SiteCategory?;
                              }
                            });
                          },
                          validator: (v) =>
                              v == null ? "Select category" : null,
                        ),
                        const SizedBox(height: 15),
                      ],
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Start Date",
                                    style: TextStyle(color: Colors.black)),
                                InkWell(
                                  onTap: () async {
                                    final date = await showDatePicker(
                                      context: context,
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100),
                                      initialDate: DateTime.now(),
                                    );
                                    if (date != null)
                                      setState(() => startDate = date);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                        border: Border.all(),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Text(
                                      startDate == null
                                          ? "dd-mm-yyyy"
                                          : "${startDate!.day}-${startDate!.month}-${startDate!.year}",
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("End Date",
                                    style: TextStyle(color: Colors.black)),
                                InkWell(
                                  onTap: () async {
                                    final date = await showDatePicker(
                                      context: context,
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100),
                                      initialDate: DateTime.now(),
                                    );
                                    if (date != null)
                                      setState(() => endDate = date);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                        border: Border.all(),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Text(
                                      endDate == null
                                          ? "dd-mm-yyyy"
                                          : "${endDate!.day}-${endDate!.month}-${endDate!.year}",
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (workType == "site") ...[
                        const SizedBox(height: 20),
                        const Text("Add Milestone",
                            style: TextStyle(color: Colors.black)),
                        Column(
                          children: [
                            for (int i = 0;
                                i < milestoneControllers.length;
                                i++)
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: milestoneControllers[i],
                                      decoration: const InputDecoration(
                                        hintText: "Enter milestone",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add,
                                        color: Colors.green),
                                    onPressed: () {
                                      setState(() {
                                        milestoneControllers
                                            .add(TextEditingController());
                                      });
                                    },
                                  ),
                                  if (i != 0)
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () {
                                        setState(() =>
                                            milestoneControllers.removeAt(i));
                                      },
                                    ),
                                ],
                              ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 20),
                      const Text("Remarks",
                          style: TextStyle(color: Colors.black)),
                      TextFormField(
                        controller: remarksController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Enter remarks",
                        ),
                      ),
                      if (_isEditMode && existingAttachments.isNotEmpty)
                        _buildExistingAttachments(),
                      const SizedBox(height: 20),
                      const Text("Attachments",
                          style: TextStyle(color: Colors.black)),
                      Column(
                        children: [
                          for (int i = 0; i < attachments.length; i++)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.black,
                                        side: const BorderSide(
                                            color: Colors.grey),
                                      ),
                                      onPressed: () async {
                                        final picked = await picker.pickImage(
                                            source: ImageSource.gallery);
                                        setState(() => attachments[i] = picked);
                                      },
                                      child: const Text("Choose Files"),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        attachments[i]?.name ??
                                            "No file chosen",
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add,
                                          color: Colors.green),
                                      onPressed: () {
                                        setState(() => attachments.add(null));
                                      },
                                    ),
                                    if (i != 0)
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () {
                                          setState(
                                              () => attachments.removeAt(i));
                                        },
                                      ),
                                  ],
                                ),
                                if (attachments[i] != null)
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Image.file(
                                      File(attachments[i]!.path),
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                              ],
                            )
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Close",
                                style: TextStyle(color: Colors.black)),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: isSubmitting
                                ? null
                                : _isEditMode
                                    ? updateTask
                                    : submitTask,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                foregroundColor: Colors.white),
                            child: isSubmitting
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(_isEditMode ? "Update" : "Submit"),
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

  Future<void> submitTask() async {
    if (!_formKey.currentState!.validate()) return;
    if (startDate == null || endDate == null) {
      snackBar(context, "Select Start & End Dates", Colors.red);
      return;
    }
    if (selectedStaff == null) {
      snackBar(context, "Please select a staff", Colors.red);
      return;
    }
    String? categoryId;
    if (workType == "office") {
      if (selectedOfficeCategory == null) {
        snackBar(context, "Please select a category", Colors.red);
        return;
      }
      categoryId = selectedOfficeCategory!.id;
    } else {
      if (selectedSiteCategory == null) {
        snackBar(context, "Please select a category", Colors.red);
        return;
      }
      categoryId = selectedSiteCategory!.id;
    }
    setState(() => isSubmitting = true);
    List<String> milestones = milestoneControllers
        .where((c) => c.text.trim().isNotEmpty)
        .map((c) => c.text.trim())
        .toList();

    List<String> filePaths = attachments
        .where((file) => file != null)
        .map((file) => file!.path)
        .toList();
    final response = await HttpServices.submitAssignTask(
      taskName: taskNameController.text,
      staffId: selectedStaff!.staffId,
      priority: priority,
      categoryId: categoryId!,
      workType: workType,
      projectId: workType == "site" ? (selectedProject?.id ?? "") : "",
      stageId: workType == "site" ? (selectedStage?.stageId ?? "") : "",
      startDate: "${startDate!.year}-${startDate!.month}-${startDate!.day}",
      endDate: "${endDate!.year}-${endDate!.month}-${endDate!.day}",
      remarks: remarksController.text,
      milestones: milestones,
      filePaths: filePaths,
    );

    setState(() => isSubmitting = false);

    if (response != null && response.status == true) {
      Navigator.pop(context);
      snackBar(context, "Task Submitted Successfully!", Colors.green);
    } else {
      snackBar(context, "Failed to submit task", Colors.red);
    }
  }
  Future<void> updateTask() async {
    if (!_formKey.currentState!.validate()) return;

    if (startDate == null || endDate == null) {
      snackBar(context, "Select Start & End Dates", Colors.red);
      return;
    }
    if (selectedStaff == null) {
      snackBar(context, "Please select a staff", Colors.red);
      return;
    }
    String? categoryId;
    if (workType == "office") {
      if (selectedOfficeCategory == null) {
        snackBar(context, "Please select a category", Colors.red);
        return;
      }
      categoryId = selectedOfficeCategory!.id;
    } else {
      if (selectedSiteCategory == null) {
        snackBar(context, "Please select a category", Colors.red);
        return;
      }
      categoryId = selectedSiteCategory!.id;
    }
    if (widget.taskId == null) return;
    setState(() => isSubmitting = true);
    List<Map<String, String>> milestones = [];
    for (var controller in milestoneControllers) {
      if (controller.text.trim().isNotEmpty) {
        milestones.add({
          'milestone': controller.text.trim(),
        });
      }
    }

    List<String> filePaths = attachments
        .where((file) => file != null)
        .map((file) => file!.path)
        .toList();
    List<String> existingAttachmentUrls =
        existingAttachments.map((attachment) => attachment.url).toList();

    final response = await HttpServices.updateTask(
      taskId: widget.taskId!,
      taskName: taskNameController.text,
      staffId: selectedStaff!.staffId,
      priority: priority,
      categoryId: categoryId!,
      workType: workType,
      projectId: workType == "site" ? (selectedProject?.id ?? "") : "",
      stageId: workType == "site" ? (selectedStage?.stageId ?? "") : "",
      startDate: "${startDate!.year}-${startDate!.month}-${startDate!.day}",
      endDate: "${endDate!.year}-${endDate!.month}-${endDate!.day}",
      remarks: remarksController.text,
      milestones: milestones,
      filePaths: filePaths,
      existingAttachments: existingAttachments,
    );

    setState(() => isSubmitting = false);

    if (response != null && response.status == true) {
      Navigator.pop(context);
      snackBar(context, "Task Updated Successfully!", Colors.green);
      if (widget.onTaskUpdated != null) {
        widget.onTaskUpdated!();
      }
    } else {
      snackBar(context, "Failed to update task", Colors.red);
    }
  }
}
