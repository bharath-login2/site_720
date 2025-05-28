// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/widgets/dialogs.dart';
import 'package:site_720/features/dashboard/cubit/dasahboard_cubit.dart';
import 'package:site_720/features/dashboard/cubit/dashboard_state.dart';
import 'package:site_720/features/dashboard/widgets/pie_chart.dart';
import '../../../core/constants/routes.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/connectivity_dialog.dart';
import '../../../core/widgets/shimmer.dart';
import '../../connectivity/cubit/connectivity_cubit.dart';
import '../../connectivity/cubit/connectivity_state.dart';
import '../widgets/dash_container.dart';
import '../widgets/date_container.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  TextEditingController searchController = TextEditingController();
  TextEditingController fdate = TextEditingController();
  TextEditingController tdate = TextEditingController();

  List colors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.red,
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardCubit(fdate.text, tdate.text),
      child: MultiBlocListener(
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
        ],
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
                      // image: DecorationImage(
                      //     image: AssetImage("assets/images/appbar.png"),
                      //     fit: BoxFit.fill),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    logOut(context);
                                  },
                                  child: Container(
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
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
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
                                          shimmerContainer(
                                              15,
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .3),
                                          const SizedBox(
                                            height: 5.0,
                                          ),
                                          shimmerContainer(
                                              11,
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .4),
                                        ],
                                      ),
                              ],
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.notification,
                                    );
                                  },
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: AppColors.lightA,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.8),
                                          blurRadius: 6,
                                          offset: const Offset(3, 3),
                                        ),
                                      ],
                                    ),
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.notifications,
                                      color: AppColors.primaryColor,
                                      size: 18,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    final dashboardCubit =
                                        BlocProvider.of<DashboardCubit>(
                                            context);
                                    showDateRangeDialog(
                                        context, dashboardCubit);
                                  },
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: AppColors.primaryColor,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.8),
                                          blurRadius: 6,
                                          offset: const Offset(3, 3),
                                        ),
                                      ],
                                    ),
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.calendar_month,
                                      color: AppColors.lightA,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
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
                      padding: const EdgeInsets.only(top: 30.0),
                      child: state is DashboardSuccess
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  child: DateContainer(
                                    count: state.response.data.fromDate.isEmpty
                                        ? DateFormat('dd-MM-yyyy')
                                            .format(DateTime.now())
                                        : state.response.data.fromDate,
                                  ),
                                ),
                                const SizedBox(
                                    width:
                                        10), 
                                const Text(
                                  "To",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                    width:
                                        10), // Adds some space between the "To" and the second date
                                InkWell(
                                  child: DateContainer(
                                    count: state.response.data.toDate.isEmpty
                                        ? DateFormat('dd-MM-yyyy')
                                            .format(DateTime.now())
                                        : state.response.data.toDate,
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                shimmerContainer(
                                    85, MediaQuery.of(context).size.width * .4),
                                shimmerContainer(
                                    85, MediaQuery.of(context).size.width * .4),
                              ],
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: state is DashboardSuccess
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                          AppRoutes.projectList,
                                          arguments: {
                                            "status": "upcoming",
                                          });
                                    },
                                    child: DashContainer(
                                      title: "Upcoming",
                                      count: state
                                          .response.data.projectCounts.upcoming,
                                    )),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        AppRoutes.projectList,
                                        arguments: {
                                          "status": "running",
                                        });
                                  },
                                  child: DashContainer(
                                    title: "Running",
                                    count: state
                                        .response.data.projectCounts.running,
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                shimmerContainer(
                                    85, MediaQuery.of(context).size.width * .4),
                                shimmerContainer(
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
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        AppRoutes.projectList,
                                        arguments: {
                                          "status": "completed",
                                        });
                                  },
                                  child: DashContainer(
                                    title: "Completed",
                                    count: state
                                        .response.data.projectCounts.completed,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        AppRoutes.projectList,
                                        arguments: {
                                          "status": "all",
                                        });
                                  },
                                  child: DashContainer(
                                    title: "All",
                                    count:
                                        state.response.data.projectCounts.all,
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                shimmerContainer(
                                    85, MediaQuery.of(context).size.width * .4),
                                shimmerContainer(
                                    85, MediaQuery.of(context).size.width * .4),
                              ],
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16.0,
                        right: 16.0,
                        top: 25,
                      ),
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
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 12.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Expense",
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                // color: AppColors.coffie,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                  state.response.data.expenseData.isNotEmpty
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 16),
                                          child: SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .23,
                                            child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                padding: EdgeInsets.zero,
                                                shrinkWrap: true,
                                                itemCount: state.response.data
                                                    .expenseData.length,
                                                itemBuilder: (context, i) {
                                                  return Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 6.0,
                                                        horizontal: 6.0),
                                                    child: InkWell(
                                                      onTap: () {
                                                        // connStatus = true;
                                                        Navigator.pushNamed(
                                                            context,
                                                            AppRoutes.expense,
                                                            arguments: {
                                                              "id": state
                                                                  .response
                                                                  .data
                                                                  .expenseData[
                                                                      i]
                                                                  .projectId,
                                                                    "expenseid": state
                                                                  .response
                                                                  .data
                                                                  .expenseData[
                                                                      i]
                                                                  .expenseHeadId,
                                                                    "type":state
                                                                  .response
                                                                  .data
                                                                  .expenseData[
                                                                      i]
                                                                  .expenseName
                                                            });
                                                      },
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            "${state.response.data.expenseData[i].percentage}%",
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 14),
                                                          ),
                                                          Container(
                                                            width: 60,
                                                            height: double.parse(state
                                                                    .response
                                                                    .data
                                                                    .expenseData[
                                                                        i]
                                                                    .percentage) *
                                                                1,
                                                            decoration: BoxDecoration(
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
                                                                            3,
                                                                            3),
                                                                  ),
                                                                ],
                                                                color: AppColors
                                                                    .primaryColor,
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .all(
                                                                        Radius.circular(
                                                                            8))),
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                state
                                                                    .response
                                                                    .data
                                                                    .expenseData[
                                                                        i]
                                                                    .count,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        14),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          SizedBox(
                                                            width: 80,
                                                            child: Text(
                                                              state
                                                                  .response
                                                                  .data
                                                                  .expenseData[
                                                                      i]
                                                                  .expenseName,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 10),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }),
                                          ),
                                        )
                                      : const Padding(
                                          padding: EdgeInsets.all(25.0),
                                          child: Text(
                                            "No Expenses !",
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primaryColor,
                                            ),
                                          ),
                                        )
                                ],
                              ),
                            )
                          : shimmerContainer(
                              MediaQuery.of(context).size.height * .4,
                              MediaQuery.of(context).size.height * .9),
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
                                                if (fdate.text != '' &&
                                                    tdate.text != '')
                                                  Text(
                                                    "from ${fdate.text} To ${tdate.text}",
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      // color: AppColors.coffie,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )),
                                  state.response.data.complaintCounts.isNotEmpty
                                      ? DashboardPieChart(
                                          values: state
                                              .response.data.complaintCounts,
                                          colors: const [
                                            Colors.blue,
                                            Colors.orange,
                                            Colors.green,
                                            Colors.red,
                                          ],
                                          // labels: ["", "", "", ""],
                                        )
                                      : const Padding(
                                          padding: EdgeInsets.all(25.0),
                                          child: Text(
                                            "No Complaints !",
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primaryColor,
                                            ),
                                          ),
                                        ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.of(context).pushNamed(
                                                AppRoutes.complaintList);
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .35,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .105,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: AppColors.primaryColor,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.8),
                                                  blurRadius: 6,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            alignment: Alignment.center,
                                            child: const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Complaint List",
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.lightA,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Icon(
                                                  Icons.arrow_forward,
                                                  color: Colors.white,
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          : shimmerContainer(
                              MediaQuery.of(context).size.height * .3,
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
                                                if (fdate.text != '' &&
                                                    tdate.text != '')
                                                  Text(
                                                    "from ${fdate.text} To ${tdate.text}",
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      // color: AppColors.coffie,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )),
                                  if (state.response.data.workissuesCounts
                                      .isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 16),
                                      child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: state.response.data
                                              .workissuesCounts.length,
                                          itemBuilder: (context, i) {
                                            final double totalCount = state
                                                .response.data.workissuesCounts
                                                .fold(
                                                    0,
                                                    (sum, item) =>
                                                        sum +
                                                        double.parse(
                                                            item.count));
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 6.0,
                                                      horizontal: 8.0),
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.of(context)
                                                      .pushNamed(
                                                          AppRoutes
                                                              .workIssuesList,
                                                          arguments: {
                                                        "status_id": state
                                                            .response
                                                            .data
                                                            .workissuesCounts[i]
                                                            .workissueId,
                                                      });
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.8),
                                                          blurRadius: 3,
                                                          offset: const Offset(
                                                              3, 3),
                                                        ),
                                                      ],
                                                      color: AppColors
                                                          .backgroundColor,
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  8))),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 12.0,
                                                        vertical: 8.0),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
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
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                              Text(
                                                                state
                                                                    .response
                                                                    .data
                                                                    .workissuesCounts[
                                                                        i]
                                                                    .count,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        LinearProgressIndicator(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          backgroundColor:
                                                              Colors.grey
                                                                  .shade400,
                                                          value: double.parse(state
                                                                  .response
                                                                  .data
                                                                  .workissuesCounts[
                                                                      i]
                                                                  .count) /
                                                              totalCount,
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                      Color>(
                                                                  colors[i]),
                                                          minHeight: 5,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                    )
                                  else
                                    const Padding(
                                      padding: EdgeInsets.all(25.0),
                                      child: Text(
                                        "No Issues !",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                    )
                                ],
                              ),
                            )
                          : shimmerContainer(
                              MediaQuery.of(context).size.height * .4,
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

  Future<dynamic> showDateRangeDialog(BuildContext context, cubit) {
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
                    onTap: () async {
                      cubit.getDashboard(fdate.text, tdate.text);
                      Navigator.pop(context);
                    },
                    child: LargeButton(title: "Continue"),
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
