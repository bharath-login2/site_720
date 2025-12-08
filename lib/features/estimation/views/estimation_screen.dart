// ignore_for_file: must_be_immutable, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/widgets/appbar.dart';
import 'package:site_720/features/estimation/cubit/estimation_state.dart';
import '../cubit/estimation_cubit.dart';
import '../widgets/estimation_container.dart';

class Estimation extends StatelessWidget {
  Estimation({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    String projectId = args["id"]!;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: simpleAppbar(context, "Estimate", true),
      body: BlocProvider(
        create: (context) => EstimationCubit(projectId),
        child: BlocBuilder<EstimationCubit, EstimationState>(
          builder: (context, state) {
            if (state is EstimationLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is EstimationFailure) {
              return Center(child: Text(state.message));
            } else if (state is EstimationSuccess) {
              final list = state.response.data;
              if (list.isEmpty) {
                return const Center(child: Text("No Estimates found"));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final item = list[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Stage: ${item.stageName}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.coffie,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Staff: ${item.staffName}",
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.calendar_month,
                                  size: 16, color: AppColors.coffie),
                              const SizedBox(width: 5),
                              Text(
                                "Created At: ${item.createdAt}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.coffie,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (item.remarks.isNotEmpty)
                                  Expanded(
                                    child: Text(
                                      "Remark: ${item.remarks}",
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.coffie,
                                      ),
                                    ),
                                  ),
                                const SizedBox(width: 8),
                                EstimationContainer(
                                  title: "Total Amount",
                                  value: item.totalAmount,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
