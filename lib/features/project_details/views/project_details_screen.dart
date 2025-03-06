// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/constants/routes.dart';
import 'package:site_720/features/project_details/cubit/project_details_cubit.dart';
import 'package:site_720/features/project_details/cubit/project_details_state.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/connectivity_dialog.dart';
import '../../connectivity/cubit/connectivity_cubit.dart';
import '../../connectivity/cubit/connectivity_state.dart';
import '../widgets/details_button_container.dart';
import '../widgets/details_item.dart';
import '../widgets/floating_profile_card.dart';

class ProjectDetails extends StatelessWidget {
  ProjectDetails({super.key});
  String clientId = "";
  String id = "";

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    id = args["id"]!;

    return BlocProvider(
      create: (context) => ProjectDetailsCubit(id),
      child: BlocBuilder<ProjectDetailsCubit, ProjectDetailsState>(
        builder: (context, state) {
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
              BlocListener<ProjectDetailsCubit, ProjectDetailsState>(
                listener: (context, state) {
                  if (state is ProjectDetailsSuccess) {
                    clientId = state.response.data.clientId;
                  }
                },
              )
            ],
            child: Scaffold(
                backgroundColor: AppColors.backgroundColor,
                body: SingleChildScrollView(
                  child: Stack(
                    children: [
                      SizedBox(
                        // height: MediaQuery.of(context).size.height,
                        child: Column(
                          children: [
                            FloatingAppBar(
                              title: "Project Details",
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * .075,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * .95,
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
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16.0, horizontal: 16),
                                child: Column(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(
                                          top: 12.0, bottom: 16.0),
                                      child: Text(
                                        "OVERVIEW",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primaryColor),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        DetailsItem(
                                          title: "Start Date",
                                          value: state is ProjectDetailsSuccess
                                              ? state.response.data.startingDate
                                              : null,
                                          icon: Icons.calendar_month,
                                        ),
                                        DetailsItem(
                                          title: "End Date",
                                          value: state is ProjectDetailsSuccess
                                              ? state
                                                  .response.data.completionDate
                                              : null,
                                          icon: Icons.calendar_month,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        DetailsItem(
                                          title: "Total Cost",
                                          value: state is ProjectDetailsSuccess
                                              ? state.response.data
                                                  .totalEstimateAmount
                                              : null,
                                          icon: Icons.currency_rupee,
                                        ),
                                        DetailsItem(
                                          title: "CCTV Address",
                                          value: state is ProjectDetailsSuccess
                                              ? state.response.data.cctvId
                                              : null,
                                          icon: Icons.video_camera_back,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        DetailsItem(
                                          title: "Total Worked",
                                          value: state is ProjectDetailsSuccess
                                              ? state.response.data.totalWorked
                                              : null,
                                          icon: Icons.done_all,
                                        ),
                                        DetailsItem(
                                          title: "Unassigned Work",
                                          value: state is ProjectDetailsSuccess
                                              ? state
                                                  .response.data.unassignedWorks
                                              : null,
                                          icon: Icons.person_off,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        DetailsItem(
                                          title: "Company Issues",
                                          value: state is ProjectDetailsSuccess
                                              ? state.response.data
                                                  .companyIssueCount
                                              : null,
                                          icon: Icons.location_city,
                                        ),
                                        DetailsItem(
                                          title: "Client Issues",
                                          value: state is ProjectDetailsSuccess
                                              ? state.response.data
                                                  .clientIssueCount
                                              : null,
                                          icon: Icons.person_remove,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        DetailsItem(
                                          title: "General Issues",
                                          value: state is ProjectDetailsSuccess
                                              ? state.response.data
                                                  .generalIssueCount
                                              : null,
                                          icon: Icons.public,
                                        ),
                                        DetailsItem(
                                          title: "Payment Delay",
                                          value: state is ProjectDetailsSuccess
                                              ? state.response.data
                                                  .paymentPendingCount
                                              : null,
                                          icon: Icons.currency_rupee,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              if (state
                                                  is ProjectDetailsSuccess) {
                                                connStatus = true;
                                                Navigator.pushNamed(context,
                                                    AppRoutes.imageViewer,
                                                    arguments: {
                                                      "title": "View Plan",
                                                      "image": state.response
                                                          .data.planImage
                                                    });
                                              }
                                            },
                                            child: DetailsButtonContainer(
                                              title: "View Plan",
                                              color: AppColors.coffie,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .4,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              if (state
                                                  is ProjectDetailsSuccess) {
                                                connStatus = true;
                                                Navigator.pushNamed(context,
                                                    AppRoutes.imageViewer,
                                                    arguments: {
                                                      "title": "View Elevation",
                                                      "image": state.response
                                                          .data.elevationImage
                                                    });
                                              }
                                            },
                                            child: DetailsButtonContainer(
                                              title: "View Elevation",
                                              color: AppColors.coffie,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .4,
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
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      connStatus = true;
                                      Navigator.pushNamed(
                                          context, AppRoutes.gallery,
                                          arguments: {
                                            "id": id,
                                            "client_id": clientId
                                          });
                                    },
                                    child: DetailsButtonContainer(
                                      title: "Gallery",
                                      color: AppColors.primaryColor,
                                      width: MediaQuery.of(context).size.width *
                                          .43,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      connStatus = true;
                                      Navigator.pushNamed(
                                          context, AppRoutes.workDetails,
                                          arguments: {
                                            "id": id,
                                            "client_id": clientId
                                          });
                                    },
                                    child: DetailsButtonContainer(
                                      title: "Work Details",
                                      color: AppColors.primaryColor,
                                      width: MediaQuery.of(context).size.width *
                                          .43,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      connStatus = true;
                                      Navigator.pushNamed(
                                          context, AppRoutes.drawing,
                                          arguments: {
                                            "id": id,
                                            "client_id": clientId
                                          });
                                    },
                                    child: DetailsButtonContainer(
                                      title: "Site Drawing",
                                      color: AppColors.primaryColor,
                                      width: MediaQuery.of(context).size.width *
                                          .43,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      connStatus = true;
                                      Navigator.pushNamed(
                                          context, AppRoutes.package,
                                          arguments: {
                                            "id": id,
                                            "client_id": clientId
                                          });
                                    },
                                    child: DetailsButtonContainer(
                                      title: "Package",
                                      color: AppColors.primaryColor,
                                      width: MediaQuery.of(context).size.width *
                                          .43,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      connStatus = true;
                                      Navigator.pushNamed(
                                          context, AppRoutes.stages,
                                          arguments: {
                                            "id": id,
                                            "client_id": clientId
                                          });
                                    },
                                    child: DetailsButtonContainer(
                                      title: "Stages",
                                      color: AppColors.primaryColor,
                                      width: MediaQuery.of(context).size.width *
                                          .43,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      connStatus = true;
                                      Navigator.pushNamed(
                                          context, AppRoutes.contractor,
                                          arguments: {"id": id});
                                    },
                                    child: DetailsButtonContainer(
                                      title: "Contractors",
                                      color: AppColors.primaryColor,
                                      width: MediaQuery.of(context).size.width *
                                          .43,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      connStatus = true;
                                      Navigator.pushNamed(
                                          context, AppRoutes.extraWork,
                                          arguments: {
                                            "id": id,
                                            "client_id": clientId
                                          });
                                    },
                                    child: DetailsButtonContainer(
                                      title: "Extra Work",
                                      color: AppColors.primaryColor,
                                      width: MediaQuery.of(context).size.width *
                                          .43,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      connStatus = true;
                                      Navigator.pushNamed(
                                          context, AppRoutes.deductionWork,
                                          arguments: {
                                            "id": id,
                                            "client_id": clientId
                                          });
                                    },
                                    child: DetailsButtonContainer(
                                      title: "Deduction Work",
                                      color: AppColors.primaryColor,
                                      width: MediaQuery.of(context).size.width *
                                          .43,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      connStatus = true;
                                      Navigator.pushNamed(
                                          context, AppRoutes.purchase,
                                          arguments: {"id": id});
                                    },
                                    child: DetailsButtonContainer(
                                      title: "Purchase",
                                      color: AppColors.primaryColor,
                                      width: MediaQuery.of(context).size.width *
                                          .43,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      connStatus = true;
                                      Navigator.pushNamed(
                                          context, AppRoutes.stock,
                                          arguments: {"id": id});
                                    },
                                    child: DetailsButtonContainer(
                                      title: "Stock",
                                      color: AppColors.primaryColor,
                                      width: MediaQuery.of(context).size.width *
                                          .43,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      connStatus = true;
                                      Navigator.pushNamed(
                                          context, AppRoutes.expense,
                                          arguments: {"id": id});
                                    },
                                    child: DetailsButtonContainer(
                                      title: "Expense",
                                      color: AppColors.primaryColor,
                                      width: MediaQuery.of(context).size.width *
                                          .43,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      connStatus = true;
                                      Navigator.pushNamed(
                                          context, AppRoutes.paymentDetails,
                                          arguments: {"id": id});
                                    },
                                    child: DetailsButtonContainer(
                                      title: "Payment Details",
                                      color: AppColors.primaryColor,
                                      width: MediaQuery.of(context).size.width *
                                          .43,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      connStatus = true;
                                      Navigator.pushNamed(
                                          context, AppRoutes.estimation,
                                          arguments: {"id": id});
                                    },
                                    child: DetailsButtonContainer(
                                      title: "Estimation",
                                      color: AppColors.primaryColor,
                                      width: MediaQuery.of(context).size.width *
                                          .43,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      connStatus = true;
                                      Navigator.pushNamed(
                                          context, AppRoutes.consumption,
                                          arguments: {"id": id});
                                    },
                                    child: DetailsButtonContainer(
                                      title: "Consumption",
                                      color: AppColors.primaryColor,
                                      width: MediaQuery.of(context).size.width *
                                          .43,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.16,
                        left: MediaQuery.of(context).size.width * 0.05,
                        child: FloatingProfileCard(
                          name: state is ProjectDetailsSuccess
                              ? state.response.data.clientName
                              : "",
                          address: state is ProjectDetailsSuccess
                              ? state.response.data.address
                              : "",
                          phoneNumber: state is ProjectDetailsSuccess
                              ? state.response.data.phoneNumber
                              : "",
                        ),
                      ),
                    ],
                  ),
                )),
          );
        },
      ),
    );
  }
}
