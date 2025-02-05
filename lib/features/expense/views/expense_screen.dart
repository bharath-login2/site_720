// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/widgets/buttons.dart';
import 'package:site_720/features/payment_details/widgets/amount_container.dart';
import '../../../core/widgets/snack_bar.dart';
import '../cubit/expense_cubit.dart';

class Expense extends StatelessWidget {
  Expense({super.key});
  TextEditingController work = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController spendBy = TextEditingController();
  TextEditingController dateOn = TextEditingController();
  TextEditingController spendAmount = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        "Expense",
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
                      addExpenseDialog(context);
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
        body: BlocProvider(
          create: (context) => ExpenseCubit(),
          child: ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            itemCount: 7,
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Cement purchase",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "ACC Cements",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Created by me",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "25-10-2024",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                AmountContainer(
                                  title: "Cost",
                                  amount: "50000 ₹",
                                ),
                                // Text(
                                //   "₹ 500000 /-",
                                //   style: TextStyle(
                                //       fontSize: 18,
                                //       fontWeight: FontWeight.bold,
                                //       color: AppColors.primaryColor),
                                // ),
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
          ),
        ));
  }

  Future<void> addExpenseDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: SizedBox(
            height: 465,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 16.0, bottom: 25),
                    child: Text(
                      "Add Expense",
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextFormField(
                      validator: (value) {
                        if (value == "") {
                          return "Enter work";
                        } else {
                          return null;
                        }
                      },
                      onTap: () {},
                      controller: work,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        labelText: 'Expense',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        prefixIcon: const Icon(Icons.text_snippet_sharp),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextFormField(
                      validator: (value) {
                        if (value == "") {
                          return "Enter Spend on data";
                        } else {
                          return null;
                        }
                      },
                      onTap: () {},
                      controller: amount,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        labelText: 'Spend On',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        prefixIcon: const Icon(Icons.text_fields),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextFormField(
                      validator: (value) {
                        if (value == "") {
                          return "Enter Spend By section";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      controller: spendBy,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        labelText: 'Spend By',
                        // labelStyle: TextingStyle.font14NormalBlack,
                        // fillColor: ColorConstant.greyyy,
                        border: OutlineInputBorder(
                          // borderSide:
                          //     const BorderSide(color: ColorConstant.greyyy),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        prefixIcon: const Icon(Icons.text_fields),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextFormField(
                      validator: (value) {
                        if (value == "") {
                          return "Enter proper date";
                        }
                        return null;
                      },
                      controller: dateOn,
                      readOnly: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        labelText: 'Date',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        prefixIcon: const Icon(Icons.calendar_month_outlined),
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2101),
                        );

                        if (pickedDate != null) {
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                          dateOn.text = formattedDate;
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextFormField(
                      validator: (value) {
                        if (value == "") {
                          return "Enter Amount";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      controller: spendAmount,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        labelText: 'Amount Spend',
                        // labelStyle: TextingStyle.font14NormalBlack,
                        // fillColor: ColorConstant.greyyy,
                        border: OutlineInputBorder(
                          // borderSide:
                          //     const BorderSide(color: ColorConstant.greyyy),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        prefixIcon: const Icon(Icons.currency_rupee),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () async {
                      snackBar(
                          context, "Expense added successfully!", Colors.black);

                      // await Future.delayed(const Duration(seconds: 0));
                      Navigator.pop(context);
                    },
                    child: LargeButton(title: "Add"),
                  ),
                  TextButton(
                    onPressed: () {
                      work.clear();
                      amount.clear();
                      description.clear();
                      Navigator.pop(context);
                    },
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
