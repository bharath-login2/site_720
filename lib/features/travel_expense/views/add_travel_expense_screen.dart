import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:site_720/core/constants/colors.dart';
import '../../../data/models/travel_expense/travel_expense_model.dart';
import '../cubit/travel_expense_cubit.dart';
import '../cubit/travel_expense_state.dart';

class AddTravelExpenseScreen extends StatefulWidget {
  final TravelExpenseItem? item;

  final bool isEdit;

  const AddTravelExpenseScreen({
    super.key,
    this.item,
    this.isEdit = false,
  });

  @override
  State<AddTravelExpenseScreen> createState() => _AddTravelExpenseScreenState();
}

class _AddTravelExpenseScreenState extends State<AddTravelExpenseScreen> {
  final List<Map<String, dynamic>> expenseRows = [];

  final remarkController = TextEditingController();

  final dateController = TextEditingController();

  final fromController = TextEditingController();
  final otherAmountController = TextEditingController();
  final otherAmountCauseController = TextEditingController();

  final routeController = TextEditingController();

  List<VehicleTypeModel> vehicleList = [];

  VehicleTypeModel? selectedVehicle;
  int? initialTotalAmount;
  bool isTotalEdited = false;

  @override
  void initState() {
    super.initState();

    otherAmountController.addListener(() {
      if (mounted) setState(() {});
    });

    if (widget.isEdit && widget.item != null) {
      dateController.text = widget.item!.date;
      fromController.text = widget.item!.from;
      remarkController.text = widget.item!.remark;
      initialTotalAmount = int.tryParse(widget.item!.totalAmount) ?? 0;
      otherAmountController.text = widget.item!.otherAmount;
      otherAmountCauseController.text = widget.item!.otherAmountCause;

      expenseRows.clear();

      final details = widget.item!.travelDetails;

      if (details.isNotEmpty) {
        for (var detail in details) {
          final toController = TextEditingController(
            text: detail.to,
          );

          final kmController = TextEditingController(
            text: detail.km,
          );

          toController.addListener(() {
            updateRoute();
          });

          kmController.addListener(() {
            if (mounted) {
              setState(() {
                isTotalEdited = true;
              });
            }
          });

          expenseRows.add({
            "to": toController,
            "km": kmController,
            "image": detail.image,
            "file": null,
          });
        }
      } else {
        final toController = TextEditingController(
          text: widget.item!.to,
        );

        final kmController = TextEditingController(
          text: widget.item!.km,
        );

        toController.addListener(() {
          updateRoute();
        });

        kmController.addListener(() {
          if (mounted) setState(() {});
        });

        expenseRows.add({
          "to": toController,
          "km": kmController,
          "image": "",
          "file": null,
        });
      }

      updateRoute();
    } else {
      dateController.text = DateFormat("dd-MM-yyyy").format(DateTime.now());

      addNewRow();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getVehicleTypes();

      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<void> getVehicleTypes() async {
    try {
      final cubit = context.read<TravelExpenseCubit>();

      vehicleList = await cubit.getVehicleType();

      if (vehicleList.isEmpty) return;

      if (widget.isEdit && widget.item != null) {
        selectedVehicle = vehicleList.firstWhere(
          (e) => e.id == widget.item!.vehicleId,
          orElse: () => vehicleList.first,
        );
      } else {
        selectedVehicle = vehicleList.first;
      }

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void addNewRow() {
    final toController = TextEditingController();
    final kmController = TextEditingController();

    toController.addListener(() {
      updateRoute();
    });

    kmController.addListener(() {
      if (mounted) {
        setState(() {
          isTotalEdited = true;
        });
      }
    });

    expenseRows.add({
      "to": toController,
      "km": kmController,
      "image": "",
      "file": null,
    });

    setState(() {});
  }

  /// PICK FILE
  Future<void> pickFile(int index) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      expenseRows[index]["file"] = File(
        result.files.single.path!,
      );

      setState(() {});
    }
  }

  /// SELECT DATE
  Future<void> selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      dateController.text = DateFormat(
        "dd-MM-yyyy",
      ).format(
        picked,
      );

      setState(() {});
    }
  }

  /// UPDATE ROUTE
  void updateRoute() {
    String route = "";

    for (var row in expenseRows) {
      if (row["to"].text.toString().isNotEmpty) {
        if (route.isEmpty) {
          route = row["to"].text.toString();
        } else {
          route += " → ${row["to"].text.toString()}";
        }
      }
    }

    routeController.text = route;

    setState(() {});
  }

  /// TOTAL KM
  int totalKm() {
    int total = 0;

    for (var row in expenseRows) {
      total += int.tryParse(
            row["km"].text,
          ) ??
          0;
    }

    return total;
  }

  /// TOTAL AMOUNT
  int totalAmount() {
    // Show API total until the user edits something
    if (widget.isEdit && !isTotalEdited && initialTotalAmount != null) {
      return initialTotalAmount!;
    }

    int total = 0;

    final int rate = int.tryParse(selectedVehicle?.ratePerKm ?? "0") ?? 0;

    for (final row in expenseRows) {
      final int km = int.tryParse(row["km"].text.trim()) ?? 0;

      total += km * rate;
    }

    final int otherAmount =
        int.tryParse(otherAmountController.text.trim()) ?? 0;

    return total + otherAmount;
  }

