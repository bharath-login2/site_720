// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/widgets/shimmer.dart';
import 'package:site_720/features/my_account/cubit/myaccount_state.dart';
import 'package:site_720/features/payment_details/widgets/amount_container.dart';
import '../../../core/widgets/connectivity_dialog.dart';
import '../../connectivity/cubit/connectivity_cubit.dart';
import '../../connectivity/cubit/connectivity_state.dart';
import '../cubit/myaccount_cubit.dart';
import 'package:site_720/features/expense/views/add_expense_screen.dart';

class MyAccount extends StatelessWidget {
  const MyAccount({super.key});

  @override
  Widget build(BuildContext context) {
    // String projectId = "";

    return Scaffold(
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
                    const SizedBox(width: 10),
                    const Text(
                      "My Account",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          fontFamily: "Lobster",
                          color: Colors.white),
                    ),
                  ],
                ),
                // InkWell(
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (_) => const AddExpenseScreen(),
                //       ),
                //     );
                //   },
                //   borderRadius: BorderRadius.circular(14),
                //   child: Container(
                //     height: 42,
                //     width: 42,
                //     decoration: BoxDecoration(
                //       color: Colors.white.withOpacity(0.18),
                //       borderRadius: BorderRadius.circular(14),
                //       border: Border.all(
                //         color: Colors.white24,
                //         width: 1,
                //       ),
                //       boxShadow: [
                //         BoxShadow(
                //           color: Colors.black.withOpacity(0.08),
                //           blurRadius: 8,
                //           offset: const Offset(0, 3),
                //         ),
                //       ],
                //     ),
                //     child: const Center(
                //       child: Icon(
                //         Icons.add_rounded,
                //         color: Colors.white,
                //         size: 24,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => MyAccountCubit(),
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
          child: BlocBuilder<MyAccountCubit, SalaryLedgerState>(
            builder: (context, state) {
              if (state is SalaryLedgerLoading) {
                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: 6,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: shimmerContainer(120, double.infinity),
                  ),
                );
              }

              if (state is SalaryLedgerSuccess &&
                  state.response != null &&
                  state.response.data!.ledger != null &&
                  state.response.data!.ledger!.isNotEmpty) {
                print("Response Data: ${state.response.data}");
                print("Ledger: ${state.response.data?.ledger}");
                print("Ledger Count: ${state.response.data?.ledger?.length}");
                final ledgerList = state.response.data!.ledger!;
                final summary = state.response.data!.summary;

                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<MyAccountCubit>().getMyAccountList();
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Expanded(
                              child: AmountContainer(
                                title: "Total Credit",
                                amount: summary?.totalCredit ?? "0",
                                valueColor: Colors.green,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: AmountContainer(
                                title: "Total Debit",
                                amount: summary?.totalDebit ?? "0",
                                valueColor: Colors.orange,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: AmountContainer(
                                title: "Balance",
                                amount: summary?.payoutBalance ?? "0",
                                valueColor: (double.tryParse(
                                                summary?.payoutBalance ??
                                                    "0") ??
                                            0) <
                                        0
                                    ? Colors.red
                                    : AppColors.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          itemCount: ledgerList.length,
                          itemBuilder: (context, index) {
                            final ledger = ledgerList[index];

                            bool isCredit =
                                (ledger.debitOrCredit ?? "").toLowerCase() ==
                                    "credit";

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(.12),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 24,
                                          backgroundColor: isCredit
                                              ? Colors.green.withOpacity(.12)
                                              : Colors.red.withOpacity(.12),
                                          child: Icon(
                                            isCredit
                                                ? Icons.arrow_downward
                                                : Icons.arrow_upward,
                                            color: isCredit
                                                ? Colors.green
                                                : Colors.red,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                ledger.accountHead ?? "-",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                ledger.referenceType ?? "",
                                                style: TextStyle(
                                                  color: Colors.grey.shade600,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isCredit
                                                ? Colors.green.withOpacity(.1)
                                                : Colors.red.withOpacity(.1),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            isCredit ? "Credit" : "Debit",
                                            style: TextStyle(
                                              color: isCredit
                                                  ? Colors.green
                                                  : Colors.red,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade50,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Description",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            ledger.description ?? "-",
                                            style: TextStyle(
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.calendar_today,
                                              size: 14,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              ledger.transactionDate != null
                                                  ? "${ledger.transactionDate!.day.toString().padLeft(2, '0')}-${ledger.transactionDate!.month.toString().padLeft(2, '0')}-${ledger.transactionDate!.year}"
                                                  : "-",
                                              style: const TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          "₹ ${ledger.amount ?? '0'}",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: isCredit
                                                ? Colors.green
                                                : Colors.red,
                                          ),
                                        ),
                                      ],
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
              }

              return const Center(
                child: Text(
                  "No Expense Added",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
