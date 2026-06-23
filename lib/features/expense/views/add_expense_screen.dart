import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/services/http_services.dart';
import '../../../data/models/project_list/project_list_model.dart';
import 'package:dropdown_search/dropdown_search.dart';
import '../../../data/models/expenselist/project_id_list_model.dart';
import '../cubit/project_cubit.dart';
import '../cubit/project_state.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  String? selectedProjectId;
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

  String gstAmount = "0";

  List<dynamic> pettyCashAccounts = [];

  String? selectedPaidFromAccId;
  List<dynamic> paymentMethodList = [];

  String? selectedPaymentMethodId;

  @override
  void initState() {
    super.initState();

    expenseType = "Project Expense";

    billDateController.text = DateFormat("dd-MM-yyyy").format(DateTime.now());

    paidDateController.text = DateFormat("dd-MM-yyyy").format(DateTime.now());

    trDateController.text = DateFormat("dd-MM-yyyy").format(DateTime.now());

    billAmountController.addListener(calculateAmounts);

    paidAmountController.addListener(calculateBalanceAmount);

    getPettyCashAccounts();
    getPaymentMethods();
  }

  void calculateAmounts() {
    double billAmount = double.tryParse(billAmountController.text) ?? 0;

    double gstPercent = double.tryParse(gst ?? "0") ?? 0;

    /// GST AMOUNT
    double calculatedGstAmount = (billAmount * gstPercent) / 100;

    gstAmount = calculatedGstAmount.toStringAsFixed(2);

    /// PAYABLE AMOUNT
    double total = billAmount + calculatedGstAmount;

    payableAmountController.text = total.toStringAsFixed(2);

    calculateBalanceAmount();
  }

  void calculateBalanceAmount() {
    double payable = double.tryParse(payableAmountController.text) ?? 0;

    double paid = double.tryParse(paidAmountController.text) ?? 0;

    /// VALIDATION
    if (paid > payable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Amount is greater than the payable amount!",
          ),
        ),
      );

      paidAmountController.text = payable.toStringAsFixed(2);

      paidAmountController.selection = TextSelection.fromPosition(
        TextPosition(
          offset: paidAmountController.text.length,
        ),
      );

      paid = payable;
    }

    double balance = payable - paid;

    balanceAmountController.text = balance.toStringAsFixed(2);
  }

  Future<void> getPettyCashAccounts() async {
    final response = await HttpServices.getPettyCashAccount();

    if (response != null && response["status"] == true) {
      setState(() {
        pettyCashAccounts = response["data"] ?? [];

        // Auto select if only one account exists
        if (pettyCashAccounts.length == 1) {
          selectedPaidFromAccId = pettyCashAccounts.first["id"].toString();

          paidFromAccController.text = pettyCashAccounts.first["id"].toString();
        }
      });
    }
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

  Future<void> getPaymentMethods() async {
    final response = await HttpServices.getPaymentMethod();

    if (response != null && response["status"] == true) {
      setState(() {
        paymentMethodList = response["data"] ?? [];
      });
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
            sectionTitle("Bill Details"),

            const SizedBox(height: 20),

            buildLabel("Expense Type *"),

            const SizedBox(height: 8),

            buildField(
              "Project Expense",
              TextEditingController(text: "Project Expense"),
              readOnly: true,
            ),

            const SizedBox(height: 16),

            /// PROJECT
            buildLabel("Project *"),

            const SizedBox(height: 8),

            BlocBuilder<ProjectCubit, ProjectState>(
              builder: (context, state) {
                if (state is ProjectLoading) {
                  return Container(
                    height: 60,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  );
                }

                if (state is ProjectFailure) {
                  return Container(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      state.message,
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  );
                }

                if (state is ProjectSuccess) {
                  final List<ProjectIdList> projectList = state.projects;

                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: DropdownSearch<ProjectIdList>(
                      items: (filter, loadProps) {
                        if (filter.isEmpty) {
                          return projectList;
                        }

                        return projectList.where((e) {
                          return e.projectName.toLowerCase().contains(
                                filter.toLowerCase(),
                              );
                        }).toList();
                      },
                      selectedItem: selectedProjectId == null
                          ? null
                          : projectList.firstWhere(
                              (e) => e.id == selectedProjectId,
                              orElse: () => projectList.first,
                            ),
                      itemAsString: (ProjectIdList item) => item.projectName,
                      compareFn: (item, selectedItem) {
                        return item.id == selectedItem.id;
                      },
                      onSelected: (ProjectIdList? value) {
                        if (value != null) {
                          setState(() {
                            selectedProjectId = value.id;
                            project = value.projectName;
                          });

                          debugPrint(
                            "SELECTED PROJECT ID : $selectedProjectId",
                          );
                        }
                      },
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        fit: FlexFit.loose,
                        searchFieldProps: TextFieldProps(
                          decoration: InputDecoration(
                            hintText: "Search Project",
                            prefixIcon: const Icon(Icons.search),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        emptyBuilder: (context, searchEntry) {
                          return const Padding(
                            padding: EdgeInsets.all(20),
                            child: Center(
                              child: Text(
                                "No Projects Found",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        },
                        itemBuilder: (context, item, isSelected, isFocused) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color.fromARGB(
                                      20,
                                      100,
                                      38,
                                      53,
                                    )
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? const Color.fromARGB(
                                        247,
                                        100,
                                        38,
                                        53,
                                      )
                                    : Colors.grey.shade200,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromARGB(
                                      247,
                                      100,
                                      38,
                                      53,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    item.projectName,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(
                          hintText: "Select Project",
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
                      ),
                    ),
                  );
                }

                return const SizedBox();
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

            DropdownButtonFormField<String>(
              value: selectedPaidFromAccId,
              decoration: InputDecoration(
                hintText: "Select Paid From ACC",
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
              items: pettyCashAccounts.map((e) {
                return DropdownMenuItem<String>(
                  value: e["id"].toString(),
                  child: Text(
                    e["account_head"].toString(),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedPaidFromAccId = value;

                  paidFromAccController.text = value ?? "";
                });
              },
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

            DropdownButtonFormField<String>(
              value: selectedPaymentMethodId,
              decoration: InputDecoration(
                hintText: "Select Payment Mode",
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
              items: paymentMethodList.map((e) {
                return DropdownMenuItem<String>(
                  value: e["id"].toString(),
                  child: Text(
                    e["payment_method"].toString(),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedPaymentMethodId = value;

                  final selected = paymentMethodList.firstWhere(
                    (e) => e["id"].toString() == value,
                  );

                  paymentMode = selected["id"].toString();
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
              readOnly: true,
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
                    expenseType: "Project Expense",
                    expenseHead: selectedProjectId ?? "",
                    billNo: billNoController.text,
                    billDate: billDateController.text,
                    gst: gst ?? "0",
                    gstAmount: gstAmount,
                    billAmount: billAmountController.text,
                    description: descriptionController.text,
                    gstNo: gstNoController.text,
                    payableAmount: payableAmountController.text,
                    consignee: consigneeController.text,
                    billRemarks: remarkController.text,
                    paidAmount: paidAmountController.text,
                    paidDate: paidDateController.text,
                    paidFromAcc: selectedPaidFromAccId ?? "",
                    paymentMode: paymentMode ?? "",
                    trReferenceNo: trRefController.text,
                    trReferenceDate: trDateController.text,
                    transactionRemarks: transactionRemarkController.text,
                    balanceAmount: balanceAmountController.text,
                    billCopy: selectedFile,
                  );

                  Navigator.pop(context);

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
