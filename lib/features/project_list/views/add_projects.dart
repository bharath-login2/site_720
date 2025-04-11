// ignore_for_file: must_be_immutable

import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/widgets/buttons.dart';
import 'package:site_720/core/widgets/snack_bar.dart';
import 'package:site_720/features/project_list/cubit/add_project_cubit.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/connectivity_dialog.dart';
import '../../../core/widgets/dialogs.dart';
import '../../../data/models/project_list/project_data_model.dart';
import '../../connectivity/cubit/connectivity_cubit.dart';
import '../../connectivity/cubit/connectivity_state.dart';
import '../../payment_details/widgets/amount_container.dart';
import '../cubit/project_list_state.dart';

class AddProjectScreen extends StatefulWidget {
  bool fromHome;
  AddProjectScreen({super.key, required this.fromHome});

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  final formKey = GlobalKey<FormState>();

  final GlobalKey<FormState> unitKey = GlobalKey<FormState>();

  TextEditingController clientName = TextEditingController();

  TextEditingController projectName = TextEditingController();

  TextEditingController referenceNumber = TextEditingController();

  TextEditingController location = TextEditingController();

  TextEditingController locationArea = TextEditingController();

  TextEditingController cctvAddress = TextEditingController();

  TextEditingController startDate = TextEditingController();

  TextEditingController completionDate = TextEditingController();

  TextEditingController companyName = TextEditingController();

  TextEditingController civilId = TextEditingController();

  TextEditingController description = TextEditingController();

  TextEditingController lpoNumber = TextEditingController();

  TextEditingController quotationNumber = TextEditingController();

  TextEditingController fixedRate = TextEditingController();

  TextEditingController name = TextEditingController();

  TextEditingController squareFeet = TextEditingController();

  TextEditingController rate = TextEditingController();

  TextEditingController amount = TextEditingController();

  // TextEditingController estBudAmt = TextEditingController();

  // TextEditingController gstAmt = TextEditingController();

  // TextEditingController totalAmt = TextEditingController();

  String priority = "";

  dynamic type;

  dynamic category;

  dynamic package;

  dynamic bhk;

  dynamic gst;

  String estBudAmt = "";

  String gstAmt = "";

  String totalAmt = "";

  List<Clients> clientList = [];

  List<Clients> filteredClientList = [];

  String clientId = "";

  String budgetMethord = 'Fixed Rate';

  List<Map<String, dynamic>> unitList = [];

  double totalSqFt = 0;

  double totalRate = 0;

  double averageRate = 0;

  double totalAmount = 0;

  List<ProjectList> projectList = [];

  List<ProjectCategory> projectCategory = [];

  List<Package> packages = [];

  List<Bhk> bhkList = [];

  List<Map<String, dynamic>> gstList = [
    {"value": 0, "name": "0%"},
    {"value": 5, "name": "5%"},
    {"value": 12, "name": "12%"},
    {"value": 18, "name": "18%"},
    {"value": 28, "name": "28%"},
  ];

  XFile? planImage;

  XFile? elevationImage;

  String pageType = "add";

  String projectId = "add";
  bool isLoading = false;

