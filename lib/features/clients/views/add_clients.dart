// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/widgets/buttons.dart';
import 'package:site_720/core/widgets/snack_bar.dart';
import 'package:site_720/features/clients/cubit/add_client_cubit.dart';
import 'package:site_720/features/clients/cubit/client_state.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/connectivity_dialog.dart';
import '../../../data/models/clientlist/client_type_list.dart';
import '../../../data/models/clientlist/district_list.dart';
import '../../../data/models/clientlist/state_list_model.dart';
import '../../connectivity/cubit/connectivity_cubit.dart';
import '../../connectivity/cubit/connectivity_state.dart';

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
  String? selectedState;
  dynamic selectedDistrict;
  String? selectedType;
  List<States> stateList = [];
  List<Districts> districtList = [];
  List<ClientTypes> clientTypes = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddClientsCubit(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: simpleAppbar(context, "Add Client", true),
        body: MultiBlocListener(
          listeners: [
            BlocListener<ConnectivityCubit, ConnectivityState>(
              listener: (context, state) {
                if (state is ConnectivityDisconnected) {
                  if (connStatus == true) {
                    connStatus = false;
                    connectivityDialog(context);
                  }
                } else {
                  connStatus = true;
                }
              },
            ),
            BlocListener<AddClientsCubit, ClientsState>(
              listener: (context, state) {
                if (state is StateListFetched) {
                  stateList = state.response.data;
                } else if (state is ClientTypesFetched) {
                  clientTypes = state.response.data;
                } else if (state is DistrictListFetched) {
                  districtList = state.response.data;
                } else if (state is AddClientSuccess) {
                  snackBar(context, state.message, Colors.green);
                  Navigator.pop(context);
                } else if (state is AddClientFailure) {
                  snackBar(context, state.message, Colors.red);
                }
              },
            )
          ],
          child: BlocBuilder<AddClientsCubit, ClientsState>(
            builder: (context, state) {
              final cubit = context.read<AddClientsCubit>();
              return SingleChildScrollView(
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
                            validator: (value) {
                              if (value == "") {
                                return "Enter name";
                              } else if (isValidName(value!) == false) {
                                return "Enter valid name";
                              } else {
                                return null;
                              }
                            },
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
                              labelStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
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
                            validator: (value) {
                              if (value == "") {
                                return "Enter name";
                              } else if (isValidName(value!) == false) {
                                return "Enter valid name";
                              } else {
                                return null;
                              }
                            },
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
                              labelStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
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
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == "") {
                                return "Enter phone number";
                              } else if (isValidPhoneNumber(value!) == false) {
                                return "Enter valid phone number";
                              } else {
                                return null;
                              }
                            },
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
                              labelStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
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
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == "") {
                                return "Enter whatsApp number";
                              } else if (isValidPhoneNumber(value!) == false) {
                                return "Enter valid number";
                              } else {
                                return null;
                              }
                            },
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
                              labelStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
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
                              labelStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
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
                                borderRadius: BorderRadius.circular(5),
                              ),
                              labelText: 'Email',
                              prefixIcon: const Icon(
                                Icons.email,
                                color: Colors.grey,
                                size: 18,
                              ),
                              labelStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
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
                              labelStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
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
                              labelStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
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
                              labelStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
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
                            value: selectedState,
                            onChanged: (value) async {
                              selectedDistrict = null;
                              districtList = [];
                              selectedState = value.toString();
                              cubit.getDistricts(selectedState!);
                            },
                            items: stateList.map((data) {
                              return DropdownMenuItem<String>(
                                value: data.stateId.toString(),
                                child: Text(
                                  data.stateTitle.toString(),
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
                              labelStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
                              contentPadding: const EdgeInsets.only(left: 10),
                            ),
                          ),
                        ),
                        if (districtList.isNotEmpty)
                          const SizedBox(
                            height: 10,
                          ),
                        if (districtList.isNotEmpty)
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .9,
                            child: DropdownButtonFormField(
                              value: selectedDistrict,
                              onChanged: (value) async {
                                selectedDistrict = value.toString();
                              },
                              items: districtList.map((data) {
                                return DropdownMenuItem<String>(
                                  value: data.districtId,
                                  child: Text(
                                    data.districtTitle,
                                  ),
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                labelText: 'District',
                                labelStyle: const TextStyle(
                                    color: Colors.grey, fontSize: 14),
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
                            value: selectedType,
                            onChanged: (value) async {
                              selectedType = value.toString();
                            },
                            items: clientTypes.map((data) {
                              return DropdownMenuItem<String>(
                                value: data.id,
                                child: Text(
                                  data.clientType,
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
                              labelStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
                              contentPadding: const EdgeInsets.only(left: 10),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        InkWell(
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                cubit.addClient(
                                    clientName.text,
                                    contactPerson.text,
                                    phoneNumber.text,
                                    whatsappNumber.text,
                                    companyName.text,
                                    email.text,
                                    address.text,
                                    civilId.text,
                                    gstNumber.text,
                                    selectedState ?? "",
                                    selectedDistrict ?? "",
                                    selectedType ?? "");
                              }
                            },
                            child: LargeButton(title: "Submit")),
                        const SizedBox(
                          height: 25,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  bool isValidPhoneNumber(String phone) {
    final regex = RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$');
    return regex.hasMatch(phone);
  }

  bool isValidName(String name) {
    final nameRegExp = RegExp(r"^[a-zA-Z]+(?:[\s'-][a-zA-Z]+)*$");
    return nameRegExp.hasMatch(name);
  }
}
