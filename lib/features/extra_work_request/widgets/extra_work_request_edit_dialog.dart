import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/colors.dart';
import '../../../data/models/extrawork_Request/extra_work_request_model.dart';
import '../cubit/extra_work_request_cubit.dart';


/// Dialog for editing a single Extra Work Request item.
/// Completely separate from the Add dialog.
class ExtraWorkRequestEditDialog extends StatefulWidget {
  // final String projectId;
  // final String? clientId;
  final ExtraWorkItem existingItem;

  const ExtraWorkRequestEditDialog({
    super.key,
    // required this.projectId,
    // this.clientId,
    required this.existingItem,
  });

  @override
  State<ExtraWorkRequestEditDialog> createState() =>
      _ExtraWorkRequestEditDialogState();
}

class _ExtraWorkRequestEditDialogState
    extends State<ExtraWorkRequestEditDialog> {
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

    final cubit = context.read<ExtraWorkRequestCubit>();

    try {
      print("EDIT REQUEST ID: ${widget.existingItem.id}");
      final response = await cubit.updateExtraWorkRequest(
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
            "Edit Extra Work Request",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Item Name
              TextFormField(
                controller: _itemNameController,
                decoration: _fieldDecoration(
                  label: "Item Name *",
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? "Item Name is required"
                    : null,
              ),
              const SizedBox(height: 12),

              /// Quantity
              TextFormField(
                controller: _qtyController,
                keyboardType: TextInputType.number,
                decoration: _fieldDecoration(
                  label: "Quantity *",
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return "Quantity is required";
                  }

                  final qty = int.tryParse(v.trim());

                  if (qty == null || qty < 1) {
                    return "Quantity must be at least 1";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 12),

              /// Remarks
              TextFormField(
                controller: _remarksController,
                maxLines: 2,
                decoration: _fieldDecoration(
                  label: "Remarks",
                  hint: "Enter remarks (optional)",
                ),
              ),
            ],
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
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          ),
          onPressed: isSubmitting ? null : _submitUpdate,
          child: isSubmitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text(
                  "Update Request",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
        ),
      ],
    );
  }
}
