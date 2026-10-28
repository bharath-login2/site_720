// // ignore_for_file: must_be_immutable

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import 'package:site_720/core/constants/colors.dart';
// import 'package:site_720/core/widgets/shimmer.dart';
// import 'package:site_720/data/models/workdetails/work_detail_model.dart';
// import 'package:site_720/features/work_details/cubit/work_details_state.dart';
// import '../../../core/widgets/buttons.dart';
// import '../../../core/widgets/connectivity_dialog.dart';
// import '../../../core/utilities/permission_manager.dart';
// import '../../../core/widgets/dialogs.dart';
// import '../../../core/widgets/snack_bar.dart';
// import '../../../data/models/workdetails/add_work_details_model.dart';
// import '../../../data/models/workdetails/work_stage_model.dart';
// import '../../connectivity/cubit/connectivity_cubit.dart';
// import '../../connectivity/cubit/connectivity_state.dart';
// import '../cubit/work_details_cubit.dart';

// class WorkDetailsScreen extends StatelessWidget {
//   WorkDetailsScreen({super.key});

//   List<WorkIssues> issuesList = [];
//   List<WorkDetails> workList = [];
//   List<Workstage> stageList = [];
//   String isWorking = 'Yes';
//   String? selectedStatus;
//   String? selectedStage;
//   final formKey = GlobalKey<FormState>();
//   TextEditingController date = TextEditingController();
//   TextEditingController noOfLabours = TextEditingController();
//   TextEditingController description = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final rawArgs = ModalRoute.of(context)?.settings.arguments;
//     final Map<String, dynamic> args =
//         rawArgs is Map ? Map<String, dynamic>.from(rawArgs) : {};
//     String id = args["id"]?.toString() ?? args["project_id"]?.toString() ?? "";
//     String clientId = args["client_id"]?.toString() ?? "";
//     return BlocProvider(
//       create: (context) => WorkDetailsCubit(id),
//       child: MultiBlocListener(
//         listeners: [
//           BlocListener<ConnectivityCubit, ConnectivityState>(
//             listener: (context, state) {
//               if (state is ConnectivityDisconnected) {
//                 if (connStatus == true) {
//                   connStatus = false;
//                   connectivityDialog(context);
//                 }
//               } else {
//                 connStatus = true;
//               }
//             },
//           ),
//           BlocListener<WorkDetailsCubit, WorkDetailsState>(
//             listener: (context, state) {
//               if (state is WorkStatusSuccess) {
//                 issuesList = state.response.data;
//               }
//               if (state is WorkDetailsSuccess) {
//                 workList = state.response.data;
//               }
//               if (state is WorkStagesSuccess) {
//                 stageList = state.response.data;
//               }
//               if (state is AddingSuccess) {
//                 snackBar(context, state.message, Colors.green);
//               }
//               if (state is AddingFailure) {
//                 snackBar(context, state.message, Colors.red);
//               }
//             },
//           )
//         ],
//         child: BlocBuilder<WorkDetailsCubit, WorkDetailsState>(
//           builder: (context, state) {
//             final cubit = context.read<WorkDetailsCubit>();
//             return Scaffold(
//               backgroundColor: AppColors.backgroundColor,
//               appBar: PreferredSize(
//                 preferredSize:
//                     Size.fromHeight(MediaQuery.of(context).size.height * 0.2),
//                 child: Container(
//                   height: MediaQuery.of(context).size.height * .15,
//                   width: MediaQuery.of(context).size.width,
//                   decoration: const BoxDecoration(
//                       image: DecorationImage(
//                           image: AssetImage("assets/images/appbar.png"),
//                           fit: BoxFit.fill),
//                       color: AppColors.primaryColor,
//                       borderRadius: BorderRadius.only(
//                         bottomLeft: Radius.circular(25),
//                         bottomRight: Radius.circular(25),
//                       )),
//                   child: Padding(
//                     padding:
//                         const EdgeInsets.only(left: 20.0, top: 35, right: 20),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             InkWell(
//                               onTap: () {
//                                 Navigator.pop(context);
//                               },
//                               child: const Icon(
//                                 Icons.arrow_back_ios,
//                                 color: Colors.white,
//                               ),
//                             ),
//                             const SizedBox(
//                               width: 10,
//                             ),
//                             const Text(
//                               "Work Details",
//                               style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   letterSpacing: 1,
//                                   fontFamily: "Lobster",
//                                   color: Colors.white),
//                             ),
//                           ],
//                         ),
//                         // Removed the add button from app bar
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               floatingActionButton:
//                   PermissionManager.hasPermission('add work details')
//                       ? FloatingActionButton(
//                           onPressed: () {
//                             date.text =
//                                 DateFormat('dd-MM-yyyy').format(DateTime.now());
//                             selectedStatus = null;
//                             selectedStage = null;
//                             noOfLabours.clear();
//                             description.clear();
//                             isWorking = 'Yes';

