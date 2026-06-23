// ignore_for_file: must_be_immutable, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/widgets/snack_bar.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/connectivity_dialog.dart';
import '../../../core/widgets/shimmer.dart';
import '../../../data/models/stages/stage_model.dart';
import '../../../data/models/stages/stagephase_model.dart';
import '../../connectivity/cubit/connectivity_cubit.dart';
import '../../connectivity/cubit/connectivity_state.dart';
import '../cubit/stages_cubit.dart';
import '../cubit/stages_state.dart';
import '../../../data/services/http_services.dart';

class Stages extends StatelessWidget {
  Stages({super.key});

  final formKey = GlobalKey<FormState>();
  List<GetStages> stages = [];
  TextEditingController searchController = TextEditingController();
  TextEditingController stage = TextEditingController();
  TextEditingController est_days = TextEditingController();
  TextEditingController curingdays = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController fdate = TextEditingController(
      text: DateFormat('dd-MM-yyyy').format(DateTime.now()));
  TextEditingController tdate = TextEditingController(
      text: DateFormat('dd-MM-yyyy').format(DateTime.now()));
  List<StagePhase> phaseList = [];
  String? selectedPhase;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    String projectId = args["id"]!;
    String clientId = args["client_id"] ?? "";

    print("PROJECT ID => $projectId");
    print("CLIENTs ID => $clientId");
    return BlocProvider(
      create: (context) => StagesCubit(projectId),
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
          BlocListener<StagesCubit, StagesState>(
            listener: (context, state) {
              if (state is PhaselistSuccess) {
                phaseList = state.response.data;
              }
              if (state is StagesSuccess) {
                stages = state.response.data;
              } else if (state is SearchResult) {
                stages = state.filteredList;
              }
              if (state is AddedSuccess) {
                snackBar(context, state.response.message, Colors.green);
              } else if (state is AddedFailure) {
                snackBar(context, "Adding Stage Failed", Colors.green);
              }
            },
          ),
        ],
        child: BlocBuilder<StagesCubit, StagesState>(
          builder: (context, state) {
            final cubit = context.read<StagesCubit>();
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
                      padding:
                          const EdgeInsets.only(left: 20.0, top: 35, right: 20),
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
                          Row(
                            children: [
                              // InkWell(
                              //   onTap: () {
                              //     Navigator.of(context)
                              //         .pushNamed(AppRoutes.stageHistory);
                              //   },
                              //   child: const CircleAvatar(
                              //     radius: 20,
                              //     backgroundColor: AppColors.lightPrimary,
                              //     child: Icon(
                              //       Icons.analytics_outlined,
                              //       color: Colors.white,
                              //     ),
                              //   ),
                              // ),
                              const SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  addStageDialog(
                                      context,
                                      cubit,
                                      "",
                                      "",
                                      // phaseList,
                                      projectId,
                                      clientId,
                                      "",
                                      "Add Stage",
                                      "Add");
                                },
                                child: const CircleAvatar(
                                  radius: 20,
                                  backgroundColor: AppColors.lightPrimary,
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                body: RefreshIndicator(
                  onRefresh: () async {
                    cubit.getStagesList(projectId);
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 16),
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
                              onChanged: (value) {
                                cubit.filterSearch(value);
                              },
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
                        state is StagesLoading
                            ? ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: 7,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: shimmerContainer(100, 70),
                                  );
                                },
                              )
                            : stages.isNotEmpty
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 6),
                                    itemCount: stages.length,
                                    itemBuilder: (context, index) {
                                      final stageItem = stages[index];

                                      String startDate =
                                          stageItem.startDate.year == 1970
                                              ? "-"
                                              : DateFormat("dd/MM/yyyy")
                                                  .format(stageItem.startDate);
                                      String endDate =
                                          stageItem.endDate.year == 1970
                                              ? "-"
                                              : DateFormat("dd/MM/yyyy")
                                                  .format(stageItem.endDate);

                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 6.0),
                                        child: InkWell(
                                          onTap: () {
                                            // open stage details if needed
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.2),
                                                  blurRadius: 6,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              children: [
                                                // Left side Est Days block
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.22,
                                                  height: 110,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(10),
                                                      bottomLeft:
                                                          Radius.circular(10),
                                                    ),
                                                    image:
                                                        const DecorationImage(
                                                      image: AssetImage(
                                                          "assets/images/appbar.png"),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        stageItem.estDays,
                                                        style: const TextStyle(
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      const Text(
                                                        "Est Days",
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                // Right side content
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10,
                                                        vertical: 8),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              stageItem
                                                                  .stageName,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: AppColors
                                                                    .coffie,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                width: 145),
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          12,
                                                                      vertical:
                                                                          6),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: stageItem
                                                                            .stageStatus
                                                                            .toLowerCase() ==
                                                                        "running"
                                                                    ? Colors
                                                                        .blue
                                                                        .withOpacity(
                                                                            0.15)
                                                                    : stageItem.stageStatus.toLowerCase() ==
                                                                            "pending"
                                                                        ? Colors
                                                                            .amber
                                                                            .withOpacity(
                                                                                0.2)
                                                                        : Colors
                                                                            .green
                                                                            .withOpacity(0.2),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20), // 👈 oval shape
                                                              ),
                                                              child: Text(
                                                                stageItem
                                                                    .stageStatus,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: stageItem
                                                                              .stageStatus
                                                                              .toLowerCase() ==
                                                                          "running"
                                                                      ? Colors
                                                                          .blue
                                                                      : stageItem.stageStatus.toLowerCase() ==
                                                                              "pending"
                                                                          ? Colors.amber[
                                                                              800]
                                                                          : Colors
                                                                              .green[700],
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),

