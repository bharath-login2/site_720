import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/colors.dart';
import '../../../core/widgets/appbar.dart';
import '../cubit/sub_contractor_details_cubit.dart';
import '../cubit/sub_contractor_details_state.dart';

class SubContractorDetailsScreen extends StatelessWidget {
  const SubContractorDetailsScreen({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final String contractorId = args["contractor_id"];
    final String workId = args["work_id"];

    return BlocProvider(
      create: (_) => SubContractorDetailsCubit(
        contractorId,
        workId,
      ),
      child: Scaffold(
        appBar: simpleAppbar(
          context,
          "Sub Contractor Details",
          true,
        ),
        body: BlocBuilder<SubContractorDetailsCubit, SubContractorDetailsState>(
          builder: (context, state) {
            if (state is SubContractorDetailsLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is SubContractorDetailsFailure) {
              return Center(
                child: Text(state.message),
              );
            }

            if (state is SubContractorDetailsSuccess) {
              final contractor = state.response.data.contractorDetails;
              final work = state.response.data.workDetails;
              final project = state.response.data.projectDetails;

              return ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  /// Contractor Details
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(.15),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionHeader("Contractor Details"),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              _detailRow(
                                "Project Name",
                                project.projectName,
                              ),
                              _detailRow(
                                "Name",
                                contractor.name,
                              ),
                              _detailRow(
                                "Phone Number",
                                contractor.phone,
                              ),
                              _detailRow(
                                "Address",
                                contractor.address,
                              ),
                              _detailRow(
                                "Contact Person",
                                contractor.contactPerson,
                              ),
                              _detailRow(
                                "GST No",
                                contractor.gstNo,
                              ),
                              _detailRow(
                                "PAN No",
                                contractor.panNo,
                              ),
                              _detailRow(
                                "Aadhaar No",
                                contractor.aadharNo,
                              ),
                              _detailRow(
                                "Bank Account",
                                contractor.bankAccount,
                              ),
                              _detailRow(
                                "IFSC Code",
                                contractor.ifscCode,
                              ),
                              _detailRow(
                                "Bank Name",
                                contractor.bankName,
                              ),
                              _detailRow(
                                "Branch Name",
                                contractor.branchName,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  /// Contract Details
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(.15),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _sectionHeader("Contract Details"),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              _detailRow(
                                "Work Name",
                                work.subcontractWorkName,
                              ),
                              _detailRow(
                                "Contract Type",
                                work.contractType,
                              ),
                              _detailRow(
                                "Estimated Amount",
                                "₹ ${work.totalEstimatedAmount}",
                              ),
                              _detailRow(
                                "Payable Amount",
                                "₹ ${work.totalPayableAmount}",
                              ),
                              _detailRow(
                                "Balance Amount",
                                "₹ ${work.balancePayableAmount}",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(.15),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _sectionHeader("Work Details"),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              _detailRow(
                                "Work Name",
                                work.subcontractWorkName,
                              ),
                              _detailRow(
                                "Contract Type",
                                work.contractType,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(.15),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionHeader("Work Description"),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            work.description.isEmpty
                                ? "No Description Available"
                                : work.description,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(.15),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _sectionHeader("Work Estimation"),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              _detailRow(
                                "Total No. of Works",
                                work.totalNoOfWorks,
                              ),
                              _detailRow(
                                "Estimated Amount",
                                "₹ ${work.totalEstimatedAmount}",
                              ),
                              _detailRow(
                                "Total Payable Amount",
                                "₹ ${work.totalPayableAmount}",
                              ),
                              _detailRow(
                                "Balance Payable",
                                "₹ ${work.balancePayableAmount}",
                              ),
                              _detailRow(
                                "Billing Address",
                                work.billingAddress,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(.15),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _sectionHeader("Payment Schedule"),
                        if (state.response.data.stageSchedules.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(20),
                            child: Text("No records found"),
                          )
                        else
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: const [
                                DataColumn(label: Text("Item Name")),
                                DataColumn(label: Text("Total Amount")),
                                DataColumn(label: Text("Paid Amount")),
                                DataColumn(label: Text("Balance Amount")),
                              ],
                              rows: state.response.data.stageSchedules.map((e) {
                                final total =
                                    double.tryParse(e.scheduleAmount) ?? 0;

                                final paid =
                                    double.tryParse(e.totalPaidAmount) ?? 0;

                                final balance = total - paid;

                                return DataRow(
                                  cells: [
                                    DataCell(Text(e.itemName)),
                                    DataCell(Text("₹${e.scheduleAmount}")),
                                    DataCell(Text("₹${e.totalPaidAmount}")),
                                    DataCell(
                                        Text("₹${balance.toStringAsFixed(2)}")),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(.15),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _sectionHeader("Payment History"),
                        if (state.response.data.paymentList.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(20),
                            child: Text("No records found"),
                          )
                        else
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: const [
                                DataColumn(label: Text("SI No")),
                                DataColumn(label: Text("Paid Amount")),
                                DataColumn(label: Text("Payment Mode")),
                                DataColumn(label: Text("Paid Date")),
                                DataColumn(label: Text("Remarks")),
                              ],
                              rows: List.generate(
                                state.response.data.paymentList.length,
                                (index) {
                                  final payment =
                                      state.response.data.paymentList[index];

                                  return DataRow(
                                    cells: [
                                      DataCell(Text("${index + 1}")),
                                      DataCell(
                                        Text("₹${payment.paidAmount}"),
                                      ),
                                      DataCell(
                                        Text(payment.paymentMethod),
                                      ),
                                      DataCell(
                                        Text(payment.paidDate),
                                      ),
                                      DataCell(
                                        Text(payment.remarks),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _detailRow(
    String title,
    String value,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Text(
              value.isEmpty ? "--" : value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.15),
        ),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }
}
