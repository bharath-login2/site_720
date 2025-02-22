// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/widgets/appbar.dart';
import '../../../core/widgets/shimmer.dart';
import '../../../data/models/stock/stock_list.dart';
import '../../payment_details/widgets/amount_container.dart';
import '../cubit/stock_cubit.dart';
import '../cubit/stock_state.dart';

class Stock extends StatelessWidget {
  Stock({super.key});
  String projectId = "";
  List<Stocks> stockList = [];

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    String projectId = args["id"]!;
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: simpleAppbar(context, "Stock", true),
        body: BlocProvider(
          create: (context) => StockCubit(projectId),
          child: MultiBlocListener(
            listeners: [
              BlocListener<StockCubit, StockState>(
                listener: (context, state) {
                  if (state is StockSuccess) {
                    stockList = state.response.data;
                  }
                },
              )
            ],
            child: BlocBuilder<StockCubit, StockState>(
              builder: (context, state) {
                final cubit = context.read<StockCubit>();
                if (state is StockLoading) {
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
                } else if (stockList.isNotEmpty) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      cubit.getStockList(projectId);
                    },
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      itemCount: stockList.length,
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
                                        stockList[index].materialName,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        stockList[index].supplierName,
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
                                            amount: stockList[index].unitPrice,
                                          ),
                                          AmountContainer(
                                            title: "In Stock",
                                            amount: stockList[index].quantity,
                                          ),
                                          AmountContainer(
                                            title: "Total Amount",
                                            amount:
                                                stockList[index].totalAmount,
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
                    child: Text("Stock is Empty"),
                  );
                }
              },
            ),
          ),
        ));
  }
}
