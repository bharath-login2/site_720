// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:site_720/core/widgets/appbar.dart';
// import 'package:site_720/features/payment_details/widgets/amount_container.dart';
// import 'package:file_picker/file_picker.dart'; // Import file_picker package
// import '../../../core/constants/colors.dart';
// import '../../../core/widgets/buttons.dart';
// import '../../../core/widgets/connectivity_dialog.dart';
// import '../../../core/widgets/snack_bar.dart';

// import '../../connectivity/cubit/connectivity_cubit.dart';
// import '../../connectivity/cubit/connectivity_state.dart';
// import '../cubit/visit_details_cubit.dart';
// import '../cubit/visit_details_state.dart';

// class VisitDetails extends StatefulWidget {
//   const VisitDetails({super.key});

//   @override
//   _VisitDetailsState createState() => _VisitDetailsState();
// }

// class _VisitDetailsState extends State<VisitDetails> {
//   final formKey = GlobalKey<FormState>();
//   TextEditingController commentController = TextEditingController();
//   TextEditingController textController = TextEditingController();
//   String? selectedStatus;
//   XFile? image;
//   String visitId = "";
//   List<List<String>> checkboxAnswers = [];
//   List<TextEditingController> textControllers = [];
//   Map<int, dynamic> answers = {};
//   List<String?> fileAnswers =
//       []; // List to hold the file paths for file upload answers

//   // Extract file name from the answer (file path)
//   String _getFileName(dynamic answer) {
//     try {
//       if (answer is String) {
//         return answer.split('/').last;
//       } else if (answer is Map && answer['path'] != null) {
//         return answer['path'].toString().split('/').last;
//       }
//     } catch (e) {
//       print("Error extracting file name: $e");
//     }
//     return '';
//   }

//   // Collect answers to submit
//   Map<String, dynamic> _collectAnswers(List<dynamic> questions) {
//     Map<String, dynamic> answers = {};

//     for (int i = 0; i < questions.length; i++) {
//       final question = questions[i];
//       switch (question.answerType) {
//         case 'text_box':
//           answers['question_${i + 1}'] = textControllers[i].text;
//           break;
//         case 'checkbox':
//           answers['question_${i + 1}'] = checkboxAnswers[i];
//           break;
//         case 'file_upload':
//           answers['question_${i + 1}'] = fileAnswers[i];
//           break;
//         default:
//           break;
//       }
//     }
//     return answers;
//   }

//   void _submitAnswers(List<dynamic> questions) {
//     if (formKey.currentState?.validate() ?? false) {
//       Map<String, dynamic> answers = _collectAnswers(questions);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Answers Submitted Successfully")),
//       );
//       print("Submitted Answers: $answers");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final args =
//         ModalRoute.of(context)!.settings.arguments as Map<String, String>;
//     visitId = args["visit_id"]!;

//     return BlocProvider(
//       create: (context) => VisitDetailsCubit(visitId),
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
//           BlocListener<VisitDetailsCubit, VisitDetailsState>(
//             listener: (context, state) {
//               if (state is VisitDetailSuccessWithMessage) {
//                 snackBar(context, state.message, Colors.green);
//                 Navigator.pushReplacementNamed(
//                   context,
//                   '/visitDetails',
//                   arguments: {'visit_id': visitId},
//                 );
//               } else if (state is VisitDetailsFailure) {
//                 snackBar(context, state.message, Colors.red);
//               }
//             },
//           ),
//           BlocListener<VisitDetailsCubit, VisitDetailsState>(
//             listener: (context, state) {
//               if (state is VisitDetailSuccess) {
//                 final visitDetailsAll = state.response.data.data.visitDetails;
//                 final questions = state.response.data.data.questions;
//                 textControllers = List.generate(
//                     questions.length, (index) => TextEditingController());
//                 checkboxAnswers =
//                     List.generate(questions.length, (index) => []);
//                 fileAnswers = List.generate(questions.length, (index) => null);
//               }
//             },
//           ),
//       BlocListener<VisitDetailsCubit, VisitDetailsState>(
//       listener: (context, state) {
//         if (state is VisitDetailSuccessWithMessage) {
//           snackBar(context, state.message, Colors.green);
//           Navigator.pushReplacementNamed(
//             context,
//             '/visitDetails',
//             arguments: {'visit_id': visitId},
//           );
//         }
//       },
//     ),

//         ],
//         child: BlocBuilder<VisitDetailsCubit, VisitDetailsState>(
//           builder: (context, state) {
//             final cubit = context.read<VisitDetailsCubit>();
//             if (state is VisitDetailLoading) {
//               return Scaffold(
//                 appBar: simpleAppbar(context, "Visit Details", true),
//                 body: const Center(
//                   child: CircularProgressIndicator(),
//                 ),
//               );
//             }