//                             if (issuesList.isNotEmpty) {
//                               workDialog(
//                                 context,
//                                 cubit,
//                                 issuesList,
//                                 stageList,
//                                 id,
//                                 clientId,
//                                 "add",
//                                 "",
//                               ).then((_) {
//                                 date.clear();
//                                 noOfLabours.clear();
//                                 description.clear();
//                                 selectedStatus = null;
//                                 selectedStage = null;
//                                 isWorking = 'Yes';
//                               });
//                             } else {
//                               snackBar(
//                                 context,
//                                 "Something went wrong",
//                                 Colors.red,
//                               );
//                             }
//                           },
//                           backgroundColor: AppColors.lightPrimary,
//                           child: const Icon(
//                             Icons.add,
//                             color: Colors.white,
//                           ),
//                         )
//                       : null,
//               body: RefreshIndicator(
//                 onRefresh: () async {
//                   cubit.getWorkDetails(id);
//                 },
//                 child: workList.isEmpty && state is! WorkDetailsLoading
//                     ? Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Image.asset(
//                               'assets/images/no_data.png',
//                               height: 100,
//                               width: 100,
//                             ),
//                             const SizedBox(height: 20),
//                             const Text(
//                               'No Data Found',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                             const SizedBox(height: 10),
//                             TextButton(
//                               onPressed: () {
//                                 cubit.getWorkDetails(id);
//                               },
//                               child: const Text(
//                                 'Refresh',
//                                 style: TextStyle(
//                                   color: AppColors.primaryColor,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     : ListView.builder(
//                         shrinkWrap: true,
//                         padding: const EdgeInsets.all(8),
//                         itemCount:
//                             state is WorkDetailsLoading ? 7 : workList.length,
//                         itemBuilder: (context, index) {
//                           return Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: state is WorkDetailsLoading
//                                   ? shimmerContainer(
//                                       MediaQuery.of(context).size.height * .1,
//                                       MediaQuery.of(context).size.width * .9)
//                                   : InkWell(
//                                       onTap: () {},
//                                       child: Container(
//                                         width:
//                                             MediaQuery.of(context).size.width *
//                                                 .9,
//                                         height:
//                                             MediaQuery.of(context).size.height *
//                                                 .1,
//                                         decoration: BoxDecoration(
//                                           borderRadius:
//                                               BorderRadius.circular(5),
//                                           color: Colors.white,
//                                           boxShadow: [
//                                             BoxShadow(
//                                               color:
//                                                   Colors.grey.withOpacity(0.8),
//                                               blurRadius: 3,
//                                               offset: const Offset(0, 3),
//                                             ),
//                                           ],
//                                         ),
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Container(
//                                                 width: MediaQuery.of(context)
//                                                         .size
//                                                         .width *
//                                                     .2,
//                                                 decoration: BoxDecoration(
//                                                   borderRadius:
//                                                       BorderRadius.circular(5),
//                                                   image: const DecorationImage(
//                                                       image: AssetImage(
//                                                           "assets/images/appbar.png"),
//                                                       fit: BoxFit.fill),
//                                                   boxShadow: [
//                                                     BoxShadow(
//                                                       color: Colors.grey
//                                                           .withOpacity(0.8),
//                                                       blurRadius: 6,
//                                                       offset:
//                                                           const Offset(1, 1),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 alignment: Alignment.center,
//                                                 child: Column(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.center,
//                                                   children: [
//                                                     Text(
//                                                       workList[index].workDay,
//                                                       style: const TextStyle(
//                                                           fontSize: 20,
//                                                           fontWeight:
//                                                               FontWeight.bold,
//                                                           color: AppColors
//                                                               .backgroundColor),
//                                                     ),
//                                                     Text(
//                                                       workList[index]
//                                                           .workMonthName,
//                                                       style: const TextStyle(
//                                                           fontSize: 14,
//                                                           fontWeight:
//                                                               FontWeight.bold,
//                                                           color: AppColors
//                                                               .backgroundColor),
//                                                     ),
//                                                     Text(
//                                                       workList[index].workYear,
//                                                       style: const TextStyle(
//                                                           fontSize: 14,
//                                                           fontWeight:
//                                                               FontWeight.bold,
//                                                           color: AppColors
//                                                               .backgroundColor),
//                                                     )
//                                                   ],
//                                                 )),
//                                             SizedBox(
//                                               width: MediaQuery.of(context)
//                                                       .size
//                                                       .width *
//                                                   .7,
//                                               child: Padding(
//                                                 padding: const EdgeInsets.only(
//                                                     top: 8.0,
//                                                     left: 8.0,
//                                                     right: 8.0,
//                                                     bottom: 8.0),
//                                                 child: Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment
//                                                           .spaceBetween,
//                                                   children: [
//                                                     // Column(
//                                                     //   crossAxisAlignment:
//                                                     //       CrossAxisAlignment
//                                                     //           .start,
//                                                     //   children: [
//                                                     //     Text(
//                                                     //       workList[index]
//                                                     //                   .isWorking ==
//                                                     //               "No"
//                                                     //           ? workList[index]
//                                                     //               .workStatus
//                                                     //           : "Labour No:${workList[index].laboursNo}",
//                                                     //       style:
//                                                     //           const TextStyle(
//                                                     //         fontSize: 14,
//                                                     //         fontWeight:
//                                                     //             FontWeight.bold,
//                                                     //       ),
//                                                     //     ),
//                                                     //     Text(
//                                                     //       "Stage Name : ${workList[index].stageName ?? ''}",
//                                                     //       style: const TextStyle(
//                                                     //           fontSize: 10,
//                                                     //           fontWeight:
//                                                     //               FontWeight
//                                                     //                   .bold,
//                                                     //           color: AppColors
//                                                     //               .coffie),
//                                                     //     ),
//                                                     //     Text(
//                                                     //       "Description: ${workList[index].description ?? ''}",
//                                                     //       style:
//                                                     //           const TextStyle(
//                                                     //         fontSize: 10,
//                                                     //         fontWeight:
//                                                     //             FontWeight.bold,
//                                                     //         color: AppColors
//                                                     //             .coffie,
//                                                     //       ),
//                                                     //       maxLines:
//                                                     //           3,
//                                                     //       overflow: TextOverflow
//                                                     //           .ellipsis,
//                                                     //     )
//                                                     //   ],
//                                                     // ),
//                                                     Flexible(
//                                                       child: Column(
//                                                         crossAxisAlignment:
//                                                             CrossAxisAlignment
//                                                                 .start,
//                                                         mainAxisAlignment:
//                                                             MainAxisAlignment
//                                                                 .start, // avoid stretching
//                                                         children: [
//                                                           Text(
//                                                             workList[index]
//                                                                         .isWorking ==
//                                                                     "No"
//                                                                 ? workList[
//                                                                         index]
//                                                                     .workStatus
//                                                                 : "Labour No:${workList[index].laboursNo}",
//                                                             style:
//                                                                 const TextStyle(
//                                                               fontSize: 14,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .bold,
//                                                             ),
//                                                           ),
//                                                           Text(
//                                                             "Stage Name : ${workList[index].stageName ?? ''}",
//                                                             style:
//                                                                 const TextStyle(
//                                                               fontSize: 10,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .bold,
//                                                               color: AppColors
//                                                                   .coffie,
//                                                             ),
//                                                           ),
//                                                           Text(
//                                                             "Description: ${workList[index].description ?? ''}",
//                                                             style:
//                                                                 const TextStyle(
//                                                               fontSize: 10,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .bold,
//                                                               color: AppColors
//                                                                   .coffie,
//                                                             ),
//                                                             maxLines: 2,
//                                                             overflow:
//                                                                 TextOverflow
//                                                                     .ellipsis,
//                                                             softWrap: true,
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                     SizedBox(
//                                                       height: 10,
//                                                     ),
//                                                     Column(
//                                                       crossAxisAlignment:
//                                                           CrossAxisAlignment
//                                                               .end,
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .spaceBetween,
//                                                       children: [
//                                                         Container(
//                                                             decoration:
//                                                                 BoxDecoration(
//                                                               borderRadius:
//                                                                   BorderRadius
//                                                                       .circular(
//                                                                           5),
//                                                               color: AppColors
//                                                                   .backgroundColor,
//                                                               boxShadow: [
//                                                                 BoxShadow(
//                                                                   color: Colors
//                                                                       .grey
//                                                                       .withOpacity(
//                                                                           0.8),
//                                                                   blurRadius: 6,
//                                                                   offset:
//                                                                       const Offset(
//                                                                           1, 1),
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                             alignment: Alignment
//                                                                 .center,
//                                                             child: Padding(
//                                                               padding:
//                                                                   const EdgeInsets
//                                                                       .symmetric(
//                                                                 horizontal:
//                                                                     20.0,
//                                                               ),
//                                                               child: Text(
//                                                                 workList[index]
//                                                                             .isWorking ==
//                                                                         "No"
//                                                                     ? "Not Worked"
//                                                                     : "Worked",
//                                                                 style: TextStyle(
//                                                                     fontSize:
//                                                                         14,
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .bold,
//                                                                     color: workList[index].isWorking ==
//                                                                             "No"
//                                                                         ? AppColors
//                                                                             .primaryColor
//                                                                         : Colors
//                                                                             .green),
//                                                               ),
//                                                             )),
//                                                         Row(
//                                                           children: [
//                                                             InkWell(
//                                                               onTap: () {
//                                                                 isWorking = workList[
//                                                                             index]
//                                                                         .isWorking
//                                                                         .isNotEmpty
//                                                                     ? workList[
//                                                                             index]
//                                                                         .isWorking
//                                                                     : 'Yes';
//                                                                 date.text =
//                                                                     workList[
//                                                                             index]
//                                                                         .workDate;
//                                                                 noOfLabours
//                                                                     .text = workList[
//                                                                         index]
//                                                                     .laboursNo;
//                                                                 description
//                                                                     .text = workList[
//                                                                         index]
//                                                                     .description;

//                                                                 String
//                                                                     targetStatusId =
//                                                                     workList[
//                                                                             index]
//                                                                         .workStatusId
//                                                                         .toString()
//                                                                         .trim();
//                                                                 if (targetStatusId
//                                                                         .isNotEmpty &&
//                                                                     targetStatusId !=
//                                                                         "0" &&
//                                                                     issuesList.any((e) =>
//                                                                         e.id
//                                                                             .toString()
//                                                                             .trim() ==
//                                                                         targetStatusId)) {
//                                                                   selectedStatus =
//                                                                       targetStatusId;
//                                                                 } else {
//                                                                   String targetStatusName = workList[
//                                                                           index]
//                                                                       .workStatus
//                                                                       .toString()
//                                                                       .trim();
//                                                                   var matchByName =
//                                                                       issuesList
//                                                                           .firstWhere(
//                                                                     (e) =>
//                                                                         e.workStatus
//                                                                             .toString()
//                                                                             .trim()
//                                                                             .toLowerCase() ==
//                                                                         targetStatusName
//                                                                             .toLowerCase(),
//                                                                     orElse: () => WorkIssues(
//                                                                         id: "",
//                                                                         workStatus:
//                                                                             ""),
//                                                                   );
//                                                                   if (matchByName
//                                                                           .id
//                                                                           .toString()
//                                                                           .trim()
//                                                                           .isNotEmpty &&
//                                                                       matchByName
//                                                                               .id
//                                                                               .toString()
//                                                                               .trim() !=
//                                                                           "0") {
//                                                                     selectedStatus =
//                                                                         matchByName
//                                                                             .id
//                                                                             .toString()
//                                                                             .trim();
//                                                                   } else {
//                                                                     selectedStatus =
//                                                                         null;
//                                                                   }
//                                                                 }

//                                                                 String
//                                                                     targetStageId =
//                                                                     workList[
//                                                                             index]
//                                                                         .stageId
//                                                                         .toString()
//                                                                         .trim();
//                                                                 if (targetStageId
//                                                                         .isNotEmpty &&
//                                                                     stageList.any((e) =>
//                                                                         e.stageId
//                                                                             .toString()
//                                                                             .trim() ==
//                                                                         targetStageId)) {
//                                                                   selectedStage =
//                                                                       targetStageId;
//                                                                 } else {
//                                                                   String targetStageName = workList[
//                                                                           index]
//                                                                       .stageName
//                                                                       .toString()
//                                                                       .trim();
//                                                                   var matchByName =
//                                                                       stageList
//                                                                           .firstWhere(
//                                                                     (e) =>
//                                                                         e.stageName
//                                                                             .toString()
//                                                                             .trim()
//                                                                             .toLowerCase() ==
//                                                                         targetStageName
//                                                                             .toLowerCase(),
//                                                                     orElse: () => Workstage(
//                                                                         stageId:
//                                                                             "",
//                                                                         stageName:
//                                                                             ""),
//                                                                   );
//                                                                   if (matchByName
//                                                                       .stageId
//                                                                       .toString()
//                                                                       .trim()
//                                                                       .isNotEmpty) {
//                                                                     selectedStage = matchByName
//                                                                         .stageId
//                                                                         .toString()
//                                                                         .trim();
//                                                                   } else {
//                                                                     selectedStage =
//                                                                         null;
//                                                                   }
//                                                                 }

//                                                                 workDialog(
//                                                                         context,
//                                                                         cubit,
//                                                                         issuesList,
//                                                                         stageList,
//                                                                         id,
//                                                                         clientId,
//                                                                         "edit",
//                                                                         workList[index]
//                                                                             .id)
//                                                                     .then((_) {
//                                                                   date.clear();
//                                                                   noOfLabours
//                                                                       .clear();
//                                                                   description
//                                                                       .clear();
//                                                                   selectedStatus =
//                                                                       null;
//                                                                   selectedStage =
//                                                                       null;
//                                                                   isWorking =
//                                                                       'Yes';
//                                                                 });
//                                                               },
//                                                               child: Container(
//                                                                 height: 25,
//                                                                 width: 25,
//                                                                 decoration:
//                                                                     BoxDecoration(
//                                                                   borderRadius:
//                                                                       BorderRadius
//                                                                           .circular(
//                                                                               5),
//                                                                   color: AppColors
//                                                                       .lightBlue,
//                                                                   boxShadow: [
//                                                                     BoxShadow(
//                                                                       color: Colors
//                                                                           .grey
//                                                                           .withOpacity(
//                                                                               0.8),
//                                                                       blurRadius:
//                                                                           6,
//                                                                       offset:
//                                                                           const Offset(
//                                                                               1,
//                                                                               1),
//                                                                     ),
//                                                                   ],
//                                                                 ),
//                                                                 child:
//                                                                     const Icon(
//                                                                   Icons.edit,
//                                                                   size: 18,
//                                                                   color: Colors
//                                                                       .white,
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                             const SizedBox(
//                                                               width: 7,
//                                                             ),
//                                                             InkWell(
//                                                               onTap: () {
//                                                                 deleteDialog(
//                                                                     context,
//                                                                     () {
//                                                                   String
//                                                                       targetId =
//                                                                       workList[
//                                                                               index]
//                                                                           .id
//                                                                           .toString();
//                                                                   workList.removeWhere((item) =>
//                                                                       item.id
//                                                                           .toString() ==
//                                                                       targetId);
//                                                                   cubit.deleteWorkDetails(
//                                                                       id,
//                                                                       targetId);
//                                                                   Navigator.pop(
//                                                                       context);
//                                                                 });
//                                                               },
//                                                               child: Container(
//                                                                 height: 25,
//                                                                 width: 25,
//                                                                 decoration:
//                                                                     BoxDecoration(
//                                                                   borderRadius:
//                                                                       BorderRadius
//                                                                           .circular(
//                                                                               5),
//                                                                   color: Colors
//                                                                       .red,
//                                                                   boxShadow: [
//                                                                     BoxShadow(
//                                                                       color: Colors
//                                                                           .grey
//                                                                           .withOpacity(
//                                                                               0.8),
//                                                                       blurRadius:
//                                                                           6,
//                                                                       offset:
//                                                                           const Offset(
//                                                                               1,
//                                                                               1),
//                                                                     ),
//                                                                   ],
//                                                                 ),
//                                                                 child:
//                                                                     const Icon(
//                                                                   Icons.delete,
//                                                                   size: 18,
//                                                                   color: Colors
//                                                                       .white,
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ));
//                         },
//                       ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Future<void> workDialog(
//     BuildContext context,
//     cubit,
//     List<WorkIssues> list,
//     List<Workstage> stagelist,
//     String projectId,
//     String clientId,
//     String type,
//     String workId,
//   ) async {
//     if (selectedStage != null) {
//       String stg = selectedStage!.toString().trim();
//       if (stg.isEmpty ||
//           !stagelist.any((data) => data.stageId.toString().trim() == stg)) {
//         selectedStage = null;
//       } else {
//         selectedStage = stg;
//       }
//     }
//     if (selectedStatus != null) {
//       String st = selectedStatus!.toString().trim();
//       if (st.isEmpty ||
//           st == "0" ||
//           !list.any((data) => data.id.toString().trim() == st)) {
//         selectedStatus = null;
//       } else {
//         selectedStatus = st;
//       }
//     }

//     /// Lives outside the builder so it survives dialog rebuilds
//     bool isSubmitting = false;

//     return showDialog(
//       context: context,
//       barrierDismissible: false, // can't tap outside to close mid-request
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setDialogState) {
//             return AlertDialog(
//               backgroundColor: Colors.white,
//               content: SizedBox(
//                   height: 550,
//                   child: SingleChildScrollView(
//                     child: Form(
//                       key: formKey,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding:
//                                 const EdgeInsets.only(top: 16.0, bottom: 25),
//                             child: Text(
//                               type == "add" ? "Add Work Details" : "Edit",
//                               style: const TextStyle(
//                                 color: AppColors.primaryColor,
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                           const Text(
//                             "Are You Sure Today is Working?",
//                             style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                                 color: AppColors.errorColor),
//                           ),
//                           Row(
//                             children: [
//                               Radio<String>(
//                                 value: 'Yes',
//                                 groupValue: isWorking,
//                                 onChanged: isSubmitting
//                                     ? null
//                                     : (value) {
//                                         setDialogState(() {
//                                           isWorking = value!;
//                                         });
//                                       },
//                               ),
//                               const Text("Yes"),
//                               Radio<String>(
//                                 value: 'No',
//                                 groupValue: isWorking,
//                                 onChanged: isSubmitting
//                                     ? null
//                                     : (value) {
//                                         setDialogState(() {
//                                           isWorking = value!;
//                                         });
//                                       },
//                               ),
//                               const Text("No"),
//                             ],
//                           ),
//                           const SizedBox(height: 12),
//                           Container(
//                             width: MediaQuery.of(context).size.width * 0.95,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(5),
//                             ),
//                             child: DropdownButtonFormField<String>(
//                               value: selectedStage,
//                               items: stagelist.map((data) {
//                                 return DropdownMenuItem<String>(
//                                   value: data.stageId.toString(),
//                                   child: Text(
//                                     data.stageName.toString(),
//                                   ),
//                                 );
//                               }).toList(),
//                               onChanged: isSubmitting
//                                   ? null
//                                   : (value) {
//                                       setDialogState(() {
//                                         selectedStage = value;
//                                       });
//                                     },
//                               validator: (value) {
//                                 if (value == null || value.trim().isEmpty) {
//                                   return "Select a Stage";
//                                 }
//                                 return null;
//                               },
//                               decoration: InputDecoration(
//                                 contentPadding: const EdgeInsets.all(10),
//                                 labelText: 'Stages*',
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 prefixIcon: const Icon(Icons.info),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 12),
//                           Container(
//                             width: MediaQuery.of(context).size.width * 0.95,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(5),
//                             ),
//                             child: TextFormField(
//                               validator: (value) {
//                                 if (value == null || value.trim().isEmpty) {
//                                   return "Enter Date";
//                                 }
//                                 return null;
//                               },
//                               onTap: isSubmitting
//                                   ? null
//                                   : () async {
//                                       String? selectedDate =
//                                           await selectDate(context);
//                                       if (selectedDate != null) {
//                                         setDialogState(() {
//                                           date.text = selectedDate;
//                                         });
//                                       }
//                                     },
//                               readOnly: true,
//                               controller: date,
//                               decoration: InputDecoration(
//                                 contentPadding: const EdgeInsets.all(10),
//                                 labelText: 'Date',
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 prefixIcon: const Icon(Icons.calendar_today),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 12),
//                           if (isWorking == "Yes")
//                             Container(
//                               width: MediaQuery.of(context).size.width * 0.95,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//                               child: TextFormField(
//                                 enabled: !isSubmitting,
//                                 validator: (value) {
//                                   if (isWorking == "Yes") {
//                                     if (value == null || value.trim().isEmpty) {
//                                       return "Enter Number of Labours";
//                                     }
//                                     final parsed = int.tryParse(value.trim());
//                                     if (parsed == null || parsed <= 0) {
//                                       return "No of Labours must be greater than 0";
//                                     }
//                                   }
//                                   return null;
//                                 },
//                                 controller: noOfLabours,
//                                 keyboardType: TextInputType.number,
//                                 decoration: InputDecoration(
//                                   contentPadding: const EdgeInsets.all(10),
//                                   labelText: 'No of Labours*',
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(5),
//                                   ),
//                                   prefixIcon: const Icon(Icons.group),
//                                 ),
//                               ),
//                             )
//                           else
//                             Container(
//                               width: MediaQuery.of(context).size.width * 0.95,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//                               child: DropdownButtonFormField<String>(
//                                 value: selectedStatus,
//                                 items: list.map((data) {
//                                   return DropdownMenuItem<String>(
//                                     value: data.id.toString(),
//                                     child: Text(
//                                       data.workStatus.toString(),
//                                     ),
//                                   );
//                                 }).toList(),
//                                 onChanged: isSubmitting
//                                     ? null
//                                     : (value) {
//                                         setDialogState(() {
//                                           selectedStatus = value;
//                                         });
//                                       },
//                                 validator: (value) {
//                                   if (isWorking == "No") {
//                                     if (value == null || value.trim().isEmpty) {
//                                       return "Select a Status";
//                                     }
//                                   }
//                                   return null;
//                                 },
//                                 decoration: InputDecoration(
//                                   contentPadding: const EdgeInsets.all(10),
//                                   labelText: 'Status*',
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(5),
//                                   ),
//                                   prefixIcon: const Icon(Icons.info),
//                                 ),
//                               ),
//                             ),
//                           const SizedBox(height: 12),
//                           Container(
//                             width: MediaQuery.of(context).size.width * 0.95,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(5),
//                             ),
//                             child: TextFormField(
//                               enabled: !isSubmitting,
//                               controller: description,
//                               keyboardType: TextInputType.text,
//                               maxLines: 3,
//                               validator: (value) {
//                                 if (value == null || value.trim().isEmpty) {
//                                   return "Enter Remark"; // Error message when empty
//                                 }
//                                 return null;
//                               },
//                               decoration: InputDecoration(
//                                 contentPadding: const EdgeInsets.all(10),
//                                 labelText: 'Remark*',
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 prefixIcon: const Icon(Icons.text_fields),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 20),

