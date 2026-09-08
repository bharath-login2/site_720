import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/colors.dart';
import '../../../data/models/extrawork_Request/extra_work_request_model.dart';
import '../cubit/extra_work_request_cubit.dart';
import 'extra_work_request_edit_dialog.dart';

class ExtraWorkRequestCard extends StatelessWidget {
  final ExtraWorkRequestModel item;
  final String? projectId;
  final VoidCallback? onTap;

  const ExtraWorkRequestCard({
    super.key,
    required this.item,
    this.projectId,
    this.onTap,
  });

  // bool get isPending => item.status.toLowerCase().trim() == "pending";

  @override
  Widget build(BuildContext context) {
    // final isPending = item.isApproved.toUpperCase().trim() == 'N';
    final isApproved = item.isApproved.toUpperCase().trim() == 'N';

    final statusBg = isApproved ? Colors.orange.shade50 : Colors.green.shade50;

    final statusColor = isApproved ? Colors.orange : Colors.green;

    final statusText = isApproved ? 'Not Approved' : 'Approved';

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
            /// Header: Badge + Delete Action
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
                        "EXTRA WORK",
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
                if (isApproved && item.id.isNotEmpty) ...[
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
                  // CircleAvatar(
                  //   radius: 18,
                  //   backgroundColor: Colors.red.shade600,
                  //   child: IconButton(
                  //     padding: EdgeInsets.zero,
                  //     icon: const Icon(
                  //       Icons.delete,
                  //       color: Colors.white,
                  //       size: 18,
                  //     ),
                  //     onPressed: () {
                  //       _showDeleteDialog(context, item);
                  //     },
                  //   ),
                  // ),
                ],
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
                            : "Extra Work Request"),
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
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            if (item.createdBy.isNotEmpty) ...[
              _buildInfoRow(
                Icons.person_outline,
                "Created By",
                item.createdBy,
              ),
              const SizedBox(height: 8),
            ],

            if (item.createdAt.isNotEmpty) ...[
              _buildInfoRow(
                Icons.calendar_month_outlined,
                "Created At",
                item.createdAt,
              ),
              const SizedBox(height: 8),
            ],

            /// Items List Preview
            if (item.items.isNotEmpty) ...[
              const SizedBox(height: 6),
              const Divider(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Requested Items (${item.items.length})",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const Text(
                    "Tap to view all",
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...item.items.take(2).map((extraItem) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              extraItem.itemName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                            if (extraItem.remarks.isNotEmpty)
                              Text(
                                "Remarks: ${extraItem.remarks}",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "Qty: ${extraItem.qty}",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              if (item.items.length > 2)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    "+${item.items.length - 2} more item(s)...",
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
            ] else if (item.itemName.isNotEmpty) ...[
              const SizedBox(height: 6),
              const Divider(height: 16),
              _buildInfoRow(
                Icons.task_alt,
                "Item Name",
                item.itemName,
              ),
              const SizedBox(height: 6),
              _buildInfoRow(
                Icons.numbers,
                "Quantity",
                item.qty,
              ),
              if (item.remarks.isNotEmpty) ...[
                const SizedBox(height: 6),
                _buildInfoRow(
                  Icons.notes,
                  "Remarks",
                  item.remarks,
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    int maxLines = 1,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey.shade600,
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        const Text(
          ": ",
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _showEditDialog(BuildContext parentContext) {
    final cubit = parentContext.read<ExtraWorkRequestCubit>();

    final ExtraWorkItem itemToEdit = item.items.isNotEmpty
        ? (item.items.first.id.isNotEmpty
            ? item.items.first
            : ExtraWorkItem(
                id: item.id,
                itemName: item.items.first.itemName,
                qty: item.items.first.qty,
                remarks: item.items.first.remarks,
                isApproved: item.items.first.isApproved,
              ))
        : ExtraWorkItem(
            id: item.id,
            itemName: item.itemName,
            qty: item.qty,
            remarks: item.remarks,
          );

    showDialog(
      context: parentContext,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: ExtraWorkRequestEditDialog(
          // projectId: projectId ?? '',
          // clientId: item.clientId.isNotEmpty ? item.clientId : null,
          existingItem: itemToEdit,
        ),
      ),
    ).then((result) {
      if (result == true) {
        cubit.getExtraWorkRequests(
          projectId: projectId ?? '',
        );
      }
    });
  }
  //uncomment if need
  // void _showDeleteDialog(BuildContext context, ExtraWorkRequestModel item) {
  //   showDialog(
  //     context: context,
  //     builder: (dialogContext) {
  //       return AlertDialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(16),
  //         ),
  //         title: const Row(
  //           children: [
  //             Icon(Icons.warning_amber_rounded, color: Colors.red),
  //             SizedBox(width: 8),
  //             Text("Delete Request"),
  //           ],
  //         ),
  //         content: const Text(
  //           "Are you sure you want to delete this extra work request?",
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(dialogContext),
  //             child: const Text("Cancel"),
  //           ),
  //           ElevatedButton(
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: Colors.red,
  //               foregroundColor: Colors.white,
  //             ),
  //             onPressed: () {
  //               Navigator.pop(dialogContext);
  //               context
  //                   .read<ExtraWorkRequestCubit>()
  //                   .deleteExtraWorkRequest(requestId: item.id);
  //             },
  //             child: const Text("Delete"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void _showDetailsDialog(BuildContext context) {
    final approved = item.isApproved.toUpperCase().trim() == 'Y';
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.assignment_outlined,
                color: AppColors.primaryColor,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  "Extra Work Request",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(dialogContext),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (item.projectName.isNotEmpty) ...[
                    Text(
                      item.projectName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  Row(
                    children: [
                      const Text(
                        "Status: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        approved ? "Approved" : "Not Approved",
                        style: TextStyle(
                          color: approved ? Colors.green : Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  if (item.createdBy.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text("Created By: ${item.createdBy}"),
                  ],
                  if (item.createdAt.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text("Created At: ${item.createdAt}"),
                  ],
                  const SizedBox(height: 14),
                  const Divider(),
                  const SizedBox(height: 8),
                  Text(
                    "Requested Items (${item.items.length})",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (item.items.isEmpty) ...[
                    if (item.itemName.isNotEmpty)
                      _buildDetailItemTile(
                        index: 1,
                        item: ExtraWorkItem(
                          itemName: item.itemName,
                          qty: item.qty,
                          remarks: item.remarks,
                        ),
                      )
                    else
                      const Text(
                        "No item details available",
                        style: TextStyle(color: Colors.grey),
                      )
                  ] else ...[
                    ...item.items.asMap().entries.map((entry) {
                      return _buildDetailItemTile(
                        index: entry.key + 1,
                        item: entry.value,
                      );
                    }),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailItemTile({
    required int index,
    required ExtraWorkItem item,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$index. ${item.itemName}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "Qty: ${item.qty}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          if (item.remarks.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              "Remarks: ${item.remarks}",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