//             if (state is VisitDetailSuccess) {
//               final visitDetailsAll = state.response.data.data.visitDetails;
//               final questions = state.response.data.data.questions;
//               final addedDetails = state.response.data.data.addedDetails;
//               return Scaffold(
//                 appBar: simpleAppbar(context, "Visit Details", true),
//                 body: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             color: AppColors.secondaryColor,
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.grey.withOpacity(0.8),
//                                 blurRadius: 4,
//                                 offset: const Offset(1, 1),
//                               ),
//                             ],
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child: Column(
//                               children: [
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           visitDetailsAll.visitName,
//                                           style: const TextStyle(
//                                               fontSize: 16,
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                         if (visitDetailsAll
//                                             .projectName.isNotEmpty)
//                                           Text(
//                                             visitDetailsAll.projectName,
//                                             style: const TextStyle(
//                                                 fontSize: 12,
//                                                 fontWeight: FontWeight.normal),
//                                           ),
//                                         Text(
//                                           'Stage: ${visitDetailsAll.stageName}',
//                                           style: const TextStyle(fontSize: 12),
//                                         ),
//                                         Text(
//                                           'Staff: ${visitDetailsAll.staffName}',
//                                           style: const TextStyle(fontSize: 12),
//                                         ),
//                                       ],
//                                     ),
//                                     InkWell(
//                                       onTap: () {
//                                         updateStatus(
//                                             context,
//                                             cubit,
//                                             visitDetailsAll.visitId,
//                                             visitDetailsAll.visitStatus);
//                                       },
//                                       child: Container(
//                                         decoration: BoxDecoration(
//                                           borderRadius:
//                                               BorderRadius.circular(5),
//                                           color: AppColors.backgroundColor,
//                                           boxShadow: [
//                                             BoxShadow(
//                                               color:
//                                                   Colors.grey.withOpacity(0.8),
//                                               blurRadius: 6,
//                                               offset: const Offset(1, 1),
//                                             ),
//                                           ],
//                                         ),
//                                         child: Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 12.0, vertical: 4.0),
//                                           child: Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Text(
//                                                 visitDetailsAll.visitStatus,
//                                                 style: const TextStyle(
//                                                     fontSize: 12,
//                                                     fontWeight:
//                                                         FontWeight.bold),
//                                               ),
//                                               const SizedBox(
//                                                 width: 8,
//                                               ),
//                                               const Icon(
//                                                 Icons.arrow_forward_ios,
//                                                 size: 14,
//                                               )
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 15),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     AmountContainer(
//                                         title: "From Date",
//                                         amount: DateFormat('dd-MM-yyyy')
//                                             .format(visitDetailsAll.fromDate),
//                                         valueColor: AppColors.primaryColor),
//                                     AmountContainer(
//                                         title: "To Date",
//                                         amount: DateFormat('dd-MM-yyyy')
//                                             .format(visitDetailsAll.toDate),
//                                         valueColor: AppColors.primaryColor),
//                                     AmountContainer(
//                                         title: "Sq.ft",
//                                         amount: visitDetailsAll.sqftName,
//                                         valueColor: AppColors.primaryColor),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               "Description :",
//                               style: TextStyle(
//                                   fontSize: 16, fontWeight: FontWeight.bold),
//                             ),
//                             Text(
//                               visitDetailsAll.description,
//                               style: const TextStyle(
//                                   fontSize: 12, fontWeight: FontWeight.w400),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 15,
//                       ),
//                       addedDetails.isEmpty
//                           ? SingleChildScrollView(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 16.0, vertical: 16.0),
//                                     child: BlocBuilder<VisitDetailsCubit,
//                                         VisitDetailsState>(
//                                       builder: (context, state) {
//                                         if (state is VisitDetailSuccess) {
//                                           final questions = state
//                                               .response.data.data.questions;
//                                           return Form(
//                                             key: formKey,
//                                             child:
//                                                 state.response.data.data
//                                                         .questions.isNotEmpty
//                                                     ? Column(
//                                                         crossAxisAlignment:
//                                                             CrossAxisAlignment
//                                                                 .start,
//                                                         children: [
//                                                           for (var i = 0;
//                                                               i <
//                                                                   questions
//                                                                       .length;
//                                                               i++) ...[
//                                                             Padding(
//                                                               padding:
//                                                                   const EdgeInsets
//                                                                       .only(
//                                                                       bottom:
//                                                                           16.0),
//                                                               child: Column(
//                                                                 crossAxisAlignment:
//                                                                     CrossAxisAlignment
//                                                                         .start,
//                                                                 children: [
//                                                                   const SizedBox(
//                                                                       height:
//                                                                           8),
//                                                                   if (questions[
//                                                                               i]
//                                                                           .answerType ==
//                                                                       'text_box')
//                                                                     Padding(
//                                                                       padding: const EdgeInsets
//                                                                           .only(
//                                                                           bottom:
//                                                                               16.0),
//                                                                       child:
//                                                                           Column(
//                                                                         crossAxisAlignment:
//                                                                             CrossAxisAlignment.start,
//                                                                         children: [
//                                                                           Text(
//                                                                             questions[i].question,
//                                                                             style:
//                                                                                 const TextStyle(
//                                                                               fontWeight: FontWeight.bold,
//                                                                               fontSize: 14,
//                                                                             ),
//                                                                           ),
//                                                                           const SizedBox(
//                                                                               height: 8),
//                                                                           TextFormField(
//                                                                             maxLines:
//                                                                                 4,
//                                                                             controller:
//                                                                                 textController,
//                                                                             keyboardType:
//                                                                                 TextInputType.text,
//                                                                             decoration:
//                                                                                 const InputDecoration(
//                                                                               border: OutlineInputBorder(),
//                                                                               hintText: 'Enter your answer',
//                                                                             ),
//                                                                             onChanged:
//                                                                                 (value) {
//                                                                               setState(() {});
//                                                                             },
//                                                                           ),
//                                                                         ],
//                                                                       ),
//                                                                     ),
//                                                                   if (questions[
//                                                                               i]
//                                                                           .answerType ==
//                                                                       'checkbox')
//                                                                     Padding(
//                                                                       padding: const EdgeInsets
//                                                                           .only(
//                                                                           bottom:
//                                                                               16.0),
//                                                                       child:
//                                                                           Column(
//                                                                         crossAxisAlignment:
//                                                                             CrossAxisAlignment.start,
//                                                                         children: [
//                                                                           Text(
//                                                                             questions[i].question,
//                                                                             style:
//                                                                                 const TextStyle(
//                                                                               fontWeight: FontWeight.bold,
//                                                                               fontSize: 14,
//                                                                             ),
//                                                                           ),
//                                                                           const SizedBox(
//                                                                               height: 8),
//                                                                           ...questions[i]
//                                                                               .checkboxOptions
//                                                                               .map((option) {
//                                                                             checkboxAnswers[i] =
//                                                                                 checkboxAnswers[i] ?? [];
//                                                                             final isChecked =
//                                                                                 checkboxAnswers[i].contains(option);

//                                                                             return Padding(
//                                                                               padding: const EdgeInsets.only(bottom: 8.0),
//                                                                               child: CheckboxListTile(
//                                                                                 title: Text(option),
//                                                                                 value: isChecked,
//                                                                                 onChanged: (bool? value) {
//                                                                                   setState(() {
//                                                                                     if (value == true) {
//                                                                                       if (checkboxAnswers[i].isEmpty) {
//                                                                                         checkboxAnswers[i].add(option);
//                                                                                       } else {
//                                                                                         ScaffoldMessenger.of(context).showSnackBar(
//                                                                                           SnackBar(
//                                                                                             content: const Text(
//                                                                                               'Only one option can be selected.',
//                                                                                               style: TextStyle(color: Colors.white),
//                                                                                             ),
//                                                                                             backgroundColor: Colors.red,
//                                                                                             duration: const Duration(seconds: 2),
//                                                                                             behavior: SnackBarBehavior.floating,
//                                                                                             shape: RoundedRectangleBorder(
//                                                                                               borderRadius: BorderRadius.circular(10),
//                                                                                             ),
//                                                                                             margin: const EdgeInsets.all(16),
//                                                                                           ),
//                                                                                         );
//                                                                                       }
//                                                                                     } else {
//                                                                                       checkboxAnswers[i].remove(option);
//                                                                                     }
//                                                                                   });
//                                                                                 },
//                                                                               ),
//                                                                             );
//                                                                           }),
//                                                                         ],
//                                                                       ),
//                                                                     ),
//                                                                   if (questions[
//                                                                               i]
//                                                                           .answerType ==
//                                                                       'file_upload')
//                                                                     Padding(
//                                                                       padding: const EdgeInsets
//                                                                           .only(
//                                                                           bottom:
//                                                                               16.0),
//                                                                       child:
//                                                                           Column(
//                                                                         crossAxisAlignment:
//                                                                             CrossAxisAlignment.start,
//                                                                         children: [
//                                                                           Text(
//                                                                             questions[i].question,
//                                                                             style:
//                                                                                 const TextStyle(
//                                                                               fontWeight: FontWeight.bold,
//                                                                               fontSize: 14,
//                                                                             ),
//                                                                           ),
//                                                                           const SizedBox(
//                                                                               height: 8),
//                                                                           Row(
//                                                                             children: [
//                                                                               ElevatedButton.icon(
//                                                                                 icon: const Icon(Icons.attach_file),
//                                                                                 label: const Text("Upload File"),
//                                                                                 onPressed: () async {
//                                                                                   FilePickerResult? result = await FilePicker.platform.pickFiles();

//                                                                                   if (result != null && result.files.isNotEmpty) {
//                                                                                     final filePath = result.files.single.path!;
//                                                                                     setState(() {
//                                                                                       answers[i] = filePath;
//                                                                                     });
//                                                                                   }
//                                                                                 },
//                                                                               ),
//                                                                               const SizedBox(width: 12),
//                                                                               Expanded(
//                                                                                 child: Text(
//                                                                                   _getFileName(
//                                                                                     // Check if this question has an existing saved answer
//                                                                                     questions[i].questionId == visitDetailsAll.addedQuestionId && visitDetailsAll.addedAnswer.isNotEmpty ? visitDetailsAll.addedAnswer : (answers[i] ?? ''),
//                                                                                   ),
//                                                                                   overflow: TextOverflow.ellipsis,
//                                                                                   style: const TextStyle(
//                                                                                     color: Colors.black54,
//                                                                                   ),
//                                                                                 ),
//                                                                               ),
//                                                                             ],
//                                                                           ),
//                                                                           if ((questions[i].questionId == visitDetailsAll.addedQuestionId && visitDetailsAll.addedAnswer.isNotEmpty) ||
//                                                                               (answers[i] != null && _getFileName(answers[i]).isNotEmpty))
//                                                                             const Padding(
//                                                                               padding: EdgeInsets.only(top: 8.0),
//                                                                             ),
//                                                                         ],
//                                                                       ),
//                                                                     ),
//                                                                 ],
//                                                               ),
//                                                             ),
//                                                           ],
//                                                           Center(
//                                                             child:
//                                                                 ElevatedButton(
//                                                               onPressed: () {
//                                                                 if (formKey
//                                                                     .currentState!
//                                                                     .validate()) {
//                                                                   List<String>
//                                                                       textQuestionNumbers =
//                                                                       [];
//                                                                   List<String>
//                                                                       checkboxQuestionNumbers =
//                                                                       [];
//                                                                   List<String>
//                                                                       fileQuestionNumbers =
//                                                                       [];
//                                                                   List<String>
//                                                                       textAnswers =
//                                                                       [];
//                                                                   List<List<String>>
//                                                                       checkboxAnswersList =
//                                                                       [];
//                                                                   List<String>
//                                                                       fileAnswers =
//                                                                       [];
//                                                                   for (var i =
//                                                                           0;
//                                                                       i <
//                                                                           questions
//                                                                               .length;
//                                                                       i++) {
//                                                                     final question =
//                                                                         questions[
//                                                                             i];
//                                                                     final answerType =
//                                                                         question
//                                                                             .answerType;
//                                                                     final questionNumber =
//                                                                         question
//                                                                             .questionNumber;
//                                                                     if (answerType ==
//                                                                         'checkbox') {
//                                                                       checkboxQuestionNumbers
//                                                                           .add(
//                                                                               questionNumber);
//                                                                       checkboxAnswersList.add(
//                                                                           checkboxAnswers[i] ??
//                                                                               []);
//                                                                     } else if (answerType ==
//                                                                         'text_box') {
//                                                                       textQuestionNumbers
//                                                                           .add(
//                                                                               questionNumber);
//                                                                       textAnswers.add(
//                                                                           textController
//                                                                               .text);
//                                                                     } else if (answerType ==
//                                                                         'file_upload') {
//                                                                       fileQuestionNumbers
//                                                                           .add(
//                                                                               questionNumber);
//                                                                       fileAnswers.add(
//                                                                           answers[i] ??
//                                                                               '');
//                                                                     }
//                                                                   }
//                                                                   final visitDetailsCubit =
//                                                                       context.read<
//                                                                           VisitDetailsCubit>();
//                                                                   visitDetailsCubit
//                                                                       .addTaskDetails(
//                                                                     //  taskId, // You need to get the taskId from somewhere (maybe arguments or state)
//                                                                     visitId, // Visit ID (you might have this already from your state)
//                                                                     textQuestionNumbers,
//                                                                     textAnswers,
//                                                                     checkboxQuestionNumbers,
//                                                                     checkboxAnswersList,
//                                                                     fileQuestionNumbers,
//                                                                     fileAnswers,
//                                                                     context,
//                                                                   );
//                                                                 }
//                                                               },
//                                                               child: const Text(
//                                                                   "Submit"),
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       )
//                                                     : const SizedBox(),
//                                           );
//                                         } else {
//                                           return const CircularProgressIndicator();
//                                         }
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             )
//                           : const SizedBox(),
//                     ],
//                   ),
//                 ),
//               );
//             }

