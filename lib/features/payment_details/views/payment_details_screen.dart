// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/widgets/appbar.dart';
import 'package:site_720/core/widgets/shimmer.dart';
import '../cubit/payment_details_cubit.dart';
import '../cubit/payment_details_state.dart';
import '../widgets/amount_container.dart';

class PaymentDetails extends StatelessWidget {
  const PaymentDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    String projectId = args["id"]!;
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: simpleAppbar(context, "Payment Details",true),
        body: BlocProvider(
          create: (context) => PaymentDetailsCubit(projectId),
          child: BlocBuilder<PaymentDetailsCubit, PaymentDetailsState>(
            builder: (context, state) {
          return  state  is PaymentDetailsSuccess?
               ListView.builder(
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
                                top: 8.0, left: 8.0, right: 8.0, bottom: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                     Text(
                                      state.response.data[index].stageName,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.8),
                                            blurRadius: 6,
                                            offset: const Offset(1, 1),
                                          ),
                                        ],
                                      ),
                                      child:  
                                      Text(
                                        state.response.data[index].paymentStatus,
                                        style:  TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color:state.response.data[index].paymentStatus=="Open"? Colors.green:state.response.data[index].paymentStatus=="Partially Paid"?Colors.amber:state.response.data[index].paymentStatus=="Close"?Colors.red:Colors.deepOrange),
                                      ),
                                    )
                                  ],
                                ),
                                 Text(
                                   state.response.data[index].phaseName,
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
                                      title: "Estimated Amount",
                                      amount: "${state.response.data[index].amount} ₹",
                                    ),
                                    AmountContainer(
                                      title: "Paid Amount",
                                      amount: "${state.response.data[index].paidAmount} ₹",
                                    ),
                                    AmountContainer(
                                      title: "Balance",
                                      amount: "${state.response.data[index].balanceAmount} ₹",
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
              ):state is PaymentDetailsLoading?
              ListView.builder(itemBuilder: (context, index) {
                shimmerContainer(100, 70);
              },):const Text("Payment Details Empty");
            },
          ),
        ));
  }
}
