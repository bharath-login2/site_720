import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/services/http_services.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final billNoController = TextEditingController();

  final billAmountController = TextEditingController();

  final payableAmountController = TextEditingController();

  final remarkController = TextEditingController();

  final descriptionController = TextEditingController();

  final gstNoController = TextEditingController();

  final consigneeController = TextEditingController();

  final paidAmountController = TextEditingController();

  final trRefController = TextEditingController();

  final transactionRemarkController = TextEditingController();

  final balanceAmountController = TextEditingController();

  final billDateController = TextEditingController();

  final paidDateController = TextEditingController();

  final trDateController = TextEditingController();

  final paidFromAccController = TextEditingController();

  String? expenseType;

  String? project;

  String? gst;

  String? paymentMode;

  File? selectedFile;

  @override
  void initState() {
    super.initState();

    billDateController.text = DateFormat(
      "dd-MM-yyyy",
    ).format(
      DateTime.now(),
    );

    paidDateController.text = DateFormat(
      "dd-MM-yyyy",
    ).format(
      DateTime.now(),
    );

    trDateController.text = DateFormat(
      "dd-MM-yyyy",
    ).format(
      DateTime.now(),
    );

    billAmountController.addListener(calculateAmounts);
  }

  void calculateAmounts() {
    double billAmount = double.tryParse(
          billAmountController.text,
        ) ??
        0;

    double gstPercent = double.tryParse(
          gst ?? "0",
        ) ??
        0;

    double gstAmount = (billAmount * gstPercent) / 100;

    double total = billAmount + gstAmount;

    payableAmountController.text = total.toStringAsFixed(2);

    paidAmountController.text = total.toStringAsFixed(2);
  }

  /// PICK FILE
  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      selectedFile = File(
        result.files.single.path!,
      );

      setState(() {});
    }
  }

  /// SELECT DATE
  Future<void> selectDate(TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      controller.text = DateFormat(
        "dd-MM-yyyy",
      ).format(
        picked,
      );

      setState(() {});
    }
  }

  @override
  void dispose() {
    billAmountController.dispose();
    payableAmountController.dispose();
    paidAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),

      /// APP BAR
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color.fromARGB(
          247,
          100,
          38,
          53,
        ),
        title: const Text(
          "Add Expense",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),

      /// BODY
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// =====================================
            /// BILL DETAILS
            /// =====================================

            sectionTitle("Bill Details"),

            const SizedBox(height: 20),

            /// EXPENSE TYPE
            buildLabel("Expense Type *"),

            const SizedBox(height: 8),

            buildDropdown(
              hint: "Select Expense Type",
              value: expenseType,
              items: const [
                "Suppliers",
                "Transport",
                "Materials",
              ],
              onChanged: (v) {
                setState(() {
                  expenseType = v;
                });
              },
            ),

            const SizedBox(height: 16),

            /// EXPENSE HEAD
            buildLabel("Project"),

            const SizedBox(height: 8),

            buildDropdown(
              hint: "Select Project",
              value: project,
              items: const [
                "Purchase",
                "Fuel",
                "Salary",
                "Office Expense",
              ],
              onChanged: (v) {
                setState(() {
                  project = v;
                });
              },
            ),

            const SizedBox(height: 16),

            /// BILL NO
            buildLabel("Bill No"),

            const SizedBox(height: 8),

            buildField(
              "Enter Bill No",
              billNoController,
            ),

            const SizedBox(height: 16),

            /// BILL DATE
            buildLabel("Bill Date *"),

            const SizedBox(height: 8),

            buildField(
              "Select Bill Date",
              billDateController,
              readOnly: true,
              suffix: Icons.calendar_month,
              onTap: () {
                selectDate(billDateController);
              },
            ),

            const SizedBox(height: 16),

            /// GST %
            buildLabel("GST %"),

            const SizedBox(height: 8),

            buildDropdown(
              hint: "Select GST %",
              value: gst,
              items: const [
                "0",
                "5",
                "12",
                "18",
                "28",
              ],
              onChanged: (v) {
                setState(() {
                  gst = v;
                  calculateAmounts();
                });
              },
            ),

            const SizedBox(height: 16),

            /// BILL AMOUNT
            buildLabel("Bill Amount"),

            const SizedBox(height: 8),

            buildField(
              "Enter Bill Amount",
              billAmountController,
              keyboard: TextInputType.number,
            ),

            const SizedBox(height: 16),

            /// PAYABLE AMOUNT
            buildLabel("Payable Amount"),

            const SizedBox(height: 8),

            buildField(
              "Payable Amount",
              payableAmountController,
              keyboard: TextInputType.number,
              readOnly: true,
            ),

            const SizedBox(height: 16),

            /// GST NO
            buildLabel("GST No"),

            const SizedBox(height: 8),

            buildField(
              "Enter GST No",
              gstNoController,
            ),

            const SizedBox(height: 16),

            /// CONSIGNEE
            buildLabel("Consignee"),

            const SizedBox(height: 8),

            buildField(
              "Enter Consignee",
              consigneeController,
            ),

            const SizedBox(height: 16),

            /// DESCRIPTION
            buildLabel("Description"),

            const SizedBox(height: 8),

            buildField(
              "Enter Description",
              descriptionController,
              maxLines: 3,
            ),

            const SizedBox(height: 16),

            /// REMARKS
            buildLabel("Remarks"),

            const SizedBox(height: 8),

            buildField(
              "Enter Remarks",
              remarkController,
              maxLines: 3,
            ),

            const SizedBox(height: 16),

            /// BILL COPY
            buildLabel("Bill Copy"),

            const SizedBox(height: 8),

            InkWell(
              onTap: () {
                pickFile();
              },
              child: Container(
                height: 58,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.upload_file_rounded,
                      color: Color.fromARGB(
                        247,
                        100,
                        38,
                        53,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        selectedFile != null
                            ? selectedFile!.path.split("/").last
                            : "Upload Bill Copy",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: selectedFile != null
                              ? Colors.black87
                              : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 6),

            Text(
              "Max upload size: 2 MB",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 32),

            /// =====================================
            /// TRANSACTION DETAILS
            /// =====================================

            sectionTitle("Transaction Details"),

            const SizedBox(height: 20),

            /// PAID AMOUNT
            buildLabel("Paid Amount"),

            const SizedBox(height: 8),

            buildField(
              "Paid Amount",
              paidAmountController,
              keyboard: TextInputType.number,
              readOnly: true,
            ),

            const SizedBox(height: 16),

            /// PAID DATE
            buildLabel("Paid Date *"),

            const SizedBox(height: 8),

            buildField(
              "Select Paid Date",
              paidDateController,
              readOnly: true,
              suffix: Icons.calendar_month,
              onTap: () {
                selectDate(paidDateController);
              },
            ),

            const SizedBox(height: 16),

            /// PAID FROM ACC
            buildLabel("Paid From ACC"),

            const SizedBox(height: 8),

            buildField(
              "Enter Paid From ACC",
              paidFromAccController,
            ),

            const SizedBox(height: 16),

            /// TR REF NO
            buildLabel("TR Reference No"),

            const SizedBox(height: 8),

            buildField(
              "Enter TR Reference No",
              trRefController,
            ),

            const SizedBox(height: 16),

            /// TR REF DATE
            buildLabel("TR Reference Date"),

            const SizedBox(height: 8),

            buildField(
              "Select TR Reference Date",
              trDateController,
              readOnly: true,
              suffix: Icons.calendar_month,
              onTap: () {
                selectDate(trDateController);
              },
            ),

            const SizedBox(height: 16),

            /// PAYMENT MODE
            buildLabel("Payment Mode *"),

            const SizedBox(height: 8),

            buildDropdown(
              hint: "Select Payment Mode",
              value: paymentMode,
              items: const [
                "Cash",
                "Bank",
                "UPI",
              ],
              onChanged: (v) {
                setState(() {
                  paymentMode = v;
                });
              },
            ),

            const SizedBox(height: 16),

            /// TRANSACTION REMARKS
            buildLabel("Transaction Remarks"),

            const SizedBox(height: 8),

            buildField(
              "Enter Transaction Remarks",
              transactionRemarkController,
              maxLines: 3,
            ),

            const SizedBox(height: 16),

            /// BALANCE AMOUNT
            buildLabel("Bill Balance Amount"),

            const SizedBox(height: 8),

            buildField(
              "Balance Amount",
              balanceAmountController,
              keyboard: TextInputType.number,
            ),

            const SizedBox(height: 35),

            /// SUBMIT
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: const Color.fromARGB(
                    247,
                    100,
                    38,
                    53,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () async {
                  /// VALIDATION
                  if (expenseType == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please select expense type"),
                      ),
                    );
                    return;
                  }

                  if (billDateController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please select bill date"),
                      ),
                    );
                    return;
                  }

                  if (paymentMode == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please select payment mode"),
                      ),
                    );
                    return;
                  }

                  /// LOADER
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  );

                  /// API CALL
                  final response = await HttpServices.addExpense(
                    expenseType: expenseType ?? "",
                    expenseHead: project ?? "",
                    billNo: billNoController.text,
                    billDate: billDateController.text,
                    gst: gst ?? "0",
                    billAmount: billAmountController.text,
                    description: descriptionController.text,
                    gstNo: gstNoController.text,
                    payableAmount: payableAmountController.text,
                    consignee: consigneeController.text,
                    billRemarks: remarkController.text,
                    paidAmount: paidAmountController.text,
                    paidDate: paidDateController.text,
                    paidFromAcc: paidFromAccController.text,
                    paymentMode: paymentMode ?? "",
                    trReferenceNo: trRefController.text,
                    trReferenceDate: trDateController.text,
                    transactionRemarks: transactionRemarkController.text,
                    balanceAmount: balanceAmountController.text,
                    billCopy: selectedFile,
                  );

                  /// CLOSE LOADER
                  Navigator.pop(context);

                  /// SUCCESS
                  if (response != null && response['status'] == true) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.green,
                        content: Text(
                          response['message'] ?? "Expense Added Successfully",
                        ),
                      ),
                    );

                    Navigator.pop(context, true);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(
                          response['message'] ?? "Failed to add expense",
                        ),
                      ),
                    );
                  }
                },
                child: const Text(
                  "Submit",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  /// SECTION TITLE
  Widget sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  /// LABEL
  Widget buildLabel(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  /// TEXT FIELD
  Widget buildField(
    String hint,
    TextEditingController controller, {
    int maxLines = 1,
    TextInputType keyboard = TextInputType.text,
    bool readOnly = false,
    IconData? suffix,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboard,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        suffixIcon: suffix != null
            ? Icon(
                suffix,
                color: const Color.fromARGB(
                  247,
                  100,
                  38,
                  53,
                ),
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color.fromARGB(
              247,
              100,
              38,
              53,
            ),
          ),
        ),
      ),
    );
  }

  /// DROPDOWN
  Widget buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color.fromARGB(
              247,
              100,
              38,
              53,
            ),
          ),
        ),
      ),
      items: items.map((e) {
        return DropdownMenuItem(
          value: e,
          child: Text(e),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
