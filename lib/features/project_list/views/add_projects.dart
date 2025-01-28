// ignore_for_file: must_be_immutable

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/widgets/buttons.dart';
import '../../../core/widgets/appbar.dart';
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
  TextEditingController fdate = TextEditingController();
  TextEditingController tdate = TextEditingController();
  final GlobalKey<FormState> budgetKey = GlobalKey<FormState>();
  String priority = "";
  dynamic status;
  List filteredClientList = [];
  String clientId = "";
  List<Map<String, dynamic>> statuses = [
    {"statusId": 101, "statusName": "status 1"},
    {"statusId": 102, "statusName": "status 2"},
    {"statusId": 103, "statusName": "status 3"},
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProjectListCubit("", ""),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: simpleAppbar(context, "Add Project"),
        body: BlocListener<ProjectListCubit, ProjectListState>(
          listener: (context, state) {
            if (state is PriorityUpdated) {
              priority = state.value;
            }
          },
          child: SingleChildScrollView(
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
                          selectClientDialog(context);
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
                          labelStyle:
                              const TextStyle(color: Colors.grey, fontSize: 14),
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
                          labelStyle:
                              const TextStyle(color: Colors.grey, fontSize: 14),
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
                        value: status,
                        onChanged: (value) async {
                          status = value.toString();
                        },
                        items: statuses.map((data) {
                          return DropdownMenuItem<String>(
                            value: data["statusId"].toString(),
                            child: Text(
                              data["statusName"].toString(),
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
                          labelStyle:
                              const TextStyle(color: Colors.grey, fontSize: 14),
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
                        value: status,
                        onChanged: (value) async {
                          status = value.toString();
                        },
                        items: statuses.map((data) {
                          return DropdownMenuItem<String>(
                            value: data["statusId"].toString(),
                            child: Text(
                              data["statusName"].toString(),
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
                          labelStyle:
                              const TextStyle(color: Colors.grey, fontSize: 14),
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
                          labelStyle:
                              const TextStyle(color: Colors.grey, fontSize: 14),
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
                          labelStyle:
                              const TextStyle(color: Colors.grey, fontSize: 14),
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
                          labelStyle:
                              const TextStyle(color: Colors.grey, fontSize: 14),
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
                          labelStyle:
                              const TextStyle(color: Colors.grey, fontSize: 14),
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
                            color: const Color.fromARGB(255, 255, 255, 255),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 209, 206, 206)
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
                                padding:
                                    const EdgeInsets.only(left: 15, top: 10),
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
                                      value: priority == "3" ? true : false)),
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
                        value: status,
                        onChanged: (value) async {
                          status = value.toString();
                        },
                        items: statuses.map((data) {
                          return DropdownMenuItem<String>(
                            value: data["statusId"].toString(),
                            child: Text(
                              data["statusName"].toString(),
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
                          labelStyle:
                              const TextStyle(color: Colors.grey, fontSize: 14),
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
                        value: status,
                        onChanged: (value) async {
                          status = value.toString();
                        },
                        items: statuses.map((data) {
                          return DropdownMenuItem<String>(
                            value: data["statusId"].toString(),
                            child: Text(
                              data["statusName"].toString(),
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
                          labelStyle:
                              const TextStyle(color: Colors.grey, fontSize: 14),
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
                                      size: 18, color: AppColors.primaryColor)),
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
                                      size: 18, color: AppColors.primaryColor)),
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
                            const Icon(Icons.upload_file, color: Colors.grey),
                            const SizedBox(width: 10),
                            Expanded(
                              child: BlocBuilder<ProjectListCubit,
                                  ProjectListState>(
                                builder: (context, state) {
                                  if (state is ProjectListLoading) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (state is ImageSuccess) {
                                    final images = state.imageList;
                                    return ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: images.length,
                                      itemBuilder: (context, index) {
                                        final image = images[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.file(
                                            File(image.path),
                                            width: 40,
                                            height: 40,
                                            fit: BoxFit.cover,
                                          ),
                                        );
                                      },
                                    );
                                  } else if (state is ProjectListFailure) {
                                    return Center(
                                        child: Text(
                                      state.message,
                                      style: const TextStyle(color: Colors.red),
                                    ));
                                  } else {
                                    return const Text(
                                      'Upload Plan',
                                      style: TextStyle(color: Colors.grey),
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
                            const Icon(Icons.upload_file, color: Colors.grey),
                            const SizedBox(width: 10),
                            Expanded(
                              child: BlocBuilder<ProjectListCubit,
                                  ProjectListState>(
                                builder: (context, state) {
                                  if (state is ProjectListLoading) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (state is ImageSuccess) {
                                    final images = state.imageList;
                                    return ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: images.length,
                                      itemBuilder: (context, index) {
                                        final image = images[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.file(
                                            File(image.path),
                                            width: 40,
                                            height: 40,
                                            fit: BoxFit.cover,
                                          ),
                                        );
                                      },
                                    );
                                  } else if (state is ProjectListFailure) {
                                    return Center(
                                        child: Text(
                                      state.message,
                                      style: const TextStyle(color: Colors.red),
                                    ));
                                  } else {
                                    return const Text(
                                      'Upload Elevation',
                                      style: TextStyle(color: Colors.grey),
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
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Budget",
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
                                              BorderRadius.circular(5),
                                          color: AppColors.lightA,
                                        ),
                                        child: const Icon(
                                          Icons.add,
                                          size: 18,
                                          color: AppColors.primaryColor,
                                        ),
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
                          labelStyle:
                              const TextStyle(color: Colors.grey, fontSize: 14),
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
                          labelStyle:
                              const TextStyle(color: Colors.grey, fontSize: 14),
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
                          labelStyle:
                              const TextStyle(color: Colors.grey, fontSize: 14),
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
                          labelStyle:
                              const TextStyle(color: Colors.grey, fontSize: 14),
                          contentPadding: const EdgeInsets.only(left: 10),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    InkWell(onTap: () {}, child: LargeButton(title: "Submit")),
                    const SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              ),
            ),
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
              height: MediaQuery.of(context).size.height * .6,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'Clients',
                      // style: TextingStyle.font18BoldBlack,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                      autocorrect: false,
                      keyboardType: TextInputType.visiblePassword,
                      autofocus: true,
                      onChanged: (value) {
                        setState(() {});
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
                        itemCount: 5,
                        itemBuilder: (context, i) {
                          return ListTile(
                            onTap: () {},
                            title: const Text(
                              "Pradeesh",
                              style: TextStyle(color: AppColors.primaryColor),
                            ),
                            subtitle: const Text("C R Manager",
                                style:
                                    TextStyle(color: AppColors.primaryColor)),
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
                        "Budget",
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
                            return "Select phase";
                          } else {
                            return null;
                          }
                        },
                        onTap: () {
                          // selectStageDialog(context).then((_) {});
                        },
                        readOnly: true,
                        // controller: stageController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(10),
                          labelText: 'Select Phase',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
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
                        validator: (value) {
                          if (value == "") {
                            return "Enter amount";
                          } else {
                            return null;
                          }
                        },
                        onTap: () {
                          // selectProductsDialog(context).then((_) {});
                        },
                        readOnly: true,
                        // controller: productController,
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
                            // controller: unitController,
                            readOnly: true,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(10),
                              labelText: 'Due Date',
                              border: OutlineInputBorder(
                                // borderSide: const BorderSide(
                                //     color: ColorConstant.greyyy),
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
                            // controller: qtyController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(10),
                              labelText: 'Completion Date',
                              // labelStyle: TextingStyle.font14NormalBlack,

                              // fillColor: ColorConstant.greyyy,
                              border: OutlineInputBorder(
                                // borderSide: const BorderSide(
                                //     color: ColorConstant.greyyy),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (budgetKey.currentState!.validate()) {}
                      },
                      child: LargeButton(title: "Add"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // stageController.clear();
                        // productController.clear();
                        // unitController.clear();
                        // qtyController.clear();
                        // amountController.clear();
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
