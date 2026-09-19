import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/colors.dart';
import '../../../data/models/deductionwork_request/deduction_work_request_model.dart';
import '../cubit/deduction_work_request_cubit.dart';
import 'deduction_work_request_edit_dialog.dart';

class DeductionWorkRequestCard extends StatelessWidget {
  final DeductionWorkRequestModel item;
  final String? projectId;
  final VoidCallback? onTap;

  const DeductionWorkRequestCard({
    super.key,
    required this.item,
    this.projectId,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // API:
    // Y = Approved
    // N = Not Approved
    final isApproved = item.isApproved.toUpperCase().trim() == 'Y';
    final isNotApproved = item.isApproved.toUpperCase().trim() == 'N';

    final statusBg = isApproved ? Colors.green.shade50 : Colors.orange.shade50;

    final statusColor = isApproved ? Colors.green : Colors.orange;

    final statusText = isApproved ? 'Approved' : 'Not Approved';

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        if (onTap != null) {
          onTap!();
        } else {
          _showDetailsDialog(context);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.grey.shade200,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header: Badge + Edit Action
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.assignment_outlined,
                        color: Colors.white,
                        size: 18,
                      ),
                      SizedBox(width: 6),
                      Text(
                        "DEDUCTION WORK",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Edit button ONLY for Not Approved (N)
                if (isNotApproved && item.id.isNotEmpty)
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.primaryColor,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 18,
                      ),
                      onPressed: () {
                        _showEditDialog(context);
                      },
                    ),
                  ),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.red.shade600,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 18,
                    ),
                    onPressed: () {
                      _showDeleteDialog(context, item);
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            /// Project + Status
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    item.projectName.isNotEmpty
                        ? item.projectName
                        : (item.items.isNotEmpty
                            ? item.items.first.itemName
                            : "Deduction Work Request"),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            const Divider(height: 1),
            const SizedBox(height: 10),

            /// Items / Summary
            if (item.items.isNotEmpty) ...[
              Text(
                "Items (${item.items.length}):",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 6),
              ...item.items.take(3).map((subItem) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Icon(
                        Icons.fiber_manual_record,
                        size: 8,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          subItem.itemName,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        "Qty: ${subItem.qty}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                );
              }),
              if (item.items.length > 3) ...[
                Text(
                  "+ ${item.items.length - 3} more items...",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ] else ...[
              _buildInfoRow(
                "Work / Item",
                item.itemName,
              ),
              const SizedBox(height: 4),
              _buildInfoRow(
                "Quantity",
                item.qty,
              ),
              if (item.remarks.isNotEmpty) ...[
                const SizedBox(height: 4),
                _buildInfoRow(
                  "Remarks",
                  item.remarks,
                ),
              ],
            ],

            const SizedBox(height: 8),

            /// Footer info: Created by / Date
            Row(
              children: [
                if (item.createdAt.isNotEmpty) ...[
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 13,
                    color: Colors.grey.shade500,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    item.createdAt,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
                const Spacer(),
                if (item.createdBy.isNotEmpty) ...[
                  Icon(
                    Icons.person_outline,
                    size: 14,
                    color: Colors.grey.shade500,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    item.createdBy,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
  ) {
    if (value.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(
            "$label:",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _showEditDialog(BuildContext parentContext) {
    final cubit = parentContext.read<DeductionWorkRequestCubit>();

    final DeductionWorkItem itemToEdit = item.items.isNotEmpty
        ? (item.items.first.id.isNotEmpty
            ? item.items.first
            : DeductionWorkItem(
                id: item.id,
                itemName: item.items.first.itemName,
                qty: item.items.first.qty,
                remarks: item.items.first.remarks,
                isApproved: item.items.first.isApproved,
              ))
        : DeductionWorkItem(
            id: item.id,
            itemName: item.itemName,
            qty: item.qty,
            remarks: item.remarks,
            isApproved: item.isApproved,
          );

    showDialog(
      context: parentContext,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: DeductionWorkRequestEditDialog(
          existingItem: itemToEdit,
        ),
      ),
    ).then((result) {
      if (result == true) {
        cubit.getDeductionWorkRequests(
          projectId: projectId ?? '',
        );
      }
    });
  }

  void _showDeleteDialog(BuildContext context, DeductionWorkRequestModel item) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red),
              SizedBox(width: 8),
              Text("Delete Request"),
            ],
          ),
          content: const Text(
            "Are you sure you want to delete this deduction work request?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
                context
                    .read<DeductionWorkRequestCubit>()
                    .deleteDeductionWorkRequest(requestId: item.id);
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  void _showDetailsDialog(BuildContext context) {
    // API:
    // Y = Approved
    // N = Not Approved
    final isApproved = item.isApproved.toUpperCase().trim() == 'Y';

    final statusBg = isApproved ? Colors.green.shade50 : Colors.orange.shade50;

    final statusColor = isApproved ? Colors.green : Colors.orange;

    final statusText = isApproved ? 'Approved' : 'Not Approved';

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.assignment_outlined,
                color: AppColors.primaryColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.projectName.isNotEmpty
                      ? item.projectName
                      : "Deduction Work Request",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Status:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        statusText,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (item.createdAt.isNotEmpty) ...[
                  _buildDetailRow(
                    "Created Date",
                    item.createdAt,
                  ),
                  const SizedBox(height: 6),
                ],
                if (item.createdBy.isNotEmpty) ...[
                  _buildDetailRow(
                    "Created By",
                    item.createdBy,
                  ),
                  const SizedBox(height: 6),
                ],
                const Divider(),
                const SizedBox(height: 6),
                const Text(
                  "Work Items:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                if (item.items.isNotEmpty) ...[
                  ...item.items.map((subItem) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey.shade200,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            subItem.itemName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Quantity: ${subItem.qty}",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          if (subItem.remarks.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              "Remarks: ${subItem.remarks}",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  }),
                ] else ...[
                  Text(
                    "Item: ${item.itemName}",
                  ),
                  Text(
                    "Quantity: ${item.qty}",
                  ),
                  if (item.remarks.isNotEmpty)
                    Text(
                      "Remarks: ${item.remarks}",
                    ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            "$label:",
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
