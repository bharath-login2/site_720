import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../payment_schedule/cubit/payment_schedule_cubit.dart';
import '../../payment_schedule/cubit/payment_schedule_state.dart';
import 'package:site_720/core/constants/colors.dart';

class PaymentScheduleScreen extends StatefulWidget {
  final String projectId;

  const PaymentScheduleScreen({
    super.key,
    required this.projectId,
  });

  @override
  State<PaymentScheduleScreen> createState() => _PaymentScheduleScreenState();
}

class _PaymentScheduleScreenState extends State<PaymentScheduleScreen> {
  @override
  void initState() {
    super.initState();

    context.read<PaymentScheduleCubit>().getPaymentSchedule(widget.projectId);
  }

  int? expandedIndex;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      "Payment Schedule",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          fontFamily: "Lobster",
                          color: Colors.white),
                    ),
                  ],
                ),
                // Removed the add button from app bar
              ],
            ),
          ),
        ),
      ),
      body: BlocBuilder<PaymentScheduleCubit, PaymentScheduleState>(
        builder: (context, state) {
          if (state is PaymentScheduleLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is PaymentScheduleError) {
            return Center(
              child: Text(state.message),
            );
          }

          if (state is PaymentScheduleLoaded) {
            if (state.schedules.isEmpty) {
              return const Center(
                child: Text("No Payment Schedule Found"),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: state.schedules.length,
              itemBuilder: (context, index) {
                final item = state.schedules[index];

                return InkWell(
                  borderRadius: BorderRadius.circular(25),
                  onTap: () {
                    setState(() {
                      expandedIndex = expandedIndex == index ? null : index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(
                      bottom: 16,
                      left: 4,
                      right: 4,
                    ),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        /// HEADER
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 52,
                              width: 52,
                              decoration: BoxDecoration(
                                color: const Color(0xffF8EEF2),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: const Icon(
                                Icons.calendar_month_outlined,
                                color: Color(0xffC56B8D),
                                size: 26,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.phaseNo,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.description,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Percentage : ${item.percentage}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 7,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getStatusBg(item.status),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    item.status,
                                    style: TextStyle(
                                      color: _getStatusText(item.status),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Icon(
                                  expandedIndex == index
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Divider(
                          color: Colors.grey.shade300,
                        ),

                        const SizedBox(height: 10),

                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _amountBox(
                                    title: "Estimated",
                                    amount: item.estCost,
                                    icon: Icons.description_outlined,
                                    bgColor: const Color(0xffEEF2FF),
                                    iconColor: Colors.blue,
                                    textColor: Colors.blue,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _amountBox(
                                    title: "Total",
                                    amount: item.totalAmount,
                                    icon: Icons.payments_outlined,
                                    bgColor: const Color(0xffF3E8FF),
                                    iconColor: Colors.deepPurple,
                                    textColor: Colors.deepPurple,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: _amountBox(
                                    title: "Paid",
                                    amount: item.paidAmount,
                                    icon: Icons.check_circle_outline,
                                    bgColor: const Color(0xffEDF9F1),
                                    iconColor: Colors.green,
                                    textColor: Colors.green,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _amountBox(
                                    title: "Balance",
                                    amount: item.balanceAmount,
                                    icon: Icons.account_balance_wallet_outlined,
                                    bgColor: const Color(0xffFFF0F0),
                                    iconColor: Colors.red,
                                    textColor: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        /// EXPANDABLE SECTION
                        if (expandedIndex == index) ...[
                          const SizedBox(height: 14),
                          Divider(
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _amountBox(
                                  title: "Extra Work",
                                  amount: item.extraWorkAmount,
                                  icon: Icons.add_circle_outline,
                                  bgColor: const Color(0xffFFF7E6),
                                  iconColor: Colors.orange,
                                  textColor: Colors.orange,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _amountBox(
                                  title: "Deduction",
                                  amount: item.deductionAmount,
                                  icon: Icons.remove_circle_outline,
                                  bgColor: const Color(0xffFFECEC),
                                  iconColor: Colors.red,
                                  textColor: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
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
    );
  }

  Widget _amountBox({
    required String title,
    required String amount,
    required IconData icon,
    required Color bgColor,
    required Color iconColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: iconColor),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "₹ $amount",
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusBg(String status) {
    switch (status.toLowerCase()) {
      case "close":
        return const Color(0xffEAF8EF);

      case "partially paid":
        return const Color(0xffFFF4E2);

      case "pending":
        return const Color(0xffFFE8E8);

      default:
        return Colors.grey.shade200;
    }
  }

  Color _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case "close":
        return Colors.green;

      case "partially paid":
        return Colors.orange;

      case "pending":
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  Widget _buildInfoRow(
    String title,
    String value,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'close':
        return Colors.green;

      case 'partially paid':
        return Colors.orange;

      case 'pending':
        return Colors.red;

      default:
        return Colors.blueGrey;
    }
  }
}