//                           /// ADD / UPDATE (shows loader while submitting)
//                           isSubmitting
//                               ? const Center(
//                                   child: Padding(
//                                     padding:
//                                         EdgeInsets.symmetric(vertical: 8.0),
//                                     child: CircularProgressIndicator(),
//                                   ),
//                                 )
//                               : GestureDetector(
//                                   onTap: () async {
//                                     // Guard: ignore taps while a request is running
//                                     if (isSubmitting) return;
//                                     if (!formKey.currentState!.validate())
//                                       return;

//                                     setDialogState(() => isSubmitting = true);

//                                     try {
//                                       final dynamic result;

//                                       if (type == "add") {
//                                         result = await cubit.addWorkDetails(
//                                             projectId,
//                                             clientId,
//                                             isWorking,
//                                             date.text,
//                                             noOfLabours.text,
//                                             selectedStatus ?? "",
//                                             selectedStage ?? "",
//                                             description.text);
//                                       } else {
//                                         result = await cubit.editWorkDetails(
//                                             projectId,
//                                             clientId,
//                                             isWorking,
//                                             date.text,
//                                             noOfLabours.text,
//                                             selectedStatus ?? "",
//                                             selectedStage ?? "",
//                                             description.text,
//                                             workId);
//                                       }

//                                       // Works with Future<void> (null) and
//                                       // Future<bool> (false = failed)
//                                       final bool success = result != false;