//             return Container();
//           },
//         ),
//       ),
//     );
//   }

//   Future<void> updateStatus(
//     BuildContext context,
//     VisitDetailsCubit cubit,
//     String visitId,
//     String? currentStatus,
//   ) async {
//     final dialogFormKey = GlobalKey<FormState>();
//     final List<String> statusOptions = [
//       'Not-Started',
//       'Inprogress',
//       'Completed',
//       'Rejected'
//     ];
//     final TextEditingController comment = TextEditingController();
//     //selectedStatus ??= 'Not-Started';
//     String? selectedStatus = currentStatus ?? 'Not-Started';

//     return showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return AlertDialog(
//               backgroundColor: Colors.white,
//               content: SizedBox(
//                 child: SingleChildScrollView(
//                   child: Form(
//                     key: dialogFormKey,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         const Padding(
//                           padding: EdgeInsets.only(top: 16.0, bottom: 25),
//                           child: Text(
//                             "Update Status",
//                             style: TextStyle(
//                                 color: AppColors.primaryColor,
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         SizedBox(
//                           width: MediaQuery.of(context).size.width * 0.95,
//                           child: DropdownButtonFormField<String>(
//                             value: selectedStatus,
//                             items: statusOptions.map((status) {
//                               return DropdownMenuItem<String>(
//                                 value: status,
//                                 child: Text(status),
//                               );
//                             }).toList(),
//                             onChanged: (value) {
//                               setState(() {
//                                 selectedStatus = value;
//                               });
//                             },
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return "Select a Status";
//                               }
//                               return null;
//                             },
//                             decoration: InputDecoration(
//                               contentPadding: const EdgeInsets.all(10),
//                               labelText: 'Status*',
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//                               prefixIcon: const Icon(Icons.info),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//                         SizedBox(
//                           width: MediaQuery.of(context).size.width * 0.95,
//                           child: TextFormField(
//                             keyboardType: TextInputType.text,
//                             controller: comment,
//                             decoration: InputDecoration(
//                               contentPadding: const EdgeInsets.all(10),
//                               labelText: 'Comment',
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//                               prefixIcon: const Icon(Icons.text_fields),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         GestureDetector(
//                           onTap: () async {
//                             if (dialogFormKey.currentState!.validate()) {
//                               cubit.updateVisitStatus(
//                                 visitId,
//                                 comment.text,
//                                 selectedStatus!,
//                               );
//                               selectedStatus = null;
//                               comment.clear();
//                               Navigator.pop(context);
//                             }
//                           },
//                           child: LargeButton(title: "Update"),
//                         ),
//                         TextButton(
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                           child: const Text('Close'),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }

