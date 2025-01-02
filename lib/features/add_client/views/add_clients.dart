// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/widgets/buttons.dart';

class AddCilentScreen extends StatelessWidget {
  AddCilentScreen({super.key});

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
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * .15,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(color: AppColors.primaryColor),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .9,
              child: TextFormField(
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    // Custom border
                    borderRadius: BorderRadius.circular(5),
                  ),
                  labelText: 'Client name *',
                  prefixIcon: const Icon(
                    Icons.person,
                    color: Colors.grey,
                    size: 18,
                  ),
                  labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                  contentPadding: const EdgeInsets.only(left: 10),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .9,
              child: TextFormField(
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    // Custom border
                    borderRadius: BorderRadius.circular(5),
                  ),
                  labelText: 'Contact person',
                  prefixIcon: const Icon(
                    Icons.person,
                    color: Colors.grey,
                    size: 18,
                  ),
                  labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                  contentPadding: const EdgeInsets.only(left: 10),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .9,
              child: TextFormField(
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    // Custom border
                    borderRadius: BorderRadius.circular(5),
                  ),
                  labelText: 'Phone number *',
                  prefixIcon: const Icon(
                    Icons.phone,
                    color: Colors.grey,
                    size: 18,
                  ),
                  labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                  contentPadding: const EdgeInsets.only(left: 10),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .9,
              child: TextFormField(
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    // Custom border
                    borderRadius: BorderRadius.circular(5),
                  ),
                  labelText: 'Whatsapp number *',
                  prefixIcon: const Icon(
                    Icons.message,
                    color: Colors.grey,
                    size: 18,
                  ),
                  labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                  contentPadding: const EdgeInsets.only(left: 10),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .9,
              child: TextFormField(
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    // Custom border
                    borderRadius: BorderRadius.circular(5),
                  ),
                  labelText: 'Address',
                  prefixIcon: const Icon(
                    Icons.pin_drop,
                    color: Colors.grey,
                    size: 18,
                  ),
                  labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                  contentPadding: const EdgeInsets.only(left: 10),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .9,
              child: TextFormField(
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    // Custom border
                    borderRadius: BorderRadius.circular(5),
                  ),
                  labelText: 'Email',
                  prefixIcon: const Icon(
                    Icons.email,
                    color: Colors.grey,
                    size: 18,
                  ),
                  labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                  contentPadding: const EdgeInsets.only(left: 10),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .9,
              child: TextFormField(
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    // Custom border
                    borderRadius: BorderRadius.circular(5),
                  ),
                  labelText: 'Company name',
                  prefixIcon: const Icon(
                    Icons.location_city,
                    color: Colors.grey,
                    size: 18,
                  ),
                  labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                  contentPadding: const EdgeInsets.only(left: 10),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .9,
              child: TextFormField(
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    // Custom border
                    borderRadius: BorderRadius.circular(5),
                  ),
                  labelText: 'Civil ID',
                  labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                  contentPadding: const EdgeInsets.only(left: 10),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .9,
              child: TextFormField(
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    // Custom border
                    borderRadius: BorderRadius.circular(5),
                  ),
                  labelText: 'GST Number',
                  prefixIcon: const Icon(
                    Icons.person,
                    color: Colors.grey,
                    size: 18,
                  ),
                  labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                  contentPadding: const EdgeInsets.only(left: 10),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .9,
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
                  labelText: 'State',
                  labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                  contentPadding: const EdgeInsets.only(left: 10),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .9,
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
                  labelText: 'District',
                  labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                  contentPadding: const EdgeInsets.only(left: 10),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .9,
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
                  labelText: 'Client type',
                  labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                  contentPadding: const EdgeInsets.only(left: 10),
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            LargeButton(title: "Submit"),
            const SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
    );
  }
}
