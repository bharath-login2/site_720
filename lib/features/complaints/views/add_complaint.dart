// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/widgets/buttons.dart';
import 'package:site_720/data/services/http_services.dart';
import 'package:site_720/features/complaints/cubit/complaint_state.dart';

import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/connectivity_dialog.dart';
import '../../../data/models/complaint/complaint_details_model.dart';
import '../../../data/models/project_list/project_list_model.dart';
import '../../connectivity/cubit/connectivity_cubit.dart';
import '../../connectivity/cubit/connectivity_state.dart';
import '../cubit/add_complaint_cubit.dart';

class ParticipantModel {
  String? userId;
  String staffName = "";
  TextEditingController remarks = TextEditingController();
  bool isTask = false;
}

class AddComplaint extends StatefulWidget {
  const AddComplaint({super.key});

  @override
  State<AddComplaint> createState() => _AddComplaintState();
}

class _AddComplaintState extends State<AddComplaint> {
  bool isChecked = false;
  String complaintType = "";
  String reportedBy = "";
  String natureOfComplaint = "";
  String complaintStatus = "";
  final formKey = GlobalKey<FormState>();
  TextEditingController customerName = TextEditingController();
  TextEditingController customerNumber = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController incidentDate = TextEditingController();
  TextEditingController complaintDescription = TextEditingController();
  List filteredClientList = [];
  String clientId = "";
  List<ReportedBy> reportedByList = [];
  List<ComplaintNature> complaintNatureList = [];
  List<ComplaintStatus> complaintStatusList = [];
  List<ComplaintType> complaintTypesList = [];
  List<Staff> staffList = [];
  List<ParticipantModel> participants = [ParticipantModel()];
  List<File> complaintImages = [];
  List<ProjectList> projectList = [];
  String selectedProjectId = "";

  @override
  void initState() {
    super.initState();
    _fetchProjects();
  }

  Future<void> _fetchProjects() async {
    var res = await HttpServices.getProjectList("all", "");
    if (res != null && res.data != null) {
      if (mounted) {
        setState(() {
          projectList = res.data.projectList;
        });
      }
    }
  }

