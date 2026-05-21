// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:site_720/core/constants/colors.dart';

class WorkScreen extends StatefulWidget {
  const WorkScreen({super.key});

  @override
  State<WorkScreen> createState() => _WorkScreenState();
}

class _WorkScreenState extends State<WorkScreen> {
  final List<Map<String, dynamic>> workList = [
    {
      "project": "Lulu Mall Project",
      "date": "20-05-2026",
      "scheduled": "Yes",
      "status": "Pending",
    },
    {
      "project": "Bridge Construction",
      "date": "19-05-2026",
      "scheduled": "No",
      "status": "Completed",
    },
    {
      "project": "Smart City Work",
      "date": "18-05-2026",
      "scheduled": "Yes",
      "status": "Pending",
    },
  ];

  final List<String> projectList = [
    "Lulu Mall Project",
    "Bridge Construction",
    "Smart City Work",
  ];

  final List<String> statusList = [
    "Pending",
    "Completed",
    "In Progress",
  ];

  final List<String> stateList = [
    "Kerala",
    "Tamil Nadu",
  ];

  final List<String> districtList = [
    "Ernakulam",
    "Kottayam",
  ];

  final List<String> updateStatusList = [
    "Updated",
    "Not Updated",
  ];

  final List<String> scheduleList = [
    "Yes",
    "No",
  ];

  final List<String> staffList = [
    "Arun",
    "Rahul",
    "Vishnu",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// HEADER
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * .24,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryColor,
                    image: DecorationImage(
                      image: AssetImage("assets/images/appbar.png"),
                      fit: BoxFit.fill,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// TITLE
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              SizedBox(height: 10),
                              Text(
                                "Work Dashboard",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),

                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.work,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                /// STATUS CARD
                Positioned(
                  bottom: 0,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(.18),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _statusItem(
                          title: "Unfreezed",
                          count: "18",
                          color: Colors.orange,
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: Colors.grey.shade300,
                        ),
                        _statusItem(
                          title: "Freezed",
                          count: "12",
                          color: Colors.green,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 55),

            /// FILTER BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Work List",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                    ),
                    onPressed: () {
                      filterPopup();
                    },
                    icon: const Icon(
                      Icons.filter_alt,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Filter",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            /// DUMMY LIST
            ListView.builder(
              itemCount: workList.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                final data = workList[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(.12),
                        blurRadius: 8,
                        offset: const Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              data["project"],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: data["status"] == "Pending"
                                  ? Colors.orange.withOpacity(.15)
                                  : Colors.green.withOpacity(.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: InkWell(
                              onTap: () {
                                if (data["status"] == "Pending") {
                                  addWorkPopup();
                                }
                              },
                              child: Text(
                                data["status"],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: data["status"] == "Pending"
                                      ? Colors.orange
                                      : Colors.green,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_month,
                            size: 18,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Work Date : ${data["date"]}",
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.schedule,
                            size: 18,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Is Scheduled : ${data["scheduled"]}",
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// STATUS ITEM
  Widget _statusItem({
    required String title,
    required String count,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  /// FILTER POPUP
  void filterPopup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Center(
                  child: Text(
                    "Filter Works",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _textField("From Date"),
                _textField("To Date"),
                _dropdown(projectList, "Project Name"),
                _dropdown(statusList, "Select Status"),
                _dropdown(stateList, "State"),
                _dropdown(districtList, "District"),
                _dropdown(updateStatusList, "Update Status"),
                _dropdown(scheduleList, "Is Scheduled?"),
                _dropdown(staffList, "Assigned Staff"),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Apply Filter",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Clear",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// ADD WORK POPUP
  void addWorkPopup() {
    String? selectedStage;
    String workingStatus = "Yes";

    final TextEditingController dateController = TextEditingController();

    final TextEditingController labourController = TextEditingController();

    final TextEditingController descriptionController = TextEditingController();

    final List<String> stageList = [
      "Foundation",
      "Piling",
      "Electrical",
      "Plumbing",
      "Finishing",
    ];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              title: const Text(
                "Add Work Update",
                style: TextStyle(
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
                            });
                          },
                        ),
                        const Text("No"),
                      ],
                    ),

                    const SizedBox(height: 10),

                    /// STAGE
                    DropdownButtonFormField<String>(
                      value: selectedStage,
                      decoration: InputDecoration(
                        labelText: "Stage *",
                        hintText: "Select Stage",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: stageList.map((e) {
                        return DropdownMenuItem(
                          value: e,
                          child: Text(e),
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

                    /// NO OF LABOURS
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
                    Navigator.pop(context);
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
                  onPressed: () {
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Work Updated"),
                      ),
                    );
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

  /// TEXTFIELD
  Widget _textField(String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  /// DROPDOWN
  Widget _dropdown(
    List<String> list,
    String hint,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        hint: Text(hint),
        items: list.map((e) {
          return DropdownMenuItem(
            value: e,
            child: Text(e),
          );
        }).toList(),
        onChanged: (value) {},
      ),
    );
  }
}
