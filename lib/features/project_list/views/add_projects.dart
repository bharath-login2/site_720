// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/widgets/buttons.dart';
import 'package:site_720/features/clients/cubit/client_cubit.dart';

import '../../../core/widgets/appbar.dart';

class AddProjectScreen extends StatelessWidget {
  AddProjectScreen({super.key});
  final formKey = GlobalKey<FormState>();
  TextEditingController clientName = TextEditingController();
  TextEditingController projectName = TextEditingController();
  TextEditingController referenceNumber = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController locationArea = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController companyName = TextEditingController();
  TextEditingController civilId = TextEditingController();
  TextEditingController gstNumber = TextEditingController();
  dynamic status;
  List filteredClientList = [];
  String clientId = "";
  List<Map<String, dynamic>> statuses = [
    {"statusId": 101, "statusName": "status 1"},
    {"statusId": 102, "statusName": "status 2"},
    {"statusId": 103, "statusName": "status 3"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: simpleAppbar(context, "Add Project"),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .9,
                  child: TextFormField(
                    readOnly: true,
                    controller: clientName,
                    onTap: () {
                      selectClientDialog(context);
                    },
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        // Custom border
                        borderRadius: BorderRadius.circular(5),
                      ),
                      labelText: 'Client *',
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Colors.grey,
                        size: 18,
                      ),
                      labelStyle:
                          const TextStyle(color: Colors.grey, fontSize: 14),
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
                    controller: projectName,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      labelText: 'Project name',
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Colors.grey,
                        size: 18,
                      ),
                      labelStyle:
                          const TextStyle(color: Colors.grey, fontSize: 14),
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
                      labelText: 'Project type',
                      labelStyle:
                          const TextStyle(color: Colors.grey, fontSize: 14),
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
                      labelText: 'Project category',
                      labelStyle:
                          const TextStyle(color: Colors.grey, fontSize: 14),
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
                    controller: referenceNumber,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        // Custom border
                        borderRadius: BorderRadius.circular(5),
                      ),
                      labelText: 'Reference number',
                      prefixIcon: const Icon(
                        Icons.numbers,
                        color: Colors.grey,
                        size: 18,
                      ),
                      labelStyle:
                          const TextStyle(color: Colors.grey, fontSize: 14),
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
                    controller: location,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        // Custom border
                        borderRadius: BorderRadius.circular(5),
                      ),
                      labelText: 'Location',
                      prefixIcon: const Icon(
                        Icons.pin_drop,
                        color: Colors.grey,
                        size: 18,
                      ),
                      labelStyle:
                          const TextStyle(color: Colors.grey, fontSize: 14),
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
                      labelText: 'Package',
                      labelStyle:
                          const TextStyle(color: Colors.grey, fontSize: 14),
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
                      labelText: 'No of BHK',
                      labelStyle:
                          const TextStyle(color: Colors.grey, fontSize: 14),
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
                    controller: locationArea,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        // Custom border
                        borderRadius: BorderRadius.circular(5),
                      ),
                      labelText: 'Location Area',
                      prefixIcon: const Icon(
                        Icons.pin_drop,
                        color: Colors.grey,
                        size: 18,
                      ),
                      labelStyle:
                          const TextStyle(color: Colors.grey, fontSize: 14),
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
                    controller: email,
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
                      labelStyle:
                          const TextStyle(color: Colors.grey, fontSize: 14),
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
                    controller: companyName,
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
                      labelStyle:
                          const TextStyle(color: Colors.grey, fontSize: 14),
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
                    controller: civilId,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        // Custom border
                        borderRadius: BorderRadius.circular(5),
                      ),
                      labelText: 'Civil ID',
                      labelStyle:
                          const TextStyle(color: Colors.grey, fontSize: 14),
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
                    controller: gstNumber,
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
                      labelStyle:
                          const TextStyle(color: Colors.grey, fontSize: 14),
                      contentPadding: const EdgeInsets.only(left: 10),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                InkWell(
                    onTap: () {
                      context.read<ClientsCubit>().addClient(
                            "",
                            "",
                          );
                    },
                    child: LargeButton(title: "Submit")),
                const SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> selectClientDialog(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: AppColors.backgroundColor,
            content: SizedBox(
              height: MediaQuery.of(context).size.height * .6,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'Clients',
                      // style: TextingStyle.font18BoldBlack,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                      autocorrect: false,
                      keyboardType: TextInputType.visiblePassword,
                      autofocus: true,
                      onChanged: (value) {
                        setState(() {});
                      },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(8),
                        labelText: 'Search',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .55,
                      width: MediaQuery.of(context).size.width * .8,
                      child: ListView.builder(
                        // ignore: prefer_const_constructors
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 5,
                        itemBuilder: (context, i) {
                          return ListTile(
                            onTap: () {},
                            title: const Text(
                              "Pradeesh",
                              style: TextStyle(color: AppColors.primaryColor),
                            ),
                            subtitle: const Text("C R Manager",
                                style:
                                    TextStyle(color: AppColors.primaryColor)),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              ),
            ],
          );
        });
      },
    );
  }
}
