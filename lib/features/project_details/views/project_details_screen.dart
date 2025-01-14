// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/constants/routes.dart';
import '../../../core/widgets/appbar.dart';
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
                    FloatingAppBar(
                      title: "Project Details",
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
                            const Padding(
                              padding: EdgeInsets.only(top: 8.0, bottom: 16.0),
                              child: Text(
                                "OVERVIEW",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryColor),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                DetailsItem(
                                  title: "Start Date",
                                  value: "11-12-2024",
                                  icon: Icons.calendar_month,
                                ),
                                DetailsItem(
                                  title: "End Date",
                                  value: "11-12-2025",
                                  icon: Icons.calendar_month,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                DetailsItem(
                                  title: "Total Cost",
                                  value: "10000/-",
                                  icon: Icons.currency_rupee,
                                ),
                                DetailsItem(
                                  title: "CCTV Address",
                                  value: "BWERT45",
                                  icon: Icons.video_camera_back,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                DetailsItem(
                                  title: "Total Worked",
                                  value: "20",
                                  icon: Icons.done_all,
                                ),
                                DetailsItem(
                                  title: "Assigned Work",
                                  value: "50",
                                  icon: Icons.person,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                DetailsItem(
                                  title: "Company Issues",
                                  value: "12",
                                  icon: Icons.location_city,
                                ),
                                DetailsItem(
                                  title: "Client Issues",
                                  value: "5",
                                  icon: Icons.person_remove,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                DetailsItem(
                                  title: "General Issues",
                                  value: "11-12-2024",
                                  icon: Icons.public,
                                ),
                                DetailsItem(
                                  title: "Payment Delay",
                                  value: "20000",
                                  icon: Icons.currency_rupee,
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
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, AppRoutes.gallery);
                            },
                            child: DetailsButtonContainer(
                              title: "Gallery",
                              color: AppColors.primaryColor,
                              width: MediaQuery.of(context).size.width * .43,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AppRoutes.workDetails);
                            },
                            child: DetailsButtonContainer(
                              title: "Work Details",
                              color: AppColors.primaryColor,
                              width: MediaQuery.of(context).size.width * .43,
                            ),
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
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, AppRoutes.drawing);
                            },
                            child: DetailsButtonContainer(
                              title: "Site Drawing",
                              color: AppColors.primaryColor,
                              width: MediaQuery.of(context).size.width * .43,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, AppRoutes.siteNote);
                            },
                            child: DetailsButtonContainer(
                              title: "Site Note",
                              color: AppColors.primaryColor,
                              width: MediaQuery.of(context).size.width * .43,
                            ),
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
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, AppRoutes.stages);
                            },
                            child: DetailsButtonContainer(
                              title: "Stages",
                              color: AppColors.primaryColor,
                              width: MediaQuery.of(context).size.width * .43,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AppRoutes.subContractor);
                            },
                            child: DetailsButtonContainer(
                              title: "Sub Contractor",
                              color: AppColors.primaryColor,
                              width: MediaQuery.of(context).size.width * .43,
                            ),
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
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, AppRoutes.extraWork);
                            },
                            child: DetailsButtonContainer(
                              title: "Extra Work",
                              color: AppColors.primaryColor,
                              width: MediaQuery.of(context).size.width * .43,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AppRoutes.deductionWork);
                            },
                            child: DetailsButtonContainer(
                              title: "Deduction Work",
                              color: AppColors.primaryColor,
                              width: MediaQuery.of(context).size.width * .43,
                            ),
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
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, AppRoutes.purchase);
                            },
                            child: DetailsButtonContainer(
                              title: "Purchase",
                              color: AppColors.primaryColor,
                              width: MediaQuery.of(context).size.width * .43,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, AppRoutes.stock);
                            },
                            child: DetailsButtonContainer(
                              title: "Stock",
                              color: AppColors.primaryColor,
                              width: MediaQuery.of(context).size.width * .43,
                            ),
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
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, AppRoutes.expense);
                            },
                            child: DetailsButtonContainer(
                              title: "Expense",
                              color: AppColors.primaryColor,
                              width: MediaQuery.of(context).size.width * .43,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AppRoutes.paymentDetails);
                            },
                            child: DetailsButtonContainer(
                              title: "Payment Details",
                              color: AppColors.primaryColor,
                              width: MediaQuery.of(context).size.width * .43,
                            ),
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
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AppRoutes.estimation);
                            },
                            child: DetailsButtonContainer(
                              title: "Estimation",
                              color: AppColors.primaryColor,
                              width: MediaQuery.of(context).size.width * .43,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, AppRoutes.consumption);
                            },
                            child: DetailsButtonContainer(
                              title: "Consumption",
                              color: AppColors.primaryColor,
                              width: MediaQuery.of(context).size.width * .43,
                            ),
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
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, AppRoutes.purchase);
                            },
                            child: DetailsButtonContainer(
                              title: "Package",
                              color: AppColors.primaryColor,
                              width: MediaQuery.of(context).size.width * .43,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
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
