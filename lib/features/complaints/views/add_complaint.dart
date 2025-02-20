// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/widgets/buttons.dart';
import 'package:site_720/features/clients/cubit/client_cubit.dart';
import 'package:site_720/features/complaints/cubit/complaint_state.dart';

import '../../../core/widgets/appbar.dart';
import '../../../data/models/complaint/complaint_details_model.dart';
import '../cubit/add_complaint_cubit.dart';

class AddComplaint extends StatelessWidget {
  bool isChecked = false;
  String complaintType = "";
  String reportedBy = "";
  String natureOfComplaint = "";
  String complaintStatus = "";
  AddComplaint({super.key});
  final formKey = GlobalKey<FormState>();
  TextEditingController clientName = TextEditingController();
  TextEditingController projectName = TextEditingController();
  TextEditingController referenceNumber = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController locationArea = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController companyName = TextEditingController();
  TextEditingController civilId = TextEditingController();
  TextEditingController gstNumber = TextEditingController();
  dynamic selectedStaff;
  List filteredClientList = [];
  String clientId = "";

  List<ReportedBy> reportedByList = [];
  List<ComplaintNature> complaintNatureList = [];
  List<ComplaintStatus> complaintStatusList = [];
  List<ComplaintType> complaintTypesList = [];
  List<Staff> staffList = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddComplaintCubit(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: simpleAppbar(context, "Complaints", true),
        body: MultiBlocListener(
          listeners: [
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            // width: MediaQuery.of(context).size.width * 0.95, // Parent container width
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
                                        Text(
                                          "Complaint Type*",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: complaintTypesList.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, top: 5),
                                      child: CheckBoxWidget(
                                        id: complaintTypesList[index].id,
                                        title:
                                            complaintTypesList[index].typeName,
                                        value: complaintType ==
                                                complaintTypesList[index].id
                                            ? true
                                            : false,
                                        type: "type",
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            // width: MediaQuery.of(context).size.width * 0.95,
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
                                              "Complaint Reported by",
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
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: reportedByList.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, top: 5),
                                      child: CheckBoxWidget(
                                        id: reportedByList[index].id,
                                        title: reportedByList[index].reportedBy,
                                        value: reportedBy ==
                                                reportedByList[index].id
                                            ? true
                                            : false,
                                        type: "reportedBy",
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
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
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: TextFormField(
                                  readOnly: true,
                                  controller: clientName,
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
                                  controller: projectName,
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
                                  controller: projectName,
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
                                  controller: clientName,
                                  onTap: () async {
                                    DateTime? selectedDate =
                                        await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime(2101),
                                    );
                                    if (selectedDate != null) {
                                      clientName.text =
                                          "${selectedDate.toLocal()}"
                                              .split(' ')[0];
                                    }
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
                                        if (selectedDate != null) {
                                          clientName.text =
                                              "${selectedDate.toLocal()}"
                                                  .split(' ')[0];
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: TextFormField(
                                  controller: projectName,
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            // width: MediaQuery.of(context).size.width * 0.95,
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
                                              "Nature of complaint",
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
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: complaintNatureList.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, top: 5),
                                      child: CheckBoxWidget(
                                        id: complaintNatureList[index].id,
                                        title: complaintNatureList[index]
                                            .natureName,
                                        value: complaintType ==
                                                complaintNatureList[index].id
                                            ? true
                                            : false,
                                        type: "nature",
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
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
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 11.0),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.77,
                                      child: DropdownButtonFormField<String>(
                                        value: selectedStaff,
                                        onChanged: (value) async {
                                          selectedStaff = value.toString();
                                        },
                                        items: staffList.map((data) {
                                          return DropdownMenuItem<String>(
                                            value: data.id.toString(),
                                            child: Text(
                                              data.staffName.toString(),
                                            ),
                                          );
                                        }).toList(),
                                        decoration: InputDecoration(
                                          fillColor: Colors.white,
                                          filled: true,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          labelText: 'Select Staff',
                                          labelStyle: const TextStyle(
                                              color: Colors.grey, fontSize: 14),
                                          contentPadding:
                                              const EdgeInsets.only(left: 10),
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 10),

                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(40, 40),
                                        padding: const EdgeInsets.all(8),
                                        backgroundColor: Colors.grey[400],
                                        iconColor: Colors.black),
                                    child: const Icon(Icons.add, size: 20),
                                  ),

                                  //const SizedBox(width: 10),

                                  //  ElevatedButton(
                                  //   onPressed: () {

                                  //   },
                                  //   style: ElevatedButton.styleFrom(
                                  //     minimumSize: const Size(40, 40),
                                  //     padding: const EdgeInsets.all(8),
                                  //     backgroundColor: const Color.fromARGB(255, 221, 101, 101),
                                  //     iconColor:Colors.black
                                  //   ),
                                  //   child: const Icon(Icons.delete, size: 20),
                                  // ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: TextFormField(
                                  controller: projectName,
                                  keyboardType: TextInputType.text,
                                  maxLines: 5,
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    labelText: 'Enter Remark',
                                    prefixIcon: const Icon(
                                      Icons.text_fields_outlined,
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
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            // width: MediaQuery.of(context).size.width * 0.95,
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
                                              "Complaint Status*",
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
                                SizedBox(
                                  height: 20,
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: complaintStatusList.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, top: 5),
                                      child: CheckBoxWidget(
                                        id: complaintStatusList[index].id,
                                        title: complaintStatusList[index]
                                            .statusName,
                                        value: complaintType ==
                                                complaintStatusList[index].id
                                            ? true
                                            : false,
                                        type: "status",
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 35),
                        InkWell(
                            onTap: () {
                              context.read<ClientsCubit>().addClient(
                                    "",
                                    "",
                                  );
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
    return Row(
      // crossAxisAlignment: CrossAxisAlignment
      //     .start,
      children: [
        Checkbox(
          value: value,
          onChanged: (bool? newValue) {
            try {
              context.read<AddComplaintCubit>().updateComplaintType(id);
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
