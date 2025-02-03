// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/widgets/appbar.dart';
import 'package:site_720/core/widgets/shimmer.dart';
import 'package:site_720/features/work_details/cubit/work_details_state.dart';

import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/snack_bar.dart';
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
                    padding:
                        const EdgeInsets.only(left: 20.0, top: 35, right: 20),
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
                              "Work Details",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                  fontFamily: "Lobster",
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            workDialog(context);
                          },
                          child: const CircleAvatar(
                            radius: 20,
                            backgroundColor: AppColors.lightPrimary,
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              body: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                itemCount: state is WorkDetailsSuccess
                    ? state.response.data.length
                    : 7,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: state is WorkDetailsSuccess
                        ? InkWell(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          .2,
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
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            state.response.data[index].workDay,
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    AppColors.backgroundColor),
                                          ),
                                          Text(
                                            state.response.data[index]
                                                .workMonthName,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    AppColors.backgroundColor),
                                          ),
                                          Text(
                                            state.response.data[index].workYear,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    AppColors.backgroundColor),
                                          )
                                        ],
                                      )),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .7,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0,
                                          left: 8.0,
                                          right: 8.0,
                                          bottom: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                state.response.data[index]
                                                            .isWorking ==
                                                        "No"
                                                    ? state.response.data[index]
                                                        .workStatus
                                                    : "Labour No:${state.response.data[index].laboursNo} ",
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: AppColors
                                                        .backgroundColor,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.8),
                                                        blurRadius: 6,
                                                        offset:
                                                            const Offset(1, 1),
                                                      ),
                                                    ],
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 20.0,
                                                    ),
                                                    child: Text(
                                                      state.response.data[index]
                                                                  .isWorking ==
                                                              "No"
                                                          ? "Not Worked"
                                                          : "Worked",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: state
                                                                      .response
                                                                      .data[
                                                                          index]
                                                                      .isWorking ==
                                                                  "No"
                                                              ? AppColors
                                                                  .primaryColor
                                                              : Colors.green),
                                                    ),
                                                  )),
                                            ],
                                          ),
                                          Text(
                                            state.response.data[index]
                                                .description,
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
                          )
                        : shimmerContainer(
                            MediaQuery.of(context).size.height * .1,
                            MediaQuery.of(context).size.width * .9),
                  );
                },
              ));
        },
      ),
    );
  }
}

Future<void> workDialog(BuildContext context) async {
  String isWorking = 'Yes';
  String? selectedStatus;

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        content: SizedBox(
          height: 500,
          child: BlocBuilder<WorkDetailsCubit, WorkDetailsState>(
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0, bottom: 25),
                      child: Text(
                        "Add Work Details",
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Text(
                      "Are You Sure Today is Working?",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.errorColor),
                    ),
                    Row(
                      children: [
                        Radio<String>(
                          value: 'Yes',
                          groupValue: isWorking,
                          onChanged: (value) {
                            isWorking = value!;
                            (context as Element).markNeedsBuild();
                          },
                        ),
                        const Text("Yes"),
                        Radio<String>(
                          value: 'No',
                          groupValue: isWorking,
                          onChanged: (value) {
                            isWorking = value!;
                            (context as Element).markNeedsBuild();
                          },
                        ),
                        const Text("No"),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextFormField(
                        validator: (value) {
                          if (value == "") {
                            return "Enter Date";
                          }
                          return null;
                        },
                        onTap: () {},
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(10),
                          labelText: 'Date',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          prefixIcon: const Icon(Icons.calendar_today),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (isWorking == "Yes")
                      Container(
                        width: MediaQuery.of(context).size.width * 0.95,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextFormField(
                          validator: (value) {
                            if (value == "") {
                              return "Enter Number of Labours";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(10),
                            labelText: 'No of Labours*',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            prefixIcon: const Icon(Icons.group),
                          ),
                        ),
                      )
                    else
                    state is WorkStatusSuccess?  Container(
                        width: MediaQuery.of(context).size.width * 0.95,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: DropdownButtonFormField<String>(
                          value: selectedStatus,
                          items: state.response.data.map((data) {
                      return DropdownMenuItem<String>(
                        value: data.id.toString(),
                        child: Text(
                          data.workStatus.toString(),
                        ),
                      );
                    }).toList(),
                          onChanged: (value) {
                            selectedStatus = value;
                          },
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty && isWorking == "Yes") {
                              return "Select a Status";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(10),
                            labelText: 'Status*',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            prefixIcon: const Icon(Icons.info),
                          ),
                        ),
                      ):SizedBox(),
                    const SizedBox(height: 12),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextFormField(
                        validator: (value) {
                          if (value == "") {
                            return "Enter Description";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        maxLines: 3,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(10),
                          labelText: 'Description',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          prefixIcon: const Icon(Icons.text_fields),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () async {
                        snackBar(context, 'Work Details Added Successfully!',
                            Colors.black);
                        Navigator.pop(context);
                      },
                      child: LargeButton(title: "Add"),
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Close'),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    },
  );
}
