// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/constants/routes.dart';
import 'package:site_720/features/payment_details/widgets/amount_container.dart';
import '../../../core/widgets/connectivity_dialog.dart';
import '../../../core/widgets/shimmer.dart';
import '../../connectivity/cubit/connectivity_cubit.dart';
import '../../connectivity/cubit/connectivity_state.dart';
import '../cubit/purchase_cubit.dart';
import '../cubit/purchase_state.dart';
import '../../../data/models/purchasebilllist/purchasebill_list_model.dart';

class PurchaseList extends StatelessWidget {
  const PurchaseList({super.key});
  void showMaterialPopup(
    BuildContext context,
    PurchaseBill bill,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(bill.supplierName),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Bill Date : ${DateFormat('dd-MM-yyyy').format(bill.billDate)}",
                ),
                const SizedBox(height: 15),
                ListView.builder(
                  shrinkWrap: true,
                  // physics: const NeverScrollableScrollPhysics(),
                  itemCount: bill.materials.length,
                  itemBuilder: (context, index) {
                    final material = bill.materials[index];

                    return Card(
                      child: ListTile(
                        title: Text(material.materialName),
                        subtitle: Text(
                          "Qty : ${material.quantity}",
                        ),
                        trailing: Text(
                          "₹${material.amount}",
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                Text(
                  "Total Qty : ${bill.totalQuantity}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Total Amount : ₹${bill.totalAmount}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    return BlocProvider(
      create: (context) => PurchaseCubit(args["id"]!),
      child: Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.2),
            child: Container(
              height: MediaQuery.of(context).size.height * .15,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/appbar.png"),
                      fit: BoxFit.fill),
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  )),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 35, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          "Purchase",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              fontFamily: "Lobster",
                              color: Colors.white),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: false,
                      child: InkWell(
                        onTap: () {
                          connStatus = true;
                          Navigator.pushNamed(context, AppRoutes.addPurchase);
                        },
                        child: const CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.lightPrimary,
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
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
            child: BlocBuilder<PurchaseCubit, PurchaseState>(
              builder: (context, state) {
                return state is PurchaseSuccess
                    ? ListView.builder(
                        shrinkWrap: true,
                        // physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        itemCount: state.response.data.length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: InkWell(
                                onTap: () {
                                  showMaterialPopup(
                                    context,
                                    state.response.data[index],
                                  );
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width * .9,
                                  height:
                                      MediaQuery.of(context).size.height * .14,
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
                                    width:
                                        MediaQuery.of(context).size.width * .7,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0,
                                          left: 8.0,
                                          right: 8.0,
                                          bottom: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: Colors.grey.shade200,
                                              ),
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          const Icon(
                                                            Icons
                                                                .person_outline,
                                                            size: 16,
                                                            color: AppColors
                                                                .primaryColor,
                                                          ),
                                                          const SizedBox(
                                                              width: 6),
                                                          Expanded(
                                                            child: Text(
                                                              state
                                                                  .response
                                                                  .data[index]
                                                                  .supplierName,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: AppColors
                                                                    .coffie,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Row(
                                                        children: [
                                                          const Icon(
                                                            Icons.flag_outlined,
                                                            size: 16,
                                                            color:
                                                                Colors.orange,
                                                          ),
                                                          const SizedBox(
                                                              width: 6),
                                                          Text(
                                                            state
                                                                .response
                                                                .data[index]
                                                                .stages,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: Colors
                                                                  .black87,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Row(
                                                        children: [
                                                          const Icon(
                                                            Icons
                                                                .calendar_today_outlined,
                                                            size: 14,
                                                            color: Colors.grey,
                                                          ),
                                                          const SizedBox(
                                                              width: 6),
                                                          Text(
                                                            DateFormat(
                                                                    'dd-MM-yyyy')
                                                                .format(state
                                                                    .response
                                                                    .data[index]
                                                                    .billDate),
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.grey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 12,
                                                    vertical: 10,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: AppColors
                                                        .primaryColor
                                                        .withOpacity(.08),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      const Text(
                                                        "Amount",
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        "₹${state.response.data[index].totalAmount}",
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: AppColors
                                                              .primaryColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                          // Row(
                                          //   crossAxisAlignment:
                                          //       CrossAxisAlignment.end,
                                          //   mainAxisAlignment:
                                          //       MainAxisAlignment.spaceBetween,
                                          //   children: [
                                          //     Row(
                                          //       children: [
                                          //         AmountContainer(
                                          //           title: "Quantity",
                                          //           amount: state
                                          //               .response
                                          //               .data[index]
                                          //               .totalQuantity
                                          //               .toString(),
                                          //           valueColor:
                                          //               AppColors.primaryColor,
                                          //         ),
                                          //         const SizedBox(
                                          //           width: 10,
                                          //         ),
                                          //         AmountContainer(
                                          //           title: "Amount",
                                          //           amount:
                                          //               "₹ ${state.response.data[index].totalAmount}",
                                          //           valueColor:
                                          //               AppColors.primaryColor,
                                          //         ),
                                          //       ],
                                          //     ),
                                          //     // Row(
                                          //     //   children: [
                                          //     //     Container(
                                          //     //       height: 25,
                                          //     //       width: 25,
                                          //     //       decoration: BoxDecoration(
                                          //     //         borderRadius:
                                          //     //             BorderRadius.circular(
                                          //     //                 5),
                                          //     //         color:
                                          //     //             AppColors.lightBlue,
                                          //     //         boxShadow: [
                                          //     //           BoxShadow(
                                          //     //             color: Colors.grey
                                          //     //                 .withOpacity(0.8),
                                          //     //             blurRadius: 6,
                                          //     //             offset: const Offset(
                                          //     //                 1, 1),
                                          //     //           ),
                                          //     //         ],
                                          //     //       ),
                                          //     //       child: const Icon(
                                          //     //         Icons.edit,
                                          //     //         size: 18,
                                          //     //         color: Colors.white,
                                          //     //       ),
                                          //     //     ),
                                          //     //     const SizedBox(
                                          //     //       width: 7,
                                          //     //     ),
                                          //     //     Container(
                                          //     //       height: 25,
                                          //     //       width: 25,
                                          //     //       decoration: BoxDecoration(
                                          //     //         borderRadius:
                                          //     //             BorderRadius.circular(
                                          //     //                 5),
                                          //     //         color: Colors.red,
                                          //     //         boxShadow: [
                                          //     //           BoxShadow(
                                          //     //             color: Colors.grey
                                          //     //                 .withOpacity(0.8),
                                          //     //             blurRadius: 6,
                                          //     //             offset: const Offset(
                                          //     //                 1, 1),
                                          //     //           ),
                                          //     //         ],
                                          //     //       ),
                                          //     //       child: const Icon(
                                          //     //         Icons.delete,
                                          //     //         size: 18,
                                          //     //         color: Colors.white,
                                          //     //       ),
                                          //     //     ),
                                          //     //   ],
                                          //     // ),
                                          //   ],
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ));
                        },
                      )
                    : state is PurchaseLoading
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
                            child: Text("No Bills"),
                          );
              },
            ),
          )),
    );
  }
}
