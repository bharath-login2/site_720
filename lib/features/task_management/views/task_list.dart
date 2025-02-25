// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/widgets/appbar.dart';
import '../../../core/widgets/shimmer.dart';
import '../../payment_details/widgets/amount_container.dart';
import '../cubit/task_cubit.dart';
import '../cubit/task_state.dart';

class TaskList extends StatelessWidget {
  TaskList({super.key});
  List taskList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: simpleAppbar(context, "Task", true),
        body: BlocProvider(
          create: (context) => TaskCubit(),
          child: MultiBlocListener(
            listeners: [
              BlocListener<TaskCubit, TaskState>(
                listener: (context, state) {
                  if (state is TaskSuccess) {
                    // taskList = state.response.data;
                  }
                },
              )
            ],
            child: BlocBuilder<TaskCubit, TaskState>(
              builder: (context, state) {
                final cubit = context.read<TaskCubit>();
                if (state is TaskLoading) {
                  return ListView.builder(
                    itemCount: 7,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: shimmerContainer(100, 70),
                      );
                    },
                  );
                } else if (taskList.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      cubit.getTaskList();
                    },
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: InkWell(
                            onTap: () {
                              // Navigator.of(context)
                              //     .pushNamed(AppRoutes.stageHistory);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * .9,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.8),
                                    blurRadius: 3,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * .7,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0,
                                      left: 8.0,
                                      right: 8.0,
                                      bottom: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "taskList[index].materialName",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        "taskList[index].supplierName",
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          AmountContainer(
                                            title: "Unit Price",
                                            amount: "taskList[index].unitPrice",
                                          ),
                                          AmountContainer(
                                            title: "In Task",
                                            amount: "taskList[index].quantity",
                                          ),
                                          AmountContainer(
                                            title: "Total Amount",
                                            amount: "taskList[index].totalAmount",
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return const Center(
                    child: Text("Task is Empty"),
                  );
                }
              },
            ),
          ),
        ));
  }
}
