import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/widgets/appbar.dart';
import '../../../core/widgets/connectivity_dialog.dart';
import '../../../core/widgets/shimmer.dart';
import '../../connectivity/cubit/connectivity_cubit.dart';
import '../../connectivity/cubit/connectivity_state.dart';
import '../cubit/sub_contractor_cubit.dart';
import '../cubit/sub_contractor_state.dart';
import 'package:site_720/core/constants/routes.dart';

class Contractor extends StatelessWidget {
  Contractor({super.key});
  TextEditingController searchController = TextEditingController();
  TextEditingController fdate = TextEditingController(
      text: DateFormat('dd-MM-yyyy').format(DateTime.now()));
  TextEditingController tdate = TextEditingController(
      text: DateFormat('dd-MM-yyyy').format(DateTime.now()));
  String id = "";
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String id = args["id"];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 235, 235),
      appBar: simpleAppbar(context, "Sub Contractors", true),
      body: BlocProvider(
        create: (context) => SubContractorCubit(id),
        child: BlocListener<ConnectivityCubit, ConnectivityState>(
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
          child: BlocBuilder<SubContractorCubit, SubContractorState>(
            builder: (context, state) {
              final cubit = context.read<SubContractorCubit>();

              if (state is SubContractorLoading) {
                return ListView.builder(
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: shimmerContainer(100, 70),
                    );
                  },
                );
              } else if (state is SubContractorSuccess) {
                return RefreshIndicator(
                  onRefresh: () async {
                    cubit.getContractorList();
                  },
                  child: ListView.builder(
                    itemCount: state.response.data.length,
                    itemBuilder: (context, index) {
                      final contractor = state.response.data[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.subContractorDetails,
                              arguments: {
                                "contractor_id": contractor.contractorId,
                                "work_id": contractor.id,
                              },
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.15),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /// Contractor Name
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundColor: AppColors
                                              .primaryColor
                                              .withOpacity(.1),
                                          child: const Icon(
                                            Icons.person,
                                            color: AppColors.primaryColor,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            contractor.name,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.coffie,
                                            ),
                                          ),
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios,
                                          size: 16,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 12),

                                    _infoRow(
                                      Icons.work_outline,
                                      "Work",
                                      contractor.subContractWorkName,
                                    ),

                                    if (contractor.stageDisplayName.isNotEmpty)
                                      _infoRow(
                                        Icons.straight,
                                        "Stage",
                                        contractor.stageDisplayName,
                                      ),

                                    _infoRow(
                                      Icons.assignment,
                                      "Contract",
                                      contractor.contractTypes,
                                    ),

                                    const Divider(height: 20),

                                    Row(
                                      children: [
                                        Expanded(
                                          child: _amountBox(
                                            "Estimated",
                                            contractor.totalEstimatedAmount,
                                            Colors.blue,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        // Expanded(
                                        //   child: _amountBox(
                                        //     "Payable",
                                        //     contractor.totalPayableAmount,
                                        //     Colors.orange,
                                        //   ),
                                        // ),

                                        _amountBox(
                                          "Balance Payable",
                                          contractor.balancePayableAmount,
                                          Colors.red,
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 8),
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
                  child: Text("No Contractors Added"),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

Widget _infoRow(
  IconData icon,
  String title,
  String value,
) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: AppColors.primaryColor,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 13,
              ),
              children: [
                TextSpan(
                  text: "$title : ",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _amountBox(
  String title,
  String amount,
  Color color,
) {
  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 10,
    ),
    decoration: BoxDecoration(
      color: color.withOpacity(.08),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: color.withOpacity(.3),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "₹ $amount",
          style: TextStyle(
            fontSize: 14,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
