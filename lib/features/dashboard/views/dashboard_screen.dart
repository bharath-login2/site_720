// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/features/dashboard/cubit/dasahboard_cubit.dart';
import 'package:site_720/features/dashboard/cubit/dashboard_state.dart';
import 'package:site_720/features/dashboard/widgets/pie_chart.dart';

import '../widgets/dash_container.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  TextEditingController searchController = TextEditingController();
  TextEditingController fdate = TextEditingController(
      text: DateFormat('dd-MM-yyyy').format(DateTime.now()));
  TextEditingController tdate = TextEditingController(
      text: DateFormat('dd-MM-yyyy').format(DateTime.now()));

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardCubit(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: BlocBuilder<DashboardCubit, DashboardState>(
            builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration:
                      const BoxDecoration(color: AppColors.secondaryColor),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 80.0, bottom: 16.0, left: 16.0, right: 16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "DEMO",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "PRADEESH",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    // color: AppColors.primaryColor,
                                    letterSpacing: 1,
                                    fontFamily: "Lobster",
                                  ),
                                ),
                              ],
                            ),
                            Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: AppColors.backgroundColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.8),
                                      blurRadius: 6,
                                      offset: const Offset(3, 3),
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: const Icon(Icons.person)),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * .75,
                              height: 45,
                              decoration: BoxDecoration(
                                  color: AppColors.search,
                                  borderRadius: BorderRadius.circular(8)),
                              child: TextFormField(
                                controller: searchController,
                                decoration: const InputDecoration(
                                    hintText: 'Search...',
                                    contentPadding: EdgeInsets.all(10),
                                    border: InputBorder.none,
                                    prefixIcon: Icon(Icons.search)),
                              ),
                            ),
                            Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: AppColors.coffie,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.8),
                                      blurRadius: 6,
                                      offset: const Offset(1, 1),
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.tune,
                                  color: Colors.white,
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DashContainer(
                        title: "Upcoming",
                        count: "100",
                      ),
                      DashContainer(
                        title: "Running",
                        count: "500",
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DashContainer(
                        title: "Completed",
                        count: "50",
                      ),
                      DashContainer(
                        title: "Paid",
                        count: "500/-",
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 16.0, top: 25),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColors.lightA,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.8),
                          blurRadius: 3,
                          offset: const Offset(0, 3),
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
                              color: AppColors.dashContainer,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 6.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Overall Progress",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          // color: AppColors.coffie,
                                        ),
                                      ),
                                      Text(
                                        "from ${fdate.text} To ${tdate.text}",
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          // color: AppColors.coffie,
                                        ),
                                      ),
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () {
                                      showDateRangeDialog(context);
                                    },
                                    child: const Icon(
                                      Icons.calendar_month,
                                      color: AppColors.coffie,
                                    ),
                                  )
                                ],
                              ),
                            )),
                        const DashboardPieChart(
                          values: [60, 40, 50, 100],
                          colors: [
                            Colors.blue,
                            Colors.green,
                            Colors.orange,
                            Colors.red,
                          ],
                          // labels: ["", "", "", ""],
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16.0, top: 25, bottom: 30),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColors.backgroundColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.8),
                          blurRadius: 3,
                          offset: const Offset(0, 3),
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
                              color: AppColors.dashContainer,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 6.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Work issues",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          // color: AppColors.coffie,
                                        ),
                                      ),
                                      Text(
                                        "from ${fdate.text} To ${tdate.text}",
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          // color: AppColors.coffie,
                                        ),
                                      ),
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () {
                                      showDateRangeDialog(context);
                                    },
                                    child: const Icon(
                                      Icons.calendar_month,
                                      color: AppColors.coffie,
                                    ),
                                  )
                                ],
                              ),
                            )),
                        ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 3,
                            itemBuilder: (context, i) {
                              return Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.8),
                                          blurRadius: 3,
                                          offset: const Offset(3, 3),
                                        ),
                                      ],
                                      color: AppColors.backgroundColor,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(2.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                "Company issue",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                        LinearProgressIndicator(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          backgroundColor: Colors.grey.shade400,
                                          value: double.parse("40") / 100,
                                          valueColor:
                                              const AlwaysStoppedAnimation<
                                                  Color>(Colors.blue),
                                          minHeight: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            })
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }

  Future<void> showDateRangeDialog(BuildContext context) async {
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
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all()),
                  height: 200,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                    children: [
                      Container(
                          height: 50,
                          width: double.infinity,
                          color: AppColors.primaryColor,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // SizedBox(),
                                const Text(
                                  "Select Range",
                                  style: TextStyle(
                                      color: AppColors.backgroundColor,
                                      fontSize: 20),
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
                        height: 140,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
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
                                              .read<DashboardCubit>()
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
                                              .read<DashboardCubit>()
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
