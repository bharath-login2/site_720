// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/widgets/appbar.dart';
import '../cubit/estimation_cubit.dart';
import '../widgets/estimation_container.dart';

class Estimation extends StatelessWidget {
  const Estimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: simpleAppbar(context, "Estimation"),
        body: BlocProvider(
          create: (context) => EstimationCubit(),
          child: ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            itemCount: 15,
            itemBuilder: (context, index) {
              return Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: ExpansionTile(
                    collapsedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    textColor: AppColors.primaryColor,
                    collapsedTextColor: AppColors.primaryColor,
                    collapsedBackgroundColor: AppColors.lightA,
                    backgroundColor: Colors.white,
                    title: const Text(
                      "Phase",
                    ),
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 5,
                        itemBuilder: (context, i) {
                          return GestureDetector(
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.only(
                                bottom: 10,
                              ),
                              child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  color: AppColors.dashContainer,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Product Name",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const Text(
                                        "Unit",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          EstimationContainer(
                                            title: "Estimated Quantity",
                                            value: "50",
                                          ),
                                          EstimationContainer(
                                            title: "Rate",
                                            value: "1000",
                                          ),
                                          EstimationContainer(
                                            title: "Estimated Amount",
                                            value: "50000",
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
                    ],
                  ));
            },
          ),
        ));
  }
}
