import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/estimate_request_cubit.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utilities/permission_manager.dart';
import '../../../data/models/estimate_request/estimate_request_model.dart';
import 'estimate_request_form_dialog.dart';

/// Approve Currently commented out, but can be enabled if needed
//import 'estimate_request_approve_form_dialog.dart';

class EstimateRequestCard extends StatelessWidget {
  final EstimateRequestModel item;
  final String? projectId;
  final VoidCallback? onTap;

  const EstimateRequestCard({
    super.key,
    required this.item,
    this.projectId,
    this.onTap,
  });

  bool get isPending => item.status.toLowerCase().trim() == "pending";

  @override
  Widget build(BuildContext context) {
    final status = item.status.toLowerCase().trim();

    Color statusBg;
    Color statusColor;

    switch (status) {
      case "pending":
        statusBg = Colors.orange.shade50;
        statusColor = Colors.orange;
        break;

      case "completed":
        statusBg = Colors.green.shade50;
        statusColor = Colors.green;
        break;

      case "in progress":
        statusBg = Colors.blue.shade50;
        statusColor = Colors.blue;
        break;

      default:
        statusBg = Colors.grey.shade200;
        statusColor = Colors.grey;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        _showEstimateDialog(context);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
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
                        Icons.request_quote,
                        color: Colors.white,
                        size: 18,
                      ),
                      SizedBox(width: 6),
                      Text(
                        "ESTIMATE",
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
                if (item.status == "Pending") ...[
                  /// Edit
                  if (PermissionManager.hasPermission('edit estimate request'))
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.amber.shade700,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 18,
                        ),
                        onPressed: () {
                          final cubit = context.read<EstimateRequestCubit>();

                          showDialog(
                            context: context,
                            builder: (_) => BlocProvider.value(
                              value: cubit,
                              child: EstimateRequestFormDialog(
                                projectId: projectId,
                                estimate: item,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                  const SizedBox(width: 8),

                  /// Delete
                  if (PermissionManager.hasPermission(
                      'delete estimate request'))
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.red,
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

                  const SizedBox(width: 8),

                  /// Approve Currently commented out, but can be enabled if needed
                  // CircleAvatar(
                  //   radius: 18,
                  //   backgroundColor: Colors.green,
                  //   child: IconButton(
                  //     padding: EdgeInsets.zero,
                  //     icon: const Icon(
                  //       Icons.check,
                  //       color: Colors.white,
                  //       size: 18,
                  //     ),
                  //     onPressed: () {
                  //       showDialog(
                  //         context: context,
                  //         builder: (_) => BlocProvider.value(
                  //           value: context.read<EstimateRequestCubit>(),
                  //           child: EstimateRequestApproveFormDialog(
                  //             estimate: item,
                  //           ),
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
                ]
              ],
            ),

            const SizedBox(height: 15),

            /// Project + Status
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.projectName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
                    item.status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            _buildInfoRow(
              Icons.layers_outlined,
              "Stage",
              item.stageName,
            ),

            const SizedBox(height: 8),

            _buildInfoRow(
              Icons.person_outline,
              "Created By",
              item.createdBy,
            ),

            const SizedBox(height: 8),

            _buildInfoRow(
              Icons.calendar_month_outlined,
              "Created At",
              item.createdAt,
            ),

            const SizedBox(height: 8),

            // _buildInfoRow(
            //   Icons.description_outlined,
            //   "Remark",
            //   item.remark,
            //   maxLines: 2,
            // ),

            const SizedBox(height: 12),

            const Divider(),

            const SizedBox(height: 8),

            const Text(
              "Assigned Staff",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            item.assignedStaff.isEmpty
                ? const Text(
                    "No Assigned Staff",
                    style: TextStyle(color: Colors.grey),
                  )
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: item.assignedStaff.map((staff) {
                      return Chip(
                        label: Text(staff.staffName),
                        backgroundColor: Colors.grey.shade100,
                      );
                    }).toList(),
                  ),
          ],
        ),
      ),
    );
  }

  void _showEstimateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final status = item.status.toLowerCase().trim();

        Color statusColor;

        switch (status) {
          case "pending":
            statusColor = Colors.orange;
            break;
          case "completed":
            statusColor = Colors.green;
            break;
          case "in progress":
            statusColor = Colors.blue;
            break;
          default:
            statusColor = Colors.grey;
        }

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          title: Row(
            children: [
              const Icon(
                Icons.request_quote_rounded,
                color: AppColors.primaryColor,
              ),
              const SizedBox(width: 8),
              const Text(
                "Estimate Request",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(
                  Icons.home_work_outlined,
                  "Project",
                  item.projectName,
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  Icons.layers_outlined,
                  "Stage",
                  item.stageName,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.flag_outlined,
                      color: AppColors.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    const SizedBox(
                      width: 90,
                      child: Text(
                        "Status",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        item.status,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  Icons.person_outline,
                  "Created By",
                  item.createdBy,
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  Icons.calendar_today_outlined,
                  "Created Date",
                  item.createdAt,
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  Icons.person_outline,
                  "Updated By",
                  item.updatedBy.isEmpty ? "-" : item.updatedBy,
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  Icons.update_outlined,
                  "Updated Date",
                  item.updatedAt.isEmpty ? "-" : item.updatedAt,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Assigned Staff",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 8),
                item.assignedStaff.isEmpty
                    ? const Text(
                        "No staff assigned",
                        style: TextStyle(color: Colors.grey),
                      )
                    : Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: item.assignedStaff.map((staff) {
                          return Chip(
                            avatar: const Icon(
                              Icons.person,
                              size: 16,
                            ),
                            label: Text(staff.staffName),
                          );
                        }).toList(),
                      ),
                const SizedBox(height: 16),
                const Text(
                  "Remark",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(item.remark),
                ),
              ],
            ),
          ),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
            // ElevatedButton.icon(
            //   onPressed: () {
            //     Navigator.pop(context);

            //     // Submit action
            //   },
            //   icon: const Icon(Icons.check),
            //   label: const Text("Submit"),
            // ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    EstimateRequestModel item,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.red,
            ),
            SizedBox(width: 8),
            Text("Delete Request"),
          ],
        ),
        content: Text(
          "Are you sure you want to delete the estimate request for '${item.projectName}'?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () async {
              Navigator.pop(context);

              if (!context.mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Estimate Request Deleted Successfully",
                  ),
                ),
              );

              await context.read<EstimateRequestCubit>().deleteEstimateRequest(
                    requestId: item.id,
                  );
            },
            child: const Text(
              "Delete",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String title,
    String value, {
    int maxLines = 1,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: AppColors.primaryColor,
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 90,
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
