import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/colors.dart';
import '../../../data/models/deductionwork_request/deduction_work_request_model.dart';
import '../cubit/deduction_work_request_cubit.dart';

/// Dialog for editing a single Deduction Work Request item.
/// Completely separate from the Add dialog.
class DeductionWorkRequestEditDialog extends StatefulWidget {
  final DeductionWorkItem existingItem;

  const DeductionWorkRequestEditDialog({
    super.key,
    required this.existingItem,
  });

  @override
  State<DeductionWorkRequestEditDialog> createState() =>
      _DeductionWorkRequestEditDialogState();
}

class _DeductionWorkRequestEditDialogState
    extends State<DeductionWorkRequestEditDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _itemNameController;
  late final TextEditingController _qtyController;
  late final TextEditingController _remarksController;

  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill with existing item values
    _itemNameController =
        TextEditingController(text: widget.existingItem.itemName);
    _qtyController = TextEditingController(text: widget.existingItem.qty);
    _remarksController =
        TextEditingController(text: widget.existingItem.remarks);
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _qtyController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  Future<void> _submitUpdate() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => isSubmitting = true);

    final cubit = context.read<DeductionWorkRequestCubit>();

    try {
      print("EDIT DEDUCTION REQUEST ID: ${widget.existingItem.id}");
      final response = await cubit.updateDeductionWorkRequest(
        requestId: widget.existingItem.id,
        itemName: _itemNameController.text.trim(),
        qty: _qtyController.text.trim(),
        remarks: _remarksController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pop(context, true);

      final successMsg =
          response?.message != null && response!.message.isNotEmpty
              ? response.message
              : "Request updated successfully.";

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(successMsg),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() => isSubmitting = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceAll("Exception: ", ""),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  InputDecoration _fieldDecoration({
    required String label,
    String? hint,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primaryColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      title: Row(
        children: const [
          Icon(Icons.edit_note, color: AppColors.primaryColor),
          SizedBox(width: 8),
          Text(
            "Edit Deduction Work Request",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                TextFormField(
                  controller: _itemNameController,
                  decoration: _fieldDecoration(
                    label: "Item Name *",
                    hint: "Enter item / work name",
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Item name is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _qtyController,
                  decoration: _fieldDecoration(
                    label: "Quantity *",
                    hint: "Enter quantity",
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Quantity is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _remarksController,
                  maxLines: 3,
                  decoration: _fieldDecoration(
                    label: "Remarks",
                    hint: "Enter remarks (optional)",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: isSubmitting ? null : () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: isSubmitting ? null : _submitUpdate,
          child: isSubmitting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text("Update"),
        ),
      ],
    );
  }
}