  /// SUBMIT
  void submit() {
    if (dateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please select date",
          ),
        ),
      );

      return;
    }

    if (fromController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please enter from location",
          ),
        ),
      );

      return;
    }

    if (selectedVehicle == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please select vehicle",
          ),
        ),
      );

      return;
    }

    /// UPDATE
    if (widget.isEdit && widget.item != null) {
      final int finalTotal = totalAmount();

      context.read<TravelExpenseCubit>().updateTravelExpense(
            travelId: widget.item!.travelId.toString(),
            date: dateController.text,
            from: fromController.text,
            vehicleType: selectedVehicle!.id,
            totalAmount: finalTotal.toString(),
            otherAmount: otherAmountController.text,
            otherAmountCause: otherAmountCauseController.text,
            remark: remarkController.text,
            rows: expenseRows,
          );
    }

    /// ADD
    else {
      context.read<TravelExpenseCubit>().postTravelExpense(
            date: dateController.text,
            from: fromController.text,
            vehicleType: selectedVehicle!.id,
            totalAmount: totalAmount().toString(),
            otherAmount: otherAmountController.text,
            otherAmountCause: otherAmountCauseController.text,
            remark: remarkController.text,
            rows: expenseRows,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TravelExpenseCubit, TravelExpenseState>(
      listener: (context, state) async {
        /// SUCCESS
        if (state is TravelExpensePostSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
              content: Text(
                state.message,
              ),
            ),
          );

          /// WAIT FOR MESSAGE
          await Future.delayed(
            const Duration(seconds: 2),
          );

          /// REFRESH LIST
          if (mounted) {
            context.read<TravelExpenseCubit>().getTravelExpenseList();

            Navigator.pop(
              context,
              true,
            );
          }
        }

        /// FAILURE
        if (state is TravelExpenseFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                state.error,
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: const Color(0xffF5F5F5),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  /// HEADER
                  Container(
                    height: MediaQuery.of(context).size.height * .16,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 50,
                      bottom: 20,
                    ),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          "assets/images/appbar.png",
                        ),
                        fit: BoxFit.fill,
                      ),
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        /// BACK BUTTON
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            height: 42,
                            width: 42,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.white24,
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 15),

                        /// TITLE
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.isEdit
                                    ? "Edit Travel Expense"
                                    : "Request Travel Expense",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: .5,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                widget.isEdit
                                    ? "Update your travel request"
                                    : "Create your travel request",
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// BODY
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// DATE
                        buildTitle("Date"),

                        const SizedBox(height: 8),

                        buildField(
                          controller: dateController,
                          hint: "dd-mm-yyyy",
                          readOnly: true,
                          suffix: Icons.calendar_today,
                          onTap: () {
                            selectDate();
                          },
                        ),

                        const SizedBox(height: 18),

                        /// VEHICLE
                        buildTitle("Vehicle Type"),

                        const SizedBox(height: 8),

                        DropdownButtonFormField<VehicleTypeModel>(
                          value: selectedVehicle,
                          decoration: inputDecoration("Select Vehicle"),
                          items: vehicleList.map((vehicle) {
                            return DropdownMenuItem<VehicleTypeModel>(
                              value: vehicle,
                              child: Text(
                                "${vehicle.vehicleType} (${vehicle.ratePerKm}/KM)",
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value == null) return;

                            setState(() {
                              selectedVehicle = value;

                              // Switch from API total to calculated total
                              isTotalEdited = true;
                            });
                          },
                        ),

                        const SizedBox(height: 18),

                        /// FROM
                        buildTitle("From"),

                        const SizedBox(height: 8),

                        buildField(
                          controller: fromController,
                          hint: "From",
                        ),

                        const SizedBox(height: 22),

                        /// ROWS
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: expenseRows.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: const EdgeInsets.all(16),
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: Column(
                                children: [
                                  /// TO + KM + BUTTON
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      /// TO
                                      Expanded(
                                        flex: 3,
                                        child: buildField(
                                          controller: expenseRows[index]["to"],
                                          hint: "To",
                                          onChanged: (v) {
                                            updateRoute();
                                          },
                                        ),
                                      ),

                                      const SizedBox(width: 8),

                                      /// KM
                                      Expanded(
                                        flex: 2,
                                        child: buildField(
                                          controller: expenseRows[index]["km"],
                                          hint: "KM",
                                          keyboard: TextInputType.number,
                                          onChanged: (v) {
                                            setState(() {
                                              isTotalEdited = true;
                                            });
                                          },
                                        ),
                                      ),

                                      const SizedBox(width: 8),

                                      /// ADD REMOVE BUTTON
                                      InkWell(
                                        onTap: () {
                                          if (index == expenseRows.length - 1) {
                                            addNewRow();
                                          } else {
                                            expenseRows.removeAt(index);

                                            updateRoute();

                                            setState(() {});
                                          }
                                        },
                                        child: Container(
                                          height: 52,
                                          width: 52,
                                          decoration: BoxDecoration(
                                            color:
                                                index == expenseRows.length - 1
                                                    ? const Color.fromARGB(
                                                        247,
                                                        100,
                                                        38,
                                                        53,
                                                      )
                                                    : Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(14),
                                          ),
                                          child: Icon(
                                            index == expenseRows.length - 1
                                                ? Icons.add_rounded
                                                : Icons.close_rounded,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 14),

                                  /// FILE PICKER
                                  /// FILE PICKER
                                  InkWell(
                                    onTap: () {
                                      pickFile(index);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xffF8F8F8),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Column(
                                        children: [
                                          /// EXISTING NETWORK IMAGE
                                          if (expenseRows[index]["image"] !=
                                                  null &&
                                              expenseRows[index]["image"]
                                                  .toString()
                                                  .isNotEmpty &&
                                              expenseRows[index]["file"] ==
                                                  null)
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              child: Image.network(
                                                expenseRows[index]["image"]
                                                    .toString(),
                                                headers: const {
                                                  "Accept": "*/*",
                                                },
                                                height: 170,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                                errorBuilder: (
                                                  context,
                                                  error,
                                                  stackTrace,
                                                ) {
                                                  return Container(
                                                    height: 170,
                                                    width: double.infinity,
                                                    color: Colors.grey.shade300,
                                                    child: const Center(
                                                      child: Icon(
                                                        Icons.broken_image,
                                                        size: 40,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),

                                          /// LOCAL FILE IMAGE
                                          if (expenseRows[index]["file"] !=
                                              null)
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              child: Image.file(
                                                expenseRows[index]["file"],
                                                height: 170,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                              ),
                                            ),

                                          const SizedBox(height: 12),

                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.attach_file_rounded,
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Text(
                                                  expenseRows[index]["file"] !=
                                                          null
                                                      ? expenseRows[index]
                                                              ["file"]
                                                          .path
                                                          .split("/")
                                                          .last
                                                      : expenseRows[index][
                                                                      "image"] !=
                                                                  null &&
                                                              expenseRows[index]
                                                                      ["image"]
                                                                  .toString()
                                                                  .isNotEmpty
                                                          ? "Existing Image"
                                                          : "Upload Bill / Receipt",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 20),

                        /// ROUTE
                        buildTitle("Route"),

                        const SizedBox(height: 8),

                        buildField(
                          controller: routeController,
                          hint: "Route",
                          readOnly: true,
                        ),
                        const SizedBox(height: 20),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey.shade300),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// HEADER
                              Row(
                                children: const [
                                  Icon(
                                    Icons.receipt_long,
                                    color: Color.fromARGB(247, 100, 38, 53),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Other Expense",
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),

                              const Divider(height: 24),

                              /// AMOUNT
                              buildTitle("Amount"),

                              const SizedBox(height: 8),

                              buildField(
                                controller: otherAmountController,
                                hint: "Enter Amount",
                                keyboard: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {
                                    isTotalEdited = true;
                                  });
                                },
                              ),

                              const SizedBox(height: 18),

                              /// DESCRIPTION
                              buildTitle("Description"),

                              const SizedBox(height: 8),

                              buildField(
                                controller: otherAmountCauseController,
                                hint: "Enter Description",
                                maxLines: 3,
                              ),
                            ],
                          ),
                        ),

                        /// TOTAL KM
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Total KM : ${totalKm()}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        /// TOTAL AMOUNT
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            selectedVehicle == null
                                ? "Total Amount : ₹ 0"
                                : "Total Amount : ₹ ${totalAmount()}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),

                        const SizedBox(height: 22),

                        /// REMARK
                        buildTitle("Remark"),

                        const SizedBox(height: 8),

                        buildField(
                          controller: remarkController,
                          hint: "Remark",
                          maxLines: 4,
                        ),

                        const SizedBox(height: 30),

                        /// SUBMIT BUTTON
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
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
                            onPressed: state is TravelExpensePostLoading
                                ? null
                                : () {
                                    submit();
                                  },
                            child: state is TravelExpensePostLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    widget.isEdit ? "Update" : "Submit",
                                    style: const TextStyle(
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// TITLE
  Widget buildTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  /// FIELD
  Widget buildField({
    required TextEditingController controller,
    required String hint,
    bool readOnly = false,
    int maxLines = 1,
    IconData? suffix,
    VoidCallback? onTap,
    TextInputType keyboard = TextInputType.text,
    Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      maxLines: maxLines,
      keyboardType: keyboard,
      onTap: onTap,
      onChanged: onChanged,
      decoration: inputDecoration(
        hint,
      ).copyWith(
        suffixIcon: suffix != null ? Icon(suffix) : null,
      ),
    );
  }

  /// INPUT DECORATION
  InputDecoration inputDecoration(
    String hint,
  ) {
    return InputDecoration(
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
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Color.fromARGB(
            247,
            100,
            38,
            53,
          ),
        ),
      ),
    );
  }
}
