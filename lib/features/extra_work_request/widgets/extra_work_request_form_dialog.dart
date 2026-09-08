import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/colors.dart';
import '../../../data/models/extrawork_Request/extra_work_request_model.dart';
import '../cubit/extra_work_request_cubit.dart';
import '../cubit/extra_work_request_state.dart';

/// Dialog for ADDING a new Extra Work Request with multiple items.
/// Edit functionality is handled separately by ExtraWorkRequestEditDialog.
class ExtraWorkRequestFormDialog extends StatefulWidget {
  final String? projectId;

  const ExtraWorkRequestFormDialog({
    super.key,
    this.projectId,
  });

  @override
  State<ExtraWorkRequestFormDialog> createState() =>
      _ExtraWorkRequestFormDialogState();
}

class _ExtraWorkRequestFormDialogState
    extends State<ExtraWorkRequestFormDialog> {
  final _itemFormKey = GlobalKey<FormState>();

  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  String? selectedProjectId;

  List<ExtraWorkItem> items = [];

  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();

    selectedProjectId = widget.projectId;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      final cubit = context.read<ExtraWorkRequestCubit>();

      // Load project list only when project is not already fixed.
      if (widget.projectId == null || widget.projectId!.isEmpty) {
        await cubit.getProjectList();

        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _qtyController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  // ============================================================
  // ADD ITEM
  // ============================================================

  void _addItem() {
    if (!(_itemFormKey.currentState?.validate() ?? false)) {
      return;
    }

    final newItem = ExtraWorkItem(
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
    // ------------------------------------------------------------
    // If no items have been added, try to add the current form item
    // ------------------------------------------------------------

    if (items.isEmpty) {
      final isValid = _itemFormKey.currentState?.validate() ?? false;

      if (isValid) {
        final itemName = _itemNameController.text.trim();
        final qty = _qtyController.text.trim();
        final remarks = _remarksController.text.trim();

        if (itemName.isNotEmpty && qty.isNotEmpty) {
          items.add(
            ExtraWorkItem(
              itemName: itemName,
              qty: qty,
              remarks: remarks,
            ),
          );
        }
      }
    }

    // ------------------------------------------------------------
    // Get final project ID
    // ------------------------------------------------------------

    final String? finalProjectId = widget.projectId?.isNotEmpty == true
        ? widget.projectId
        : selectedProjectId;

    // ------------------------------------------------------------
    // Validate project
    // ------------------------------------------------------------

    if (finalProjectId == null || finalProjectId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a project"),
          backgroundColor: Colors.red,
        ),
      );

      return;
    }

    // ------------------------------------------------------------
    // Validate items
    // ------------------------------------------------------------

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

    final cubit = context.read<ExtraWorkRequestCubit>();

    try {
      // ----------------------------------------------------------
      // ADD API
      // No clientId is sent
      // ----------------------------------------------------------

      final response = await cubit.addExtraWorkRequest(
        projectId: finalProjectId,
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

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ExtraWorkRequestCubit>();

    final bool isProjectFixed =
        widget.projectId != null && widget.projectId!.isNotEmpty;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),

      // ==========================================================
      // TITLE
      // ==========================================================

      title: const Row(
        children: [
          Icon(
            Icons.add_task,
            color: AppColors.primaryColor,
          ),
          SizedBox(width: 8),
          Text(
            "Add Extra Work Request",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),

      // ==========================================================
      // CONTENT
      // ==========================================================

      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ====================================================
              // PROJECT DROPDOWN
              // ====================================================

              if (!isProjectFixed) ...[
                BlocBuilder<ExtraWorkRequestCubit, ExtraWorkRequestState>(
                  builder: (context, state) {
                    return DropdownButtonFormField<String>(
                      value: selectedProjectId,
                      isExpanded: true,
                      borderRadius: BorderRadius.circular(12),

                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.grey,
                      ),

                      decoration: InputDecoration(
                        labelText: "Project *",
                        hintText: "Select Project",
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.primaryColor,
                            width: 2,
                          ),
                        ),
                      ),

                      // IMPORTANT:
                      // New model uses project.id
                      // NOT project.projectId
                      items: cubit.projectList.map((project) {
                        return DropdownMenuItem<String>(
                          value: project.id,
                          child: Text(
                            project.projectName,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),

                      onChanged: (value) {
                        setState(() {
                          selectedProjectId = value;
                        });
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],

              // ====================================================
              // ITEM INPUT SECTION
              // ====================================================

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                ),
                child: Form(
                  key: _itemFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.post_add,
                            size: 18,
                            color: AppColors.primaryColor,
                          ),
                          SizedBox(width: 6),
                          Text(
                            "Add Item Details",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // ==================================================
                      // ITEM NAME
                      // ==================================================

                      TextFormField(
                        controller: _itemNameController,
                        decoration: InputDecoration(
                          labelText: "Item Name *",
                          hintText: "e.g. Electrical wiring work",
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: AppColors.primaryColor,
                              width: 1.5,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Item Name is required";
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 10),

                      // ==================================================
                      // QUANTITY
                      // ==================================================

                      TextFormField(
                        controller: _qtyController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Quantity *",
                          hintText: "e.g. 2",
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: AppColors.primaryColor,
                              width: 1.5,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Quantity is required";
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 10),

                      // ==================================================
                      // REMARKS
                      // ==================================================

                      TextFormField(
                        controller: _remarksController,
                        maxLines: 2,
                        decoration: InputDecoration(
                          labelText: "Remarks",
                          hintText: "Enter remarks (optional)",
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: AppColors.primaryColor,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // ==================================================
                      // ADD ITEM BUTTON
                      // ==================================================

                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          onPressed: isSubmitting ? null : _addItem,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                          ),
                          icon: const Icon(
                            Icons.add,
                            size: 18,
                          ),
                          label: const Text(
                            "Add Item",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ====================================================
              // ADDED ITEMS HEADER
              // ====================================================

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Added Items",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: items.isEmpty
                          ? Colors.grey.shade200
                          : AppColors.primaryColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "${items.length} item(s)",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: items.isEmpty
                            ? Colors.grey.shade700
                            : AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // ====================================================
              // NO ITEMS
              // ====================================================

              if (items.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 32,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "No items added yet.\n"
                        "Fill details above and tap 'Add Item'.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                )

              // ====================================================
              // ITEMS
              // ====================================================

              else
                ...items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey.shade300,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(
                            0.04,
                          ),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.itemName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Quantity: ${item.qty}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (item.remarks.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Text(
                                  "Remarks: ${item.remarks}",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                            size: 20,
                          ),
                          onPressed:
                              isSubmitting ? null : () => _removeItem(index),
                        ),
                      ],
                    ),
                  );
                }),
            ],
          ),
        ),
      ),

      // ==========================================================
      // ACTIONS
      // ==========================================================

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
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 10,
            ),
          ),
          onPressed: isSubmitting ? null : _submitRequest,
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
                  "Submit Request",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ],
    );
  }
}