//// testt
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:site_720/core/widgets/appbar.dart';
// import '../../../core/constants/colors.dart';
// import '../../../core/widgets/connectivity_dialog.dart';
// import '../../../core/widgets/snack_bar.dart';
// import '../../../data/models/visit/visit_questions_model.dart';
// import '../../connectivity/cubit/connectivity_cubit.dart';
// import '../../connectivity/cubit/connectivity_state.dart';
// import '../cubit/visit_details_cubit.dart';

// class VisitDetails extends StatefulWidget {
//   const VisitDetails({super.key});

//   @override
//   State<VisitDetails> createState() => _VisitDetailsState();
// }

// class _VisitDetailsState extends State<VisitDetails> {
//   final Map<int, TextEditingController> _text = {};
//   final Map<int, String> _choice = {}; // checkbox answer per question
//   final Map<int, String> _files = {}; // newly picked file path per question

//   VisitTaskData? _loaded; // data the fields were initialised from
//   bool _completed = false; // toggle value
//   bool _readOnly = false; // server status is Completed
//   bool _showErrors = false;
//   bool _saving = false;

//   String _arg(Map<String, dynamic> args, String key) =>
//       args[key]?.toString().trim() ?? "";

//   @override
//   void dispose() {
//     for (final c in _text.values) {
//       c.dispose();
//     }
//     super.dispose();
//   }

//   // ---------------------------------------------------------------------------
//   // COLORS (same as the list screen)
//   // ---------------------------------------------------------------------------
//   Color _priorityColor(String priority) {
//     switch (priority.toLowerCase()) {
//       case "high":
//         return Colors.red;
//       case "medium":
//         return Colors.orange;
//       case "low":
//         return Colors.green;
//       default:
//         return Colors.grey;
//     }
//   }

//   static const Color _completedColor = Color.fromARGB(255, 10, 180, 90);
//   Color get _pendingColor => Colors.amber.shade800;

//   // ---------------------------------------------------------------------------
//   // ANSWER STATE
//   // ---------------------------------------------------------------------------
//   void _initFrom(VisitTaskData data) {
//     for (final c in _text.values) {
//       c.dispose();
//     }
//     _text.clear();
//     _choice.clear();
//     _files.clear();

//     for (final q in data.questions) {
//       if (q.answerType == 'text_box') {
//         _text[q.questionId] = TextEditingController(text: q.answer);
//       } else if (q.answerType == 'checkbox' && q.answer.isNotEmpty) {
//         _choice[q.questionId] = q.answer;
//       }
//     }
//     _completed = data.isCompleted;
//     _readOnly = data.isCompleted;
//     _showErrors = false;
//     _loaded = data;
//   }

//   bool _isFilled(VisitQuestion q) {
//     switch (q.answerType) {
//       case 'text_box':
//         return (_text[q.questionId]?.text.trim() ?? '').isNotEmpty;
//       case 'checkbox':
//         return (_choice[q.questionId] ?? '').isNotEmpty;
//       case 'file_upload':
//         return _files.containsKey(q.questionId) || q.fileName.isNotEmpty;
//       default:
//         return true;
//     }
//   }

//   bool _requiredMet(List<VisitQuestion> qs) =>
//       qs.where((q) => q.isRequired).every(_isFilled);

//   void _toggle(bool toCompleted, List<VisitQuestion> qs) {
//     if (_readOnly || _completed == toCompleted) return;
//     if (toCompleted && !_requiredMet(qs)) {
//       setState(() => _showErrors = true);
//       snackBar(context, "Fill all required questions before marking Completed",
//           Colors.red);
//       return;
//     }
//     setState(() => _completed = toCompleted);
//   }

//   void _save(VisitTaskCubit cubit, List<VisitQuestion> qs) {
//     if (_completed && !_requiredMet(qs)) {
//       setState(() => _showErrors = true);
//       snackBar(context, "Fill all required questions before marking Completed",
//           Colors.red);
//       return;
//     }

//     final answers = <Map<String, dynamic>>[];
//     for (final q in qs) {
//       String answer = "";
//       if (q.answerType == 'text_box') {
//         answer = _text[q.questionId]?.text.trim() ?? "";
//       } else if (q.answerType == 'checkbox') {
//         answer = _choice[q.questionId] ?? "";
//       }
//       answers.add({
//         "question_id": q.questionId,
//         "answer_type": q.answerType,
//         "answer": answer,
//       });
//     }