  void clearAllVariables() {
    clientName.clear();
    projectName.clear();
    referenceNumber.clear();
    location.clear();
    locationArea.clear();
    cctvAddress.clear();
    startDate.clear();
    completionDate.clear();
    companyName.clear();
    civilId.clear();
    description.clear();
    lpoNumber.clear();
    quotationNumber.clear();
    fixedRate.clear();
    name.clear();
    squareFeet.clear();
    rate.clear();
    amount.clear();
    gstAmt = "";
    totalAmt = "";
    priority = "";
    estBudAmt = "";
    type = null;
    category = null;
    package = null;
    bhk = null;
    gst = null;
    clientId = "";
    budgetMethord = 'Fixed Rate';
    totalSqFt = 0;
    totalRate = 0;
    averageRate = 0;
    totalAmount = 0;
    pageType = "add";
    projectId = "add";
    unitList.clear();
    planImage = null;
    elevationImage = null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddProjectCubit(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: simpleAppbar(
            context, "Add Project", widget.fromHome ? false : true),
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
            BlocListener<AddProjectCubit, ProjectListState>(
              listener: (context, state) {
                if (state is PriorityUpdated) {
                  priority = state.value;
                }
                if (state is ProjectDataSuccess) {
                  filteredClientList = state.response.data.clientList;
                  clientList = state.response.data.clientList;
                  projectList = state.response.data.projectList;
                  projectCategory = state.response.data.projectCategory;
                  packages = state.response.data.packages;
                  bhkList = state.response.data.bhk;
                }
                if (state is PlanSuccess) {
                  planImage = state.image;
                }
                if (state is ElevationSuccess) {
                  elevationImage = state.image;
                }
                if (state is AddProjectSuccess) {
                  isLoading = false;
                  snackBar(context, state.message, Colors.green);
                  if (widget.fromHome == false) {
                    Navigator.pop(context);
                  } else {
                    clearAllVariables();
                  }
                }
                if (state is AddProjectFailed) {
                  isLoading = false;
                  snackBar(context, state.message, Colors.red);
                }
              },
            )
          ],
          child: BlocBuilder<AddProjectCubit, ProjectListState>(
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
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .9,
                          child: TextFormField(
                            readOnly: true,
                            controller: clientName,
                            onTap: () {
                              selectClientDialog(context).then((_) {
                                filteredClientList = [];
                                filteredClientList = clientList;
                              });
                            },
                            validator: (value) {
                              if (value == "") {
                                return "Select Client";
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                // Custom border
                                borderRadius: BorderRadius.circular(5),
                              ),
                              labelText: 'Client *',
                              prefixIcon: const Icon(
                                Icons.person,
                                color: Colors.grey,
                                size: 18,
                              ),
                              labelStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
                              contentPadding: const EdgeInsets.only(left: 10),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .9,
                          child: TextFormField(
                            controller: projectName,
                            validator: (value) {
                              if (value == "") {
                                return "Enter Project Name";
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              labelText: 'Project name *',
                              prefixIcon: const Icon(
                                Icons.person,
                                color: Colors.grey,
                                size: 18,
                              ),
                              labelStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
                              contentPadding: const EdgeInsets.only(left: 10),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .9,
                          child: DropdownButtonFormField(
                            value: type,
                            validator: (value) {
                              if (value == null) {
                                return "Select Type";
                              } else {
                                return null;
                              }
                            },
                            onChanged: (value) async {
                              type = value.toString();
                            },
                            items: projectList.map((data) {
                              return DropdownMenuItem<String>(
                                value: data.id.toString(),
                                child: Text(
                                  data.projectType.toString(),
                                ),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                // Custom border
                                borderRadius: BorderRadius.circular(5),
                              ),
                              labelText: 'Project type *',
                              labelStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
                              contentPadding: const EdgeInsets.only(left: 10),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .9,
                          child: DropdownButtonFormField(
                            value: category,
                            validator: (value) {
                              if (value == null) {
                                return "Select Category";
                              } else {
                                return null;
                              }
                            },
                            onChanged: (value) async {
                              category = value.toString();
                            },
                            items: projectCategory.map((data) {
                              return DropdownMenuItem<String>(
                                value: data.id.toString(),
                                child: Text(
                                  data.categoryName.toString(),
                                ),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                // Custom border
                                borderRadius: BorderRadius.circular(5),
                              ),
                              labelText: 'Project category *',
                              labelStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
                              contentPadding: const EdgeInsets.only(left: 10),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .9,
                          child: TextFormField(
                            controller: referenceNumber,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                // Custom border
                                borderRadius: BorderRadius.circular(5),
                              ),
                              labelText: 'Reference number',
                              prefixIcon: const Icon(
                                Icons.numbers,
                                color: Colors.grey,
                                size: 18,
                              ),
                              labelStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
                              contentPadding: const EdgeInsets.only(left: 10),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .9,
                          child: TextFormField(
                            controller: location,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                // Custom border
                                borderRadius: BorderRadius.circular(5),
                              ),
                              labelText: 'Location',
                              prefixIcon: const Icon(
                                Icons.pin_drop,
                                color: Colors.grey,
                                size: 18,
                              ),
                              labelStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
                              contentPadding: const EdgeInsets.only(left: 10),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .9,
                          child: TextFormField(
                            controller: locationArea,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              labelText: 'Location Area',
                              prefixIcon: const Icon(
                                Icons.pin_drop,
                                color: Colors.grey,
                                size: 18,
                              ),
                              labelStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
                              contentPadding: const EdgeInsets.only(left: 10),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .9,
                          child: TextFormField(
                            controller: cctvAddress,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                // Custom border
                                borderRadius: BorderRadius.circular(5),
                              ),
                              labelText: 'CCTV Address',
                              prefixIcon: const Icon(
                                Icons.video_camera_front,
                                color: Colors.grey,
                                size: 18,
                              ),
                              labelStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
                              contentPadding: const EdgeInsets.only(left: 10),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        BlocBuilder<AddProjectCubit, ProjectListState>(
                          builder: (context, state) {
                            return Container(
                              width: MediaQuery.of(context).size.width * 0.92,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: const Color.fromARGB(255, 255, 255, 255),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        const Color.fromARGB(255, 209, 206, 206)
                                            .withOpacity(0.8),
                                    blurRadius: 3,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    width: double.infinity,
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
                                                "Priority",
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
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, top: 10),
                                    child: CheckBoxWidget(
                                        id: "1",
                                        title: "High",
                                        value: priority == "1" ? true : false),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: CheckBoxWidget(
                                        id: "2",
                                        title: "Medium",
                                        value: priority == "2" ? true : false),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 10.0, left: 15),
                                      child: CheckBoxWidget(
                                          id: "3",
                                          title: "Low",
                                          value:
                                              priority == "3" ? true : false)),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .9,
                          child: DropdownButtonFormField(
                            value: package,
                            onChanged: (value) async {
                              package = value.toString();
                            },
                            validator: (value) {
                              if (value == null) {
                                return "Select Package";
                              } else {
                                return null;
                              }
                            },
                            items: packages.map((data) {
                              return DropdownMenuItem<String>(
                                value: data.id.toString(),
                                child: Text(
                                  data.packageName.toString(),
                                ),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                // Custom border
                                borderRadius: BorderRadius.circular(5),
                              ),
                              labelText: 'Package *',
                              labelStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
                              contentPadding: const EdgeInsets.only(left: 10),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .9,
                          child: DropdownButtonFormField(
                            value: bhk,
                            onChanged: (value) async {
                              bhk = value.toString();
                            },
                            validator: (value) {
                              if (value == null) {
                                return "Select no of BHK";
                              } else {
                                return null;
                              }
                            },
                            items: bhkList.map((data) {
                              return DropdownMenuItem<String>(
                                value: data.id.toString(),
                                child: Text(
                                  data.name.toString(),
                                ),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                // Custom border
                                borderRadius: BorderRadius.circular(5),
                              ),
                              labelText: 'No of BHK *',
                              labelStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
                              contentPadding: const EdgeInsets.only(left: 10),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .9,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width * .44,
                                height: 50,
                                child: TextFormField(
                                  onTap: () async {
                                    String? selectedDate =
                                        await selectDate(context, false);
                                    if (selectedDate != null) {
                                      startDate.text = selectedDate;
                                      if (context.mounted) {}
                                    }
                                  },
                                  readOnly: true,
                                  controller: startDate,
                                  decoration: const InputDecoration(
                                      labelText: 'Start Date',
                                      contentPadding: EdgeInsets.all(10),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppColors.primaryColor)),
                                      labelStyle: TextStyle(
                                          color: Colors.grey, fontSize: 14),
                                      prefixIcon: Icon(Icons.calendar_today,
                                          size: 18,
                                          color: AppColors.primaryColor)),
                                ),
                              ),
                              // const SizedBox(
                              //   width: 10,
                              // ),
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width * .44,
                                height: 50,
                                child: TextFormField(
                                  onTap: () async {
                                    String? selectedDate =
                                        await selectDate(context, true);
                                    if (selectedDate != null) {
                                      completionDate.text = selectedDate;
                                      if (context.mounted) {}
                                    }
                                  },
                                  readOnly: true,
                                  controller: completionDate,
                                  decoration: const InputDecoration(
                                      labelText: 'Completion Date',
                                      contentPadding: EdgeInsets.all(10),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppColors.primaryColor)),
                                      labelStyle: TextStyle(
                                          color: Colors.grey, fontSize: 14),
                                      suffixIcon: Icon(Icons.calendar_today,
                                          size: 18,
                                          color: AppColors.primaryColor)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Plan',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                InkWell(
                                  onTap: () async {
                                    imageDialog(context, "plan");
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * .4,
                                    height:
                                        MediaQuery.of(context).size.width * .4,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black, width: 1.5),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                      child: planImage == null
                                          ? const Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.upload_file,
                                                    color: Colors.grey),
                                                SizedBox(height: 10),
                                                Text(
                                                  'Upload Plan',
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            )
                                          : Image.file(
                                              File(planImage!.path),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .4,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .4,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Elevation',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                InkWell(
                                  onTap: () async {
                                    imageDialog(context, "elevation");
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * .4,
                                    height:
                                        MediaQuery.of(context).size.width * .4,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black, width: 1.5),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: elevationImage == null
                                        ? const Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.upload_file,
                                                  color: Colors.grey),
                                              SizedBox(height: 10),
                                              Text(
                                                'Upload Elevation',
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              )
                                            ],
                                          )
                                        : Image.file(
                                            File(elevationImage!.path),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .4,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .4,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Project Details",
                                style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Radio<String>(
                                    value: 'Fixed Rate',
                                    groupValue: budgetMethord,
                                    onChanged: (value) {
                                      budgetMethord = value!;
                                      unitList.clear();
                                      estBudAmt = "";
                                      gstAmt = "";
                                      totalAmt = "";
                                      (context as Element).markNeedsBuild();
                                    },
                                  ),
                                  const Text("Fixed Rate"),
                                  Radio<String>(
                                    value: 'Unit Based Rate',
                                    groupValue: budgetMethord,
                                    onChanged: (value) {
                                      budgetMethord = value!;
                                      fixedRate.clear();
                                      estBudAmt = '';
                                      gstAmt = "";
                                      totalAmt = "";
                                      (context as Element).markNeedsBuild();
                                    },
                                  ),
                                  const Text("Unit Based Rate"),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * .91,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: AppColors.backgroundColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.8),
                                blurRadius: 3,
                                offset: const Offset(0, .5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(5),
                                    ),
                                    color: AppColors.primaryColor,
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 12.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Project Budget",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.lightA,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              if (budgetMethord != "Fixed Rate")
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 16.0, left: 16.0, right: 16.0),
                                  child: Container(
                                    // width:
                                    //     MediaQuery.of(context).size.width * .9,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: AppColors.backgroundColor,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.8),
                                          blurRadius: 3,
                                          offset: const Offset(0, .5),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(5),
                                                topRight: Radius.circular(5),
                                              ),
                                              color: AppColors.primaryColor,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12.0,
                                                      vertical: 12.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text(
                                                    "Units",
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: AppColors.lightA,
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      addBudgetDialog(context);
                                                    },
                                                    child: Container(
                                                      height: 25,
                                                      width: 25,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        color: AppColors.lightA,
                                                      ),
                                                      child: const Icon(
                                                        Icons.add,
                                                        size: 18,
                                                        color: AppColors
                                                            .primaryColor,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )),
                                        unitList.isNotEmpty
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 10.0),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 10.0),
                                                      child: ListView.builder(
                                                        shrinkWrap: true,
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    8.0),
                                                        itemCount:
                                                            unitList.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(6.0),
                                                            child: InkWell(
                                                              onTap: () {
                                                                // Navigator.of(context)
                                                                //     .pushNamed(AppRoutes.stageHistory);
                                                              },
                                                              child: Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    .9,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                  color: Colors
                                                                      .white,
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.8),
                                                                      blurRadius:
                                                                          3,
                                                                      offset:
                                                                          const Offset(
                                                                              0,
                                                                              3),
                                                                    ),
                                                                  ],
                                                                ),
                                                                child: SizedBox(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      .7,
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets.only(
                                                                        top:
                                                                            8.0,
                                                                        left:
                                                                            8.0,
                                                                        right:
                                                                            8.0,
                                                                        bottom:
                                                                            8.0),
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text(
                                                                              unitList[index]['name'],
                                                                              style: const TextStyle(
                                                                                fontSize: 16,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                            Row(
                                                                              children: [
                                                                                // InkWell(
                                                                                //   onTap: () {},
                                                                                //   child: Container(
                                                                                //     height: 25,
                                                                                //     width: 25,
                                                                                //     decoration: BoxDecoration(
                                                                                //       borderRadius: BorderRadius.circular(5),
                                                                                //       color: AppColors.lightBlue,
                                                                                //       boxShadow: [
                                                                                //         BoxShadow(
                                                                                //           color: Colors.grey.withOpacity(0.8),
                                                                                //           blurRadius: 6,
                                                                                //           offset: const Offset(1, 1),
                                                                                //         ),
                                                                                //       ],
                                                                                //     ),
                                                                                //     child: const Icon(
                                                                                //       Icons.edit,
                                                                                //       size: 18,
                                                                                //       color: Colors.white,
                                                                                //     ),
                                                                                //   ),
                                                                                // ),
                                                                                // const SizedBox(
                                                                                //   width: 7,
                                                                                // ),
                                                                                InkWell(
                                                                                  onTap: () {
                                                                                    deleteDialog(context, () {
                                                                                      unitList.removeAt(index);
                                                                                      calculateTotal();
                                                                                      updateGst();
                                                                                      setState(() {});
                                                                                      Navigator.pop(context);
                                                                                    });
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
                                                                                    child: const Icon(
                                                                                      Icons.delete,
                                                                                      size: 18,
                                                                                      color: Colors.white,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            SmallContainer(
                                                                              title: "Square Feet",
                                                                              amount: unitList[index]['squareFeet'],
                                                                            ),
                                                                            SmallContainer(
                                                                              title: "Rate",
                                                                              amount: unitList[index]['rate'],
                                                                            ),
                                                                            SmallContainer(
                                                                              title: "Amount",
                                                                              amount: unitList[index]['amount'],
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
                                                        },
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 16.0),
                                                      child: Column(
                                                        children: [
                                                          buildRow(
                                                              "Total Square Feet : ",
                                                              totalSqFt
                                                                  .toString()),
                                                          // buildRow(
                                                          //     "Total Rate : ",
                                                          //     totalRate
                                                          //         .toString()),
                                                          buildRow(
                                                              "Average : ",
                                                              averageRate
                                                                  .toString()),
                                                          buildRow(
                                                              "Total Amount : ",
                                                              totalAmount
                                                                  .toString()),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : const Padding(
                                                padding: EdgeInsets.all(25.0),
                                                child: Text(
                                                  "Empty !",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        AppColors.primaryColor,
                                                  ),
                                                ),
                                              )
                                      ],
                                    ),
                                  ),
                                )
                              else
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 16.0, left: 16.0, right: 16.0),
                                  child: TextFormField(
                                    controller: fixedRate,
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      estBudAmt = value;
                                      totalAmt = value;
                                      updateGst();
                                    },
                                    decoration: const InputDecoration(
                                        labelText: 'Fixed rate',
                                        contentPadding: EdgeInsets.all(10),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: AppColors.primaryColor)),
                                        labelStyle: TextStyle(
                                            color: Colors.grey, fontSize: 14),
                                        prefixIcon: Icon(Icons.money,
                                            size: 18,
                                            color: AppColors.primaryColor)),
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 12.0, left: 16.0, right: 16.0),
                                child: DropdownButtonFormField(
                                  value: gst,
                                  onChanged: (value) async {
                                    gst = value.toString();
                                    updateGst();
                                  },
                                  items: gstList.map((data) {
                                    return DropdownMenuItem<String>(
                                      value: data["value"].toString(),
                                      child: Text(
                                        data["name"].toString(),
                                      ),
                                    );
                                  }).toList(),
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      // Custom border
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    labelText: 'GST',
                                    labelStyle: const TextStyle(
                                        color: Colors.grey, fontSize: 14),
                                    contentPadding:
                                        const EdgeInsets.only(left: 10),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    if (estBudAmt != "")
                                      buildRow("Estimated Budget : ",
                                          estBudAmt.toString()),
                                    if (gstAmt != "")
                                      buildRow(
                                          "GST Amount : ", gstAmt.toString()),
                                    if (totalAmt != "")
                                      buildRow("Total Amount : ",
                                          totalAmt.toString()),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .9,
                          child: TextFormField(
                            controller: description,
                            maxLines: 3,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                // Custom border
                                borderRadius: BorderRadius.circular(5),
                              ),
                              labelText: 'Description',
                              prefixIcon: const Icon(
                                Icons.text_fields,
                                color: Colors.grey,
                                size: 18,
                              ),
                              labelStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
                              contentPadding: const EdgeInsets.only(
                                  left: 10, top: 10, bottom: 10),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .9,
                          child: TextFormField(
                            controller: lpoNumber,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                // Custom border
                                borderRadius: BorderRadius.circular(5),
                              ),
                              labelText: 'LPO Number',
                              prefixIcon: const Icon(
                                Icons.numbers,
                                color: Colors.grey,
                                size: 18,
                              ),
                              labelStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
                              contentPadding: const EdgeInsets.only(left: 10),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .9,
                          child: TextFormField(
                            controller: quotationNumber,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                // Custom border
                                borderRadius: BorderRadius.circular(5),
                              ),
                              labelText: 'Quotation/work order number',
                              prefixIcon: const Icon(
                                Icons.numbers,
                                color: Colors.grey,
                                size: 18,
                              ),
                              labelStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
                              contentPadding: const EdgeInsets.only(left: 10),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        isLoading
                            ? const CircularProgressIndicator()
                            : InkWell(
                                onTap: () {
                                  if (formKey.currentState!.validate()) {
                                    isLoading = true;
                                    setState(() {});
                                    context.read<AddProjectCubit>().addProject(
                                        clientId,
                                        projectName.text,
                                        type,
                                        category,
                                        referenceNumber.text,
                                        location.text,
                                        locationArea.text,
                                        cctvAddress.text,
                                        priority,
                                        package,
                                        bhk,
                                        startDate.text,
                                        completionDate.text,
                                        planImage == null
                                            ? ""
                                            : planImage!.path,
                                        elevationImage == null
                                            ? ""
                                            : elevationImage!.path,
                                        fixedRate.text,
                                        unitList,
                                        estBudAmt,
                                        gst ?? "0",
                                        gstAmt,
                                        totalAmount.toString(),
                                        description.text,
                                        lpoNumber.text,
                                        quotationNumber.text);
                                    isLoading = true;
                                    setState(() {});
                                  } else {
                                    snackBar(
                                        context, "Fill all fields", Colors.red);
                                  }
                                },
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

  Row buildRow(String name, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          name,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
      ],
    );
  }

  Future<dynamic> selectClientDialog(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: AppColors.backgroundColor,
            content: SizedBox(
              height: MediaQuery.of(context).size.height * .5,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // const SizedBox(
                    //   height: 15,
                    // ),
                    // const Text(
                    //   'Clients',
                    //   // style: TextingStyle.font18BoldBlack,
                    // ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextField(
                      autocorrect: false,
                      keyboardType: TextInputType.visiblePassword,
                      autofocus: true,
                      onChanged: (value) {
                        setState(() {
                          filteredClientList = clientList
                              .where((item) => item.clientName
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                              .toList();
                        });
                      },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(8),
                        labelText: 'Search',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .55,
                      width: MediaQuery.of(context).size.width * .8,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: filteredClientList.length,
                        itemBuilder: (context, i) {
                          return ListTile(
                            onTap: () {
                              clientName.text =
                                  filteredClientList[i].clientName;
                              clientId = filteredClientList[i].id;
                              Navigator.pop(context);
                            },
                            title: Text(
                              filteredClientList[i].clientName,
                              style: const TextStyle(
                                  color: AppColors.primaryColor),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              ),
            ],
          );
        });
      },
    );
  }

  Future<String?> selectDate(BuildContext context, bool isEndDate) async {
    DateTime now = DateTime.now();
    DateTime initialDate = now;
    DateTime firstDate = DateTime(2000);

    if (isEndDate && startDate.text.isNotEmpty) {
      try {
        firstDate = DateFormat('dd-MM-yyyy').parse(startDate.text);
      } catch (e) {
        log(e.toString());
        firstDate = now;
      }
    }
    if (initialDate.isBefore(firstDate)) {
      initialDate = firstDate;
    }
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      return DateFormat('dd-MM-yyyy').format(pickedDate);
    }
    return null;
  }

  Future<void> imageDialog(BuildContext context, type) async {
    return showDialog(
      barrierColor: Colors.white.withOpacity(.4),
      context: context,
      builder: (ctx) {
        return Material(
          type: MaterialType.transparency,
          color: Colors.grey.shade200,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(),
                ),
                height: 200,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const CircleAvatar(
                              radius: 10,
                              foregroundColor: AppColors.backgroundColor,
                              backgroundColor: AppColors.primaryColor,
                              child: Center(
                                child: Icon(
                                  Icons.close,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () async {
                            await context
                                .read<AddProjectCubit>()
                                .selectImage(ImageSource.camera, type);
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Camera",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        InkWell(
                          onTap: () async {
                            await context
                                .read<AddProjectCubit>()
                                .selectImage(null, type);
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Gallery",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
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
        );
      },
    );
  }

  Future<dynamic> addBudgetDialog(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: SizedBox(
            height: 350,
            child: Form(
              key: unitKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0, bottom: 25),
                      child: Text(
                        "Add Unit",
                        style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextFormField(
                        validator: (value) {
                          if (value == "") {
                            return "Enter unit name";
                          } else {
                            return null;
                          }
                        },
                        controller: name,
                        onTap: () {},
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(10),
                          labelText: 'Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.32,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextFormField(
                            controller: squareFeet,
                            validator: (value) {
                              if (value == "") {
                                return "Enter square feet";
                              } else {
                                return null;
                              }
                            },
                            onChanged: (value) {
                              amount.text = (double.parse(value) *
                                      double.parse(
                                          rate.text == "" ? "1" : rate.text))
                                  .toString();
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(10),
                              labelText: 'Square Feet',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.32,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextFormField(
                            validator: (value) {
                              if (value == "") {
                                return "Enter rate";
                              } else {
                                return null;
                              }
                            },
                            onChanged: (value) {
                              amount.text = (double.parse(value) *
                                      double.parse(squareFeet.text == ""
                                          ? "1"
                                          : squareFeet.text))
                                  .toString();
                            },
                            keyboardType: TextInputType.number,
                            controller: rate,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(10),
                              labelText: 'Rate',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextFormField(
                        onTap: () {},
                        readOnly: true,
                        controller: amount,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(10),
                          labelText: 'Amount',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (unitKey.currentState!.validate()) {
                          unitList.add({
                            "name": name.text,
                            "squareFeet": squareFeet.text,
                            "rate": rate.text,
                            "amount": amount.text,
                          });
                          calculateTotal();
                        }
                        Navigator.pop(context);
                        updateGst();
                      },
                      child: LargeButton(title: "Add"),
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
    );
  }

  void updateGst() {
    double amt = double.parse(estBudAmt == "" ? "0" : estBudAmt);
    double gstPercent = double.parse(gst ?? "0");
    double gstRate = (amt * gstPercent) / 100;
    gstAmt = gstRate.toString();
    totalAmt = (amt + gstRate).toString();
    setState(() {});
  }

  void calculateTotal() {
    averageRate = 0;
    totalSqFt = 0;
    totalRate = 0;
    totalAmount = 0;
    for (var unit in unitList) {
      double squareFeet = double.tryParse(unit["squareFeet"] ?? "0") ?? 0;
      double rate = double.tryParse(unit["rate"] ?? "0") ?? 0;
      double amount = double.tryParse(unit["amount"] ?? "0") ?? 0;

      totalSqFt += squareFeet;
      totalRate += rate;
      totalAmount += amount;
    }
    averageRate = unitList.isNotEmpty ? totalRate / totalSqFt : 0;
    estBudAmt = totalAmount.toString();
    totalAmt = totalAmount.toString();
    name.text = "";
    squareFeet.text = "";
    rate.text = "";
    amount.text = "";
  }
}

class CheckBoxWidget extends StatelessWidget {
  const CheckBoxWidget({
    super.key,
    required this.id,
    required this.title,
    required this.value,
  });

  final bool value;
  final String id;
  final String title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        try {
          context.read<AddProjectCubit>().updatePriority(id);
        } catch (e) {
          log(e.toString());
        }
      },
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment
        //     .start,
        children: [
          Checkbox(
            value: value,
            onChanged: (bool? newValue) {
              try {
                context.read<AddProjectCubit>().updatePriority(id);
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
      ),
    );
  }
}
