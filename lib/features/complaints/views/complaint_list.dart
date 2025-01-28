// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/features/package/cubit/package_detailed_cubit.dart';
import '../../../core/constants/routes.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/snack_bar.dart';

class ComplaintList extends StatelessWidget {
  ComplaintList({super.key});
  TextEditingController searchController = TextEditingController();
  TextEditingController work = TextEditingController();
  TextEditingController details = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController description = TextEditingController();

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
                        "Complaints List",
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
                      Navigator.of(context).pushNamed(AppRoutes.addComplaints);
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
          create: (context) => PackageDetailedCubit(),
          child: ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
            itemCount: 5,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(6.0),
                child: InkWell(
                  onTap: () {
                    // Navigator.of(context).pushNamed(AppRoutes.stageHistory);
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Complaint 1",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.coffie),
                                    ),
                                    Text(
                                      "Complaint Details",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            editDialog(context, () {
                                              Navigator.pop(context);
                                            });
                                          },
                                          child: Container(
                                            height: 25,
                                            width: 25,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: AppColors.lightBlue,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.8),
                                                  blurRadius: 6,
                                                  offset: const Offset(1, 1),
                                                ),
                                              ],
                                            ),
                                            child: const Icon(
                                              Icons.edit,
                                              size: 18,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 7,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            deleteDialog(context, () {
                                              Navigator.pop(context);
                                            });
                                          },
                                          child: Container(
                                            height: 25,
                                            width: 25,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colors.red,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.8),
                                                  blurRadius: 6,
                                                  offset: const Offset(1, 1),
                                                ),
                                              ],
                                            ),
                                            child: const Icon(
                                              Icons.delete,
                                              size: 18,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
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

  Future<void> workDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: SizedBox(
            height: 400,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 16.0, bottom: 25),
                    child: Text(
                      "Add Package",
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
                        labelText: 'package',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        prefixIcon: const Icon(Icons.badge),
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
                          return "Enter work";
                        } else {
                          return null;
                        }
                      },
                      onTap: () {},
                      controller: details,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        labelText: 'Package Details',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        prefixIcon: const Icon(Icons.text_fields_sharp),
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
                          return "Enter Amount";
                        } else {
                          return null;
                        }
                      },
                      onTap: () {},
                      keyboardType: TextInputType.number,
                      controller: amount,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        labelText: 'Amount',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        prefixIcon: const Icon(Icons.currency_rupee),
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
                          return "Enter Description";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      controller: description,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        labelText: 'Description',
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
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () async {
                      snackBar(context, 'Package Uploaded Successfully!!',
                          Colors.black);

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

  Future<void> deleteDialog(BuildContext context, onTap) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: SizedBox(
            height: 200,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 30.0, bottom: 20),
                    child: Text(
                      "Are you sure ?",
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: LargeButton(title: "Delete"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      work.clear();
                      amount.clear();
                      description.clear();
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

  Future<void> editDialog(BuildContext context, onTap) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: SizedBox(
            height: 200,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 30.0, bottom: 20),
                    child: Text(
                      "Edit Details",
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: LargeButton(title: "Make Edit"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      work.clear();
                      amount.clear();
                      description.clear();
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