//     // cubit.save(
//     //   status: _completed ? "Completed" : "Pending",
//     //   answers: answers,
//     //   files: Map<int, String>.from(_files),
//     // );
//   }

//   Future<void> _pickFile(VisitQuestion q) async {
//     final result = await FilePicker.platform.pickFiles();
//     final path = result?.files.single.path;
//     if (path != null) {
//       setState(() => _files[q.questionId] = path);
//     }
//   }

//   // ---------------------------------------------------------------------------
//   // BUILD
//   // ---------------------------------------------------------------------------
//   @override
//   Widget build(BuildContext context) {
//     final args = (ModalRoute.of(context)?.settings.arguments as Map?)
//             ?.cast<String, dynamic>() ??
//         <String, dynamic>{};

//     // GUESS: the questions API needs "id". If it needs "visit_id", swap them.
//     final visitId =
//         _arg(args, "id").isNotEmpty ? _arg(args, "id") : _arg(args, "visit_id");

//     return BlocProvider(
//       create: (_) => VisitTaskCubit(visitId),
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
//           BlocListener<VisitTaskCubit, VisitTaskState>(
//             listener: (context, state) {
//               if (state is VisitTaskSaving) {
//                 setState(() => _saving = true);
//               } else if (state is VisitTaskSaved) {
//                 setState(() => _saving = false);
//                 snackBar(context, state.message, Colors.green);
//                 context.read<VisitTaskCubit>().load(); // reload saved data
//               } else if (state is VisitTaskSaveFailed) {
//                 setState(() => _saving = false);
//                 snackBar(context, state.message, Colors.red);
//               }
//             },
//           ),
//         ],
//         child: Scaffold(
//           backgroundColor: AppColors.backgroundColor,
//           appBar: simpleAppbar(context, "Visit Details", true),
//           body: BlocBuilder<VisitTaskCubit, VisitTaskState>(
//             buildWhen: (p, c) =>
//                 c is VisitTaskLoading ||
//                 c is VisitTaskLoaded ||
//                 c is VisitTaskFailure,
//             builder: (context, state) {
//               final cubit = context.read<VisitTaskCubit>();

//               if (state is VisitTaskLoading) {
//                 return const Center(child: CircularProgressIndicator());
//               }

//               if (state is VisitTaskFailure) {
//                 return Center(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(Icons.error_outline,
//                           size: 48, color: Colors.grey.shade400),
//                       const SizedBox(height: 8),
//                       Text(state.message.isEmpty
//                           ? "Something went wrong"
//                           : state.message),
//                       const SizedBox(height: 8),
//                       TextButton(
//                         onPressed: cubit.load,
//                         child: const Text("Retry"),
//                       ),
//                     ],
//                   ),
//                 );
//               }

//               if (state is VisitTaskLoaded) {
//                 if (!identical(_loaded, state.data)) {
//                   _initFrom(state.data);
//                 }
//                 final qs = state.data.questions;

//                 return Column(
//                   children: [
//                     Expanded(
//                       child: ListView(
//                         padding: const EdgeInsets.all(14),
//                         children: [
//                           _summaryCard(args),
//                           const SizedBox(height: 12),
//                           _statusToggle(qs),
//                           const SizedBox(height: 12),
//                           if (qs.isEmpty)
//                             Padding(
//                               padding: const EdgeInsets.only(top: 40),
//                               child: Center(
//                                 child: Text(
//                                   "No questions for this visit",
//                                   style: TextStyle(color: Colors.grey.shade600),
//                                 ),
//                               ),
//                             ),
//                           for (final q in qs) _questionCard(q),
//                         ],
//                       ),
//                     ),
//                     if (!_readOnly) _saveBar(cubit, qs),
//                   ],
//                 );
//               }

//               return const SizedBox();
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   // ---------------------------------------------------------------------------
//   // SUMMARY (from list arguments)
//   // ---------------------------------------------------------------------------
//   Widget _summaryCard(Map<String, dynamic> args) {
//     final title = _arg(args, "task_title");
//     final project = _arg(args, "project_name");
//     final stage = _arg(args, "stage_name");
//     final priority = _arg(args, "priority");
//     final from = _arg(args, "from_date");
//     final to = _arg(args, "to_date");
//     final desc = _arg(args, "description");

//     return _card(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(title.isEmpty ? "-" : title,
//               style:
//                   const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 4),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(top: 1),
//                 child: Icon(Icons.apartment,
//                     size: 13, color: Colors.grey.shade600),
//               ),
//               const SizedBox(width: 4),
//               Expanded(
//                 child: Text(project,
//                     style:
//                         TextStyle(fontSize: 11, color: Colors.grey.shade700)),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Wrap(
//             spacing: 6,
//             runSpacing: 6,
//             children: [
//               if (stage.isNotEmpty) _labelTag("Stage", stage, Colors.blueGrey),
//               if (priority.isNotEmpty)
//                 _labelTag("Priority", priority, _priorityColor(priority)),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Expanded(child: _dateInfo("From", from)),
//               Icon(Icons.arrow_forward, size: 16, color: Colors.grey.shade400),
//               Expanded(child: _dateInfo("To", to, alignEnd: true)),
//             ],
//           ),
//           if (desc.isNotEmpty) ...[
//             const SizedBox(height: 10),
//             Text(desc,
//                 style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
//           ],
//         ],
//       ),
//     );
//   }

