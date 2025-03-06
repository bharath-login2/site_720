// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/widgets/appbar.dart';
import 'package:site_720/core/widgets/shimmer.dart';
import 'package:site_720/features/task_management/cubit/task_history_cubit.dart';
import 'package:site_720/features/task_management/cubit/task_state.dart';
import 'package:timelines_plus/timelines_plus.dart';

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
                return shimmerWidget(context);
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: ListView.builder(
                    itemCount: cubit.taskList.length,
                    itemBuilder: (context, index) {
                      return TimelineTile(
                        nodeAlign: TimelineNodeAlign.start,
                        node: TimelineNode(
                          indicator: const DotIndicator(
                            color: AppColors.primaryColor,
                          ),
                          startConnector: index == 0
                              ? null
                              : const SolidLineConnector(
                                  color: AppColors.primaryColor),
                          endConnector: index == cubit.taskList.length - 1
                              ? null
                              : const SolidLineConnector(
                                  color: AppColors.primaryColor),
                        ),
                        contents: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cubit.taskList[index].reStatus,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryColor),
                                  ),
                                  Text(
                                    cubit.taskList[index].comment,
                                    style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.lightPrimary),
                                  ),
                                  Text(
                                    cubit.taskList[index].updatedDate,
                                    style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.lightPrimary),
                                  ),
                                  if (cubit.taskList[index].attachment != "")
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  if (cubit.taskList[index].attachment != "")
                                    Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        child: Image.network(
                                            cubit.taskList[index].attachment))
                                ],
                              ),
                            ),
                          ),
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
}
