// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/widgets/shimmer.dart';
import 'package:site_720/data/models/workdetails/work_detail_model.dart';
import 'package:site_720/features/work_details/cubit/work_details_state.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/connectivity_dialog.dart';
import '../../../core/widgets/dialogs.dart';
import '../../../core/widgets/snack_bar.dart';
import '../../../data/models/workdetails/add_work_details_model.dart';
import '../../../data/models/workdetails/work_stage_model.dart';
import '../../connectivity/cubit/connectivity_cubit.dart';
import '../../connectivity/cubit/connectivity_state.dart';
import '../cubit/work_details_cubit.dart';

class WorkDetailsScreen extends StatelessWidget {
  WorkDetailsScreen({super.key});

  List<WorkIssues> issuesList = [];
  List<WorkDetails> workList = [];
  List<Workstage> stageList = [];
  String isWorking = 'Yes';
  String? selectedStatus;
  String? selectedStage;
  final formKey = GlobalKey<FormState>();
  TextEditingController date = TextEditingController();
  TextEditingController noOfLabours = TextEditingController();
  TextEditingController description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    String id = args["id"]!;
    String clientId = args["client_id"]!;
    return BlocProvider(
      create: (context) => WorkDetailsCubit(id),
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
          BlocListener<WorkDetailsCubit, WorkDetailsState>(
            listener: (context, state) {
              if (state is WorkStatusSuccess) {
                issuesList = state.response.data;
              }
              if (state is WorkDetailsSuccess) {
                workList = state.response.data;
              }
              if (state is WorkStagesSuccess) {
                stageList = state.response.data;
              }
              if (state is AddingSuccess) {
                snackBar(context, state.message, AppColors.primaryColor);
              }
              if (state is AddingFailure) {
                snackBar(context, state.message, Colors.red);
              }
            },
          )
        ],
        child: BlocBuilder<WorkDetailsCubit, WorkDetailsState>(
          builder: (context, state) {
            final cubit = context.read<WorkDetailsCubit>();
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
                                "Work Details",
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
                              date.text = DateFormat('dd-MM-yyyy')
                                  .format(DateTime.now());
                              if (issuesList.isNotEmpty) {
                                workDialog(context, cubit, issuesList,
                                        stageList, id, clientId, "add", "")
                                    .then((_) {
                                  date.clear();
                                  noOfLabours.clear();
                                  description.clear();
                                  selectedStatus = null;
                                  isWorking = 'Yes';
                                });
                              } else {
                                snackBar(context, "Something went wrong",
                                    Colors.red);
                              }
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
                body: RefreshIndicator(
                  onRefresh: () async {
                    cubit.getWorkDetails(id);
                  },
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8),
                    itemCount:
                        state is WorkDetailsLoading ? 7 : workList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: state is WorkDetailsLoading
                              ? shimmerContainer(
                                  MediaQuery.of(context).size.height * .1,
                                  MediaQuery.of(context).size.width * .9)
                              : InkWell(
                                  onTap: () {},
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * .9,
                                    height:
                                        MediaQuery.of(context).size.height * .1,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .2,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              image: const DecorationImage(
                                                  image: AssetImage(
                                                      "assets/images/appbar.png"),
                                                  fit: BoxFit.fill),
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
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  workList[index].workDay,
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: AppColors
                                                          .backgroundColor),
                                                ),
                                                Text(
                                                  workList[index].workMonthName,
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: AppColors
                                                          .backgroundColor),
                                                ),
                                                Text(
                                                  workList[index].workYear,
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                            padding: const EdgeInsets.only(
                                                top: 8.0,
                                                left: 8.0,
                                                right: 8.0,
                                                bottom: 8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      workList[index]
                                                                  .isWorking ==
                                                              "No"
                                                          ? workList[index]
                                                              .workStatus
                                                          : "Labour No:${workList[index].laboursNo}",
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      workList[index]
                                                          .description,
                                                      style: const TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              AppColors.coffie),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: AppColors
                                                              .backgroundColor,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.8),
                                                              blurRadius: 6,
                                                              offset:
                                                                  const Offset(
                                                                      1, 1),
                                                            ),
                                                          ],
                                                        ),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            horizontal: 20.0,
                                                          ),
                                                          child: Text(
                                                            workList[index]
                                                                        .isWorking ==
                                                                    "No"
                                                                ? "Not Worked"
                                                                : "Worked",
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: workList[index]
                                                                            .isWorking ==
                                                                        "No"
                                                                    ? AppColors
                                                                        .primaryColor
                                                                    : Colors
                                                                        .green),
                                                          ),
                                                        )),
                                                    Row(
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            isWorking =
                                                                workList[index]
                                                                    .isWorking;
                                                            date.text =
                                                                workList[index]
                                                                    .workDate;
                                                            noOfLabours.text =
                                                                workList[index]
                                                                    .laboursNo;
                                                            selectedStatus =
                                                                workList[index]
                                                                    .workStatusId;
                                                            selectedStage =
                                                                workList[index]
                                                                    .stageId;
                                                            description.text =
                                                                workList[index]
                                                                    .description;
                                                            workDialog(
                                                                    context,
                                                                    cubit,
                                                                    issuesList,
                                                                    stageList,
                                                                    id,
                                                                    clientId,
                                                                    "edit",
                                                                    workList[
                                                                            index]
                                                                        .id)
                                                                .then((_) {
                                                              date.clear();
                                                              noOfLabours
                                                                  .clear();
                                                              description
                                                                  .clear();
                                                              selectedStatus =
                                                                  null;
                                                              isWorking = 'Yes';
                                                            });
                                                          },
                                                          child: Container(
                                                            height: 25,
                                                            width: 25,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              color: AppColors
                                                                  .lightBlue,
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.8),
                                                                  blurRadius: 6,
                                                                  offset:
                                                                      const Offset(
                                                                          1, 1),
                                                                ),
                                                              ],
                                                            ),
                                                            child: const Icon(
                                                              Icons.edit,
                                                              size: 18,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 7,
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            deleteDialog(
                                                                context, () {
                                                              cubit.deleteWorkDetails(
                                                                  id,
                                                                  workList[
                                                                          index]
                                                                      .id);
                                                              Navigator.pop(
                                                                  context);
                                                            });
                                                          },
                                                          child: Container(
                                                            height: 25,
                                                            width: 25,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              color: Colors.red,
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.8),
                                                                  blurRadius: 6,
                                                                  offset:
                                                                      const Offset(
                                                                          1, 1),
                                                                ),
                                                              ],
                                                            ),
                                                            child: const Icon(
                                                              Icons.delete,
                                                              size: 18,
                                                              color:
                                                                  Colors.white,
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
                                        ),
                                      ],
                                    ),
                                  ),
                                ));
                    },
                  ),
                ));
          },
        ),
      ),
    );
  }

  Future<void> workDialog(
    BuildContext context,
    cubit,
    List<WorkIssues> list,
    List<Workstage> stagelist,
    String projectId,
    String clientId,
    String type,
    String workId,
  ) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: SizedBox(
              height: 550,
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0, bottom: 25),
                        child: Text(
                          type == "add" ? "Add Work Details" : "Edit",
                          style: const TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Text(
                        "Are You Sure Today is Working?",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.errorColor),
                      ),
                      Row(
                        children: [
                          Radio<String>(
                            value: 'Yes',
                            groupValue: isWorking,
                            onChanged: (value) {
                              isWorking = value!;
                              (context as Element).markNeedsBuild();
                            },
                          ),
                          const Text("Yes"),
                          Radio<String>(
                            value: 'No',
                            groupValue: isWorking,
                            onChanged: (value) {
                              isWorking = value!;
                              (context as Element).markNeedsBuild();
                            },
                          ),
                          const Text("No"),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.95,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: DropdownButtonFormField<String>(
                          value: selectedStage,
                          items: stagelist.map((data) {
                            return DropdownMenuItem<String>(
                              value: data.stageId.toString(),
                              child: Text(
                                data.stageName.toString(),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            selectedStage = value;
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(10),
                            labelText: 'Stages*',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            prefixIcon: const Icon(Icons.info),
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
                              return "Enter Date";
                            }
                            return null;
                          },
                          onTap: () async {
                            String? selectedDate = await selectDate(context);
                            if (selectedDate != null) {
                              date.text = selectedDate;
                              if (context.mounted) {}
                            }
                          },
                          readOnly: true,
                          controller: date,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(10),
                            labelText: 'Date',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            prefixIcon: const Icon(Icons.calendar_today),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (isWorking == "Yes")
                        Container(
                          width: MediaQuery.of(context).size.width * 0.95,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextFormField(
                            validator: (value) {
                              if (isWorking == "Yes") {
                                if (value == null || value.trim().isEmpty) {
                                  return "Enter Number of Labours";
                                }
                                final parsed = int.tryParse(value.trim());
                                if (parsed == null || parsed <= 0) {
                                  return "No of Labours must be greater than 0";
                                }
                              }
                              return null;
                            },
                            controller: noOfLabours,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(10),
                              labelText: 'No of Labours*',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              prefixIcon: const Icon(Icons.group),
                            ),
                          ),
                        )
                      else
                        Container(
                          width: MediaQuery.of(context).size.width * 0.95,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: DropdownButtonFormField<String>(
                            value: selectedStatus,
                            items: list.map((data) {
                              return DropdownMenuItem<String>(
                                value: data.id.toString(),
                                child: Text(
                                  data.workStatus.toString(),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              selectedStatus = value;
                            },
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty && isWorking == "Yes") {
                                return "Select a Status";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(10),
                              labelText: 'Status*',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              prefixIcon: const Icon(Icons.info),
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
                          // validator: (value) {
                          //   if (value == "") {
                          //     return "Enter Description";
                          //   }
                          //   return null;
                          // },
                          controller: description,
                          keyboardType: TextInputType.text,
                          maxLines: 3,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(10),
                            labelText: 'Description',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            prefixIcon: const Icon(Icons.text_fields),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            if (type == "add") {
                              cubit.addWorkDetails(
                                  projectId,
                                  clientId,
                                  isWorking,
                                  date.text,
                                  noOfLabours.text,
                                  selectedStatus ?? "",
                                  selectedStage ?? "",
                                  description.text);
                            } else {
                              cubit.editWorkDetails(
                                  projectId,
                                  clientId,
                                  isWorking,
                                  date.text,
                                  noOfLabours.text,
                                  selectedStatus ?? "",
                                  selectedStage ?? "",
                                  description.text,
                                  workId);
                            }
                            Navigator.pop(context);
                            date.clear();
                            noOfLabours.clear();
                            description.clear();
                            selectedStatus = null;
                            selectedStage = null;
                            isWorking = 'Yes';
                          }
                        },
                        child: LargeButton(
                            title: type == "add" ? "Add" : "Update"),
                      ),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Close'),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
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
