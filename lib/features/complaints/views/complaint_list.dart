// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/widgets/shimmer.dart';
import 'package:site_720/features/complaints/cubit/complaint_cubit.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/connectivity_dialog.dart';
import '../../connectivity/cubit/connectivity_cubit.dart';
import '../../connectivity/cubit/connectivity_state.dart';
import '../cubit/complaint_state.dart';

class ComplaintList extends StatelessWidget {
  ComplaintList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ComplaintCubit(),
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
        child: BlocBuilder<ComplaintCubit, ComplaintState>(
          builder: (context, state) {
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
                                "Complaints List",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                    fontFamily: "Lobster",
                                    color: Colors.white),
                              ),
                            ],
                          ),
                          // InkWell(
                          //   onTap: () {
                          //     Navigator.of(context)
                          //         .pushNamed(AppRoutes.addComplaints);
                          //   },
                          //   child: const CircleAvatar(
                          //     radius: 20,
                          //     backgroundColor: AppColors.lightPrimary,
                          //     child: Icon(
                          //       Icons.add,
                          //       color: Colors.white,
                          //     ),
                          //   ),
                          // )
                        ],
                      ),
                    ),
                  ),
                ),
                body: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 6.0),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: state is ComplaintSuccess
                          ? InkWell(
                              onTap: () {
                                // Navigator.of(context).pushNamed(AppRoutes.stageHistory);
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * .9,
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
                                child: SizedBox(
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
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                if (state.response.data[index]
                                                        .natureName !=
                                                    '')
                                                  Text(
                                                    state.response.data[index]
                                                        .natureName,
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            AppColors.coffie),
                                                  ),
                                                if (state.response.data[index]
                                                        .description !=
                                                    '')
                                                  Text(
                                                    state.response.data[index]
                                                        .description,
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                if (state.response.data[index]
                                                        .incidentDate !=
                                                    '')
                                                  Text(
                                                    state.response.data[index]
                                                        .incidentDate,
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                if (state.response.data[index]
                                                        .statusName !=
                                                    '')
                                                  Text(
                                                    state.response.data[index]
                                                        .statusName,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: state
                                                                    .response
                                                                    .data[index]
                                                                    .statusName ==
                                                                "Closed"
                                                            ? AppColors
                                                                .primaryColor
                                                            : Colors.green),
                                                  ),
                                              ],
                                            ),
                                            // Column(
                                            //   crossAxisAlignment:
                                            //       CrossAxisAlignment.end,
                                            //   children: [
                                            // Row(
                                            //   children: [
                                            //     InkWell(
                                            //       onTap: () {},
                                            //       child: Container(
                                            //         height: 25,
                                            //         width: 25,
                                            //         decoration: BoxDecoration(
                                            //           borderRadius:
                                            //               BorderRadius
                                            //                   .circular(5),
                                            //           color:
                                            //               AppColors.lightBlue,
                                            //           boxShadow: [
                                            //             BoxShadow(
                                            //               color: Colors.grey
                                            //                   .withOpacity(
                                            //                       0.8),
                                            //               blurRadius: 6,
                                            //               offset:
                                            //                   const Offset(
                                            //                       1, 1),
                                            //             ),
                                            //           ],
                                            //         ),
                                            //         child: const Icon(
                                            //           Icons.edit,
                                            //           size: 18,
                                            //           color: Colors.white,
                                            //         ),
                                            //       ),
                                            //     ),
                                            //     const SizedBox(
                                            //       width: 7,
                                            //     ),
                                            //     InkWell(
                                            //       onTap: () {
                                            //         deleteDialog(context, () {
                                            //           Navigator.pop(context);
                                            //         });
                                            //       },
                                            //       child: Container(
                                            //         height: 25,
                                            //         width: 25,
                                            //         decoration: BoxDecoration(
                                            //           borderRadius:
                                            //               BorderRadius
                                            //                   .circular(5),
                                            //           color: Colors.red,
                                            //           boxShadow: [
                                            //             BoxShadow(
                                            //               color: Colors.grey
                                            //                   .withOpacity(
                                            //                       0.8),
                                            //               blurRadius: 6,
                                            //               offset:
                                            //                   const Offset(
                                            //                       1, 1),
                                            //             ),
                                            //           ],
                                            //         ),
                                            //         child: const Icon(
                                            //           Icons.delete,
                                            //           size: 18,
                                            //           color: Colors.white,
                                            //         ),
                                            //       ),
                                            //     ),
                                            //   ],
                                            // ),
                                            //   ],
                                            // )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : shimmerContainer(80, 200),
                    );
                  },
                ));
          },
        ),
      ),
    );
  }

  Future<void> deleteDialog(BuildContext context, onTap) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: SizedBox(
            height: 200,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 30.0, bottom: 20),
                    child: Text(
                      "Are you sure ?",
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: LargeButton(title: "Delete"),
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
}
