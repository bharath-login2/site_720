import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/travel_expense_cubit.dart';
import '../cubit/travel_expense_state.dart';
import '../widgets/expense_header.dart';
import 'package:site_720/features/travel_expense/views/travel_expence_view_screen.dart';
import '../../../data/models/travel_expense/travel_expense_model.dart';
import 'package:site_720/features/travel_expense/views/add_travel_expense_screen.dart';

class TravelExpenseDashboardScreen extends StatefulWidget {
  const TravelExpenseDashboardScreen({super.key});

  @override
  State<TravelExpenseDashboardScreen> createState() =>
      _TravelExpenseDashboardScreenState();
}

class _TravelExpenseDashboardScreenState
    extends State<TravelExpenseDashboardScreen> {
  String selectedFilter = "All";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TravelExpenseCubit(),
      child: BlocBuilder<TravelExpenseCubit, TravelExpenseState>(
        builder: (context, state) {
          final cubit = context.read<TravelExpenseCubit>();

          if (state is TravelExpenseLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (state is TravelExpenseFailure) {
            return Scaffold(
              backgroundColor: const Color(0xffF4F6FA),
              body: SafeArea(
                child: Column(
                  children: [
                    const ExpenseHeader(),
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inbox_outlined,
                              size: 80,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 15),
                            Text(
                              "No Records Found",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (cubit.travelExpenseModel == null) {
            return const Scaffold(
              body: Center(
                child: Text("No Data"),
              ),
            );
          }

          final data = cubit.travelExpenseModel!.data;

          List<TravelExpenseItem> expenseList = data.travelExpenseList;

          List<TravelExpenseItem> filteredList = selectedFilter == "All"
              ? expenseList
              : expenseList
                  .where(
                    (e) => e.status == selectedFilter,
                  )
                  .toList();
          if (filteredList.isEmpty) {
            return Scaffold(
              backgroundColor: const Color(0xffF4F6FA),
              body: SafeArea(
                child: Column(
                  children: [
                    const ExpenseHeader(),
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.assignment_outlined,
                              size: 90,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              "No Travel Expenses Found",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Scaffold(
            backgroundColor: const Color(0xffF4F6FA),
            body: SafeArea(
              child: Column(
                children: [
                  const ExpenseHeader(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// TOP CARDS
                          SizedBox(
                            height: 135,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                buildTopCard(
                                  title: "All",
                                  count: data.totalRequest.toString(),
                                  icon: Icons.apps,
                                  color: Colors.blue,
                                ),
                                buildTopCard(
                                  title: "Pending",
                                  count: data.pendingRequest.toString(),
                                  icon: Icons.pending_actions,
                                  color: Colors.orange,
                                ),
                                buildTopCard(
                                  title: "Approved",
                                  count: data.approvedRequest.toString(),
                                  icon: Icons.check_circle,
                                  color: Colors.green,
                                ),
                                buildTopCard(
                                  title: "Rejected",
                                  count: data.rejectedRequest.toString(),
                                  icon: Icons.cancel,
                                  color: Colors.red,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          /// TITLE ROW
                          Row(
                            children: [
                              Text(
                                selectedFilter == "All"
                                    ? "All Requests"
                                    : "$selectedFilter Requests",
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(
                                    247,
                                    100,
                                    38,
                                    53,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(
                                    30,
                                  ),
                                ),
                                child: Text(
                                  "${filteredList.length} Items",
                                  style: const TextStyle(
                                    color: Color.fromARGB(
                                      247,
                                      100,
                                      38,
                                      53,
                                    ),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          /// LIST
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredList.length,
                            itemBuilder: (context, index) {
                              final item = filteredList[index];

                              return InkWell(
                                borderRadius: BorderRadius.circular(
                                  24,
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => TravelExpenseViewScreen(
                                        item: {
                                          "travel_id": item.travelId,
                                          "name": item.name,
                                          "date": item.date,

                                          /// VEHICLE
                                          "vehicle": item.vehicleType,
                                          "vehicle_type": item.vehicleType,

                                          /// LOCATION
                                          "from": item.from,
                                          "to": item.to,

                                          /// KM + AMOUNT
                                          "km": item.km,
                                          "amount": item.totalAmount,
                                          "total_amount": item.totalAmount,

                                          "other_amount": item.otherAmount,
                                          "other_amount_cause":
                                              item.otherAmountCause,

                                          /// STATUS
                                          "status": item.status,

                                          /// REMARK
                                          "remark": item.remark,

                                          /// IMPORTANT
                                          /// SEND FULL TRAVEL DETAILS FOR IMAGE VIEW
                                          "travel_details": item.travelDetails
                                              .map(
                                                (e) => {
                                                  "to": e.to,
                                                  "km": e.km,
                                                  "image": e.image,
                                                },
                                              )
                                              .toList(),
                                        },
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                    bottom: 18,
                                  ),
                                  padding: const EdgeInsets.all(
                                    18,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                      24,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(
                                          0.04,
                                        ),
                                        blurRadius: 12,
                                        offset: const Offset(
                                          0,
                                          4,
                                        ),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      /// TOP ROW
                                      Row(
                                        children: [
                                          Container(
                                            height: 54,
                                            width: 54,
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                247,
                                                100,
                                                38,
                                                53,
                                              ).withOpacity(
                                                0.1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                16,
                                              ),
                                            ),
                                            child: const Icon(
                                              Icons.person,
                                              color: Color.fromARGB(
                                                247,
                                                100,
                                                38,
                                                53,
                                              ),
                                            ),
                                          ),

                                          const SizedBox(
                                            width: 14,
                                          ),

                                          /// NAME + DATE
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item.name,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 4,
                                                ),
                                                Text(
                                                  item.date,
                                                  style: TextStyle(
                                                    color: Colors.grey.shade600,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          /// STATUS + MENU
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 14,
                                                  vertical: 7,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: item.status ==
                                                          "Approved"
                                                      ? Colors.green
                                                          .withOpacity(
                                                          0.12,
                                                        )
                                                      : item.status == "Pending"
                                                          ? Colors.orange
                                                              .withOpacity(
                                                              0.12,
                                                            )
                                                          : Colors.red
                                                              .withOpacity(
                                                              0.12,
                                                            ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    30,
                                                  ),
                                                ),
                                                child: Text(
                                                  item.status,
                                                  style: TextStyle(
                                                    color: item.status ==
                                                            "Approved"
                                                        ? Colors.green
                                                        : item.status ==
                                                                "Pending"
                                                            ? Colors.orange
                                                            : Colors.red,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              if (item.status !=
                                                  "Approved") ...[
                                                const SizedBox(width: 6),
                                                PopupMenuButton<String>(
                                                  icon: const Icon(
                                                    Icons.more_vert,
                                                    color: Colors.black87,
                                                  ),
                                                  onSelected: (value) {
                                                    if (value == "edit") {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (_) =>
                                                              BlocProvider
                                                                  .value(
                                                            value: context.read<
                                                                TravelExpenseCubit>(),
                                                            child:
                                                                AddTravelExpenseScreen(
                                                              item: item,
                                                              isEdit: true,
                                                            ),
                                                          ),
                                                        ),
                                                      ).then((value) {
                                                        if (value == true) {
                                                          context
                                                              .read<
                                                                  TravelExpenseCubit>()
                                                              .getTravelExpenseList();
                                                        }
                                                      });
                                                    } else if (value ==
                                                        "delete") {
                                                      final cubit = BlocProvider
                                                          .of<TravelExpenseCubit>(
                                                              context);

                                                      showDialog(
                                                        context: context,
                                                        builder:
                                                            (dialogContext) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                                "Delete"),
                                                            content: const Text(
                                                              "Are you sure you want to delete this travel expense?",
                                                            ),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      dialogContext);
                                                                },
                                                                child: const Text(
                                                                    "Cancel"),
                                                              ),
                                                              TextButton(
                                                                onPressed:
                                                                    () async {
                                                                  Navigator.pop(
                                                                      dialogContext);

                                                                  await cubit
                                                                      .deleteTravelExpense(
                                                                    context,
                                                                    item.travelId,
                                                                  );
                                                                },
                                                                child:
                                                                    const Text(
                                                                  "Delete",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red),
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    }
                                                  },
                                                  itemBuilder: (context) =>
                                                      const [
                                                    PopupMenuItem(
                                                      value: "edit",
                                                      child: Row(
                                                        children: [
                                                          Icon(Icons.edit,
                                                              size: 20),
                                                          SizedBox(width: 10),
                                                          Text("Edit"),
                                                        ],
                                                      ),
                                                    ),
                                                    PopupMenuItem(
                                                      value: "delete",
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.delete,
                                                            size: 20,
                                                            color: Colors.red,
                                                          ),
                                                          SizedBox(width: 10),
                                                          Text(
                                                            "Delete",
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ],
                                          ),
                                        ],
                                      ),

                                      const SizedBox(
                                        height: 20,
                                      ),

                                      /// DETAILS
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              children: [
                                                buildRow(
                                                  Icons.directions_car,
                                                  "Vehicle",
                                                  item.vehicleType,
                                                ),
                                                buildRow(
                                                  Icons.location_on_outlined,
                                                  "From",
                                                  item.from,
                                                ),
                                                const SizedBox(height: 15),
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        "Payment Status : ",
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors
                                                              .grey.shade700,
                                                        ),
                                                      ),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 10,
                                                          vertical: 6,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: item.paymentstatus ==
                                                                  "Paid"
                                                              ? Colors.green
                                                                  .withOpacity(
                                                                      0.10)
                                                              : item.paymentstatus ==
                                                                      "Partially Paid"
                                                                  ? Colors
                                                                      .orange
                                                                      .withOpacity(
                                                                          0.10)
                                                                  : Colors.red
                                                                      .withOpacity(
                                                                          0.10),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          border: Border.all(
                                                            color: item.paymentstatus ==
                                                                    "Paid"
                                                                ? Colors.green
                                                                : item.paymentstatus ==
                                                                        "Partially Paid"
                                                                    ? Colors
                                                                        .orange
                                                                    : Colors
                                                                        .red,
                                                          ),
                                                        ),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Icon(
                                                              item.paymentstatus ==
                                                                      "Paid"
                                                                  ? Icons
                                                                      .check_circle
                                                                  : item.paymentstatus ==
                                                                          "Partially Paid"
                                                                      ? Icons
                                                                          .pending
                                                                      : Icons
                                                                          .error_outline,
                                                              size: 14,
                                                              color: item.paymentstatus ==
                                                                      "Paid"
                                                                  ? Colors.green
                                                                  : item.paymentstatus ==
                                                                          "Partially Paid"
                                                                      ? Colors
                                                                          .orange
                                                                      : Colors
                                                                          .red,
                                                            ),
                                                            const SizedBox(
                                                                width: 4),
                                                            Text(
                                                              item.paymentstatus ??
                                                                  "Pending",
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: item.paymentstatus ==
                                                                        "Paid"
                                                                    ? Colors
                                                                        .green
                                                                    : item.paymentstatus ==
                                                                            "Partially Paid"
                                                                        ? Colors
                                                                            .orange
                                                                        : Colors
                                                                            .red,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 14,
                                          ),
                                          Expanded(
                                            child: Column(
                                              children: [
                                                buildRow(
                                                  Icons.location_city,
                                                  "To",
                                                  item.to,
                                                ),
                                                buildRow(
                                                  Icons.currency_rupee,
                                                  "Amount",
                                                  item.totalAmount,
                                                ),
                                              ],
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildTopCard({
    required String title,
    required String count,
    required IconData icon,
    required Color color,
  }) {
    bool isSelected =
        selectedFilter == title || (title == "All" && selectedFilter == "All");

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = title;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 120,
        margin: const EdgeInsets.only(right: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(
                0.04,
              ),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(
                        0.2,
                      )
                    : color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : color,
                size: 22,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  count,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white70 : Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: const Color.fromARGB(
              247,
              100,
              38,
              53,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            "$title : ",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
