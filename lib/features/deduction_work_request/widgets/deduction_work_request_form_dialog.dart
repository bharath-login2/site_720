import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/colors.dart';
import '../../../data/models/deductionwork_request/deduction_work_request_model.dart';
import '../cubit/deduction_work_request_cubit.dart';

/// Dialog for ADDING a new Deduction Work Request with multiple items.
/// Edit functionality is handled separately by DeductionWorkRequestEditDialog.
class DeductionWorkRequestFormDialog extends StatefulWidget {
  final String projectId;

  const DeductionWorkRequestFormDialog({
    super.key,
    required this.projectId,
  });

  @override
  State<DeductionWorkRequestFormDialog> createState() =>
      _DeductionWorkRequestFormDialogState();
}

class _DeductionWorkRequestFormDialogState
    extends State<DeductionWorkRequestFormDialog> {
  final _itemFormKey = GlobalKey<FormState>();

  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  List<DeductionWorkItem> items = [];

  bool isSubmitting = false;

  @override
  void dispose() {
    _itemNameController.dispose();
    _qtyController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  // ============================================================
  // ADD ITEM TO BATCH
  // ============================================================

  void _addItem() {
    if (!(_itemFormKey.currentState?.validate() ?? false)) {
      return;
    }

    final newItem = DeductionWorkItem(
      itemName: _itemNameController.text.trim(),
      qty: _qtyController.text.trim(),
      remarks: _remarksController.text.trim(),
    );

    setState(() {
      items.add(newItem);

      _itemNameController.clear();
      _qtyController.clear();
      _remarksController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Item added to request list"),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.green,
      ),
    );
  }

  // ============================================================
  // REMOVE ITEM
  // ============================================================

  void _removeItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  // ============================================================
  // SUBMIT REQUEST
  // ============================================================

  Future<void> _submitRequest() async {
    // If no items have been added to the list, try to use the current input fields
    if (items.isEmpty) {
      final isValid = _itemFormKey.currentState?.validate() ?? false;

      if (isValid) {
        final itemName = _itemNameController.text.trim();
        final qty = _qtyController.text.trim();
        final remarks = _remarksController.text.trim();

        if (itemName.isNotEmpty && qty.isNotEmpty) {
          items.add(
            DeductionWorkItem(
              itemName: itemName,
              qty: qty,
              remarks: remarks,
            ),
          );
        }
      }
    }

    if (widget.projectId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid project ID"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please add at least one item before submitting",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    final cubit = context.read<DeductionWorkRequestCubit>();

    try {
      final response = await cubit.addDeductionWorkRequest(
        projectId: widget.projectId,
        items: items,
      );

      if (!mounted) return;

      final successMsg = response != null && response.message.isNotEmpty
          ? response.message
          : "Request sent.";

      Navigator.pop(context, true);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(successMsg),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isSubmitting = false;
      });

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
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Row(
              children: [
                const Icon(
                  Icons.playlist_add,
                  color: AppColors.primaryColor,
                  size: 26,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    "Add Deduction Work Request",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: isSubmitting ? null : () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),

            /// Scrollable Form Content
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Item Input Section
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Form(
                        key: _itemFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Work / Item Details",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            const SizedBox(height: 10),
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
                            const SizedBox(height: 12),
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
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _remarksController,
                              maxLines: 2,
                              decoration: _fieldDecoration(
                                label: "Remarks",
                                hint: "Enter remarks (optional)",
                              ),
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.lightPrimary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: _addItem,
                                icon: const Icon(Icons.add, size: 18),
                                label: const Text("Add to List"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    /// Added Items Queue
                    if (items.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Items to Submit (${items.length})",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                items.clear();
                              });
                            },
                            child: const Text(
                              "Clear All",
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  backgroundColor: AppColors.primaryColor,
                                  child: Text(
                                    "${index + 1}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.itemName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        "Qty: ${item.qty}${item.remarks.isNotEmpty ? ' | Remarks: ${item.remarks}' : ''}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                  onPressed: () => _removeItem(index),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 12),

            /// Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: isSubmitting ? null : () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: isSubmitting ? null : _submitRequest,
                  child: isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          items.length > 1
                              ? "Submit (${items.length}) Items"
                              : "Submit Request",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
