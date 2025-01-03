// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/constants/routes.dart';
import '../widgets/floating_card.dart';

class ProjectList extends StatelessWidget {
  ProjectList({super.key});

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
                      height: MediaQuery.of(context).size.height * .25,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/appbar.png"))),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 80.0, bottom: 16.0, left: 16.0, right: 16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Hi, Pradeesh",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      "Supervisor",
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1,
                                          fontFamily: "Lobster",
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const CircleAvatar(
                              backgroundColor: AppColors.coffie,
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .075,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .9,
                      height: MediaQuery.of(context).size.width * .105,
                      child: DropdownButtonFormField(
                        value: status,
                        onChanged: (value) async {
                          status = value.toString();
                        },
                        items: statuses.map((data) {
                          return DropdownMenuItem<String>(
                            value: data["statusId"].toString(),
                            child: Text(
                              data["statusName"].toString(),
                            ),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            // Custom border
                            borderRadius: BorderRadius.circular(5),
                          ),
                          labelText: 'Select Status',
                          labelStyle: const TextStyle(color: Colors.grey),
                          contentPadding: const EdgeInsets.only(
                              left: 10, top: 2, bottom: 2),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .6,
                            height: MediaQuery.of(context).size.width * .105,
                            child: TextFormField(
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  // Custom border
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                labelText: 'Search.',
                                prefixIcon: const Icon(Icons.search,
                                    color: Colors.grey),
                                labelStyle: const TextStyle(color: Colors.grey),
                                contentPadding: const EdgeInsets.only(
                                    left: 10, top: 2, bottom: 2),
                              ),
                            ),
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width * .25,
                              height: MediaQuery.of(context).size.width * .105,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: AppColors.primaryColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.8),
                                    blurRadius: 6,
                                    offset: const Offset(1, 1),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                "Submit",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                    fontFamily: "Lobster",
                                    color: Colors.white),
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(8),
                      itemCount: 15,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AppRoutes.projectDetails);
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
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, left: 8.0, right: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const CircleAvatar(
                                          backgroundColor: Colors.red,
                                          radius: 5,
                                        ),
                                        Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: Colors.purple.shade100,
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
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 20.0,
                                              ),
                                              child: Text(
                                                "Upcoming",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: AppColors.primaryColor,
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
                                            child: const Icon(
                                              Icons.person,
                                              color: Colors.white,
                                            )),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Taj Mahal",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "Shajahan",
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "22-11-2023 to 01-12-2025",
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.grey.shade300,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 8.0, left: 8.0, right: 8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "₹ 5000000",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "Cash",
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: Colors.green,
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
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20.0,
                                                  vertical: 2.0),
                                              child: Text(
                                                "paid",
                                                style: TextStyle(
                                                    fontSize: 8,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.2,
                left: MediaQuery.of(context).size.width * 0.05,
                child: const FloatingCard(
                  title: "Total Projects",
                  value: "25",
                ),
              ),
            ],
          ),
        ));
  }
}
