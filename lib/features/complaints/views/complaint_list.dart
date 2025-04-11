// ignore_for_file: must_be_immutable, prefer_const_constructors_in_immutables

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

  final formKey = GlobalKey<FormState>();
  TextEditingController status = TextEditingController();
  TextEditingController remark = TextEditingController();

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
            ComplaintCubit cubit = context.read<ComplaintCubit>();
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
                body: state is ComplaintFailure
                    ? const Center(
                        child: Text("Something went wrong"),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 6.0),
                        itemCount: cubit.complaints.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: state is ComplaintLoading
                                ? shimmerContainer(80, 200)
                                : cubit.complaints.isNotEmpty
                                    ? InkWell(
                                        onTap: () {
                                          // Navigator.of(context).pushNamed(AppRoutes.stageHistory);
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
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: SizedBox(
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
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          if (cubit
                                                                  .complaints[
                                                                      index]
                                                                  .customerName !=
                                                              '')
                                                            Text(
                                                              cubit
                                                                  .complaints[
                                                                      index]
                                                                  .customerName,
                                                              style: const TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: AppColors
                                                                      .coffie),
                                                            ),
                                                          if (cubit
                                                                  .complaints[
                                                                      index]
                                                                  .natureName !=
                                                              '')
                                                            Text(
                                                              cubit
                                                                  .complaints[
                                                                      index]
                                                                  .natureName,
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: AppColors
                                                                      .coffie),
                                                            ),
                                                          if (cubit
                                                                  .complaints[
                                                                      index]
                                                                  .description !=
                                                              '')
                                                            Text(
                                                              cubit
                                                                  .complaints[
                                                                      index]
                                                                  .description,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          if (cubit
                                                                  .complaints[
                                                                      index]
                                                                  .incidentDate !=
                                                              '')
                                                            Text(
                                                              cubit
                                                                  .complaints[
                                                                      index]
                                                                  .incidentDate,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          if (cubit
                                                                  .complaints[
                                                                      index]
                                                                  .statusName !=
                                                              '')
                                                            Text(
                                                              cubit
                                                                  .complaints[
                                                                      index]
                                                                  .statusName,
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: cubit.complaints[index].statusName ==
                                                                          "Closed"
                                                                      ? AppColors
                                                                          .primaryColor
                                                                      : cubit.complaints[index].statusName ==
                                                                              "NEW"
                                                                          ? Colors
                                                                              .blue
                                                                          : Colors
                                                                              .green),
                                                            ),
                                                        ],
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  updateStatus(
                                                                      context,
                                                                      cubit);
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
                                                                            1,
                                                                            1),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  child:
                                                                      const Icon(
                                                                    Icons
                                                                        .upload,
                                                                    size: 18,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ),
                                                              // const SizedBox(
                                                              //   width: 7,
                                                              // ),
                                                              // InkWell(
                                                              //   onTap: () {},
                                                              //   child: Container(
                                                              //     height: 25,
                                                              //     width: 25,
                                                              //     decoration: BoxDecoration(
                                                              //       borderRadius:
                                                              //           BorderRadius
                                                              //               .circular(5),
                                                              //       color:
                                                              //           AppColors.lightBlue,
                                                              //       boxShadow: [
                                                              //         BoxShadow(
                                                              //           color: Colors.grey
                                                              //               .withOpacity(
                                                              //                   0.8),
                                                              //           blurRadius: 6,
                                                              //           offset:
                                                              //               const Offset(
                                                              //                   1, 1),
                                                              //         ),
                                                              //       ],
                                                              //     ),
                                                              //     child: const Icon(
                                                              //       Icons.edit,
                                                              //       size: 18,
                                                              //       color: Colors.white,
                                                              //     ),
                                                              //   ),
                                                              // ),
                                                              // const SizedBox(
                                                              //   width: 7,
                                                              // ),
                                                              // InkWell(
                                                              //   onTap: () {
                                                              //     deleteDialog(context, () {
                                                              //       Navigator.pop(context);
                                                              //     });
                                                              //   },
                                                              //   child: Container(
                                                              //     height: 25,
                                                              //     width: 25,
                                                              //     decoration: BoxDecoration(
                                                              //       borderRadius:
                                                              //           BorderRadius
                                                              //               .circular(5),
                                                              //       color: Colors.red,
                                                              //       boxShadow: [
                                                              //         BoxShadow(
                                                              //           color: Colors.grey
                                                              //               .withOpacity(
                                                              //                   0.8),
                                                              //           blurRadius: 6,
                                                              //           offset:
                                                              //               const Offset(
                                                              //                   1, 1),
                                                              //         ),
                                                              //       ],
                                                              //     ),
                                                              //     child: const Icon(
                                                              //       Icons.delete,
                                                              //       size: 18,
                                                              //       color: Colors.white,
                                                              //     ),
                                                              //   ),
                                                              // ),
                                                            ],
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : const Center(
                                        child: Text("Empty..."),
                                      ),
                          );
                        },
                      ));
          },
        ),
      ),
    );
  }

  Future<void> updateStatus(
    BuildContext context,
    ComplaintCubit cubit,
  ) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              content: SizedBox(
                height: 300,
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 16.0, bottom: 25),
                          child: Text(
                            "Update Status",
                            style: TextStyle(
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
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            controller: status,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(10),
                              labelText: 'Status',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              prefixIcon: const Icon(Icons.edit),
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
                            keyboardType: TextInputType.text,
                            controller: remark,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(10),
                              labelText: 'Remark',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              prefixIcon: const Icon(Icons.text_fields),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (formKey.currentState!.validate()) {
                              Navigator.pop(context);
                            }
                          },
                          child: LargeButton(title: "Update"),
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
              ),
            );
          },
        );
      },
    );
  }
}
