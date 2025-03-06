
// ignore_for_file: must_be_immutable

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

class Contractor extends StatelessWidget {
  Contractor({super.key});
  TextEditingController searchController = TextEditingController();
  TextEditingController fdate = TextEditingController(
      text: DateFormat('dd-MM-yyyy').format(DateTime.now()));
  TextEditingController tdate = TextEditingController(
      text: DateFormat('dd-MM-yyyy').format(DateTime.now()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: simpleAppbar(context, "Contractors", true),
        body: BlocProvider(
          create: (context) => SubContractorCubit(),
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
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
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
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0,
                                    left: 8.0,
                                    right: 8.0,
                                    bottom: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          state.response.data[index].name,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.coffie),
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.phone,
                                              size: 16,
                                              color: AppColors.primaryColor,
                                            ),
                                            Text(
                                              state.response.data[index].phone,
                                              style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.location_pin,
                                              size: 16,
                                              color: AppColors.primaryColor,
                                            ),
                                            Text(
                                              state
                                                  .response.data[index].address,
                                              style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
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
        ));
  }
}
