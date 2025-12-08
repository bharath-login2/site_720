// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/widgets/appbar.dart';
import 'package:site_720/core/widgets/shimmer.dart';
import 'package:site_720/features/task_management/cubit/task_history_cubit.dart';
import 'package:site_720/features/task_management/cubit/task_state.dart';
import 'package:timelines_plus/timelines_plus.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/connectivity_dialog.dart';
import '../../connectivity/cubit/connectivity_cubit.dart';
import '../../connectivity/cubit/connectivity_state.dart';

class TaskHistoryScreen extends StatelessWidget {
  const TaskHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    String taskId = args["task_id"]!;
    return BlocProvider(
      create: (context) => TaskHistoryCubit(taskId),
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: simpleAppbar(context, "Task History", true),
        body: MultiBlocListener(
          listeners: [
            BlocListener<ConnectivityCubit, ConnectivityState>(
              listener: (context, state) {
                if (state is ConnectivityDisconnected) {
                  if (connStatus == true) {
                    connStatus = false;
                    connectivityDialog(context);
                  }
                } else {
                  connStatus = true;
                }
              },
            ),
          ],
          child: BlocBuilder<TaskHistoryCubit, TaskState>(
            builder: (context, state) {
              final cubit = context.read<TaskHistoryCubit>();
              if (state is TaskLoading) {
                return _buildShimmerLoader();
              } else if (cubit.taskList.isEmpty) {
                return _buildEmptyState();
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 16.0),
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: cubit.taskList.length,
                    itemBuilder: (context, index) {
                      final task = cubit.taskList[index];
                      return TimelineTile(
                        nodeAlign: TimelineNodeAlign.start,
                        node: TimelineNode(
                          indicator: DotIndicator(
                            color: _getStatusColor(task.statusName),
                            size: 24,
                          ),
                          startConnector: index == 0
                              ? null
                              : SolidLineConnector(
                                  color:
                                      AppColors.primaryColor.withOpacity(0.3),
                                ),
                          endConnector: index == cubit.taskList.length - 1
                              ? null
                              : SolidLineConnector(
                                  color:
                                      AppColors.primaryColor.withOpacity(0.3),
                                ),
                        ),
                        contents: Padding(
                          padding:
                              const EdgeInsets.only(left: 16.0, bottom: 24.0),
                          child: _buildTaskCard(task, context),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerLoader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        children: List.generate(3, (index) => _buildShimmerCard()),
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator shimmer
          Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 2,
                height: 120,
                color: Colors.grey[300],
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Content shimmer
          Expanded(
            child: Container(
              height: 160,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_toggle_off_outlined,
            size: 80,
            color: AppColors.lightPrimary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            "No Task History Found",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.lightPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Task updates will appear here",
            style: TextStyle(
              fontSize: 14,
              color: AppColors.lightPrimary.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(dynamic task, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Badge at top
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _getStatusColor(task.statusName).withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(task.statusName),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getStatusIcon(task.statusName),
                        size: 14,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        task.statusName.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.access_time,
                  size: 14,
                  color: Colors.grey.shade500,
                ),
                const SizedBox(width: 6),
                Text(
                  _formatDateTime(task.updatedDate),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),

          // Content Area
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title (if exists)
                if (task.historyTitle != null && task.historyTitle!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "TITLE",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        task.historyTitle!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),

                // Comment Section
                Text(
                  "COMMENT",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  task.comment.isNotEmpty
                      ? task.comment
                      : "No comment provided",
                  style: TextStyle(
                    fontSize: 14,
                     fontWeight: FontWeight.w600,
                    color: AppColors.lightPrimary,
                    height: 1.5,
                  ),
                ),

                // Attachments
                if (task.attachments.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  _buildAttachmentsSection(task.attachments, context),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentsSection(
      List<String> attachments, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "ATTACHMENTS",
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: attachments.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return _buildAttachmentThumbnail(attachments[index], context);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAttachmentThumbnail(String imageUrl, BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showImagePreview(context, imageUrl);
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey.shade200,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        color: AppColors.primaryColor,
                        strokeWidth: 2,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: Icon(
                        Icons.broken_image_outlined,
                        color: Colors.grey,
                        size: 32,
                      ),
                    ),
                  );
                },
              ),

              // Overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                      ],
                      stops: const [0.6, 1.0],
                    ),
                  ),
                ),
              ),

              // Zoom icon
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.zoom_in,
                    size: 14,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImagePreview(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: Stack(
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: InteractiveViewer(
                  panEnabled: true,
                  minScale: 0.5,
                  maxScale: 3.0,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // Close button
              Positioned(
                top: 16,
                right: 16,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper methods
  Color _getStatusColor(String status) {
    final statusLower = status.toLowerCase();
    if (statusLower.contains('completed') || statusLower.contains('closed')) {
      return Colors.green;
    } else if (statusLower.contains('progress') ||
        statusLower.contains('ongoing')) {
      return Colors.orange;
    } else if (statusLower.contains('pending') ||
        statusLower.contains('waiting')) {
      return Colors.blue;
    } else if (statusLower.contains('reject') ||
        statusLower.contains('cancel')) {
      return Colors.red;
    } else {
      return AppColors.primaryColor;
    }
  }

  IconData _getStatusIcon(String status) {
    final statusLower = status.toLowerCase();
    if (statusLower.contains('completed') || statusLower.contains('closed')) {
      return Icons.check_circle;
    } else if (statusLower.contains('progress') ||
        statusLower.contains('ongoing')) {
      return Icons.autorenew;
    } else if (statusLower.contains('pending') ||
        statusLower.contains('waiting')) {
      return Icons.pending;
    } else if (statusLower.contains('reject') ||
        statusLower.contains('cancel')) {
      return Icons.cancel;
    } else {
      return Icons.info;
    }
  }

  String _formatDateTime(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd • hh:mm a').format(date);
    } catch (e) {
      try {
        final date = DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateString);
        return DateFormat('MMM dd • hh:mm a').format(date);
      } catch (e) {
        return dateString;
      }
    }
  }
}
