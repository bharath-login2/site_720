// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/widgets/buttons.dart';
import 'package:site_720/features/clients/cubit/client_cubit.dart';

import '../../../core/widgets/appbar.dart';

class AddComplaint extends StatelessWidget {
  bool isChecked = false;
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
  dynamic status;
  List filteredClientList = [];
  String clientId = "";
  List<Map<String, dynamic>> statuses = [
    {"statusId": 101, "statusName": "Staff 1"},
    {"statusId": 102, "statusName": "Staff 2"},
    {"statusId": 103, "statusName": "Staff 3"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: simpleAppbar(context, "Complaints",true),
      body: SingleChildScrollView(
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
                          width: double
                              .infinity,
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
                                      "Complaint Type*",
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
                          padding: const EdgeInsets.all(
                              15.0), 
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment
                                .start, 
                            children: [
                              Checkbox(
                                value:
                                    false, 
                                onChanged: (bool? newValue) {
                                 
                                },
                              ),
                              const Expanded(
                                child: Text(
                                  "A: medium-level issues that might require discussion with project coordinators and Supervisor",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 59, 58, 58),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(
                              15.0), 
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment
                                .start, 
                            children: [
                              Checkbox(
                                value:
                                    false,
                                onChanged: (bool? newValue) {
                                  
                                },
                              ),
                              const Expanded(
                                child: Text(
                                  "B: major cases requiring the involvement of key personnel, including Project Managers, Accounts Managers, and Administration:",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 59, 58, 58),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(
                              15.0), 
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment
                                .start,
                            children: [
                              Checkbox(
                                value:
                                    false, 
                                onChanged: (bool? newValue) {
                                  
                                },
                              ),
                              const Expanded(
                                child: Text(
                                  "C: (Major cases requiring involvement of key personnel including Case Managers, Managers, and HR.)",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 59, 58, 58),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(
                              15.0), 
                          child: Row(
                            // crossAxisAlignment: CrossAxisAlignment.start, 
                            children: [
                              Checkbox(
                                value:
                                    false,
                                onChanged: (bool? newValue) {
                                 
                                },
                              ),
                              const Expanded(
                                child: Text(
                                  "Others",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ),
                              ),
                            ],
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
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    // width: MediaQuery.of(context).size.width * 0.95, 
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
                          width: double
                              .infinity,
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
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: 10.0, left: 15),
                          child: Row(
                            // crossAxisAlignment: CrossAxisAlignment
                            //     .start,
                            children: [
                              Checkbox(
                                value: false,
                                onChanged: (bool? newValue) {},
                              ),
                              const Expanded(
                                child: Text(
                                  "CLIENT",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 59, 58, 58),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: 10.0, left: 15),
                          child: Row(
                            // crossAxisAlignment: CrossAxisAlignment
                            //     .start,
                            children: [
                              Checkbox(
                                value: false,
                                onChanged: (bool? newValue) {},
                              ),
                              const Expanded(
                                child: Text(
                                  "ADMIN",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 59, 58, 58),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: 10.0, left: 15),
                          child: Row(
                            //  crossAxisAlignment: CrossAxisAlignment
                            //  .start,
                            children: [
                              Checkbox(
                                value: false,
                                onChanged: (bool? newValue) {},
                              ),
                              const Expanded(
                                child: Text(
                                  "SUPERVISOR",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 59, 58, 58),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                            contentPadding: const EdgeInsets.only(left: 10),
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
                            contentPadding: const EdgeInsets.only(left: 10),
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
                            contentPadding: const EdgeInsets.only(left: 10),
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
                            DateTime? selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2101),
                            );
                            if (selectedDate != null) {
                              clientName.text =
                                  "${selectedDate.toLocal()}".split(' ')[0];
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
                            contentPadding: const EdgeInsets.only(left: 10),
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
                                DateTime? selectedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(2101),
                                );
                                if (selectedDate != null) {
                                  clientName.text =
                                      "${selectedDate.toLocal()}".split(' ')[0];
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
                            contentPadding: const EdgeInsets.only(left: 10),
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
                          width: double
                              .infinity, 
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
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0, left: 15),
                          child: Row(
                            // crossAxisAlignment: CrossAxisAlignment
                            //     .start,
                            children: [
                              Checkbox(
                                value: false,
                                onChanged: (bool? newValue) {},
                              ),
                              const Expanded(
                                child: Text(
                                  "Construction",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 59, 58, 58),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: 10.0, left: 15),
                          child: Row(
                            // crossAxisAlignment: CrossAxisAlignment
                            //     .start,
                            children: [
                              Checkbox(
                                value: false,
                                onChanged: (bool? newValue) {},
                              ),
                              const Expanded(
                                child: Text(
                                  "Service Related",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 59, 58, 58),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: 10.0, left: 15),
                          child: Row(
                            //  crossAxisAlignment: CrossAxisAlignment
                            //  .start,
                            children: [
                              Checkbox(
                                value: false,
                                onChanged: (bool? newValue) {},
                              ),
                              const Expanded(
                                child: Text(
                                  "Staff Behavior",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 59, 58, 58),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0, left: 15),
                          child: Row(
                            //  crossAxisAlignment: CrossAxisAlignment
                            //  .start,
                            children: [
                              Checkbox(
                                value: false,
                                onChanged: (bool? newValue) {},
                              ),
                              const Expanded(
                                child: Text(
                                  "Rate Issue",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 59, 58, 58),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: 10.0, left: 15),
                          child: Row(
                            //  crossAxisAlignment: CrossAxisAlignment
                            //  .start,
                            children: [
                              Checkbox(
                                value: false,
                                onChanged: (bool? newValue) {},
                              ),
                              const Expanded(
                                child: Text(
                                  "Other",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 59, 58, 58),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                              width: MediaQuery.of(context).size.width * 0.77,
                              child: DropdownButtonFormField<String>(
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
                                    borderRadius: BorderRadius.circular(5),
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
                            contentPadding: const EdgeInsets.only(left: 10),
                          ),
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
                                width: double
                                    .infinity,
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
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 5.0, left: 15),
                                child: Row(
                                  // crossAxisAlignment: CrossAxisAlignment
                                  //     .start,
                                  children: [
                                    Checkbox(
                                      value: false,
                                      onChanged: (bool? newValue) {},
                                    ),
                                    const Expanded(
                                      child: Text(
                                        "New",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromARGB(255, 59, 58, 58),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 10.0, left: 15),
                                child: Row(
                                  // crossAxisAlignment: CrossAxisAlignment
                                  //     .start,
                                  children: [
                                    Checkbox(
                                      value: false,
                                      onChanged: (bool? newValue) {},
                                    ),
                                    const Expanded(
                                      child: Text(
                                        "Pending",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromARGB(255, 59, 58, 58),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 10.0, left: 15),
                                child: Row(
                                  //  crossAxisAlignment: CrossAxisAlignment
                                  //  .start,
                                  children: [
                                    Checkbox(
                                      value: false,
                                      onChanged: (bool? newValue) {},
                                    ),
                                    const Expanded(
                                      child: Text(
                                        "Rejected",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromARGB(255, 59, 58, 58),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 5.0, left: 15),
                                child: Row(
                                  //  crossAxisAlignment: CrossAxisAlignment
                                  //  .start,
                                  children: [
                                    Checkbox(
                                      value: false,
                                      onChanged: (bool? newValue) {},
                                    ),
                                    const Expanded(
                                      child: Text(
                                        "Closed",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromARGB(255, 59, 58, 58),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
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
      ),
    );
  }
}
