import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:site_720/core/widgets/appbar.dart';
import 'package:site_720/features/payment_details/widgets/amount_container.dart';
import 'package:file_picker/file_picker.dart'; // Import file_picker package
import '../../../core/constants/colors.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/connectivity_dialog.dart';
import '../../../core/widgets/snack_bar.dart';

import '../../connectivity/cubit/connectivity_cubit.dart';
import '../../connectivity/cubit/connectivity_state.dart';
import '../cubit/visit_details_cubit.dart';
import '../cubit/visit_details_state.dart';

class VisitDetails extends StatefulWidget {
  const VisitDetails({super.key});

  @override
  _VisitDetailsState createState() => _VisitDetailsState();
}

class _VisitDetailsState extends State<VisitDetails> {
  final formKey = GlobalKey<FormState>();
  TextEditingController commentController = TextEditingController();
  TextEditingController textController = TextEditingController();
  String? selectedStatus;
  XFile? image;
  String visitId = "";
  List<List<String>> checkboxAnswers = [];
  List<TextEditingController> textControllers = [];
  Map<int, dynamic> answers = {};
  List<String?> fileAnswers =
      []; // List to hold the file paths for file upload answers

  // Extract file name from the answer (file path)
  String _getFileName(dynamic answer) {
    try {
      if (answer is String) {
        return answer.split('/').last;
      } else if (answer is Map && answer['path'] != null) {
        return answer['path'].toString().split('/').last;
      }
    } catch (e) {
      print("Error extracting file name: $e");
    }
    return '';
  }

  // Collect answers to submit
  Map<String, dynamic> _collectAnswers(List<dynamic> questions) {
    Map<String, dynamic> answers = {};

    for (int i = 0; i < questions.length; i++) {
      final question = questions[i];
      switch (question.answerType) {
        case 'text_box':
          answers['question_${i + 1}'] = textControllers[i].text;
          break;
        case 'checkbox':
          answers['question_${i + 1}'] = checkboxAnswers[i];
          break;
        case 'file_upload':
          answers['question_${i + 1}'] = fileAnswers[i];
          break;
        default:
          break;
      }
    }
    return answers;
  }

