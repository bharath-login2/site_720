// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/data/models/work/work_model.dart';
import 'package:site_720/features/work/cubit/work_cubit.dart';
import 'package:site_720/features/work/cubit/work_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/services/http_services.dart';

class WorkScreen extends StatefulWidget {
  const WorkScreen({super.key});

  @override
  State<WorkScreen> createState() => _WorkScreenState();
}

class _WorkScreenState extends State<WorkScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WorkCubit>().getExternalWorkDetailsList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: BlocBuilder<WorkCubit, WorkState>(
        builder: (context, state) {
          /// LOADING
          if (state is WorkLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is WorkFailure) {
            return Center(
              child: Text(
                state.error,
              ),
            );
          }

          /// SUCCESS
          if (state is WorkSuccess) {
            final workList = state.workList;

            return SingleChildScrollView(
              child: Column(
                children: [
                  /// HEADER
                  Container(
                    height: MediaQuery.of(context).size.height * .20,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryColor,
                      image: DecorationImage(
                        image: AssetImage(
                          "assets/images/appbar.png",
                        ),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(
                          30,
                        ),
                        bottomRight: Radius.circular(
                          30,
                        ),
                      ),
                    ),
                    child: const SafeArea(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Work Dashboard",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Icon(
                              Icons.work,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  ListView.builder(
                    itemCount: workList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (context, index) {
                      final item = workList[index];

                      bool isPending =
                          item.updateStatus.toLowerCase().trim() == "pending";

                      /// SAFE DATE
                      String day = "--";
                      String month = "--";
                      String year = "--";

                      try {
                        final date = DateTime.parse(item.workDate);

                        day = date.day.toString();
                        month = _getMonth(date.month);
                        year = date.year.toString();
                      } catch (_) {}

                      return InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () {
                          if (isPending) {
                            addWorkPopup(item);
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              /// DATE BOX
                              Container(
                                width: 100,
                                height: 140,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(18),
                                    bottomLeft: Radius.circular(18),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    CircleAvatar(
                                      radius: 26,
                                      backgroundColor: Colors.white24,
                                      child: Icon(
                                        Icons.construction_rounded,
                                        color: Colors.white,
                                        size: 32,
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      "WORK",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              /// DETAILS
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              item.projectName,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isPending
                                                  ? Colors.orange.shade50
                                                  : Colors.green.shade50,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              item.updateStatus,
                                              style: TextStyle(
                                                color: isPending
                                                    ? Colors.orange
                                                    : Colors.green,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        "Working : ${item.isWorking}",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "Labours : ${item.laboursNo}",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "Date : ${item.workDate}",
                                        style: TextStyle(
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "Description : ${item.description}",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  String _getMonth(int month) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];

    return months[month - 1];
  }

  /// ROW
  Widget buildRow(
    IconData icon,
    String text,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: Colors.grey,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(text),
        ),
      ],
    );
  }

  /// POPUP
  void addWorkPopup(
    ExternalWorkItem item,
  ) async {
    String? selectedStage;

    String workingStatus = "Yes";

    String? selectedWorkStatusId;

    final TextEditingController dateController = TextEditingController();

    final TextEditingController labourController = TextEditingController();

    final TextEditingController descriptionController = TextEditingController();

    List<dynamic> stageList = [];

    List<dynamic> workStatusList = [];

    /// GET STAGES API
    final stageResponse = await HttpServices.getStagesByprojectId(
      projectId: item.projectId,
    );

    if (stageResponse != null && stageResponse["status"] == true) {
      stageList = stageResponse["data"]["stages"] ?? [];
    }

    /// GET WORK STATUS API
    final workStatusResponse = await HttpServices.getWorkStatusID();

    if (workStatusResponse != null && workStatusResponse["status"] == true) {
      workStatusList = workStatusResponse["data"] ?? [];
    }

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              title: Text(
                item.projectName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// WORKING STATUS
                    const Text(
                      "Are You Sure Today is Working?",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    Row(
                      children: [
                        Radio<String>(
                          value: "Yes",
                          groupValue: workingStatus,
                          activeColor: AppColors.primaryColor,
                          onChanged: (value) {
                            setState(() {
                              workingStatus = value!;

                              /// RESET
                              selectedWorkStatusId = null;
                              labourController.clear();
                            });
                          },
                        ),
                        const Text("Yes"),
                        Radio<String>(
                          value: "No",
                          groupValue: workingStatus,
                          activeColor: AppColors.primaryColor,
                          onChanged: (value) {
                            setState(() {
                              workingStatus = value!;

                              /// RESET
                              selectedWorkStatusId = null;
                              labourController.clear();
                            });
                          },
                        ),
                        const Text("No"),
                      ],
                    ),

                    const SizedBox(height: 10),

                    /// STAGE DROPDOWN
                    DropdownButtonFormField<String>(
                      value: selectedStage,
                      decoration: InputDecoration(
                        labelText: "Stage *",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: stageList.map((e) {
                        return DropdownMenuItem<String>(
                          value: e["stage_id"].toString(),
                          child: Text(
                            e["stage_name"].toString(),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedStage = value;
                        });
                      },
                    ),

                    const SizedBox(height: 14),

                    /// DATE
                    TextFormField(
                      controller: dateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Date *",
                        hintText: "dd-mm-yyyy",
                        suffixIcon: const Icon(
                          Icons.calendar_month,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );

                        if (pickedDate != null) {
                          String formattedDate =
                              "${pickedDate.day.toString().padLeft(2, '0')}-"
                              "${pickedDate.month.toString().padLeft(2, '0')}-"
                              "${pickedDate.year}";

                          dateController.text = formattedDate;
                        }
                      },
                    ),

                    const SizedBox(height: 14),

                    /// IF YES SHOW LABOUR FIELD
                    if (workingStatus == "Yes")
                      TextFormField(
                        controller: labourController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "No of Labours *",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                    /// IF NO SHOW WORK STATUS
                    if (workingStatus == "No")
                      DropdownButtonFormField<String>(
                        value: selectedWorkStatusId,
                        decoration: InputDecoration(
                          labelText: "Work Status *",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: workStatusList.map((e) {
                          return DropdownMenuItem<String>(
                            value: e["id"].toString(),
                            child: Text(
                              e["work_status"].toString(),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedWorkStatusId = value;
                          });
                        },
                      ),

                    const SizedBox(height: 14),

                    /// DESCRIPTION
                    TextFormField(
                      controller: descriptionController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: "Description",
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                /// CANCEL
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text(
                    "Cancel",
                  ),
                ),

                /// SUBMIT
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                  ),
                  onPressed: () async {
                    /// VALIDATION
                    if (selectedStage == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Please Select Stage",
                          ),
                        ),
                      );

                      return;
                    }

                    if (dateController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Please Select Date",
                          ),
                        ),
                      );

                      return;
                    }

                    /// YES VALIDATION
                    if (workingStatus == "Yes" &&
                        labourController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Please Enter Labour Count",
                          ),
                        ),
                      );

                      return;
                    }

                    /// NO VALIDATION
                    if (workingStatus == "No" && selectedWorkStatusId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Please Select Work Status",
                          ),
                        ),
                      );

                      return;
                    }

                    /// API CALL
                    final updateResponse =
                        await HttpServices.updateExternalWork(
                      stageId: selectedStage!,
                      projectId: item.projectId,
                      clientId: item.clientId,

                      /// YES / NO
                      workStatus: workingStatus,

                      workDate: dateController.text,

                      /// YES
                      labourCount:
                          workingStatus == "Yes" ? labourController.text : "0",

                      /// NO
                      workStatusId:
                          workingStatus == "No" ? selectedWorkStatusId! : "0",

                      description: descriptionController.text,
                    );

                    /// SUCCESS
                    if (updateResponse != null &&
                        updateResponse["status"] == true) {
                      /// CLOSE POPUP
                      Navigator.pop(dialogContext);

                      /// RELOAD LIST
                      if (mounted) {
                        BlocProvider.of<WorkCubit>(
                          this.context,
                        ).getExternalWorkDetailsList();
                      }

                      /// SUCCESS MESSAGE
                      Future.delayed(
                        const Duration(milliseconds: 300),
                        () {
                          if (mounted) {
                            ScaffoldMessenger.of(this.context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.green,
                                content: Text(
                                  updateResponse["message"] ??
                                      "Work Updated Successfully",
                                ),
                              ),
                            );
                          }
                        },
                      );
                    } else {
                      ScaffoldMessenger.of(this.context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                            updateResponse?["message"] ??
                                "Something went wrong",
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