//                                       if (!context.mounted) return;

//                                       if (success) {
//                                         Navigator.pop(context);

//                                         date.clear();
//                                         noOfLabours.clear();
//                                         description.clear();
//                                         selectedStatus = null;
//                                         selectedStage = null;
//                                         isWorking = 'Yes';
//                                       } else {
//                                         // keep dialog + typed values, allow retry
//                                         setDialogState(
//                                             () => isSubmitting = false);
//                                       }
//                                     } catch (e) {
//                                       if (context.mounted) {
//                                         setDialogState(
//                                             () => isSubmitting = false);
//                                       }
//                                     }
//                                   },
//                                   child: LargeButton(
//                                       title: type == "add" ? "Add" : "Update"),
//                                 ),
//                           Center(
//                             child: TextButton(
//                               onPressed: isSubmitting
//                                   ? null
//                                   : () {
//                                       Navigator.pop(context);
//                                       date.clear();
//                                       noOfLabours.clear();
//                                       description.clear();
//                                       selectedStatus = null;
//                                       selectedStage = null;
//                                       isWorking = 'Yes';
//                                     },
//                               child: const Text('Close'),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   )),
//             );
//           },
//         );
//       },
//     );
//   }

//   selectDate(BuildContext context) async {
//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//     if (pickedDate != null) {
//       return DateFormat('dd-MM-yyyy').format(pickedDate);
//     }
//   }
// }
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/widgets/shimmer.dart';
import 'package:site_720/data/models/workdetails/work_detail_model.dart';
import 'package:site_720/features/work_details/cubit/work_details_state.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/connectivity_dialog.dart';
import '../../../core/utilities/permission_manager.dart';
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
    final rawArgs = ModalRoute.of(context)?.settings.arguments;
    final Map<String, dynamic> args =
        rawArgs is Map ? Map<String, dynamic>.from(rawArgs) : {};
    String id = args["id"]?.toString() ?? args["project_id"]?.toString() ?? "";
    String clientId = args["client_id"]?.toString() ?? "";
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
                snackBar(context, state.message, Colors.green);
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
                            const SizedBox(width: 10),
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
                      ],
                    ),
                  ),
                ),
              ),
              floatingActionButton:
                  PermissionManager.hasPermission('add work details')
                      ? FloatingActionButton(
                          onPressed: () {
                            date.text =
                                DateFormat('dd-MM-yyyy').format(DateTime.now());
                            selectedStatus = null;
                            selectedStage = null;
                            noOfLabours.clear();
                            description.clear();
                            isWorking = 'Yes';

                            if (issuesList.isNotEmpty) {
                              workDialog(
                                context,
                                cubit,
                                issuesList,
                                stageList,
                                id,
                                clientId,
                                "add",
                                "",
                              ).then((_) => _resetForm());
                            } else {
                              snackBar(
                                context,
                                "Something went wrong",
                                Colors.red,
                              );
                            }
                          },
                          backgroundColor: AppColors.lightPrimary,
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        )
                      : null,
              body: RefreshIndicator(
                onRefresh: () async {
                  cubit.getWorkDetails(id);
                },
                child: workList.isEmpty && state is! WorkDetailsLoading
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/no_data.png',
                              height: 100,
                              width: 100,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'No Data Found',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextButton(
                              onPressed: () {
                                cubit.getWorkDetails(id);
                              },
                              child: const Text(
                                'Refresh',
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
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
                                : _buildCard(
                                    context, cubit, index, id, clientId),
                          );
                        },
                      ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // CARD (tap the card or the arrow to expand / collapse long text)
  // ---------------------------------------------------------------------------
  Widget _buildCard(BuildContext context, WorkDetailsCubit cubit, int index,
      String id, String clientId) {
    final item = workList[index];
    return WorkCard(
      key: ValueKey(item.id), // keeps expanded state when the list rebuilds
      item: item,
      index: index,
      onEdit: () => _openEditDialog(context, cubit, index, id, clientId),
      onDelete: () {
        deleteDialog(context, () {
          // cubit removes the item from state itself
          cubit.deleteWorkDetails(id, item.id.toString());
          Navigator.pop(context);
        });
      },
    );
  }

  // ---------------------------------------------------------------------------
  // EDIT: fill the form from the selected item and open the dialog
  // ---------------------------------------------------------------------------
  void _openEditDialog(BuildContext context, WorkDetailsCubit cubit, int index,
      String id, String clientId) {
    final item = workList[index];

    isWorking = item.isWorking.isNotEmpty ? item.isWorking : 'Yes';
    date.text = item.workDate;
    noOfLabours.text = item.laboursNo;
    description.text = item.description;

    // ---- status: match by id first, then by name ----
    final targetStatusId = item.workStatusId.toString().trim();
    if (targetStatusId.isNotEmpty &&
        targetStatusId != "0" &&
        issuesList.any((e) => e.id.toString().trim() == targetStatusId)) {
      selectedStatus = targetStatusId;
    } else {
      final targetStatusName = item.workStatus.toString().trim().toLowerCase();
      final match = issuesList.firstWhere(
        (e) => e.workStatus.toString().trim().toLowerCase() == targetStatusName,
        orElse: () => WorkIssues(id: "", workStatus: ""),
      );
      final matchId = match.id.toString().trim();
      selectedStatus = (matchId.isNotEmpty && matchId != "0") ? matchId : null;
    }

    // ---- stage: match by id first, then by name ----
    final targetStageId = item.stageId.toString().trim();
    if (targetStageId.isNotEmpty &&
        stageList.any((e) => e.stageId.toString().trim() == targetStageId)) {
      selectedStage = targetStageId;
    } else {
      final targetStageName = item.stageName.toString().trim().toLowerCase();
      final match = stageList.firstWhere(
        (e) => e.stageName.toString().trim().toLowerCase() == targetStageName,
        orElse: () => Workstage(stageId: "", stageName: ""),
      );
      final matchId = match.stageId.toString().trim();
      selectedStage = matchId.isNotEmpty ? matchId : null;
    }

    workDialog(
      context,
      cubit,
      issuesList,
      stageList,
      id,
      clientId,
      "edit",
      item.id,
    ).then((_) => _resetForm());
  }

  void _resetForm() {
    date.clear();
    noOfLabours.clear();
    description.clear();
    selectedStatus = null;
    selectedStage = null;
    isWorking = 'Yes';
  }

  // ---------------------------------------------------------------------------
  // ADD / EDIT DIALOG
  // ---------------------------------------------------------------------------
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
    if (selectedStage != null) {
      String stg = selectedStage!.toString().trim();
      if (stg.isEmpty ||
          !stagelist.any((data) => data.stageId.toString().trim() == stg)) {
        selectedStage = null;
      } else {
        selectedStage = stg;
      }
    }
    if (selectedStatus != null) {
      String st = selectedStatus!.toString().trim();
      if (st.isEmpty ||
          st == "0" ||
          !list.any((data) => data.id.toString().trim() == st)) {
        selectedStatus = null;
      } else {
        selectedStatus = st;
      }
    }

    /// Lives outside the builder so it survives dialog rebuilds
    bool isSubmitting = false;

    return showDialog(
      context: context,
      barrierDismissible: false, // can't tap outside to close mid-request
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
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
                            padding:
                                const EdgeInsets.only(top: 16.0, bottom: 25),
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
                                onChanged: isSubmitting
                                    ? null
                                    : (value) {
                                        setDialogState(() {
                                          isWorking = value!;
                                        });
                                      },
                              ),
                              const Text("Yes"),
                              Radio<String>(
                                value: 'No',
                                groupValue: isWorking,
                                onChanged: isSubmitting
                                    ? null
                                    : (value) {
                                        setDialogState(() {
                                          isWorking = value!;
                                        });
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
                              isExpanded: true,
                              items: stagelist.map((data) {
                                return DropdownMenuItem<String>(
                                  value: data.stageId.toString(),
                                  child: Text(
                                    data.stageName.toString(),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                              onChanged: isSubmitting
                                  ? null
                                  : (value) {
                                      setDialogState(() {
                                        selectedStage = value;
                                      });
                                    },
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Select a Stage";
                                }
                                return null;
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
                                if (value == null || value.trim().isEmpty) {
                                  return "Enter Date";
                                }
                                return null;
                              },
                              onTap: isSubmitting
                                  ? null
                                  : () async {
                                      String? selectedDate =
                                          await selectDate(context);
                                      if (selectedDate != null) {
                                        setDialogState(() {
                                          date.text = selectedDate;
                                        });
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
                                enabled: !isSubmitting,
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
                                isExpanded: true,
                                items: list.map((data) {
                                  return DropdownMenuItem<String>(
                                    value: data.id.toString(),
                                    child: Text(
                                      data.workStatus.toString(),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }).toList(),
                                onChanged: isSubmitting
                                    ? null
                                    : (value) {
                                        setDialogState(() {
                                          selectedStatus = value;
                                        });
                                      },
                                validator: (value) {
                                  if (isWorking == "No") {
                                    if (value == null || value.trim().isEmpty) {
                                      return "Select a Status";
                                    }
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
                              enabled: !isSubmitting,
                              controller: description,
                              keyboardType: TextInputType.text,
                              maxLines: 3,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Enter Remark";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(10),
                                labelText: 'Remark*',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                prefixIcon: const Icon(Icons.text_fields),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          /// ADD / UPDATE (shows loader while submitting)
                          isSubmitting
                              ? const Center(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () async {
                                    // Guard: ignore taps while a request is running
                                    if (isSubmitting) return;
                                    if (!formKey.currentState!.validate()) {
                                      return;
                                    }

                                    setDialogState(() => isSubmitting = true);

                                    try {
                                      final dynamic result;

                                      if (type == "add") {
                                        result = await cubit.addWorkDetails(
                                            projectId,
                                            clientId,
                                            isWorking,
                                            date.text,
                                            noOfLabours.text,
                                            selectedStatus ?? "",
                                            selectedStage ?? "",
                                            description.text);
                                      } else {
                                        result = await cubit.editWorkDetails(
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

                                      // Works with Future<void> (null) and
                                      // Future<bool> (false = failed)
                                      final bool success = result != false;

                                      if (!context.mounted) return;

                                      if (success) {
                                        Navigator.pop(context);
                                        _resetForm();
                                      } else {
                                        // keep dialog + typed values, allow retry
                                        setDialogState(
                                            () => isSubmitting = false);
                                      }
                                    } catch (e) {
                                      if (context.mounted) {
                                        setDialogState(
                                            () => isSubmitting = false);
                                      }
                                    }
                                  },
                                  child: LargeButton(
                                      title: type == "add" ? "Add" : "Update"),
                                ),
                          Center(
                            child: TextButton(
                              onPressed: isSubmitting
                                  ? null
                                  : () {
                                      Navigator.pop(context);
                                      _resetForm();
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

// =============================================================================
// EXPANDABLE WORK CARD
// =============================================================================
class WorkCard extends StatefulWidget {
  final WorkDetails item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final int index;

  const WorkCard({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onDelete,
    this.index = 0,
  });

  @override
  State<WorkCard> createState() => _WorkCardState();
}

class _WorkCardState extends State<WorkCard> {
  bool _expanded = false;

  // Light label + medium value = easy to scan, no heavy bold
  static const _labelStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.35,
    color: Color(0xFF757575),
  );
  static const _valueStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.35,
    color: Color(0xDE000000),
  );
  static const _badgeStyle =
      TextStyle(fontSize: 12, fontWeight: FontWeight.w600);

  static const double _iconBox = 28;
  static const double _iconPad = 4;

  InlineSpan _span(String label, String value) => TextSpan(children: [
        TextSpan(text: "$label : ", style: _labelStyle),
        TextSpan(text: value, style: _valueStyle),
      ]);

  TextPainter _paint(
      InlineSpan span, int? maxLines, double maxWidth, TextScaler scaler) {
    return TextPainter(
      text: span,
      maxLines: maxLines,
      textDirection: TextDirection.ltr,
      textScaler: scaler,
    )..layout(maxWidth: maxWidth);
  }

  bool _overflows(
      InlineSpan span, int maxLines, double maxWidth, TextScaler scaler) {
    if (maxWidth <= 0) return false;
    return _paint(span, maxLines, maxWidth, scaler).didExceedMaxLines;
  }

  Widget _row(InlineSpan span, bool showFull, {bool justify = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Text.rich(
        span,
        textAlign: justify ? TextAlign.justify : TextAlign.start,
        maxLines: showFull ? null : 2,
        overflow: showFull ? TextOverflow.visible : TextOverflow.ellipsis,
      ),
    );
  }

  Widget _action(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.all(_iconPad),
        child: Container(
          height: _iconBox,
          width: _iconBox,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final size = MediaQuery.of(context).size;
    final scaler = MediaQuery.textScalerOf(context);

    final isNo = item.isWorking == "No";
    final first = isNo
        ? _span("Status", item.workStatus)
        : _span("Labour No", item.laboursNo);
    final stage = _span("Stage Name", "${item.stageName ?? ''}");
    final desc = _span("Description", "${item.description ?? ''}");
    final badge = isNo ? "Not Worked" : "Worked";
    final badgeColor = isNo ? AppColors.primaryColor : Colors.green;
    // border colour: red = not worked, green = worked
    final borderColor = isNo ? Colors.red.shade400 : Colors.green.shade500;

    // Width the text column gets, so we know if text is cut off
    final cardW = size.width * .9;
    final dateW = size.width * .2;
    final badgeW = _paint(TextSpan(text: badge, style: _badgeStyle), 1,
                double.infinity, scaler)
            .width +
        20;
    const iconsW = (_iconBox + _iconPad * 2) * 2 + 4;
    final rightW = badgeW > iconsW ? badgeW : iconsW;
    final textW = cardW - dateW - 16 - 8 - rightW;

    final canExpand = _overflows(first, 2, textW, scaler) ||
        _overflows(stage, 2, textW, scaler) ||
        _overflows(desc, 2, textW, scaler);
    final showFull = _expanded && canExpand;

    final card = AnimatedContainer(
      duration: const Duration(milliseconds: 250), // border colour fades
      curve: Curves.easeOut,
      width: cardW,
      constraints: BoxConstraints(minHeight: size.height * .1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: Material(
          color: Colors.white,
          child: InkWell(
            // tapping the card toggles; the edit / delete icons win over this
            onTap:
                canExpand ? () => setState(() => _expanded = !_expanded) : null,
            child: AnimatedSize(
              duration: const Duration(milliseconds: 200),
              alignment: Alignment.topCenter,
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // LEFT: date box
                    Container(
                      width: dateW,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryColor,
                        image: DecorationImage(
                          image: AssetImage("assets/images/appbar.png"),
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.workDay,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              height: 1.1,
                              color: AppColors.backgroundColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.workMonthName,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.backgroundColor,
                            ),
                          ),
                          Text(
                            item.workYear,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color:
                                  AppColors.backgroundColor.withOpacity(0.85),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // MIDDLE + RIGHT
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // TEXT COLUMN
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  _row(first, showFull),
                                  _row(stage, showFull),
                                  _row(desc, showFull, justify: true),
                                  // down / up arrow, only when text is cut off
                                  if (canExpand)
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: AnimatedRotation(
                                        turns: _expanded ? 0.5 : 0,
                                        duration:
                                            const Duration(milliseconds: 200),
                                        child: Icon(
                                          Icons.keyboard_arrow_down,
                                          size: 22,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),

                            // RIGHT COLUMN: status pill + actions
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: badgeColor.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    badge,
                                    style:
                                        _badgeStyle.copyWith(color: badgeColor),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _action(Icons.edit_outlined,
                                        AppColors.primaryColor, widget.onEdit),
                                    const SizedBox(width: 4),
                                    _action(Icons.delete_outline, Colors.red,
                                        widget.onDelete),
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
            ),
          ),
        ),
      ),
    );

    // entrance: fade + slide up, later items start a little slower
    final extra = (widget.index > 8 ? 8 : widget.index) * 70;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 350 + extra),
      curve: Curves.easeOutCubic,
      builder: (context, v, child) => Opacity(
        opacity: v,
        child: Transform.translate(
          offset: Offset(0, 16 * (1 - v)),
          child: child,
        ),
      ),
      child: card,
    );
  }
}
