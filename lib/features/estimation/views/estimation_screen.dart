// ignore_for_file: must_be_immutable, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/widgets/appbar.dart';
import 'package:site_720/features/estimation/cubit/estimation_state.dart';
import '../cubit/estimation_cubit.dart';

class Estimation extends StatelessWidget {
  Estimation({super.key});
  // final stages = state.response.data.purchaseVsEstimate;
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
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final stage = list[index];

                  return Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    child: ListTile(
                      title: Text(
                        stage.stageName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.coffie,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "Item Count : ${stage.count}",
                            style: const TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (_) {
                            return Container(
                              padding: const EdgeInsets.all(16),
                              height: MediaQuery.of(context).size.height * 0.75,
                              child: Column(
                                children: [
                                  Text(
                                    stage.stageName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: stage.materials.length,
                                      itemBuilder: (context, materialIndex) {
                                        final item =
                                            stage.materials[materialIndex];

                                        return Card(
                                          elevation: 2,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 6),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item.materialName,
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.coffie,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                    "Unit Price : ₹${item.unitPrice}"),
                                                Text(
                                                    "Estimation Qty : ${item.estimationQty}"),
                                                Text(
                                                    "Estimation Price : ₹${item.estimationUnitPrice}"),
                                                Text(
                                                    "Purchase Qty : ${item.purchaseQty}"),
                                                Text(
                                                    "Purchase Price : ₹${item.purchaseUnitPrice}"),
                                                const SizedBox(height: 8),
                                                Text(
                                                    "Variation Qty : ${item.variation}"),
                                                Text(
                                                  "Variation Amount : ₹${item.variationPrice}",
                                                  style: const TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
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