  Future<void> pickImage() async {
    final pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        complaintImages.addAll(pickedFiles.map((e) => File(e.path)));
      });
    }
  }

  Future<void> showQuickAddDialog(String title,
      Future<bool> Function(String) onSubmit, BuildContext cubitContext) async {
    TextEditingController controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add $title"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: "Enter $title"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (controller.text.isNotEmpty) {
                  bool success = await onSubmit(controller.text);
                  if (success) {
                    cubitContext
                        .read<AddComplaintCubit>()
                        .getComplaintDetails();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("$title added successfully")));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Failed to add $title")));
                  }
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  Future<void> submitComplaint(
  BuildContext cubitContext,
) async {
  if (formKey.currentState!.validate()) {

    List<Map<String, dynamic>> participantData = [];

    for (var p in participants) {
      if (p.userId != null) {
        participantData.add({
          'staff_id': p.userId,
          'remarks': p.remarks.text,
          'is_task': p.isTask,
        });
      }
    }

    Map<String, String> fields = {
      'project_id': selectedProjectId ?? "",
      'customer_name': customerName.text,
      'customer_number': customerNumber.text,
      'email': email.text,
      'incident_date': incidentDate.text,
      'complaint_description':
          complaintDescription.text,
      'complaint_type': complaintType ?? "",
      'reported_by': reportedBy ?? "",
      'nature_of_complaint':
          natureOfComplaint ?? "",
      'complaint_status':
          complaintStatus ?? "",
    };

    final response =
        await HttpServices.addComplaint(
      fields: fields,
      participants: participantData,
      imageFiles: complaintImages,
    );

    print(
      "COMPLAINT RESPONSE : ${response?.message}",
    );

    if (response != null &&
        response.status == true) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            response.message ??
                "Complaint added successfully",
          ),
        ),
      );

      Navigator.pop(context, true);

    } else {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            response?.message ??
                "Failed to add complaint",
          ),
        ),
      );
    }
  }
}
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddComplaintCubit(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: simpleAppbar(context, "Add Complaints", true),
        body: MultiBlocListener(
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
            BlocListener<AddComplaintCubit, ComplaintState>(
              listener: (context, state) {
                if (state is ComplaintDetailsFetched) {
                  complaintTypesList = state.response.data.complaintTypes;
                  complaintNatureList = state.response.data.complaintNature;
                  complaintStatusList = state.response.data.complaintStatus;
                  reportedByList = state.response.data.reportedBy;
                  staffList = state.response.data.staff;
                } else if (state is ComplaintTypeUpdated) {
                  complaintType = state.value;
                } else if (state is ReportedByUpdated) {
                  reportedBy = state.value;
                } else if (state is NatureUpdated) {
                  natureOfComplaint = state.value;
                } else if (state is StatusUpdated) {
                  complaintStatus = state.value;
                }
              },
            )
          ],
          child: BlocBuilder<AddComplaintCubit, ComplaintState>(
            builder: (context, state) {
              return SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Row(
                            children: [
                              Expanded(
                                child: DropdownSearch<ComplaintType>(
                                  selectedItem: complaintTypesList
                                          .where((e) => e.id == complaintType)
                                          .isEmpty
                                      ? null
                                      : complaintTypesList.firstWhere(
                                          (e) => e.id == complaintType),
                                  onSelected: (value) {
                                    if (value != null) {
                                      context
                                          .read<AddComplaintCubit>()
                                          .updateComplaintType(value.id);
                                    }
                                  },
                                  items: (filter, loadProps) {
                                    if (filter.isEmpty)
                                      return complaintTypesList;
                                    return complaintTypesList
                                        .where((e) => e.typeName
                                            .toLowerCase()
                                            .contains(filter.toLowerCase()))
                                        .toList();
                                  },
                                  itemAsString: (ComplaintType u) => u.typeName,
                                  compareFn: (item, selectedItem) =>
                                      item.id == selectedItem.id,
                                  popupProps: PopupProps.menu(
                                    showSearchBox: true,
                                    fit: FlexFit.loose,
                                    itemBuilder:
                                        (context, item, isSelected, isFocused) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 10),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text("• ",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Expanded(
                                                child: Text(item.typeName,
                                                    style: const TextStyle(
                                                        fontSize: 14))),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  decoratorProps: DropDownDecoratorProps(
                                    decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      labelText: 'Complaint Type*',
                                      labelStyle: const TextStyle(
                                          color: Colors.grey, fontSize: 14),
                                      contentPadding:
                                          const EdgeInsets.only(left: 10),
                                    ),
                                  ),
                                ),
                              ),
                              // IconButton(
                              //   icon: const Icon(Icons.add_circle, color: AppColors.primaryColor, size: 30),
                              //   onPressed: () {
                              //     showQuickAddDialog("Complaint Type", (name) async {
                              //       var res = await HttpServices.addComplaintType(name);
                              //       return res.status == true;
                              //     }, context);
                              //   },
                              // ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Row(
                            children: [
                              Expanded(
                                child: DropdownSearch<ReportedBy>(
                                  selectedItem: reportedByList
                                          .where((e) => e.id == reportedBy)
                                          .isEmpty
                                      ? null
                                      : reportedByList.firstWhere(
                                          (e) => e.id == reportedBy),
                                  onSelected: (value) {
                                    if (value != null) {
                                      context
                                          .read<AddComplaintCubit>()
                                          .updateReportedby(value.id);
                                    }
                                  },
                                  items: (filter, loadProps) {
                                    if (filter.isEmpty) return reportedByList;
                                    return reportedByList
                                        .where((e) => e.reportedBy
                                            .toLowerCase()
                                            .contains(filter.toLowerCase()))
                                        .toList();
                                  },
                                  itemAsString: (ReportedBy u) => u.reportedBy,
                                  compareFn: (item, selectedItem) =>
                                      item.id == selectedItem.id,
                                  popupProps: PopupProps.menu(
                                    showSearchBox: true,
                                    fit: FlexFit.loose,
                                    itemBuilder:
                                        (context, item, isSelected, isFocused) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 10),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text("• ",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Expanded(
                                                child: Text(item.reportedBy,
                                                    style: const TextStyle(
                                                        fontSize: 14))),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  decoratorProps: DropDownDecoratorProps(
                                    decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      labelText: 'Complaint Reported by',
                                      labelStyle: const TextStyle(
                                          color: Colors.grey, fontSize: 14),
                                      contentPadding:
                                          const EdgeInsets.only(left: 10),
                                    ),
                                  ),
                                ),
                              ),
                              // IconButton(
                              //   icon: const Icon(Icons.add_circle, color: AppColors.primaryColor, size: 30),
                              //   onPressed: () {
                              //     showQuickAddDialog("Reported By", (name) async {
                              //       var res = await HttpServices.addComplaintReportedBy(name);
                              //       return res.status == true;
                              //     }, context);
                              //   },
                              // ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.95,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                blurRadius: 8.0,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: 370,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(5),
                                  ),
                                  color: AppColors.primaryColor,
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30.0, vertical: 12.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Customer Details",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              // SizedBox(
                              //   width: MediaQuery.of(context).size.width * 0.9,
                              //   child: DropdownSearch<Staff>(
                              //     selectedItem: staffList.where((e) => e.id == selectedStaff).isEmpty ? null : staffList.firstWhere((e) => e.id == selectedStaff),
                              //     onSelected: (value) async {
                              //       if (value != null) {
                              //         selectedStaff = value.id.toString();
                              //         selectedStaffName = value.staffName;
                              //       }
                              //     },
                              //     items: (filter, loadProps) {
                              //       if (filter.isEmpty) return staffList;
                              //       return staffList.where((e) => e.staffName.toLowerCase().contains(filter.toLowerCase())).toList();
                              //     },
                              //     itemAsString: (Staff u) => u.staffName,
                              //     compareFn: (item, selectedItem) => item.id == selectedItem.id,
                              //     popupProps: const PopupProps.menu(
                              //       showSearchBox: true,
                              //       fit: FlexFit.loose,
                              //     ),
                              //     decoratorProps: DropDownDecoratorProps(
                              //       decoration: InputDecoration(
                              //         fillColor: Colors.white,
                              //         filled: true,
                              //         border: OutlineInputBorder(
                              //           borderRadius: BorderRadius.circular(5),
                              //         ),
                              //         labelText: 'Select Staff',
                              //         labelStyle: const TextStyle(
                              //             color: Colors.grey, fontSize: 14),
                              //         contentPadding:
                              //             const EdgeInsets.only(left: 10),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: TextFormField(
                                  controller: customerName,
                                  onTap: () {
                                    // selectClientDialog(context);
                                  },
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    labelText: 'Customer Name',
                                    prefixIcon: const Icon(
                                      Icons.person,
                                      color: Color.fromARGB(255, 10, 10, 10),
                                      size: 18,
                                    ),
                                    labelStyle: const TextStyle(
                                        color: Colors.grey, fontSize: 14),
                                    contentPadding:
                                        const EdgeInsets.only(left: 10),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: TextFormField(
                                  controller: customerNumber,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    labelText: 'Customer Number',
                                    prefixIcon: const Icon(
                                      Icons.numbers,
                                      color: Color.fromARGB(255, 15, 15, 15),
                                      size: 18,
                                    ),
                                    labelStyle: const TextStyle(
                                        color: Colors.grey, fontSize: 14),
                                    contentPadding:
                                        const EdgeInsets.only(left: 10),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: TextFormField(
                                  controller: email,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    labelText: 'Customer Email',
                                    prefixIcon: const Icon(
                                      Icons.email,
                                      color: Color.fromARGB(255, 15, 15, 15),
                                      size: 18,
                                    ),
                                    labelStyle: const TextStyle(
                                        color: Colors.grey, fontSize: 14),
                                    contentPadding:
                                        const EdgeInsets.only(left: 10),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 35,
                        ),
                        Container(
                          width: 370,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                            ),
                            color: AppColors.primaryColor,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Project",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: DropdownSearch<ProjectList>(
                            selectedItem: projectList
                                    .where((e) => e.id == selectedProjectId)
                                    .isEmpty
                                ? null
                                : projectList.firstWhere(
                                    (e) => e.id == selectedProjectId),
                            onSelected: (value) {
                              if (value != null) {
                                setState(() {
                                  selectedProjectId = value.id;
                                });
                              }
                            },
                            items: (filter, loadProps) {
                              if (filter.isEmpty) return projectList;
                              return projectList
                                  .where((e) => e.projectName
                                      .toLowerCase()
                                      .contains(filter.toLowerCase()))
                                  .toList();
                            },
                            itemAsString: (ProjectList u) => u.projectName,
                            compareFn: (item, selectedItem) =>
                                item.id == selectedItem.id,
                            popupProps: PopupProps.menu(
                              showSearchBox: true,
                              fit: FlexFit.loose,
                              itemBuilder:
                                  (context, item, isSelected, isFocused) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text("• ",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                      Expanded(
                                          child: Text(item.projectName,
                                              style: const TextStyle(
                                                  fontSize: 14))),
                                    ],
                                  ),
                                );
                              },
                            ),
                            decoratorProps: DropDownDecoratorProps(
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                labelText: 'Select Project*',
                                labelStyle: const TextStyle(
                                    color: Colors.grey, fontSize: 14),
                                contentPadding: const EdgeInsets.only(left: 10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 35,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.95,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                blurRadius: 8.0,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: TextFormField(
                                  readOnly: true,
                                  controller: incidentDate,
                                  onTap: () async {
                                    DateTime? selectedDate =
                                        await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime(2101),
                                    );
                                    incidentDate.text =
                                        "${selectedDate!.toLocal()}"
                                            .split(' ')[0];
                                  },
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    labelText: 'Incident Date',
                                    labelStyle: const TextStyle(
                                        color: Colors.grey, fontSize: 14),
                                    contentPadding:
                                        const EdgeInsets.only(left: 10),
                                    // prefixIcon: const Icon(
                                    //   Icons.calendar_today,
                                    //   color: Color.fromARGB(255, 10, 10, 10),
                                    //   size: 18,
                                    // ),
                                    suffixIcon: IconButton(
                                      icon: const Icon(
                                        Icons.calendar_today,
                                        color: Color.fromARGB(255, 10, 10, 10),
                                        size: 18,
                                      ),
                                      onPressed: () async {
                                        DateTime? selectedDate =
                                            await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime(2101),
                                        );
                                        incidentDate.text =
                                            "${selectedDate!.toLocal()}"
                                                .split(' ')[0];
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: TextFormField(
                                  controller: complaintDescription,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    labelText: 'Complaint Description',
                                    prefixIcon: const Icon(
                                      Icons.text_fields_sharp,
                                      color: Color.fromARGB(255, 15, 15, 15),
                                      size: 18,
                                    ),
                                    labelStyle: const TextStyle(
                                        color: Colors.grey, fontSize: 14),
                                    contentPadding:
                                        const EdgeInsets.only(left: 10),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Row(
                            children: [
                              Expanded(
                                child: DropdownSearch<ComplaintNature>(
                                  selectedItem: complaintNatureList
                                          .where(
                                              (e) => e.id == natureOfComplaint)
                                          .isEmpty
                                      ? null
                                      : complaintNatureList.firstWhere(
                                          (e) => e.id == natureOfComplaint),
                                  onSelected: (value) {
                                    if (value != null) {
                                      context
                                          .read<AddComplaintCubit>()
                                          .updatNature(value.id);
                                    }
                                  },
                                  items: (filter, loadProps) {
                                    if (filter.isEmpty)
                                      return complaintNatureList;
                                    return complaintNatureList
                                        .where((e) => e.natureName
                                            .toLowerCase()
                                            .contains(filter.toLowerCase()))
                                        .toList();
                                  },
                                  itemAsString: (ComplaintNature u) =>
                                      u.natureName,
                                  compareFn: (item, selectedItem) =>
                                      item.id == selectedItem.id,
                                  popupProps: PopupProps.menu(
                                    showSearchBox: true,
                                    fit: FlexFit.loose,
                                    itemBuilder:
                                        (context, item, isSelected, isFocused) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 10),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text("• ",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Expanded(
                                                child: Text(item.natureName,
                                                    style: const TextStyle(
                                                        fontSize: 14))),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  decoratorProps: DropDownDecoratorProps(
                                    decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      labelText: 'Nature of complaint',
                                      labelStyle: const TextStyle(
                                          color: Colors.grey, fontSize: 14),
                                      contentPadding:
                                          const EdgeInsets.only(left: 10),
                                    ),
                                  ),
                                ),
                              ),
                              // IconButton(
                              //   icon: const Icon(Icons.add_circle, color: AppColors.primaryColor, size: 30),
                              //   onPressed: () {
                              //     showQuickAddDialog("Nature of Complaint", (name) async {
                              //       var res = await HttpServices.addComplaintNature(name);
                              //       return res.status == true;
                              //     }, context);
                              //   },
                              // ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.95,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                blurRadius: 8.0,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: 370,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(5),
                                  ),
                                  color: AppColors.primaryColor,
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30.0, vertical: 12.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Complaint Participants",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: participants.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: DropdownSearch<Staff>(
                                                  selectedItem: staffList
                                                          .where((e) =>
                                                              e.userId ==
                                                              participants[
                                                                      index]
                                                                  .userId)
                                                          .isEmpty
                                                      ? null
                                                      : staffList.firstWhere(
                                                          (e) =>
                                                              e.userId ==
                                                              participants[
                                                                      index]
                                                                  .userId),
                                                  onSelected: (value) async {
                                                    if (value != null) {
                                                      setState(() {
                                                        participants[index]
                                                                .userId =
                                                            value.userId
                                                                .toString();
                                                        participants[index]
                                                                .staffName =
                                                            value.staffName;
                                                      });
                                                    }
                                                  },
                                                  items: (filter, loadProps) {
                                                    if (filter.isEmpty)
                                                      return staffList;
                                                    return staffList
                                                        .where((e) => e
                                                            .staffName
                                                            .toLowerCase()
                                                            .contains(filter
                                                                .toLowerCase()))
                                                        .toList();
                                                  },
                                                  itemAsString: (Staff u) =>
                                                      u.staffName,
                                                  compareFn: (item,
                                                          selectedItem) =>
                                                      item.userId ==
                                                      selectedItem.userId,
                                                  popupProps:
                                                      const PopupProps.menu(
                                                    showSearchBox: true,
                                                    fit: FlexFit.loose,
                                                  ),
                                                  decoratorProps:
                                                      DropDownDecoratorProps(
                                                    decoration: InputDecoration(
                                                      fillColor: Colors.white,
                                                      filled: true,
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      labelText: 'Select Staff',
                                                      labelStyle:
                                                          const TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 12),
                                                      contentPadding:
                                                          const EdgeInsets.only(
                                                              left: 10),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: TextFormField(
                                                  controller:
                                                      participants[index]
                                                          .remarks,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  decoration: InputDecoration(
                                                    fillColor: Colors.white,
                                                    filled: true,
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    labelText: 'Enter Remarks',
                                                    labelStyle: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 12),
                                                    contentPadding:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Checkbox(
                                                    value: participants[index]
                                                        .isTask,
                                                    onChanged: (val) {
                                                      setState(() {
                                                        participants[index]
                                                                .isTask =
                                                            val ?? false;
                                                      });
                                                    },
                                                  ),
                                                  const Text("Assign as Task",
                                                      style: TextStyle(
                                                          fontSize: 12)),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        participants.add(
                                                            ParticipantModel());
                                                      });
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xFF00BFA5),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      child: const Icon(
                                                          Icons.add,
                                                          color: Colors.white,
                                                          size: 20),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        if (participants
                                                                .length >
                                                            1) {
                                                          participants
                                                              .removeAt(index);
                                                        }
                                                      });
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors
                                                                .redAccent),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      child: const Icon(
                                                          Icons.delete,
                                                          color:
                                                              Colors.redAccent,
                                                          size: 20),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: DropdownSearch<ComplaintStatus>(
                            selectedItem: complaintStatusList
                                    .where((e) => e.id == complaintStatus)
                                    .isEmpty
                                ? null
                                : complaintStatusList
                                    .firstWhere((e) => e.id == complaintStatus),
                            onSelected: (value) {
                              if (value != null) {
                                context
                                    .read<AddComplaintCubit>()
                                    .updateStatus(value.id);
                              }
                            },
                            items: (filter, loadProps) {
                              if (filter.isEmpty) return complaintStatusList;
                              return complaintStatusList
                                  .where((e) => e.statusName
                                      .toLowerCase()
                                      .contains(filter.toLowerCase()))
                                  .toList();
                            },
                            itemAsString: (ComplaintStatus u) => u.statusName,
                            compareFn: (item, selectedItem) =>
                                item.id == selectedItem.id,
                            popupProps: PopupProps.menu(
                              showSearchBox: true,
                              fit: FlexFit.loose,
                              itemBuilder:
                                  (context, item, isSelected, isFocused) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text("• ",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                      Expanded(
                                          child: Text(item.statusName,
                                              style: const TextStyle(
                                                  fontSize: 14))),
                                    ],
                                  ),
                                );
                              },
                            ),
                            decoratorProps: DropDownDecoratorProps(
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                labelText: 'Complaint Status*',
                                labelStyle: const TextStyle(
                                    color: Colors.grey, fontSize: 14),
                                contentPadding: const EdgeInsets.only(left: 10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.grey),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.image,
                                    color: AppColors.primaryColor),
                                title: const Text('Upload Images'),
                                trailing: const Icon(Icons.upload_file),
                                onTap: pickImage,
                              ),
                              if (complaintImages.isNotEmpty)
                                const Divider(height: 1),
                              if (complaintImages.isNotEmpty)
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: complaintImages.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      leading: const Icon(Icons.image_outlined,
                                          color: Colors.grey),
                                      title: Text(
                                        complaintImages[index]
                                            .path
                                            .split('\\')
                                            .last
                                            .split('/')
                                            .last,
                                        style: const TextStyle(fontSize: 12),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.clear,
                                            color: Colors.red, size: 20),
                                        onPressed: () {
                                          setState(() {
                                            complaintImages.removeAt(index);
                                          });
                                        },
                                      ),
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 35),
                        InkWell(
                            onTap: () => submitComplaint(context),
                            child: LargeButton(title: "Submit")),
                        const SizedBox(
                          height: 25,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Container addButton(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * .23,
        height: MediaQuery.of(context).size.height * .1,
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
        alignment: Alignment.center,
        child: const Text(
          "Add",
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              fontFamily: "Lobster",
              color: Colors.white),
        ));
  }
}

class CheckBoxWidget extends StatelessWidget {
  const CheckBoxWidget({
    super.key,
    required this.id,
    required this.title,
    required this.value,
    required this.type,
  });

  final bool value;
  final String id;
  final String title;
  final String type;

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<AddComplaintCubit>();
    return Row(
      // crossAxisAlignment: CrossAxisAlignment
      //     .start,
      children: [
        Checkbox(
          value: value,
          onChanged: (bool? newValue) {
            try {
              if (type == "type") {
                cubit.updateComplaintType(id);
              } else if (type == "reportedBy") {
                cubit.updateReportedby(id);
              } else if (type == "nature") {
                cubit.updatNature(id);
              } else if (type == "status") {
                cubit.updateStatus(id);
              }
            } catch (e) {
              log(e.toString());
            }
          },
        ),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 59, 58, 58),
            ),
          ),
        ),
      ],
    );
  }
}
