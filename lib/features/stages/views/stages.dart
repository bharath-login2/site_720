// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:site_720/core/constants/colors.dart';

import '../../../core/constants/routes.dart';
import '../cubit/stages_cubit.dart';

class Stages extends StatelessWidget {
  Stages({super.key});
  TextEditingController searchController = TextEditingController();
  TextEditingController fdate = TextEditingController(
      text: DateFormat('dd-MM-yyyy').format(DateTime.now()));
  TextEditingController tdate = TextEditingController(
      text: DateFormat('dd-MM-yyyy').format(DateTime.now()));
  dynamic status;
  List<Map<String, dynamic>> statuses = [
    {"statusId": 101, "statusName": "status 1"},
    {"statusId": 102, "statusName": "status 2"},
    {"statusId": 103, "statusName": "status 3"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.2),
          child: Container(
            height: MediaQuery.of(context).size.height * .15,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/appbar.png"),
                    fit: BoxFit.fill),
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                )),
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 35, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        "Stages",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            fontFamily: "Lobster",
                            color: Colors.white),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      addStageDialog(context);
                    },
                    child: const CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.lightPrimary,
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        body: BlocProvider(
          create: (context) => StagesCubit(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
                  child: Container(
                    width: MediaQuery.of(context).size.width * .95,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.8),
                          blurRadius: 3,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search...',
                        hintStyle: TextStyle(fontSize: 14),
                        contentPadding: EdgeInsets.all(12),
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.search,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  itemCount: 15,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(AppRoutes.stageHistory);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * .9,
                          height: MediaQuery.of(context).size.height * .1,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.8),
                                blurRadius: 3,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  width: MediaQuery.of(context).size.width * .2,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    image: const DecorationImage(
                                        image: AssetImage(
                                            "assets/images/appbar.png"),
                                        fit: BoxFit.cover),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.8),
                                        blurRadius: 6,
                                        offset: const Offset(1, 1),
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.center,
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "18",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.backgroundColor),
                                      ),
                                      Text(
                                        "Est Days",
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.backgroundColor),
                                      )
                                    ],
                                  )),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .7,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0,
                                      left: 8.0,
                                      right: 8.0,
                                      bottom: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all()),
                                              alignment: Alignment.center,
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0,
                                                    vertical: 3.0),
                                                child: Text(
                                                  "Bedroom",
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: AppColors.coffie),
                                                ),
                                              )),
                                          Row(
                                            children: [
                                              Container(
                                                height: 25,
                                                width: 25,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: AppColors.primaryColor,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.8),
                                                      blurRadius: 6,
                                                      offset:
                                                          const Offset(1, 1),
                                                    ),
                                                  ],
                                                ),
                                                child: const Icon(
                                                  Icons.add,
                                                  size: 18,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 7,
                                              ),
                                              Container(
                                                height: 25,
                                                width: 25,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: AppColors.lightBlue,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.8),
                                                      blurRadius: 6,
                                                      offset:
                                                          const Offset(1, 1),
                                                    ),
                                                  ],
                                                ),
                                                child: const Icon(
                                                  Icons.analytics_outlined,
                                                  size: 18,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      Row(
                                        // mainAxisAlignment:
                                        //     MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            "Created by",
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: AppColors.coffie,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.8),
                                                    blurRadius: 6,
                                                    offset: const Offset(1, 1),
                                                  ),
                                                ],
                                              ),
                                              alignment: Alignment.center,
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10.0,
                                                ),
                                                child: Text(
                                                  "Pradeesh mon bino",
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> addStageDialog(BuildContext context) async {
    return showDialog(
      barrierColor: Colors.white.withOpacity(.4),
      context: context,
      builder: (context) {
        return Material(
          type: MaterialType.transparency,
          color: Colors.grey.shade200,
          child: Padding(
            padding: const EdgeInsets.all(8.0), 
            child: Center(
              child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  height: 250,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                    children: [
                      Container(
                          height: 50,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              )),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // SizedBox(),
                                const Text(
                                  "Add Stage",
                                  style: TextStyle(
                                      color: AppColors.backgroundColor,
                                      fontSize: 16),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: const CircleAvatar(
                                    radius: 10,
                                    backgroundColor: AppColors.backgroundColor,
                                    foregroundColor: AppColors.primaryColor,
                                    child: Center(
                                        child: Icon(
                                      Icons.close,
                                      size: 16,
                                    )),
                                  ),
                                )
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .8,
                              height: MediaQuery.of(context).size.width * .105,
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
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  labelText: 'Select Status',
                                  labelStyle:
                                      const TextStyle(color: Colors.grey),
                                  contentPadding: const EdgeInsets.only(
                                      left: 10, top: 2, bottom: 2),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: MediaQuery.sizeOf(context).width * .37,
                                  height: 40,
                                  child: TextFormField(
                                    onTap: () async {
                                      String? selectedDate =
                                          await selectDate(context);
                                      if (selectedDate != null) {
                                        fdate.text = selectedDate;
                                        if (context.mounted) {
                                          context
                                              .read<StagesCubit>()
                                              .updateFromDate(selectedDate);
                                        }
                                      }
                                    },
                                    readOnly: true,
                                    controller: fdate,
                                    decoration: const InputDecoration(
                                        hintText: 'From Date',
                                        contentPadding: EdgeInsets.all(10),
                                        border: OutlineInputBorder(),
                                        suffixIcon: Icon(
                                          Icons.calendar_today,
                                          size: 20,
                                        )),
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                  width: MediaQuery.sizeOf(context).width * .37,
                                  child: TextFormField(
                                    onTap: () async {
                                      String? selectedDate =
                                          await selectDate(context);
                                      if (selectedDate != null) {
                                        tdate.text = selectedDate;
                                        if (context.mounted) {
                                          context
                                              .read<StagesCubit>()
                                              .updateToDate(selectedDate);
                                        }
                                      }
                                    },
                                    readOnly: true,
                                    controller: tdate,
                                    decoration: const InputDecoration(
                                        hintText: 'To Date',
                                        contentPadding: EdgeInsets.all(10),
                                        border: OutlineInputBorder(),
                                        suffixIcon: Icon(
                                          Icons.calendar_today,
                                          size: 20,
                                        )),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 40,
                              width: MediaQuery.sizeOf(context).width * .5,
                              decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(5)),
                              child: const Center(
                                child: Text(
                                  "Continue",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        );
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
}
