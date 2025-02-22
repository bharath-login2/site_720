// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/widgets/buttons.dart';
import 'package:site_720/features/clients/cubit/client_cubit.dart';

import '../../../core/widgets/appbar.dart';

class AddCilentScreen extends StatelessWidget {
  AddCilentScreen({super.key});
  final formKey = GlobalKey<FormState>();
  TextEditingController clientName = TextEditingController();
  TextEditingController contactPerson = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController whatsappNumber = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController companyName = TextEditingController();
  TextEditingController civilId = TextEditingController();
  TextEditingController gstNumber = TextEditingController();
  dynamic status;
  List<Map<String, dynamic>> statuses = [
    {"statusId": 1, "statusName": "Normal"},
    {"statusId": 2, "statusName": "Premium"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: simpleAppbar(context, "Add Client", true),
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
                    controller: clientName,
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
                    controller: contactPerson,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      labelText: 'Contact person',
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
                    controller: phoneNumber,
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
                    controller: whatsappNumber,
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
                    controller: address,
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
                      labelText: 'District',
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
                      labelText: 'Client type',
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
}
