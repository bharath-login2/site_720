// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/constants/routes.dart';
import 'package:site_720/core/widgets/dialogs.dart';
import 'package:site_720/core/widgets/snack_bar.dart';
import 'package:site_720/features/project_list/cubit/project_list_state.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/connectivity_dialog.dart';
import '../../../core/widgets/shimmer.dart';
import '../../connectivity/cubit/connectivity_cubit.dart';
import '../../connectivity/cubit/connectivity_state.dart';
import '../cubit/project_list_cubit.dart';
import '../widgets/floating_card.dart';

class ProjectList extends StatelessWidget {
  bool fromHome;
  ProjectList({super.key, required this.fromHome});
  TextEditingController search = TextEditingController();
  dynamic status;
  List statuses = ["upcoming", "running", "completed", "all"];
  String sts = "";

  @override
  Widget build(BuildContext context) {
    if (fromHome) {
      sts = "all";
      status = sts;
    } else {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, String>;
      sts = args["status"]!;
      status = sts;
    }
    return BlocProvider(
      create: (context) => ProjectListCubit(status.toString(), search.text),
      child: Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: BlocBuilder<ProjectListCubit, ProjectListState>(
            builder: (context, state) {
              final cubit = context.read<ProjectListCubit>();
              return MultiBlocListener(
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
                  BlocListener<ProjectListCubit, ProjectListState>(
                    listener: (context, state) {
                      if (state is ProjectDeleted) {
                        snackBar(
                            context, state.message, AppColors.primaryColor);
                      }
                    },
                  )
                ],
                child: RefreshIndicator(
                  onRefresh: () async {
                    cubit.getProjectList(status.toString(), search.text);
                  },
                  child: SingleChildScrollView(
                    child: Stack(
                      children: [
                        SizedBox(
                          // height: MediaQuery.of(context).size.height,
                          child: Column(
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * .25,
                                width: MediaQuery.of(context).size.width,
                                decoration: const BoxDecoration(
                                    color: AppColors.primaryColor,
                                    image: DecorationImage(
                                        image: AssetImage(
                                            "assets/images/appbar.png"),
                                        fit: BoxFit.fill)),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 80.0,
                                      bottom: 16.0,
                                      left: 16.0,
                                      right: 16.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: fromHome
                                                ? const SizedBox()
                                                : InkWell(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Icon(
                                                      Icons.arrow_back_ios,
                                                      color: Colors.white,
                                                    )),
                                          ),
                                          if (state is ProjectListSuccess)
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Hi, ${state.response.data.username}",
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                                Text(
                                                  state.response.data
                                                      .designation,
                                                  style: const TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: 1,
                                                      fontFamily: "Lobster",
                                                      color: Colors.white),
                                                ),
                                              ],
                                            )
                                        ],
                                      ),
                                      const CircleAvatar(
                                        backgroundColor: AppColors.lightA,
                                        child: Icon(Icons.person),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .075,
                              ),
                              if (sts == "all")
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * .9,
                                  height:
                                      MediaQuery.of(context).size.width * .105,
                                  child: DropdownButtonFormField(
                                    value: status,
                                    onChanged: (value) async {
                                      status = value.toString();
                                    },
                                    items: statuses.map((data) {
                                      return DropdownMenuItem<String>(
                                        value: data,
                                        child: Text(
                                          data,
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
                              if (sts == "all")
                                const SizedBox(
                                  height: 10,
                                ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .9,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          .6,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              .105,
                                      child: TextFormField(
                                        controller: search,
                                        decoration: InputDecoration(
                                          fillColor: Colors.white,
                                          filled: true,
                                          border: OutlineInputBorder(
                                            // Custom border
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          labelText: 'Search.',
                                          prefixIcon: const Icon(Icons.search,
                                              color: Colors.grey),
                                          labelStyle: const TextStyle(
                                              color: Colors.grey),
                                          contentPadding: const EdgeInsets.only(
                                              left: 10, top: 2, bottom: 2),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                        onTap: () {
                                          cubit.getProjectList(
                                              status.toString(), search.text);
                                        },
                                        child: SmallButton(title: "Submit")),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              if (state is ProjectListFailure)
                                const Padding(
                                  padding: EdgeInsets.only(top: 140.0),
                                  child: Center(
                                    child: Text(
                                      "Something went wrong !",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.red),
                                    ),
                                  ),
                                )
                              else
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.all(8),
                                  itemCount: state is ProjectListSuccess
                                      ? state.response.data.projectList.length
                                      : 4,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: state is ProjectListSuccess
                                          ? InkWell(
                                              onTap: () {
                                                connStatus = true;
                                                Navigator.pushNamed(context,
                                                    AppRoutes.projectDetails,
                                                    arguments: {
                                                      "id": state.response.data
                                                          .projectList[index].id
                                                    });
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .9,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.8),
                                                      blurRadius: 3,
                                                      offset:
                                                          const Offset(0, 3),
                                                    ),
                                                  ],
                                                ),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0,
                                                              right: 8.0,
                                                              top: 12),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                              width: 40,
                                                              height: 40,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                color: AppColors
                                                                    .primaryColor,
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.8),
                                                                    blurRadius:
                                                                        6,
                                                                    offset:
                                                                        const Offset(
                                                                            1,
                                                                            1),
                                                                  ),
                                                                ],
                                                              ),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: const Icon(
                                                                Icons.person,
                                                                color: Colors
                                                                    .white,
                                                              )),
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                .45,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  state
                                                                      .response
                                                                      .data
                                                                      .projectList[
                                                                          index]
                                                                      .projectName,
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  state
                                                                      .response
                                                                      .data
                                                                      .projectList[
                                                                          index]
                                                                      .location,
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        11,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "${state.response.data.projectList[index].startingDate} to ${state.response.data.projectList[index].completionDate}",
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        11,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                color: AppColors
                                                                    .backgroundColor,
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.8),
                                                                    blurRadius:
                                                                        6,
                                                                    offset:
                                                                        const Offset(
                                                                            1,
                                                                            1),
                                                                  ),
                                                                ],
                                                              ),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        20.0,
                                                                    vertical:
                                                                        2.0),
                                                                child: Text(
                                                                  state
                                                                      .response
                                                                      .data
                                                                      .projectList[
                                                                          index]
                                                                      .workStatus,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: AppColors
                                                                          .primaryColor),
                                                                ),
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                    Divider(
                                                      color:
                                                          Colors.grey.shade300,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 4,
                                                              bottom: 12.0,
                                                              left: 10.0,
                                                              right: 10.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                "${state.response.data.projectList[index].totalAmount} ₹",
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12),
                                                                    color: Colors
                                                                        .green,
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: Colors
                                                                            .grey
                                                                            .withOpacity(0.8),
                                                                        blurRadius:
                                                                            6,
                                                                        offset: const Offset(
                                                                            1,
                                                                            1),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            20.0,
                                                                        vertical:
                                                                            2.0),
                                                                    child: Text(
                                                                      state.response.data.projectList[index].paymentStatus ==
                                                                              true
                                                                          ? "paid"
                                                                          : "unpaid",
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              8,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  )),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  connStatus =
                                                                      true;
                                                                  Navigator.pushNamed(
                                                                      context,
                                                                      AppRoutes
                                                                          .editProjectScreen,
                                                                      arguments: {
                                                                        "project_id": state
                                                                            .response
                                                                            .data
                                                                            .projectList[index]
                                                                            .id
                                                                      });
                                                                },
                                                                child:
                                                                    Container(
                                                                  height: 25,
                                                                  width: 25,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                    color: AppColors
                                                                        .lightBlue,
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: Colors
                                                                            .grey
                                                                            .withOpacity(0.8),
                                                                        blurRadius:
                                                                            6,
                                                                        offset: const Offset(
                                                                            2,
                                                                            3),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  child:
                                                                      const Icon(
                                                                    Icons.edit,
                                                                    size: 18,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 10),
                                                              InkWell(
                                                                onTap: () {
                                                                  deleteDialog(
                                                                      context,
                                                                      () {
                                                                    cubit.deleteProject(
                                                                        state
                                                                            .response
                                                                            .data
                                                                            .projectList[
                                                                                index]
                                                                            .id,
                                                                        status,
                                                                        search
                                                                            .text);
                                                                    Navigator.pop(
                                                                        context);
                                                                  });
                                                                },
                                                                child:
                                                                    Container(
                                                                  height: 25,
                                                                  width: 25,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                    color: Colors
                                                                        .red,
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: Colors
                                                                            .grey
                                                                            .withOpacity(0.8),
                                                                        blurRadius:
                                                                            6,
                                                                        offset: const Offset(
                                                                            2,
                                                                            3),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  child: const Icon(
                                                                      Icons
                                                                          .delete,
                                                                      size: 18,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : shimmerContainer(
                                              MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .15,
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .9,
                                            ),
                                    );
                                  },
                                )
                            ],
                          ),
                        ),
                        Positioned(
                          top: MediaQuery.of(context).size.height * 0.2,
                          left: MediaQuery.of(context).size.width * 0.05,
                          child: FloatingCard(
                            title: "Total Projects",
                            value: state is ProjectListSuccess
                                ? "${state.response.data.projectList.length.toString()}/${state.response.data.totalProjectCount.toString()}"
                                : "0",
                            status: status,
                            search: search.text,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          )),
    );
  }
}
