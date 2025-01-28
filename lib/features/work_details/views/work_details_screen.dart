// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/widgets/appbar.dart';
import 'package:site_720/core/widgets/shimmer.dart';
import 'package:site_720/features/work_details/cubit/work_details_state.dart';

import '../cubit/work_details_cubit.dart';

class WorkDetails extends StatelessWidget {
  const WorkDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WorkDetailsCubit("302"),
      child: BlocBuilder<WorkDetailsCubit, WorkDetailsState>(
        builder: (context, state) {
          return Scaffold(
              backgroundColor: AppColors.backgroundColor,
              appBar: simpleAppbar(context, "Work Details"),
              body: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                itemCount:state is WorkDetailsSuccess ? state.response.data.length:7,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:state is WorkDetailsSuccess ? InkWell(
                      onTap: () {},
                      child: Container(
                        width: MediaQuery.of(context).size.width * .9,
                        height: MediaQuery.of(context).size.height * .1,
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width * .2,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  image: const DecorationImage(
                                      image: AssetImage(
                                          "assets/images/appbar.png"),
                                      fit: BoxFit.fill),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.8),
                                      blurRadius: 6,
                                      offset: const Offset(1, 1),
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child:  Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      state.response.data[index].workDay,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.backgroundColor),
                                    ),
                                    Text(
                                       state.response.data[index].workMonthName,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.backgroundColor),
                                    ),
                                     Text(
                                       state.response.data[index].workYear,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.backgroundColor),
                                    )
                                  ],
                                )),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .7,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0,
                                    left: 8.0,
                                    right: 8.0,
                                    bottom: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                       Text(
                                      state.response.data[index].isWorking == "No"
                                          ? state.response.data[index].workStatus
                                          : "Labour No:${state.response.data[index].laboursNo} ",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                        Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: AppColors.backgroundColor,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.8),
                                                  blurRadius: 6,
                                                  offset: const Offset(1, 1),
                                                ),
                                              ],
                                            ),
                                            alignment: Alignment.center,
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 20.0,
                                              ),
                                              child: 
                                              Text(
                                            state.response.data[index].isWorking == "No"
                                                ? "Not Worked"
                                                : "Worked",
                                            style:  TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color:  state.response.data[index].isWorking == "No"
                                                ? AppColors.primaryColor:Colors.green
                                            ),
                                          ),
                                            )
                                            ),
                                      ],
                                    ),
                                     Text(
                                       state.response.data[index].description,
                                      style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.coffie),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ):shimmerContainer(MediaQuery.of(context).size.height * .1,MediaQuery.of(context).size.width * .9),
                  );
                },
              ));
        },
      ),
    );
  }
}
