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

class Stages extends StatelessWidget {
  Stages({super.key});
  bool connStatus = false;
  final formKey = GlobalKey<FormState>();
  List<GetStages> stages = [];
  TextEditingController searchController = TextEditingController();
  TextEditingController stage = TextEditingController();
  TextEditingController days = TextEditingController();
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
    return BlocProvider(
      create: (context) => StagesCubit(projectId),
      child: MultiBlocListener(
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
                                  addStageDialog(context, cubit, phaseList,
                                      projectId, clientId,"","Add Stage","Add");
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
                                        horizontal: 8.0),
                                    itemCount: stages.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: InkWell(
                                          onTap: () {
                                            // Navigator.of(context)
                                            //     .pushNamed(AppRoutes.stageHistory);
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .9,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .12,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.8),
                                                  blurRadius: 3,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .2,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      image: const DecorationImage(
                                                          image: AssetImage(
                                                              "assets/images/appbar.png"),
                                                          fit: BoxFit.cover),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.8),
                                                          blurRadius: 6,
                                                          offset: const Offset(
                                                              1, 1),
                                                        ),
                                                      ],
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          stages[index].estDays,
                                                          style: const TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: AppColors
                                                                  .backgroundColor),
                                                        ),
                                                        const Text(
                                                          "Est Days",
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: AppColors
                                                                  .backgroundColor),
                                                        )
                                                      ],
                                                    )),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .7,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0,
                                                            left: 8.0,
                                                            right: 8.0,
                                                            bottom: 8.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              stages[index]
                                                                  .stageName,
                                                              style: const TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: AppColors
                                                                      .coffie),
                                                            ),
                                                            Row(
                                                              children: [
                                                                Container(
                                                                  height: 25,
                                                                  width: 25,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                    color: AppColors
                                                                        .primaryColor,
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
                                                                  child:
                                                                      InkWell(
                                                                    onTap: () {
                                                                      selectedPhase = stages[index].phaseId;
                                                                      stage.text =
                                                                       stages[
                                                                          index]
                                                                      .stageName;
                                                                      startDateController.text = DateFormat('dd/MM/yyyy').format(stages[index].startDate);
                                                                        endDateController.text = DateFormat('dd/MM/yyyy').format(stages[index].endDate);
                                                                      String stageId = stages[index].stageId;
                                                                      addStageDialog(
                                                                          context,
                                                                          cubit,
                                                                          phaseList,
                                                                        
                                                                          projectId,
                                                                          clientId,
                                                                            stageId,
                                                                          "Edit Stage",
                                                                          "Update");
                                                                    },
                                                                    child:
                                                                        const Icon(
                                                                      Icons
                                                                          .edit,
                                                                      size: 18,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              stages[index]
                                                                  .phaseName,
                                                              style: const TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: AppColors
                                                                      .coffie),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          // mainAxisAlignment:
                                                          //     MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            const Text(
                                                              "Created by",
                                                              style: TextStyle(
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 5,
                                                            ),
                                                            Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                  color: AppColors
                                                                      .coffie,
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
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .symmetric(
                                                                    horizontal:
                                                                        10.0,
                                                                  ),
                                                                  child: Text(
                                                                    stages[index]
                                                                        .username,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            10,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .white),
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
                                  )
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

  Future<void> addStageDialog(
    BuildContext context,
    StagesCubit cubit,
    List<StagePhase> list,
    String projectId,
    String clientId,
    String stageId,
    String title,
    String button,
  ) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: SizedBox(
            height: 400,
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                     Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 25),
                      child: Text(
                         title == "Add Stage"
                            ? "Add Stage"
                            : "Edit Stage",
                        style: const TextStyle(
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
                      child: DropdownButtonFormField<String>(
                        value: selectedPhase,
                        items: list.map((data) {
                          return DropdownMenuItem<String>(
                            value: data.id.toString(),
                            child: Text(
                              data.phaseName.toString(),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          selectedPhase = value;
                        },
                        validator: (value) {
                          if (value == null) {
                            return "Select a Status";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(10),
                          labelText: 'Phase',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          prefixIcon: const Icon(Icons.info),
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
                            return "Enter start date"; // Error message if no date is selected
                          }
                          return null;
                        },
                        controller: startDateController,
                        readOnly:
                            true, // Makes the TextFormField read-only so that the user can only select a date
                        onTap: () async {
                          DateTime? selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate:
                                DateTime(1900), // Set the first valid date
                            lastDate: DateTime(2101), // Set the last valid date
                          );
                          if (selectedDate != null) {
                            // If a date is selected, format it and set it in the TextFormField
                            String formattedDate =
                                "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
                            // Set the selected date as the value of the TextFormField
                            startDateController.text = formattedDate;
                          }
                        },
                        // controller: descriptionController, // Controller to manage the input text
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
                        readOnly:
                            true, // Makes the TextFormField read-only so that the user can only select a date
                        onTap: () async {
                          DateTime? selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate:
                                DateTime(1900), // Set the first valid date
                            lastDate: DateTime(2101), // Set the last valid date
                          );
                          if (selectedDate != null) {
                            // If a date is selected, format it and set it in the TextFormField
                            String formattedDate =
                                "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
                            // Set the selected date as the value of the TextFormField
                            endDateController.text = formattedDate;
                          }
                        },
                        // controller: descriptionController, // Controller to manage the input text
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
                          if(title =="Add Stage" ){cubit.addStageDetails(
                            projectId,
                            clientId,
                            selectedPhase,
                            stage.text,
                            startDateController.text,
                            endDateController.text,
                          );}else{
                            cubit.editStageDetails(
                            projectId,
                            clientId,
                            stageId,
                            selectedPhase,
                            stage.text,
                            startDateController.text,
                            endDateController.text,
                          );
                          }
                          
                          selectedPhase = null;
                          stage.clear();
                          startDateController.clear();
                          endDateController.clear();
                          Navigator.pop(context);
                        }
                      },
                      child: LargeButton(title: button =="Add"?"Add":"Update"),
                    ),
                    TextButton(
                      onPressed: () {
                        stage.clear();

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
