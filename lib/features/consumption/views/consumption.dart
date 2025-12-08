// ignore_for_file: must_be_immutable, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/widgets/appbar.dart';
import 'package:site_720/core/widgets/shimmer.dart';
import 'package:site_720/features/consumption/cubit/consumption_state.dart';
import '../../../core/widgets/connectivity_dialog.dart';
import '../../connectivity/cubit/connectivity_cubit.dart';
import '../../connectivity/cubit/connectivity_state.dart';
import '../../payment_details/widgets/amount_container.dart';
import '../cubit/consumption_cubit.dart';

class Consumption extends StatelessWidget {
  Consumption({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    String projectId = args["id"]!;
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: simpleAppbar(context, "Consumption", true),
        body: BlocProvider(
          create: (context) => ConsumptionCubit(projectId),
          child: MultiBlocListener(
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
            child: BlocBuilder<ConsumptionCubit, ConsumptionState>(
              builder: (context, state) {
                return state is ConsumptionSuccess
                    ? ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        itemCount: state.response.data.length,
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
                                        Row(
                                          children: [
                                            Text(
                                              "Material: ${state.response.data[index]
                                                  .materialName}",
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 110,
                                            ),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.calendar_month,
                                                  size: 16,
                                                  color: AppColors
                                                      .coffie, // or any color you prefer
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  "${state.response.data[index].dateConsumed}",
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.coffie,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Location: ${state.response.data[index].locationName}",
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Unit: ${state.response.data[index].unit}",
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
                                                amount: "₹ ${state.response
                                                    .data[index].unitPrice}",
                                                valueColor:
                                                    AppColors.primaryColor),
                                            AmountContainer(
                                                title: "In Stock",
                                                amount:
                                                    " ${state.response.data[index].inStock}",
                                                valueColor:
                                                    AppColors.primaryColor),
                                            AmountContainer(
                                                title: "Total Quantity",
                                                amount:
                                                    " ${state.response.data[index].quantity}",
                                                valueColor:
                                                    AppColors.primaryColor),
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
                      )
                    : state is ConsumptionLoading
                        ? ListView.builder(
                            itemCount: 7,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: shimmerContainer(100, 70),
                              );
                            },
                          )
                        : const Center(
                            child: Text(""),
                          );
              },
            ),
          ),
        ));
  }
}
