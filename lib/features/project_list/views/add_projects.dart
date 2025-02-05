// ignore_for_file: must_be_immutable

import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/widgets/buttons.dart';
import 'package:site_720/core/widgets/shimmer.dart';
import '../../../core/widgets/appbar.dart';
import '../../../data/models/project_list/project_data_model.dart';
import '../../payment_details/widgets/amount_container.dart';
import '../cubit/project_list_cubit.dart';
import '../cubit/project_list_state.dart';

class AddProjectScreen extends StatelessWidget {
  AddProjectScreen({super.key});
  final formKey = GlobalKey<FormState>();
  TextEditingController clientName = TextEditingController();
  TextEditingController projectName = TextEditingController();
  TextEditingController referenceNumber = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController locationArea = TextEditingController();
  TextEditingController startDate = TextEditingController();
  TextEditingController completionDate = TextEditingController();
  TextEditingController companyName = TextEditingController();
  TextEditingController civilId = TextEditingController();
  TextEditingController cost = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController lpoNumber = TextEditingController();
  TextEditingController quotationNumber = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController squareFeet = TextEditingController();
  TextEditingController rate = TextEditingController();
  TextEditingController total = TextEditingController();
  final GlobalKey<FormState> budgetKey = GlobalKey<FormState>();
  String priority = "";
  dynamic type;
  dynamic category;
  dynamic package;
  dynamic bhk;
  List<Clients> clientList = [];
  List<Clients> filteredClientList = [];
  String clientId = "";
  String budgetMethord = 'Fixed Rate';
  List<Map<String, dynamic>> unitList = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProjectListCubit("", "", "add"),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: simpleAppbar(context, "Add Project"),
        body: BlocListener<ProjectListCubit, ProjectListState>(
          listener: (context, state) {
            if (state is PriorityUpdated) {
              priority = state.value;
            }
            if (state is ProjectDataSuccess) {
              filteredClientList = state.response.data.clientList;
              clientList = state.response.data.clientList;
            }
          },
          child: BlocBuilder<ProjectListCubit, ProjectListState>(
            builder: (context, state) {
              if (state is ProjectDataLoading) {
                return ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 10),
                      child: shimmerContainer(
                          55, MediaQuery.of(context).size.width * .8),
                    );
                  },
                );
              } else if (state is ProjectDataSuccess) {
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
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                labelText: 'Project name',
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
                              onChanged: (value) async {
                                type = value.toString();
                              },
                              items:
                                  state.response.data.projectList.map((data) {
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
                                labelText: 'Project type',
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
                              onChanged: (value) async {
                                category = value.toString();
                              },
                              items: state.response.data.projectCategory
                                  .map((data) {
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
                                labelText: 'Project category',
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
                                  // Custom border
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
                              controller: locationArea,
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
                          BlocBuilder<ProjectListCubit, ProjectListState>(
                            builder: (context, state) {
                              return Container(
                                width: MediaQuery.of(context).size.width * 0.92,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color.fromARGB(
                                              255, 209, 206, 206)
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
                                          value:
                                              priority == "1" ? true : false),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: CheckBoxWidget(
                                          id: "2",
                                          title: "Medium",
                                          value:
                                              priority == "2" ? true : false),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 10.0, left: 15),
                                        child: CheckBoxWidget(
                                            id: "3",
                                            title: "Low",
                                            value: priority == "3"
                                                ? true
                                                : false)),
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
                              items: state.response.data.packages.map((data) {
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
                                labelText: 'Package',
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
                              items: state.response.data.bhk.map((data) {
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
                                labelText: 'No of BHK',
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
                                          await selectDate(context);
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
                                          await selectDate(context);
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
                          InkWell(
                            onTap: () async {
                              imageDialog(context);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * .9,
                              height: 60,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(width: 10),
                                  const Icon(Icons.upload_file,
                                      color: Colors.grey),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: BlocBuilder<ProjectListCubit,
                                        ProjectListState>(
                                      builder: (context, state) {
                                        if (state is ProjectListLoading) {
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        } else if (state is ImageSuccess) {
                                          final images = state.imageList;
                                          return ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: images.length,
                                            itemBuilder: (context, index) {
                                              final image = images[index];
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Image.file(
                                                  File(image.path),
                                                  width: 40,
                                                  height: 40,
                                                  fit: BoxFit.cover,
                                                ),
                                              );
                                            },
                                          );
                                        } else if (state is ImageFailure) {
                                          return Center(
                                              child: Text(
                                            state.message,
                                            style: const TextStyle(
                                                color: Colors.red),
                                          ));
                                        } else {
                                          return const Text(
                                            'Upload Plan',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () async {
                              imageDialog(context);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * .9,
                              height: 60,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(width: 10),
                                  const Icon(Icons.upload_file,
                                      color: Colors.grey),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: BlocBuilder<ProjectListCubit,
                                        ProjectListState>(
                                      builder: (context, state) {
                                        if (state is ProjectListLoading) {
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        } else if (state is ImageSuccess) {
                                          final images = state.imageList;
                                          return ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: images.length,
                                            itemBuilder: (context, index) {
                                              final image = images[index];
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Image.file(
                                                  File(image.path),
                                                  width: 40,
                                                  height: 40,
                                                  fit: BoxFit.cover,
                                                ),
                                              );
                                            },
                                          );
                                        } else if (state is ImageFailure) {
                                          return Center(
                                              child: Text(
                                            state.message,
                                            style: const TextStyle(
                                                color: Colors.red),
                                          ));
                                        } else {
                                          return const Text(
                                            'Upload Elevation',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
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
                                        (context as Element).markNeedsBuild();
                                      },
                                    ),
                                    const Text("Fixed Rate"),
                                    Radio<String>(
                                      value: 'Unit Based Rate',
                                      groupValue: budgetMethord,
                                      onChanged: (value) {
                                        budgetMethord = value!;
                                        (context as Element).markNeedsBuild();
                                      },
                                    ),
                                    const Text("Unit Based Rate"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          budgetMethord == "Fixed Rate"
                              ? SizedBox(
                                  width: MediaQuery.sizeOf(context).width * .9,
                                  height: 50,
                                  child: TextFormField(
                                    controller: completionDate,
                                    keyboardType: TextInputType.number,
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
                                )
                              : Container(
                                  width:
                                      MediaQuery.of(context).size.width * .91,
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
                                            padding: const EdgeInsets.symmetric(
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
                                                    fontWeight: FontWeight.bold,
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
                                                          BorderRadius.circular(
                                                              5),
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
                                          ? ListView.builder(
                                              shrinkWrap: true,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              itemCount: unitList.length,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(6.0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      // Navigator.of(context)
                                                      //     .pushNamed(AppRoutes.stageHistory);
                                                    },
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .9,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.8),
                                                            blurRadius: 3,
                                                            offset:
                                                                const Offset(
                                                                    0, 3),
                                                          ),
                                                        ],
                                                      ),
                                                      child: SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            .7,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 8.0,
                                                                  left: 8.0,
                                                                  right: 8.0,
                                                                  bottom: 8.0),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                unitList[index]
                                                                    ['name'],
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  SmallContainer(
                                                                    title:
                                                                        "Square Feet",
                                                                    amount: unitList[
                                                                            index]
                                                                        [
                                                                        'squareFeet'],
                                                                  ),
                                                                  SmallContainer(
                                                                    title:
                                                                        "Rate",
                                                                    amount: unitList[
                                                                            index]
                                                                        [
                                                                        'rate'],
                                                                  ),
                                                                  SmallContainer(
                                                                    title:
                                                                        "Total",
                                                                    amount: unitList[
                                                                            index]
                                                                        [
                                                                        'total'],
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
                                            )
                                          : const Padding(
                                              padding: EdgeInsets.all(25.0),
                                              child: Text(
                                                "Empty !",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.primaryColor,
                                                ),
                                              ),
                                            )
                                    ],
                                  ),
                                ),
                          const SizedBox(
                            height: 20,
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
                                const Padding(
                                  padding: EdgeInsets.all(25.0),
                                  child: Text(
                                    "Empty !",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .9,
                            child: TextFormField(
                              controller: cost,
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  // Custom border
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                labelText: 'Cost',
                                prefixIcon: const Icon(
                                  Icons.currency_rupee,
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
                          InkWell(
                              onTap: () {},
                              child: LargeButton(title: "Submit")),
                          const SizedBox(
                            height: 25,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
      ),
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
                        // ignore: prefer_const_constructors
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: filteredClientList.length,
                        itemBuilder: (context, i) {
                          return ListTile(
                            onTap: () {
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

  selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      return DateFormat('dd-MM-yyyy').format(pickedDate);
    }
  }

  Future<void> imageDialog(
    BuildContext context,
  ) async {
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
                                .read<ProjectListCubit>()
                                .selectMultiImage(ImageSource.camera);
                            Navigator.pop(context);
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
                                .read<ProjectListCubit>()
                                .selectMultiImage(null);
                            Navigator.pop(context);
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
                                  "ProjectList",
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
              key: budgetKey,
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
                              total.text = (double.parse(value) *
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
                              total.text = (double.parse(value) *
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
                        controller: total,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(10),
                          labelText: 'Total',
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
                        if (budgetKey.currentState!.validate()) {
                          unitList.add({
                            "name": name.text,
                            "squareFeet": squareFeet.text,
                            "rate": rate.text,
                            "total": total.text,
                          });
                          name.text = "";
                          squareFeet.text = "";
                          rate.text = "";
                          total.text = "";
                          log(unitList.toString());
                        }
                        Navigator.pop(context);
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
    return Row(
      // crossAxisAlignment: CrossAxisAlignment
      //     .start,
      children: [
        Checkbox(
          value: value,
          onChanged: (bool? newValue) {
            context.read<ProjectListCubit>().updatePriority(id);
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
