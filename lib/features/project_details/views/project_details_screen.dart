// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:site_720/core/constants/colors.dart';
import '../widgets/details_button_container.dart';
import '../widgets/details_item.dart';
import '../widgets/floating_profile_card.dart';

class ProjectDetails extends StatelessWidget {
  ProjectDetails({super.key});

  dynamic status;
  List<Map<String, dynamic>> statuses = [
    {"statusId": 101, "statusName": "status 1"},
    {"statusId": 102, "statusName": "status 2"},
    {"statusId": 103, "statusName": "status 3"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              SizedBox(
                // height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * .22,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(22),
                            bottomRight: Radius.circular(22),
                          )),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 60.0, left: 16.0, right: 16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Icon(
                                        Icons.arrow_back_ios,
                                        color: Colors.white,
                                      )),
                                ),
                                const Text(
                                  "Project Details",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .075,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * .95,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppColors.lightA,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.8),
                            blurRadius: 3,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 16),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                DetailsItem(
                                  title: "Start Date",
                                  value: "11-12-2024",
                                  icon: "",
                                ),
                                DetailsItem(
                                  title: "Start Date",
                                  value: "11-12-2024",
                                  icon: "",
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                DetailsItem(
                                  title: "Start Date",
                                  value: "11-12-2024",
                                  icon: "",
                                ),
                                DetailsItem(
                                  title: "Start Date",
                                  value: "11-12-2024",
                                  icon: "",
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                DetailsItem(
                                  title: "Start Date",
                                  value: "11-12-2024",
                                  icon: "",
                                ),
                                DetailsItem(
                                  title: "Start Date",
                                  value: "11-12-2024",
                                  icon: "",
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                DetailsItem(
                                  title: "Start Date",
                                  value: "11-12-2024",
                                  icon: "",
                                ),
                                DetailsItem(
                                  title: "Start Date",
                                  value: "11-12-2024",
                                  icon: "",
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                DetailsItem(
                                  title: "Start Date",
                                  value: "11-12-2024",
                                  icon: "",
                                ),
                                DetailsItem(
                                  title: "Start Date",
                                  value: "11-12-2024",
                                  icon: "",
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  DetailsButtonContainer(
                                    title: "View Plan",
                                    color: AppColors.coffie,
                                    width:
                                        MediaQuery.of(context).size.width * .4,
                                  ),
                                  DetailsButtonContainer(
                                    title: "View Elevation",
                                    color: AppColors.coffie,
                                    width:
                                        MediaQuery.of(context).size.width * .4,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DetailsButtonContainer(
                            title: "Gallery",
                            color: AppColors.primaryColor,
                            width: MediaQuery.of(context).size.width * .43,
                          ),
                          DetailsButtonContainer(
                            title: "Work Details",
                            color: AppColors.primaryColor,
                            width: MediaQuery.of(context).size.width * .43,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DetailsButtonContainer(
                            title: "Gallery",
                            color: AppColors.primaryColor,
                            width: MediaQuery.of(context).size.width * .43,
                          ),
                          DetailsButtonContainer(
                            title: "Work Details",
                            color: AppColors.primaryColor,
                            width: MediaQuery.of(context).size.width * .43,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DetailsButtonContainer(
                            title: "Gallery",
                            color: AppColors.primaryColor,
                            width: MediaQuery.of(context).size.width * .43,
                          ),
                          DetailsButtonContainer(
                            title: "Work Details",
                            color: AppColors.primaryColor,
                            width: MediaQuery.of(context).size.width * .43,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DetailsButtonContainer(
                            title: "Gallery",
                            color: AppColors.primaryColor,
                            width: MediaQuery.of(context).size.width * .43,
                          ),
                          DetailsButtonContainer(
                            title: "Work Details",
                            color: AppColors.primaryColor,
                            width: MediaQuery.of(context).size.width * .43,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DetailsButtonContainer(
                            title: "Gallery",
                            color: AppColors.primaryColor,
                            width: MediaQuery.of(context).size.width * .43,
                          ),
                          DetailsButtonContainer(
                            title: "Work Details",
                            color: AppColors.primaryColor,
                            width: MediaQuery.of(context).size.width * .43,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.16,
                left: MediaQuery.of(context).size.width * 0.05,
                child: const FloatingProfileCard(
                  name: "Ajmal p",
                  address: "Kaloor,Kochi",
                  phoneNumber: "9947667744",
                ),
              ),
            ],
          ),
        ));
  }
}