  void _submitAnswers(List<dynamic> questions) {
    if (formKey.currentState?.validate() ?? false) {
      Map<String, dynamic> answers = _collectAnswers(questions);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Answers Submitted Successfully")),
      );
      print("Submitted Answers: $answers");
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    visitId = args["visit_id"]!;

    return BlocProvider(
      create: (context) => VisitDetailsCubit(visitId),
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
          BlocListener<VisitDetailsCubit, VisitDetailsState>(
            listener: (context, state) {
              if (state is VisitDetailSuccessWithMessage) {
                snackBar(context, state.message, Colors.green);
                Navigator.pushReplacementNamed(
                  context,
                  '/visitDetails',
                  arguments: {'visit_id': visitId},
                );
              } else if (state is VisitDetailsFailure) {
                snackBar(context, state.message, Colors.red);
              }
            },
          ),
          BlocListener<VisitDetailsCubit, VisitDetailsState>(
            listener: (context, state) {
              if (state is VisitDetailSuccess) {
                final visitDetailsAll = state.response.data.data.visitDetails;
                final questions = state.response.data.data.questions;
                textControllers = List.generate(
                    questions.length, (index) => TextEditingController());
                checkboxAnswers =
                    List.generate(questions.length, (index) => []);
                fileAnswers = List.generate(questions.length, (index) => null);
              }
            },
          ),
      BlocListener<VisitDetailsCubit, VisitDetailsState>(
      listener: (context, state) {
        if (state is VisitDetailSuccessWithMessage) {
          snackBar(context, state.message, Colors.green);
          Navigator.pushReplacementNamed(
            context,
            '/visitDetails',
            arguments: {'visit_id': visitId},
          );
        }
      },
    ),




        ],
        child: BlocBuilder<VisitDetailsCubit, VisitDetailsState>(
          builder: (context, state) {
            final cubit = context.read<VisitDetailsCubit>();
            if (state is VisitDetailLoading) {
              return Scaffold(
                appBar: simpleAppbar(context, "Visit Details", true),
                body: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (state is VisitDetailSuccess) {
              final visitDetailsAll = state.response.data.data.visitDetails;
              final questions = state.response.data.data.questions;
              final addedDetails = state.response.data.data.addedDetails;
              return Scaffold(
                appBar: simpleAppbar(context, "Visit Details", true),
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.secondaryColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.8),
                                blurRadius: 4,
                                offset: const Offset(1, 1),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          visitDetailsAll.visitName,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        if (visitDetailsAll
                                            .projectName.isNotEmpty)
                                          Text(
                                            visitDetailsAll.projectName,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        Text(
                                          'Stage: ${visitDetailsAll.stageName}',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        Text(
                                          'Staff: ${visitDetailsAll.staffName}',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () {
                                        updateStatus(
                                            context,
                                            cubit,
                                            visitDetailsAll.visitId,
                                            visitDetailsAll.visitStatus);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: AppColors.backgroundColor,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.8),
                                              blurRadius: 6,
                                              offset: const Offset(1, 1),
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0, vertical: 4.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                visitDetailsAll.visitStatus,
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              const Icon(
                                                Icons.arrow_forward_ios,
                                                size: 14,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    AmountContainer(
                                        title: "From Date",
                                        amount: DateFormat('dd-MM-yyyy')
                                            .format(visitDetailsAll.fromDate),
                                        valueColor: AppColors.primaryColor),
                                    AmountContainer(
                                        title: "To Date",
                                        amount: DateFormat('dd-MM-yyyy')
                                            .format(visitDetailsAll.toDate),
                                        valueColor: AppColors.primaryColor),
                                    AmountContainer(
                                        title: "Sq.ft",
                                        amount: visitDetailsAll.sqftName,
                                        valueColor: AppColors.primaryColor),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Description :",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              visitDetailsAll.description,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      addedDetails.isEmpty
                          ? SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 16.0),
                                    child: BlocBuilder<VisitDetailsCubit,
                                        VisitDetailsState>(
                                      builder: (context, state) {
                                        if (state is VisitDetailSuccess) {
                                          final questions = state
                                              .response.data.data.questions;
                                          return Form(
                                            key: formKey,
                                            child:
                                                state.response.data.data
                                                        .questions.isNotEmpty
                                                    ? Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          for (var i = 0;
                                                              i <
                                                                  questions
                                                                      .length;
                                                              i++) ...[
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      bottom:
                                                                          16.0),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  const SizedBox(
                                                                      height:
                                                                          8),
                                                                  if (questions[
                                                                              i]
                                                                          .answerType ==
                                                                      'text_box')
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          bottom:
                                                                              16.0),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            questions[i].question,
                                                                            style:
                                                                                const TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 14,
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                              height: 8),
                                                                          TextFormField(
                                                                            maxLines:
                                                                                4,
                                                                            controller:
                                                                                textController,
                                                                            keyboardType:
                                                                                TextInputType.text,
                                                                            decoration:
                                                                                const InputDecoration(
                                                                              border: OutlineInputBorder(),
                                                                              hintText: 'Enter your answer',
                                                                            ),
                                                                            onChanged:
                                                                                (value) {
                                                                              setState(() {});
                                                                            },
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  if (questions[
                                                                              i]
                                                                          .answerType ==
                                                                      'checkbox')
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          bottom:
                                                                              16.0),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            questions[i].question,
                                                                            style:
                                                                                const TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 14,
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                              height: 8),
                                                                          ...questions[i]
                                                                              .checkboxOptions
                                                                              .map((option) {
                                                                            checkboxAnswers[i] =
                                                                                checkboxAnswers[i] ?? [];
                                                                            final isChecked =
                                                                                checkboxAnswers[i].contains(option);

                                                                            return Padding(
                                                                              padding: const EdgeInsets.only(bottom: 8.0),
                                                                              child: CheckboxListTile(
                                                                                title: Text(option),
                                                                                value: isChecked,
                                                                                onChanged: (bool? value) {
                                                                                  setState(() {
                                                                                    if (value == true) {
                                                                                      if (checkboxAnswers[i].isEmpty) {
                                                                                        checkboxAnswers[i].add(option);
                                                                                      } else {
                                                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                                                          SnackBar(
                                                                                            content: const Text(
                                                                                              'Only one option can be selected.',
                                                                                              style: TextStyle(color: Colors.white),
                                                                                            ),
                                                                                            backgroundColor: Colors.red,
                                                                                            duration: const Duration(seconds: 2),
                                                                                            behavior: SnackBarBehavior.floating,
                                                                                            shape: RoundedRectangleBorder(
                                                                                              borderRadius: BorderRadius.circular(10),
                                                                                            ),
                                                                                            margin: const EdgeInsets.all(16),
                                                                                          ),
                                                                                        );
                                                                                      }
                                                                                    } else {
                                                                                      checkboxAnswers[i].remove(option);
                                                                                    }
                                                                                  });
                                                                                },
                                                                              ),
                                                                            );
                                                                          }),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  if (questions[
                                                                              i]
                                                                          .answerType ==
                                                                      'file_upload')
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          bottom:
                                                                              16.0),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            questions[i].question,
                                                                            style:
                                                                                const TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 14,
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                              height: 8),
                                                                          Row(
                                                                            children: [
                                                                              ElevatedButton.icon(
                                                                                icon: const Icon(Icons.attach_file),
                                                                                label: const Text("Upload File"),
                                                                                onPressed: () async {
                                                                                  FilePickerResult? result = await FilePicker.platform.pickFiles();

                                                                                  if (result != null && result.files.isNotEmpty) {
                                                                                    final filePath = result.files.single.path!;
                                                                                    setState(() {
                                                                                      answers[i] = filePath;
                                                                                    });
                                                                                  }
                                                                                },
                                                                              ),
                                                                              const SizedBox(width: 12),
                                                                              Expanded(
                                                                                child: Text(
                                                                                  _getFileName(
                                                                                    // Check if this question has an existing saved answer
                                                                                    questions[i].questionId == visitDetailsAll.addedQuestionId && visitDetailsAll.addedAnswer.isNotEmpty ? visitDetailsAll.addedAnswer : (answers[i] ?? ''),
                                                                                  ),
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  style: const TextStyle(
                                                                                    color: Colors.black54,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          if ((questions[i].questionId == visitDetailsAll.addedQuestionId && visitDetailsAll.addedAnswer.isNotEmpty) ||
                                                                              (answers[i] != null && _getFileName(answers[i]).isNotEmpty))
                                                                            const Padding(
                                                                              padding: EdgeInsets.only(top: 8.0),
                                                                            ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                          Center(
                                                            child:
                                                                ElevatedButton(
                                                              onPressed: () {
                                                                if (formKey
                                                                    .currentState!
                                                                    .validate()) {
                                                                  List<String>
                                                                      textQuestionNumbers =
                                                                      [];
                                                                  List<String>
                                                                      checkboxQuestionNumbers =
                                                                      [];
                                                                  List<String>
                                                                      fileQuestionNumbers =
                                                                      [];
                                                                  List<String>
                                                                      textAnswers =
                                                                      [];
                                                                  List<List<String>>
                                                                      checkboxAnswersList =
                                                                      [];
                                                                  List<String>
                                                                      fileAnswers =
                                                                      [];
                                                                  for (var i =
                                                                          0;
                                                                      i <
                                                                          questions
                                                                              .length;
                                                                      i++) {
                                                                    final question =
                                                                        questions[
                                                                            i];
                                                                    final answerType =
                                                                        question
                                                                            .answerType;
                                                                    final questionNumber =
                                                                        question
                                                                            .questionNumber;
                                                                    if (answerType ==
                                                                        'checkbox') {
                                                                      checkboxQuestionNumbers
                                                                          .add(
                                                                              questionNumber);
                                                                      checkboxAnswersList.add(
                                                                          checkboxAnswers[i] ??
                                                                              []);
                                                                    } else if (answerType ==
                                                                        'text_box') {
                                                                      textQuestionNumbers
                                                                          .add(
                                                                              questionNumber);
                                                                      textAnswers.add(
                                                                          textController
                                                                              .text);
                                                                    } else if (answerType ==
                                                                        'file_upload') {
                                                                      fileQuestionNumbers
                                                                          .add(
                                                                              questionNumber);
                                                                      fileAnswers.add(
                                                                          answers[i] ??
                                                                              '');
                                                                    }
                                                                  }
                                                                  final visitDetailsCubit =
                                                                      context.read<
                                                                          VisitDetailsCubit>();
                                                                  visitDetailsCubit
                                                                      .addTaskDetails(
                                                                    //  taskId, // You need to get the taskId from somewhere (maybe arguments or state)
                                                                    visitId, // Visit ID (you might have this already from your state)
                                                                    textQuestionNumbers,
                                                                    textAnswers,
                                                                    checkboxQuestionNumbers,
                                                                    checkboxAnswersList,
                                                                    fileQuestionNumbers,
                                                                    fileAnswers,
                                                                    context,
                                                                  );
                                                                }
                                                              },
                                                              child: const Text(
                                                                  "Submit"),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : const SizedBox(),
                                          );
                                        } else {
                                          return const CircularProgressIndicator();
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              );
            }

            return Container();
          },
        ),
      ),
    );
  }

  Future<void> updateStatus(
    BuildContext context,
    VisitDetailsCubit cubit,
    String visitId,
    String? currentStatus,
  ) async {
    final dialogFormKey = GlobalKey<FormState>();
    final List<String> statusOptions = [
      'Not-Started',
      'Inprogress',
      'Completed',
      'Rejected'
    ];
    final TextEditingController comment = TextEditingController();
    //selectedStatus ??= 'Not-Started';
    String? selectedStatus = currentStatus ?? 'Not-Started';

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              content: SizedBox(
                child: SingleChildScrollView(
                  child: Form(
                    key: dialogFormKey,
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
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.95,
                          child: DropdownButtonFormField<String>(
                            value: selectedStatus,
                            items: statusOptions.map((status) {
                              return DropdownMenuItem<String>(
                                value: status,
                                child: Text(status),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedStatus = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
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
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.95,
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            controller: comment,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(10),
                              labelText: 'Comment',
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
                            if (dialogFormKey.currentState!.validate()) {
                              cubit.updateVisitStatus(
                                visitId,
                                comment.text,
                                selectedStatus!,
                              );
                              selectedStatus = null;
                              comment.clear();
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
