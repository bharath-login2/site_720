// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/constants/routes.dart';
import 'package:site_720/features/payment_details/widgets/amount_container.dart';
import '../../../core/widgets/shimmer.dart';
import '../cubit/purchase_cubit.dart';
import '../cubit/purchase_state.dart';

class PurchaseList extends StatelessWidget {
  const PurchaseList({super.key});

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
          body: BlocBuilder<PurchaseCubit, PurchaseState>(
            builder: (context, state) {
              return state is PurchaseSuccess
                  ? ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      itemCount: state.response.data.length,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: InkWell(
                              onTap: () {
                                // Navigator.of(context).pushNamed(AppRoutes.stageHistory);
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  state.response.data[index]
                                                      .materialName,
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: AppColors.coffie),
                                                ),
                                                //  Text(
                                                //    "Bill Date: ${state.response.data[index].billDate}",
                                                //   style: const TextStyle(
                                                //     fontSize: 12,
                                                //     fontWeight: FontWeight.bold,
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                            Text(
                                              DateFormat('yyyy-MM-dd').format(
                                                  state.response.data[index]
                                                      .billDate),
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                AmountContainer(
                                                    title: "Quantity",
                                                    amount: state.response
                                                        .data[index].quantity),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                AmountContainer(
                                                    title: "Amount",
                                                    amount:
                                                        "₹ ${state.response.data[index].grandTotal}"),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  height: 25,
                                                  width: 25,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: AppColors.lightBlue,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.8),
                                                        blurRadius: 6,
                                                        offset:
                                                            const Offset(1, 1),
                                                      ),
                                                    ],
                                                  ),
                                                  child: const Icon(
                                                    Icons.edit,
                                                    size: 18,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 7,
                                                ),
                                                Container(
                                                  height: 25,
                                                  width: 25,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: Colors.red,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.8),
                                                        blurRadius: 6,
                                                        offset:
                                                            const Offset(1, 1),
                                                      ),
                                                    ],
                                                  ),
                                                  child: const Icon(
                                                    Icons.delete,
                                                    size: 18,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
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
          )),
    );
  }
}