//   // ---------------------------------------------------------------------------
//   // STATUS TOGGLE (Pending | Completed)
//   // ---------------------------------------------------------------------------
//   Widget _statusToggle(List<VisitQuestion> qs) {
//     return _card(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("Visit Status",
//               style: TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.grey.shade700)),
//           const SizedBox(height: 8),
//           Container(
//             padding: const EdgeInsets.all(4),
//             decoration: BoxDecoration(
//               color: Colors.grey.shade100,
//               borderRadius: BorderRadius.circular(24),
//             ),
//             child: Row(
//               children: [
//                 _toggleOption("Pending", !_completed, _pendingColor,
//                     () => _toggle(false, qs)),
//                 _toggleOption("Completed", _completed, _completedColor,
//                     () => _toggle(true, qs)),
//               ],
//             ),
//           ),
//           if (_readOnly) ...[
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 Icon(Icons.lock_outline, size: 14, color: Colors.grey.shade600),
//                 const SizedBox(width: 4),
//                 Text("Completed. Answers are view only.",
//                     style:
//                         TextStyle(fontSize: 11, color: Colors.grey.shade600)),
//               ],
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _toggleOption(
//       String label, bool selected, Color color, VoidCallback onTap) {
//     return Expanded(
//       child: InkWell(
//         borderRadius: BorderRadius.circular(20),
//         onTap: _readOnly ? null : onTap,
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 200),
//           height: 36,
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             color: selected ? color : Colors.transparent,
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Text(
//             label,
//             style: TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w700,
//               color: selected ? Colors.white : Colors.grey.shade600,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // ---------------------------------------------------------------------------
//   // QUESTIONS
//   // ---------------------------------------------------------------------------
//   Widget _questionCard(VisitQuestion q) {
//     final missing = _showErrors && !_readOnly && q.isRequired && !_isFilled(q);

//     Widget body;
//     switch (q.answerType) {
//       case 'text_box':
//         body = _textAnswer(q);
//         break;
//       case 'checkbox':
//         body = _checkboxAnswer(q);
//         break;
//       case 'file_upload':
//         body = _fileAnswer(q);
//         break;
//       default:
//         body = const SizedBox();
//     }

//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: _card(
//         borderColor: missing ? Colors.red.shade300 : null,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: Text.rich(
//                     TextSpan(
//                       children: [
//                         TextSpan(
//                           text: "${q.questionNumber}. ${q.question}",
//                           style: const TextStyle(
//                               fontSize: 14, fontWeight: FontWeight.bold),
//                         ),
//                         if (q.isRequired && !_readOnly)
//                           const TextSpan(
//                             text: " *",
//                             style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.red),
//                           ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             body,
//             if (missing)
//               const Padding(
//                 padding: EdgeInsets.only(top: 6),
//                 child: Text("This question is required",
//                     style: TextStyle(fontSize: 11, color: Colors.red)),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _readOnlyText(String value, {IconData? icon}) {
//     final empty = value.trim().isEmpty;
//     return Row(
//       children: [
//         if (icon != null) ...[
//           Icon(icon, size: 16, color: Colors.grey.shade600),
//           const SizedBox(width: 6),
//         ],
//         Expanded(
//           child: Text(
//             empty ? "Not answered" : value,
//             style: TextStyle(
//               fontSize: 13,
//               fontStyle: empty ? FontStyle.italic : FontStyle.normal,
//               color: empty ? Colors.grey.shade400 : Colors.black87,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _textAnswer(VisitQuestion q) {
//     if (_readOnly) return _readOnlyText(q.answer);
//     return TextField(
//       controller: _text[q.questionId],
//       minLines: 1,
//       maxLines: 4,
//       style: const TextStyle(fontSize: 13),
//       onChanged: (_) {
//         if (_showErrors) setState(() {});
//       },
//       decoration: InputDecoration(
//         hintText: "Enter your answer",
//         isDense: true,
//         contentPadding: const EdgeInsets.all(10),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(5),
//           borderSide: const BorderSide(color: AppColors.primaryColor),
//         ),
//       ),
//     );
//   }

//   Widget _checkboxAnswer(VisitQuestion q) {
//     if (_readOnly) return _readOnlyText(q.answer, icon: Icons.check_box);

//     final selected = _choice[q.questionId];
//     return Column(
//       children: q.options.map((option) {
//         return CheckboxListTile(
//           dense: true,
//           contentPadding: EdgeInsets.zero,
//           controlAffinity: ListTileControlAffinity.leading,
//           activeColor: AppColors.primaryColor,
//           title: Text(option, style: const TextStyle(fontSize: 13)),
//           value: selected == option,
//           // single choice: picking one replaces the other, unticking clears it
//           onChanged: (v) {
//             setState(() {
//               if (v == true) {
//                 _choice[q.questionId] = option;
//               } else {
//                 _choice.remove(q.questionId);
//               }
//             });
//           },
//         );
//       }).toList(),
//     );
//   }

//   Widget _fileAnswer(VisitQuestion q) {
//     final picked = _files[q.questionId];
//     final name = picked != null ? picked.split('/').last : q.fileName;

//     if (_readOnly) {
//       return _readOnlyText(q.fileName.isEmpty ? "" : q.fileName,
//           icon: Icons.attach_file);
//     }

//     return Row(
//       children: [
//         OutlinedButton.icon(
//           onPressed: () => _pickFile(q),
//           icon: const Icon(Icons.attach_file, size: 16),
//           label: Text(name.isEmpty ? "Choose file" : "Change file",
//               style: const TextStyle(fontSize: 12)),
//           style: OutlinedButton.styleFrom(
//             foregroundColor: AppColors.primaryColor,
//             side: const BorderSide(color: AppColors.primaryColor),
//           ),
//         ),
//         const SizedBox(width: 10),
//         Expanded(
//           child: Text(
//             name.isEmpty ? "No file chosen" : name,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: TextStyle(
//               fontSize: 12,
//               color: name.isEmpty ? Colors.grey : Colors.black87,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   // ---------------------------------------------------------------------------
//   // SAVE BAR
//   // ---------------------------------------------------------------------------
//   Widget _saveBar(VisitTaskCubit cubit, List<VisitQuestion> qs) {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 6,
//             offset: const Offset(0, -2),
//           ),
//         ],
//       ),
//       child: SafeArea(
//         top: false,
//         child: SizedBox(
//           width: double.infinity,
//           height: 48,
//           child: ElevatedButton(
//             onPressed: _saving ? null : () => _save(cubit, qs),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.primaryColor,
//               foregroundColor: Colors.white,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             child: _saving
//                 ? const SizedBox(
//                     height: 20,
//                     width: 20,
//                     child: CircularProgressIndicator(
//                         strokeWidth: 2, color: Colors.white),
//                   )
//                 : Text(
//                     _completed ? "Save as Completed" : "Save as Pending",
//                     style: const TextStyle(
//                         fontSize: 14, fontWeight: FontWeight.w700),
//                   ),
//           ),
//         ),
//       ),
//     );
//   }

//   // ---------------------------------------------------------------------------
//   // SHARED WIDGETS
//   // ---------------------------------------------------------------------------
//   Widget _card({required Widget child, Color? borderColor}) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(5),
//         border: borderColor == null ? null : Border.all(color: borderColor),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.8),
//             blurRadius: 3,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: child,
//     );
//   }

//   Widget _labelTag(String label, String value, Color color) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.10),
//         borderRadius: BorderRadius.circular(6),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text("$label: ",
//               style: TextStyle(
//                   fontSize: 10,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.grey.shade700)),
//           Text(value,
//               style: TextStyle(
//                   fontSize: 10, fontWeight: FontWeight.w700, color: color)),
//         ],
//       ),
//     );
//   }

//   Widget _dateInfo(String label, String value, {bool alignEnd = false}) {
//     return Column(
//       crossAxisAlignment:
//           alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//       children: [
//         Text(label,
//             style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
//         const SizedBox(height: 2),
//         Text(
//           value.isEmpty ? "-" : value,
//           style: const TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w600,
//               color: AppColors.primaryColor),
//         ),
//       ],
//     );
//   }
// }
//

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:site_720/core/widgets/appbar.dart';
import '../../../core/constants/colors.dart';
import '../../../core/widgets/connectivity_dialog.dart';
import '../../../core/widgets/snack_bar.dart';
import '../../../data/models/visit/visit_questions_model.dart';
import '../../connectivity/cubit/connectivity_cubit.dart';
import '../../connectivity/cubit/connectivity_state.dart';
import '../cubit/visit_details_cubit.dart';

class VisitDetails extends StatefulWidget {
  const VisitDetails({super.key});

  @override
  State<VisitDetails> createState() => _VisitDetailsState();
}

class _VisitDetailsState extends State<VisitDetails> {
  final Map<int, TextEditingController> _text = {};
  final Map<int, String> _choice = {}; // checkbox answer per question
  final Map<int, String> _files = {}; // newly picked file path per question

  VisitTaskData? _loaded; // data the fields were initialised from
  bool _completed = false; // toggle value
  bool _readOnly = false; // server status is Completed
  bool _showErrors = false;
  bool _saving = false;

  String _arg(Map<String, dynamic> args, String key) =>
      args[key]?.toString().trim() ?? "";

  @override
  void dispose() {
    for (final c in _text.values) {
      c.dispose();
    }
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // COLORS (same as the list screen)
  // ---------------------------------------------------------------------------
  Color _priorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case "high":
        return Colors.red;
      case "medium":
        return Colors.orange;
      case "low":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  static const Color _completedColor = Color.fromARGB(255, 10, 180, 90);
  Color get _pendingColor => Colors.amber.shade800;

  // ---------------------------------------------------------------------------
  // ANSWER STATE
  // ---------------------------------------------------------------------------
  void _initFrom(VisitTaskData data) {
    for (final c in _text.values) {
      c.dispose();
    }
    _text.clear();
    _choice.clear();
    _files.clear();

    for (final q in data.questions) {
      if (q.answerType == 'text_box') {
        _text[q.questionId] = TextEditingController(text: q.answer);
      } else if (q.answerType == 'checkbox' && q.answer.isNotEmpty) {
        _choice[q.questionId] = q.answer;
      }
    }
    _completed = data.isCompleted;
    _readOnly = data.isCompleted;
    _showErrors = false;
    _loaded = data;
  }

  bool _isFilled(VisitQuestion q) {
    switch (q.answerType) {
      case 'text_box':
        return (_text[q.questionId]?.text.trim() ?? '').isNotEmpty;
      case 'checkbox':
        return (_choice[q.questionId] ?? '').isNotEmpty;
      case 'file_upload':
        return _files.containsKey(q.questionId) || q.fileName.isNotEmpty;
      default:
        return true;
    }
  }

  bool _requiredMet(List<VisitQuestion> qs) =>
      qs.where((q) => q.isRequired).every(_isFilled);

  void _toggle(bool toCompleted, List<VisitQuestion> qs) {
    if (_readOnly || _completed == toCompleted) return;
    if (toCompleted && !_requiredMet(qs)) {
      setState(() => _showErrors = true);
      snackBar(context, "Fill all required questions before marking Completed",
          Colors.red);
      return;
    }
    setState(() => _completed = toCompleted);
  }

  void _save(VisitTaskCubit cubit, List<VisitQuestion> qs) {
    if (_completed && !_requiredMet(qs)) {
      setState(() => _showErrors = true);
      snackBar(context, "Fill all required questions before marking Completed",
          Colors.red);
      return;
    }

    final answers = <Map<String, dynamic>>[];
    for (final q in qs) {
      String answer = "";
      if (q.answerType == 'text_box') {
        answer = _text[q.questionId]?.text.trim() ?? "";
      } else if (q.answerType == 'checkbox') {
        answer = _choice[q.questionId] ?? "";
      }
      answers.add({
        "question_id": q.questionId,
        "answer_type": q.answerType,
        "answer": answer,
      });
    }

    cubit.save(
      status: _completed ? "Completed" : "Pending",
      answers: answers,
      files: Map<int, String>.from(_files),
    );
  }

  Future<void> _pickFile(VisitQuestion q) async {
    final result = await FilePicker.platform.pickFiles();
    final path = result?.files.single.path;
    if (path != null) {
      setState(() => _files[q.questionId] = path);
    }
  }

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final args = (ModalRoute.of(context)?.settings.arguments as Map?)
            ?.cast<String, dynamic>() ??
        <String, dynamic>{};

    // GUESS: the questions API needs "id". If it needs "visit_id", swap them.
    final visitId =
        _arg(args, "id").isNotEmpty ? _arg(args, "id") : _arg(args, "visit_id");

    return BlocProvider(
      create: (_) => VisitTaskCubit(visitId),
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
          BlocListener<VisitTaskCubit, VisitTaskState>(
            listener: (context, state) {
              if (state is VisitTaskSaving) {
                setState(() => _saving = true);
              } else if (state is VisitTaskSaved) {
                setState(() => _saving = false);
                snackBar(context, state.message, Colors.green);
                context.read<VisitTaskCubit>().load(); // reload saved data
              } else if (state is VisitTaskSaveFailed) {
                setState(() => _saving = false);
                snackBar(context, "Something went wrong. Please try again.",
                    Colors.red);
              }
            },
          ),
        ],
        child: Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: simpleAppbar(context, "Visit Details", true),
          body: BlocBuilder<VisitTaskCubit, VisitTaskState>(
            buildWhen: (p, c) =>
                c is VisitTaskLoading ||
                c is VisitTaskLoaded ||
                c is VisitTaskFailure,
            builder: (context, state) {
              final cubit = context.read<VisitTaskCubit>();

              if (state is VisitTaskLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is VisitTaskFailure) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline,
                          size: 48, color: Colors.grey.shade400),
                      const SizedBox(height: 8),
                      Text(
                        "Something went wrong",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: cubit.load,
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text("Retry"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primaryColor,
                          side: const BorderSide(color: AppColors.primaryColor),
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (state is VisitTaskLoaded) {
                if (!identical(_loaded, state.data)) {
                  _initFrom(state.data);
                }
                final qs = state.data.questions;

                return Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(14),
                        children: [
                          _summaryCard(args),
                          const SizedBox(height: 12),
                          _statusToggle(qs),
                          const SizedBox(height: 12),
                          if (qs.isEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 40),
                              child: Center(
                                child: Text(
                                  "No questions for this visit",
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                              ),
                            ),
                          for (final q in qs) _questionCard(q),
                        ],
                      ),
                    ),
                    if (!_readOnly) _saveBar(cubit, qs),
                  ],
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SUMMARY (from list arguments)
  // ---------------------------------------------------------------------------
  Widget _summaryCard(Map<String, dynamic> args) {
    final title = _arg(args, "task_title");
    final project = _arg(args, "project_name");
    final stage = _arg(args, "stage_name");
    final priority = _arg(args, "priority");
    final from = _arg(args, "from_date");
    final to = _arg(args, "to_date");
    final desc = _arg(args, "description");

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.isEmpty ? "-" : title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 1),
                child: Icon(Icons.apartment,
                    size: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(project,
                    style:
                        TextStyle(fontSize: 11, color: Colors.grey.shade700)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              if (stage.isNotEmpty) _labelTag("Stage", stage, Colors.blueGrey),
              if (priority.isNotEmpty)
                _labelTag("Priority", priority, _priorityColor(priority)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _dateInfo("From", from)),
              Icon(Icons.arrow_forward, size: 16, color: Colors.grey.shade400),
              Expanded(child: _dateInfo("To", to, alignEnd: true)),
            ],
          ),
          if (desc.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(desc,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
          ],
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // STATUS TOGGLE (Pending | Completed)
  // ---------------------------------------------------------------------------
  Widget _statusToggle(List<VisitQuestion> qs) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Visit Status",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                _toggleOption("Pending", !_completed, _pendingColor,
                    () => _toggle(false, qs)),
                _toggleOption("Completed", _completed, _completedColor,
                    () => _toggle(true, qs)),
              ],
            ),
          ),
          if (_readOnly) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.lock_outline, size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text("Completed. Answers are view only.",
                    style:
                        TextStyle(fontSize: 11, color: Colors.grey.shade600)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _toggleOption(
      String label, bool selected, Color color, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: _readOnly ? null : onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? color : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: selected ? Colors.white : Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // QUESTIONS
  // ---------------------------------------------------------------------------
  Widget _questionCard(VisitQuestion q) {
    final missing = _showErrors && !_readOnly && q.isRequired && !_isFilled(q);

    Widget body;
    switch (q.answerType) {
      case 'text_box':
        body = _textAnswer(q);
        break;
      case 'checkbox':
        body = _checkboxAnswer(q);
        break;
      case 'file_upload':
        body = _fileAnswer(q);
        break;
      default:
        body = const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: _card(
        borderColor: missing ? Colors.red.shade300 : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "${q.questionNumber}. ${q.question}",
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        if (q.isRequired && !_readOnly)
                          const TextSpan(
                            text: " *",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            body,
            if (missing)
              const Padding(
                padding: EdgeInsets.only(top: 6),
                child: Text("This question is required",
                    style: TextStyle(fontSize: 11, color: Colors.red)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _readOnlyText(String value, {IconData? icon}) {
    final empty = value.trim().isEmpty;
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 6),
        ],
        Expanded(
          child: Text(
            empty ? "Not answered" : value,
            style: TextStyle(
              fontSize: 13,
              fontStyle: empty ? FontStyle.italic : FontStyle.normal,
              color: empty ? Colors.grey.shade400 : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _textAnswer(VisitQuestion q) {
    if (_readOnly) return _readOnlyText(q.answer);
    return TextField(
      controller: _text[q.questionId],
      minLines: 1,
      maxLines: 4,
      style: const TextStyle(fontSize: 13),
      onChanged: (_) {
        if (_showErrors) setState(() {});
      },
      decoration: InputDecoration(
        hintText: "Enter your answer",
        isDense: true,
        contentPadding: const EdgeInsets.all(10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }

  Widget _checkboxAnswer(VisitQuestion q) {
    if (_readOnly) return _readOnlyText(q.answer, icon: Icons.check_box);

    final selected = _choice[q.questionId];
    return Column(
      children: q.options.map((option) {
        return CheckboxListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
          activeColor: AppColors.primaryColor,
          title: Text(option, style: const TextStyle(fontSize: 13)),
          value: selected == option,
          // single choice: picking one replaces the other, unticking clears it
          onChanged: (v) {
            setState(() {
              if (v == true) {
                _choice[q.questionId] = option;
              } else {
                _choice.remove(q.questionId);
              }
            });
          },
        );
      }).toList(),
    );
  }

  Widget _fileAnswer(VisitQuestion q) {
    final picked = _files[q.questionId];
    final name = picked != null ? picked.split('/').last : q.fileName;

    if (_readOnly) {
      return _readOnlyText(q.fileName.isEmpty ? "" : q.fileName,
          icon: Icons.attach_file);
    }

    return Row(
      children: [
        OutlinedButton.icon(
          onPressed: () => _pickFile(q),
          icon: const Icon(Icons.attach_file, size: 16),
          label: Text(name.isEmpty ? "Choose file" : "Change file",
              style: const TextStyle(fontSize: 12)),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primaryColor,
            side: const BorderSide(color: AppColors.primaryColor),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            name.isEmpty ? "No file chosen" : name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: name.isEmpty ? Colors.grey : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // SAVE BAR
  // ---------------------------------------------------------------------------
  Widget _saveBar(VisitTaskCubit cubit, List<VisitQuestion> qs) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _saving ? null : () => _save(cubit, qs),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: _saving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : Text(
                    _completed ? "Save as Completed" : "Save as Pending",
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w700),
                  ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SHARED WIDGETS
  // ---------------------------------------------------------------------------
  Widget _card({required Widget child, Color? borderColor}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: borderColor == null ? null : Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
            blurRadius: 3,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _labelTag(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("$label: ",
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700)),
          Text(value,
              style: TextStyle(
                  fontSize: 10, fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }

  Widget _dateInfo(String label, String value, {bool alignEnd = false}) {
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
        const SizedBox(height: 2),
        Text(
          value.isEmpty ? "-" : value,
          style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryColor),
        ),
      ],
    );
  }
}
