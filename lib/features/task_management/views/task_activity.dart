import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/data/models/task/taskActivityModel.dart';
import 'package:site_720/data/services/http_services.dart';
import 'package:timelines_plus/timelines_plus.dart';

class TaskActivityPage extends StatefulWidget {
  const TaskActivityPage({super.key});

  @override
  State<TaskActivityPage> createState() => _TaskActivityPageState();
}

class _TaskActivityPageState extends State<TaskActivityPage> {
  bool isLoading = true;
  List<TaskActivity> activities = [];

  @override
  void initState() {
    super.initState();
    _fetchActivities();
  }

  Future<void> _fetchActivities() async {
    setState(() => isLoading = true);
    try {
      final response = await HttpServices.getTaskActivity();
      if (response.status == true) {
        setState(() {
          activities = response.data;
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message)),
          );
        }
      }
    } catch (e) {
      debugPrint("Error fetching activities: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Task Activity",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: isLoading
          ? _buildLoadingState()
          : activities.isEmpty
              ? _buildEmptyState()
              : _buildTimeline(),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primaryColor),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_outlined, size: 80, color: Colors.grey.withOpacity(0.5)),
          const SizedBox(height: 16),
          const Text(
            "No activity found",
            style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: FixedTimeline.tileBuilder(
        theme: TimelineThemeData(
          nodePosition: 0,
          color: AppColors.primaryColor.withOpacity(0.5),
          indicatorTheme: const IndicatorThemeData(size: 20),
          connectorTheme: const ConnectorThemeData(thickness: 2),
        ),
        builder: TimelineTileBuilder.connected(
          connectionDirection: ConnectionDirection.before,
          itemCount: activities.length,
          contentsBuilder: (context, index) {
            final activity = activities[index];
            return Padding(
              padding: const EdgeInsets.only(left: 15, bottom: 25),
              child: _buildActivityCard(activity),
            );
          },
          indicatorBuilder: (context, index) {
             final activityTitle = activities[index].activity.toLowerCase();
            final doneBy = activities[index].doneBy.toLowerCase();
            IconData icon = Icons.notifications_none_rounded;
            Color color = AppColors.primaryColor;

            if (activityTitle.contains('completed') || activityTitle.contains('done')) {
              icon = Icons.check_circle_rounded;
              color = Colors.green;
            } else if (activityTitle.contains('task')) {
              icon = Icons.assignment_rounded;
            } else if (activityTitle.contains('assigned')) {
              icon = Icons.person_add_alt_1_rounded;
            } else if (activityTitle.contains('attendance')) {
              icon = Icons.camera_alt_rounded;
            } else if (doneBy.isNotEmpty) {
              icon = Icons.person_rounded;
            }

            return DotIndicator(
              color: color,
              size: 28,
              child: Icon(icon, size: 16, color: Colors.white),
            );
          },
          connectorBuilder: (context, index, type) {
            return SolidLineConnector(
              color: AppColors.primaryColor.withOpacity(0.2),
              thickness: 3,
            );
          },
        ),
      ),
    );
  }

  Widget _buildActivityCard(TaskActivity activity) {
    DateTime? parsedDate = DateTime.tryParse(activity.dateTime);
    
    if (parsedDate == null && activity.dateTime.contains('-')) {
      // Try parsing dd-MM-yyyy format
      final parts = activity.dateTime.split(' ')[0].split('-');
      if (parts.length == 3) {
        try {
          if (parts[0].length == 4) {
            // yyyy-MM-dd
            parsedDate = DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
          } else {
            // dd-MM-yyyy
            parsedDate = DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
          }
        } catch (_) {}
      }
    }
    
    final displayDate = parsedDate ?? DateTime.now();
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.secondaryColor,
                    AppColors.secondaryColor.withOpacity(0.3),
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded, size: 12, color: AppColors.lightPrimary),
                        const SizedBox(width: 6),
                        Text(
                          _formatDate(displayDate),
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.lightPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.watch_later_outlined, size: 12, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text(
                        _formatTime(displayDate),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.doneBy,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2D3142),
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    activity.activity,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      height: 1.6,
                      letterSpacing: 0.1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  String _formatTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }
}
