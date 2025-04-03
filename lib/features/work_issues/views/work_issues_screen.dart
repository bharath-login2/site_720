// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/widgets/shimmer.dart';
import 'package:site_720/data/models/workdetails/work_detail_model.dart';
import '../../../core/widgets/connectivity_dialog.dart';
import '../../connectivity/cubit/connectivity_cubit.dart';
import '../../connectivity/cubit/connectivity_state.dart';
import '../cubit/work_issues_cubit.dart';
import '../cubit/work_issues_state.dart';

class WorkIssues extends StatelessWidget {
  WorkIssues({super.key});

  List<WorkDetails> workList = [];
  String isWorking = 'Yes';
  String? selectedStatus;
  final formKey = GlobalKey<FormState>();
  TextEditingController date = TextEditingController();
  TextEditingController noOfLabours = TextEditingController();
  TextEditingController description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    String statusId = args["status_id"]!;
    return BlocProvider(
      create: (context) => WorkIssuesCubit(statusId),
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
          BlocListener<WorkIssuesCubit, WorkIssuesState>(
            listener: (context, state) {
              if (state is WorkIssuesSuccess) {
                workList = state.response.data;
              }
            },
          )
        ],
        child: BlocBuilder<WorkIssuesCubit, WorkIssuesState>(
          builder: (context, state) {
            final cubit = context.read<WorkIssuesCubit>();
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
                                "Work Issues",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                    fontFamily: "Lobster",
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                body: RefreshIndicator(
                  onRefresh: () async {
                    cubit.getWorkIssues(statusId);
                  },
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8),
                    itemCount: state is WorkIssuesLoading ? 7 : workList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: state is WorkIssuesLoading
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
}