                                                        const SizedBox(
                                                            height: 4),

                                                        // Start - End date row with icons
                                                        Row(
                                                          children: [
                                                            const Icon(
                                                                Icons
                                                                    .date_range,
                                                                size: 16,
                                                                color: AppColors
                                                                    .primaryColor),
                                                            const SizedBox(
                                                                width: 4),
                                                            Text(
                                                              "$startDate → $endDate",
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: AppColors
                                                                    .coffie,
                                                              ),
                                                            ),
                                                          ],
                                                        ),

                                                        const SizedBox(
                                                            height: 6),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Curing Days: ${stageItem.curingDays}",
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .black54,
                                                              ),
                                                            ),
                                                            SizedBox(width: 60),
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          12,
                                                                      vertical:
                                                                          5),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: stageItem
                                                                            .isLocked
                                                                            .toUpperCase() ==
                                                                        "Y"
                                                                    ? Colors.red
                                                                        .withOpacity(
                                                                            0.15) // 🔒 Locked bg
                                                                    : Colors
                                                                        .green
                                                                        .withOpacity(
                                                                            0.15), // 🔓 Unlocked bg
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30), // 👈 pill shape
                                                              ),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Icon(
                                                                    stageItem.isLocked.toUpperCase() ==
                                                                            "Y"
                                                                        ? Icons
                                                                            .lock
                                                                        : Icons
                                                                            .lock_open,
                                                                    color: stageItem.isLocked
                                                                                .toUpperCase() ==
                                                                            "Y"
                                                                        ? Colors
                                                                            .red
                                                                        : Colors
                                                                            .green,
                                                                    size: 15,
                                                                  ),
                                                                  const SizedBox(
                                                                      width: 6),
                                                                  Text(
                                                                    stageItem.isLocked.toUpperCase() ==
                                                                            "Y"
                                                                        ? "Locked"
                                                                        : "Unlocked",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          11,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: stageItem.isLocked.toUpperCase() ==
                                                                              "Y"
                                                                          ? Colors
                                                                              .red
                                                                          : Colors
                                                                              .green,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),

                                                        const SizedBox(
                                                            height: 6),

                                                        // Created by row
                                                        Row(
                                                          children: [
                                                            const Text(
                                                              "Created by: ",
                                                              style: TextStyle(
                                                                fontSize: 11,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black54,
                                                              ),
                                                            ),
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: AppColors
                                                                    .coffie,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12),
                                                              ),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          8,
                                                                      vertical:
                                                                          2),
                                                              child: Text(
                                                                stageItem
                                                                    .createdBy,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 11,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        if (stageItem.isLocked
                                                                .toUpperCase() !=
                                                            "Y")
                                                          Align(
                                                            alignment: Alignment
                                                                .bottomRight,
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                // Pending => Edit + Add Stage Days
                                                                if (stageItem
                                                                        .stageStatus
                                                                        .toLowerCase() ==
                                                                    "pending") ...[
                                                                  _actionButton(
                                                                    Icons.edit,
                                                                    Colors.blue,
                                                                    () {
                                                                      curingdays
                                                                              .text =
                                                                          stageItem
                                                                              .curingDays;
                                                                      stage.text =
                                                                          stageItem
                                                                              .stageName;
                                                                      est_days.text =
                                                                          stageItem
                                                                              .estDays;

                                                                      startDateController
                                                                          .text = DateFormat(
                                                                              'dd/MM/yyyy')
                                                                          .format(
                                                                              stageItem.startDate);

                                                                      endDateController
                                                                          .text = DateFormat(
                                                                              'dd/MM/yyyy')
                                                                          .format(
                                                                              stageItem.endDate);

                                                                      addStageDialog(
                                                                        context,
                                                                        cubit,
                                                                        curingdays
                                                                            .text,
                                                                        est_days
                                                                            .text,
                                                                        projectId,
                                                                        clientId,
                                                                        stageItem
                                                                            .stageId,
                                                                        "Edit Stage",
                                                                        "Update",
                                                                      );
                                                                    },
                                                                  ),
                                                                  const SizedBox(
                                                                      width: 8),
                                                                  _actionButton(
                                                                    Icons.add,
                                                                    Colors
                                                                        .green,
                                                                    () {
                                                                      showAddStageDaysPopup(
                                                                        context,
                                                                        stageItem,
                                                                        cubit,
                                                                      );
                                                                    },
                                                                  ),
                                                                ],

                                                                // Running => Edit + Update Status
                                                                if (stageItem
                                                                        .stageStatus
                                                                        .toLowerCase() ==
                                                                    "running") ...[
                                                                  _actionButton(
                                                                    Icons.edit,
                                                                    Colors.blue,
                                                                    () {
                                                                      curingdays
                                                                              .text =
                                                                          stageItem
                                                                              .curingDays;
                                                                      stage.text =
                                                                          stageItem
                                                                              .stageName;
                                                                      est_days.text =
                                                                          stageItem
                                                                              .estDays;

                                                                      addStageDialog(
                                                                        context,
                                                                        cubit,
                                                                        curingdays
                                                                            .text,
                                                                        est_days
                                                                            .text,
                                                                        projectId,
                                                                        clientId,
                                                                        stageItem
                                                                            .stageId,
                                                                        "Edit Stage",
                                                                        "Update",
                                                                      );
                                                                    },
                                                                  ),
                                                                  const SizedBox(
                                                                      width: 8),
                                                                  _actionButton(
                                                                    Icons
                                                                        .update,
                                                                    Colors
                                                                        .orange,
                                                                    () {
                                                                      showUpdateStatusPopup(
                                                                        context,
                                                                        stageItem,
                                                                        context.read<
                                                                            StagesCubit>(),
                                                                      );
                                                                    },
                                                                  ),
                                                                ],

                                                                // Completed => Update Status only
                                                                if (stageItem
                                                                        .stageStatus
                                                                        .toLowerCase() ==
                                                                    "completed")
                                                                  _actionButton(
                                                                    Icons
                                                                        .update,
                                                                    Colors
                                                                        .orange,
                                                                    () {
                                                                      showUpdateStatusPopup(
                                                                        context,
                                                                        stageItem,
                                                                        context.read<
                                                                            StagesCubit>(),
                                                                      );
                                                                    },
                                                                  ),
                                                              ],
                                                            ),
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
                                  )

                                // ListView.builder(
                                //     shrinkWrap: true,
                                //     physics:
                                //         const NeverScrollableScrollPhysics(),
                                //     padding: const EdgeInsets.symmetric(
                                //         horizontal: 8.0),
                                //     itemCount: stages.length,
                                //     itemBuilder: (context, index) {
                                //       return Padding(
                                //         padding: const EdgeInsets.all(6.0),
                                //         child: InkWell(
                                //           onTap: () {
                                //             // Navigator.of(context)
                                //             //     .pushNamed(AppRoutes.stageHistory);
                                //           },
                                //           child: Container(
                                //             width: MediaQuery.of(context)
                                //                     .size
                                //                     .width *
                                //                 .9,
                                //             height: MediaQuery.of(context)
                                //                     .size
                                //                     .height *
                                //                 .12,
                                //             decoration: BoxDecoration(
                                //               borderRadius:
                                //                   BorderRadius.circular(5),
                                //               color: Colors.white,
                                //               boxShadow: [
                                //                 BoxShadow(
                                //                   color: Colors.grey
                                //                       .withOpacity(0.8),
                                //                   blurRadius: 3,
                                //                   offset: const Offset(0, 3),
                                //                 ),
                                //               ],
                                //             ),
                                //             child: Row(
                                //               mainAxisAlignment:
                                //                   MainAxisAlignment
                                //                       .spaceBetween,
                                //               children: [
                                //                 Container(
                                //                     width:
                                //                         MediaQuery.of(context)
                                //                                 .size
                                //                                 .width *
                                //                             .2,
                                //                     decoration: BoxDecoration(
                                //                       borderRadius:
                                //                           BorderRadius.circular(
                                //                               5),
                                //                       image: const DecorationImage(
                                //                           image: AssetImage(
                                //                               "assets/images/appbar.png"),
                                //                           fit: BoxFit.cover),
                                //                       boxShadow: [
                                //                         BoxShadow(
                                //                           color: Colors.grey
                                //                               .withOpacity(0.8),
                                //                           blurRadius: 6,
                                //                           offset: const Offset(
                                //                               1, 1),
                                //                         ),
                                //                       ],
                                //                     ),
                                //                     alignment: Alignment.center,
                                //                     child: Column(
                                //                       mainAxisAlignment:
                                //                           MainAxisAlignment
                                //                               .center,
                                //                       children: [
                                //                         Text(
                                //                           stages[index].estDays,
                                //                           style: const TextStyle(
                                //                               fontSize: 20,
                                //                               fontWeight:
                                //                                   FontWeight
                                //                                       .bold,
                                //                               color: AppColors
                                //                                   .backgroundColor),
                                //                         ),
                                //                         const Text(
                                //                           "Est Days",
                                //                           style: TextStyle(
                                //                               fontSize: 10,
                                //                               fontWeight:
                                //                                   FontWeight
                                //                                       .bold,
                                //                               color: AppColors
                                //                                   .backgroundColor),
                                //                         )
                                //                       ],
                                //                     )),
                                //                 SizedBox(
                                //                   width: MediaQuery.of(context)
                                //                           .size
                                //                           .width *
                                //                       .7,
                                //                   child: Padding(
                                //                     padding:
                                //                         const EdgeInsets.only(
                                //                             top: 8.0,
                                //                             left: 8.0,
                                //                             right: 8.0,
                                //                             bottom: 8.0),
                                //                     child: Column(
                                //                       crossAxisAlignment:
                                //                           CrossAxisAlignment
                                //                               .start,
                                //                       mainAxisAlignment:
                                //                           MainAxisAlignment
                                //                               .spaceAround,
                                //                       children: [
                                //                         Row(
                                //                           mainAxisAlignment:
                                //                               MainAxisAlignment
                                //                                   .spaceBetween,
                                //                           children: [
                                //                             Text(
                                //                               "Stage: ${stages[index]
                                //                                   .stageName}",
                                //                               style: const TextStyle(
                                //                                   fontSize: 16,
                                //                                   fontWeight:
                                //                                       FontWeight
                                //                                           .bold,
                                //                                   color: AppColors
                                //                                       .coffie),
                                //                             ),
                                //                             SizedBox(width: 46,),
                                //                               Text(
                                //                               "${stages[index]
                                //                                   .startDate} -${stages[index]
                                //                                   .endDate} ",
                                //                               style: const TextStyle(
                                //                                   fontSize: 12,
                                //                                   fontWeight:
                                //                                       FontWeight
                                //                                           .bold,
                                //                                   color: AppColors
                                //                                       .coffie),
                                //                             ),
                                //                             Row(
                                //                               children: [
                                //                                 Container(
                                //                                   height: 25,
                                //                                   width: 25,
                                //                                   decoration:
                                //                                       BoxDecoration(
                                //                                     borderRadius:
                                //                                         BorderRadius
                                //                                             .circular(5),
                                //                                     color: AppColors
                                //                                         .primaryColor,
                                //                                     boxShadow: [
                                //                                       BoxShadow(
                                //                                         color: Colors
                                //                                             .grey
                                //                                             .withOpacity(0.8),
                                //                                         blurRadius:
                                //                                             6,
                                //                                         offset: const Offset(
                                //                                             1,
                                //                                             1),
                                //                                       ),
                                //                                     ],
                                //                                   ),
                                //                                   child:
                                //                                       InkWell(
                                //                                     onTap: () {
                                //                                       curingdays
                                //                                           .text = stages[
                                //                                               index]
                                //                                           .curingDays;
                                //                                       stage.text =
                                //                                           stages[index]
                                //                                               .stageName;
                                //                                       startDateController
                                //                                           .text = DateFormat(
                                //                                               'dd/MM/yyyy')
                                //                                           .format(
                                //                                               stages[index].startDate);
                                //                                       endDateController
                                //                                           .text = DateFormat(
                                //                                               'dd/MM/yyyy')
                                //                                           .format(
                                //                                               stages[index].endDate);
                                //                                       String
                                //                                           stageId =
                                //                                           stages[index]
                                //                                               .stageId;
                                //                                       est_days
                                //                                           .text = stages[
                                //                                               index]
                                //                                           .estDays;
                                //                                       addStageDialog(
                                //                                           context,
                                //                                           cubit,
                                //                                           curingdays
                                //                                               .text,
                                //                                           est_days
                                //                                               .text,
                                //                                           projectId,
                                //                                           clientId,
                                //                                           stageId,
                                //                                           "Edit Stage",
                                //                                           "Update");
                                //                                     },
                                //                                     child:
                                //                                         const Icon(
                                //                                       Icons
                                //                                           .edit,
                                //                                       size: 18,
                                //                                       color: Colors
                                //                                           .white,
                                //                                     ),
                                //                                   ),
                                //                                 ),
                                //                               ],
                                //                             )
                                //                           ],
                                //                         ),
                                //                         Row(
                                //                           mainAxisAlignment:
                                //                               MainAxisAlignment
                                //                                   .spaceBetween,
                                //                           children: [
                                //                             Text(
                                //                               "Curing Days: ${stages[index]
                                //                                   .curingDays}",
                                //                               style: const TextStyle(
                                //                                   fontSize: 12,
                                //                                   fontWeight:
                                //                                       FontWeight
                                //                                           .bold,
                                //                                   color: AppColors
                                //                                       .coffie),
                                //                             ),
                                //                           ],
                                //                         ),
                                //                         const SizedBox(
                                //                           height: 10,
                                //                         ),
                                //                         Row(
                                //                           // mainAxisAlignment:
                                //                           //     MainAxisAlignment.spaceBetween,
                                //                           children: [
                                //                             const Text(
                                //                               "Created by",
                                //                               style: TextStyle(
                                //                                 fontSize: 10,
                                //                                 fontWeight:
                                //                                     FontWeight
                                //                                         .bold,
                                //                               ),
                                //                             ),
                                //                             const SizedBox(
                                //                               width: 5,
                                //                             ),
                                //                             Container(
                                //                                 decoration:
                                //                                     BoxDecoration(
                                //                                   borderRadius:
                                //                                       BorderRadius
                                //                                           .circular(
                                //                                               12),
                                //                                   color: AppColors
                                //                                       .coffie,
                                //                                   boxShadow: [
                                //                                     BoxShadow(
                                //                                       color: Colors
                                //                                           .grey
                                //                                           .withOpacity(
                                //                                               0.8),
                                //                                       blurRadius:
                                //                                           6,
                                //                                       offset:
                                //                                           const Offset(
                                //                                               1,
                                //                                               1),
                                //                                     ),
                                //                                   ],
                                //                                 ),
                                //                                 alignment:
                                //                                     Alignment
                                //                                         .center,
                                //                                 child: Padding(
                                //                                   padding:
                                //                                       const EdgeInsets
                                //                                           .symmetric(
                                //                                     horizontal:
                                //                                         10.0,
                                //                                   ),
                                //                                   child: Text(
                                //                                     stages[index]
                                //                                         .createdBy,
                                //                                     style: const TextStyle(
                                //                                         fontSize:
                                //                                             10,
                                //                                         fontWeight:
                                //                                             FontWeight
                                //                                                 .bold,
                                //                                         color: Colors
                                //                                             .white),
                                //                                   ),
                                //                                 )),
                                //                           ],
                                //                         ),
                                //                       ],
                                //                     ),
                                //                   ),
                                //                 ),
                                //               ],
                                //             ),
                                //           ),
                                //         ),
                                //       );
                                //     },
                                //   )
                                : const Center(
                                    child: Text("No Stages Added"),
                                  ),
                      ],
                    ),
                  ),
                ));
          },
        ),
      ),
    );
  }

  Widget _actionButton(
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 18,
          color: Colors.white,
        ),
      ),
    );
  }

  void showAddStageDaysPopup(
    BuildContext context,
    GetStages stage,
    StagesCubit cubit,
  ) {
    final startDateController = TextEditingController();
    final endDateController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Add Stage Days"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: startDateController,
                readOnly: true,
                onTap: () async {
                  final picked = await showDatePicker(
                    context: dialogContext,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(), // disable future dates
                  );

                  if (picked != null) {
                    startDateController.text =
                        DateFormat('dd-MM-yyyy').format(picked);

                    final estDays = int.tryParse(stage.estDays) ?? 0;

                    final endDate = picked.add(
                      Duration(days: estDays),
                    );

                    endDateController.text =
                        DateFormat('dd-MM-yyyy').format(endDate);
                  }
                },
                decoration: const InputDecoration(
                  labelText: "Start Date *",
                  suffixIcon: Icon(Icons.calendar_today),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: endDateController,
                readOnly: true,
                enabled: false,
                decoration: const InputDecoration(
                  labelText: "End Date *",
                  suffixIcon: Icon(Icons.calendar_today),
                ),
              ),
            ],
          ),
          actions: [
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(dialogContext),
              icon: const Icon(Icons.close),
              label: const Text("Close"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (startDateController.text.isEmpty ||
                    endDateController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Please select Start Date",
                      ),
                    ),
                  );
                  return;
                }

                final response = await HttpServices.addStageDays(
                  stageId: stage.stageId,
                  projectId: stage.projectId,
                  clientId: stage.clientId,
                  startDate: startDateController.text,
                  endDate: endDateController.text,
                );

                if (response != null && response["status"] == true) {
                  Navigator.pop(dialogContext);

                  // Refresh Stage List
                  await cubit.getStagesList(
                    stage.projectId,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        response["message"]?.toString() ??
                            "Stage days added successfully",
                      ),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 3),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        response?["message"] ?? "Something went wrong",
                      ),
                    ),
                  );
                }
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  void showUpdateStatusPopup(
    BuildContext context,
    GetStages stage,
    StagesCubit cubit,
  ) {
    final completedDateController = TextEditingController();

    bool isCompleted = true;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Update Status"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: completedDateController,
                    readOnly: true,
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100), // Allow future dates
                      );

                      if (picked != null) {
                        completedDateController.text =
                            DateFormat('dd-MM-yyyy').format(picked);
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: "Completed Date *",
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                  const SizedBox(height: 12),
                  CheckboxListTile(
                    value: isCompleted,
                    onChanged: (value) {
                      setState(() {
                        isCompleted = value ?? true;
                      });
                    },
                    title: const Text("Is work completed?"),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ],
              ),
              actions: [
                OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  label: const Text("Close"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // if (completedDateController.text.isEmpty) {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(
                    //       content: Text("Please select completed date"),
                    //     ),
                    //   );
                    //   return;
                    // }

                    final response = await HttpServices.updateStageStatus(
                      projectId: stage.projectId,
                      stageId: stage.stageId,
                      isCompleted: isCompleted ? "Y" : "",
                      completedDate: completedDateController.text,
                    );

                    if (response != null && response["status"] == true) {
                      Navigator.pop(dialogContext);

                      await cubit.getStagesList(stage.projectId);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            response["message"]?.toString() ??
                                "Stage status updated successfully",
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            response?["message"]?.toString() ??
                                "Failed to update status",
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text("Update"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> addStageDialog(
    BuildContext context,
    StagesCubit cubit,
    //  List<StagePhase> list,
    String curingDays,
    String estDays,
    String projectId,
    String clientId,
    String stageId,
    String title,
    String button,
  ) async {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: SizedBox(
            height: 460,
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 25),
                      child: Text(
                        title == "Add Stage" ? "Add Stage" : "Edit Stage",
                        style: const TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    // Container(
                    //   width: MediaQuery.of(context).size.width * 0.95,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(5),
                    //   ),
                    //   child: DropdownButtonFormField<String>(
                    //     value: selectedPhase,
                    //     items: list.map((data) {
                    //       return DropdownMenuItem<String>(
                    //         value: data.id.toString(),
                    //         child: Text(
                    //           data.phaseName.toString(),
                    //         ),
                    //       );
                    //     }).toList(),
                    //     onChanged: (value) {
                    //       selectedPhase = value;
                    //     },
                    //     validator: (value) {
                    //       if (value == null) {
                    //         return "Select a Status";
                    //       }
                    //       return null;
                    //     },
                    //     decoration: InputDecoration(
                    //       contentPadding: const EdgeInsets.all(10),
                    //       labelText: 'Phase',
                    //       border: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(5),
                    //       ),
                    //       prefixIcon: const Icon(Icons.info),
                    //     ),
                    //   ),
                    // ),
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
                            return "Enter Stage";
                          } else {
                            return null;
                          }
                        },
                        onTap: () {},
                        controller: stage,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(10),
                          labelText: 'Stage*',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          prefixIcon: const Icon(Icons.auto_graph_rounded),
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
                            return "Enter days";
                          } else {
                            return null;
                          }
                        },
                        onTap: () {},
                        controller: est_days,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(10),
                          labelText: 'Days*',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          prefixIcon: const Icon(Icons.calendar_view_day),
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
                            return "Enter Curing Days";
                          } else {
                            return null;
                          }
                        },
                        onTap: () {},
                        controller: curingdays,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(10),
                          labelText: 'Curing Days',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          prefixIcon: const Icon(Icons.calendar_view_day),
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
                            return "Enter start date";
                          }
                          return null;
                        },
                        controller: startDateController,
                        readOnly: true,
                        // onTap: () async {
                        //   DateTime? selectedDate = await showDatePicker(
                        //     context: context,
                        //     initialDate: DateTime.now(),
                        //     firstDate: DateTime(1900),
                        //     lastDate: DateTime(2101),
                        //   );
                        //   if (selectedDate != null) {
                        //     String formattedDate =
                        //         "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";

                        //     startDateController.text = formattedDate;
                        //   }
                        // },
                        onTap: () async {
                          DateTime? selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2101),
                          );
                          String formattedDate =
                              "${selectedDate!.day}/${selectedDate.month}/${selectedDate.year}";
                          startDateController.text = formattedDate;
                          int daysToAdd = int.tryParse(est_days.text) ?? 0;
                          DateTime calculatedEndDate =
                              selectedDate.add(Duration(days: daysToAdd));
                          String endFormattedDate =
                              "${calculatedEndDate.day}/${calculatedEndDate.month}/${calculatedEndDate.year}";
                          endDateController.text = endFormattedDate;
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(10),
                          labelText: 'Start Date',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          prefixIcon:
                              const Icon(Icons.calendar_today), // Calendar icon
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextFormField(
                        validator: (value) {
                          if (value == "") {
                            return "Enter end date"; // Error message if no date is selected
                          }
                          return null;
                        },
                        controller: endDateController,
                        readOnly: true,
                        onTap: () async {
                          DateTime? selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2101),
                          );
                          String formattedDate =
                              "${selectedDate!.day}/${selectedDate.month}/${selectedDate.year}";

                          endDateController.text = formattedDate;
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(10),
                          labelText: 'End Date',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          prefixIcon:
                              const Icon(Icons.calendar_today), // Calendar icon
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          if (title == "Add Stage") {
                            cubit.addStageDetails(
                              projectId,
                              clientId,
                              // selectedPhase,
                              stage.text,
                              est_days.text,
                              curingdays.text,
                              startDateController.text,
                              endDateController.text,
                            );
                          } else {
                            cubit.editStageDetails(
                              projectId,
                              clientId,
                              stageId,
                              // selectedPhase,
                              stage.text,
                              est_days.text,
                              curingdays.text,
                              startDateController.text,
                              endDateController.text,
                            );
                          }
                          selectedPhase = null;
                          stage.clear();
                          est_days.clear();
                          curingdays.clear();
                          startDateController.clear();
                          endDateController.clear();
                          Navigator.pop(context);
                        }
                      },
                      child: LargeButton(
                          title: button == "Add" ? "Add" : "Update"),
                    ),
                    TextButton(
                      onPressed: () {
                        stage.clear();
                        est_days.clear();
                        curingdays.clear();
                        selectedPhase = null;
                        startDateController.clear();
                        endDateController.clear();
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
