// ignore_for_file: must_be_immutable

import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/features/dashboard/cubit/dasahboard_cubit.dart';
import 'package:site_720/features/dashboard/cubit/dashboard_state.dart';
import 'package:site_720/features/dashboard/widgets/pie_chart.dart';
import '../../../core/constants/routes.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/connectivity_dialog.dart';
import '../../connectivity/cubit/connectivity_cubit.dart';
import '../../connectivity/cubit/connectivity_state.dart';
import '../widgets/dash_container.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  TextEditingController searchController = TextEditingController();
  TextEditingController fdate = TextEditingController(
      text: DateFormat('dd-MM-yyyy').format(DateTime.now()));
  TextEditingController tdate = TextEditingController(
      text: DateFormat('dd-MM-yyyy').format(DateTime.now()));
  bool connStatus = false;

  List colors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.red,
  ];
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ConnectivityCubit, ConnectivityState>(
          listener: (context, state) {
            if (state is ConnectivityDisconnected) {
              connStatus = false;
              connectivityDialog(context);
            } else {
              connStatus = true;
            }
          },
        ),
      ],
      child: BlocProvider(
        create: (context) => DashboardCubit(fdate.text, tdate.text),
        child: Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.1),
            child: BlocBuilder<DashboardCubit, DashboardState>(
              builder: (context, state) {
                return Container(
                  decoration: BoxDecoration(
                      color: AppColors.secondaryColor,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade300,
                            offset: Offset.zero,
                            blurRadius: 1,
                            spreadRadius: 2)
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 60.0, left: 16.0, right: 16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            state is DashboardSuccess
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        state.response.data.username,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        state.response.data.designation,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1,
                                          fontFamily: "Lobster",
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      dashShimmer(
                                          15,
                                          MediaQuery.of(context).size.width *
                                              .3),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      dashShimmer(
                                          11,
                                          MediaQuery.of(context).size.width *
                                              .4),
                                    ],
                                  ),
                            Container(
                              width: 40,
                              height: 40,
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
                              child: const Icon(Icons.person),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          body: BlocBuilder<DashboardCubit, DashboardState>(
              builder: (context, state) {
            final cubit = context.read<DashboardCubit>();

            return RefreshIndicator(
              onRefresh: () async {
                cubit.getDashboard(fdate.text, tdate.text);
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: state is DashboardSuccess
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                    onTap: () {
                                      Navigator.of(context)
                                          .pushNamed(AppRoutes.projectList);
                                    },
                                    child: DashContainer(
                                      title: "Upcoming",
                                      count: state
                                          .response.data.projectCounts.upcoming,
                                    )),
                                DashContainer(
                                  title: "Running",
                                  count:
                                      state.response.data.projectCounts.running,
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                dashShimmer(
                                    85, MediaQuery.of(context).size.width * .4),
                                dashShimmer(
                                    85, MediaQuery.of(context).size.width * .4),
                              ],
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: state is DashboardSuccess
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                DashContainer(
                                  title: "Completed",
                                  count: state
                                      .response.data.projectCounts.completed,
                                ),
                                DashContainer(
                                  title: "Paid",
                                  count: "-----/-",
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                dashShimmer(
                                    85, MediaQuery.of(context).size.width * .4),
                                dashShimmer(
                                    85, MediaQuery.of(context).size.width * .4),
                              ],
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 25),
                      child: state is DashboardSuccess
                          ? Container(
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
                                                  "Complaints",
                                                  style: TextStyle(
                                                    fontSize: 12,
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
                                  DashboardPieChart(
                                    values: state.response.data.complaintCounts,
                                    colors: const [
                                      Colors.blue,
                                      Colors.orange,
                                      Colors.green,
                                      Colors.red,
                                    ],
                                    // labels: ["", "", "", ""],
                                  )
                                ],
                              ),
                            )
                          : dashShimmer(MediaQuery.of(context).size.height * .3,
                              MediaQuery.of(context).size.height * .9),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 25, bottom: 30),
                      child: state is DashboardSuccess
                          ? Container(
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
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: state.response.data
                                            .workissuesCounts.length,
                                        itemBuilder: (context, i) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 6.0, horizontal: 8.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.8),
                                                      blurRadius: 3,
                                                      offset:
                                                          const Offset(3, 3),
                                                    ),
                                                  ],
                                                  color:
                                                      AppColors.backgroundColor,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(8))),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12.0,
                                                        vertical: 8.0),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2.0),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            state
                                                                .response
                                                                .data
                                                                .workissuesCounts[
                                                                    i]
                                                                .workissueName,
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    LinearProgressIndicator(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      backgroundColor:
                                                          Colors.grey.shade400,
                                                      value: double.parse(state
                                                              .response
                                                              .data
                                                              .workissuesCounts[
                                                                  i]
                                                              .count) /
                                                          100,
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                              Color>(colors[i]),
                                                      minHeight: 5,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  )
                                ],
                              ),
                            )
                          : dashShimmer(MediaQuery.of(context).size.height * .4,
                              MediaQuery.of(context).size.height * .9),
                    )
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Future<dynamic> showDateRangeDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: SizedBox(
            height: 300,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 16.0, bottom: 25),
                    child: Text(
                      "Select Range",
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * .8,
                        height: 50,
                        child: TextFormField(
                          onTap: () async {
                            String? selectedDate = await selectDate(context);
                            if (selectedDate != null) {
                              fdate.text = selectedDate;
                              if (context.mounted) {}
                            }
                          },
                          readOnly: true,
                          controller: fdate,
                          decoration: const InputDecoration(
                              hintText: 'From Date',
                              contentPadding: EdgeInsets.all(10),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.primaryColor)),
                              suffixIcon: Icon(Icons.calendar_today,
                                  size: 20, color: AppColors.primaryColor)),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 50,
                        width: MediaQuery.sizeOf(context).width * .8,
                        child: TextFormField(
                          onTap: () async {
                            String? selectedDate = await selectDate(context);
                            if (selectedDate != null) {
                              tdate.text = selectedDate;
                              if (context.mounted) {}
                            }
                          },
                          readOnly: true,
                          controller: tdate,
                          decoration: const InputDecoration(
                              // labelText: 'To Date',
                              hintText: 'To Date',
                              contentPadding: EdgeInsets.all(10),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.primaryColor)),
                              suffixIcon: Icon(Icons.calendar_today,
                                  size: 20, color: AppColors.primaryColor)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () async {},
                    child: LargeButton(title: "Continue"),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Close'),
                  ),
                ],
              ),
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

  Widget dashShimmer(double height, double width) {
    return FadeShimmer(
      height: height,
      width: width,
      radius: 4,
      highlightColor: Colors.grey.shade800,
      baseColor: Colors.grey.shade300,
      fadeTheme: FadeTheme.light,
    );
  }
}
