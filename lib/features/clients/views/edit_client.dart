// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/widgets/buttons.dart';
import 'package:site_720/core/widgets/snack_bar.dart';
import 'package:site_720/features/clients/cubit/client_state.dart';
import '../../../core/widgets/appbar.dart';
import '../../../data/models/clientlist/client_type_list.dart';
import '../../../data/models/clientlist/district_list.dart';
import '../../../data/models/clientlist/state_list_model.dart';
import '../cubit/edit_client_cubit.dart';

class EditCilentScreen extends StatelessWidget {
  EditCilentScreen({super.key});
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
  String? selectedDistrict;
  String? selectedType;
  List<States> stateList = [];
  List<Districts> districtList = [];
  List<ClientTypes> clientTypes = [];
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    String clientId = args["client_id"]!;
    return BlocProvider(
      create: (context) => EditClientsCubit(clientId),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: simpleAppbar(context, "Edit Client", true),
        body: MultiBlocListener(
          listeners: [
            BlocListener<EditClientsCubit, ClientsState>(
              listener: (context, state) {
                if (state is StateListFetched) {
                  stateList = state.response.data;
                } else if (state is ClientTypesFetched) {
                  clientTypes = state.response.data;
                } else if (state is DistrictListFetched) {
                  districtList = state.response.data;
                } else if (state is EditClientSuccess) {
                  snackBar(context, state.message, Colors.green);
                  Navigator.pop(context);
                } else if (state is EditClientFailure) {
                  snackBar(context, state.message, Colors.red);
                } else if (state is EditDetailsSuccess) {
                  clientName.text = state.response.data.clientName;
                  contactPerson.text = state.response.data.contactPerson;
                  phoneNumber.text = state.response.data.phoneNumber;
                  whatsappNumber.text = state.response.data.whatsappNumber;
                  companyName.text = state.response.data.companyName;
                  email.text = state.response.data.emailId;
                  address.text = state.response.data.address;
                  civilId.text = state.response.data.civilId;
                  gstNumber.text = state.response.data.gstNo;
                  if (state.response.data.stateId != "") {
                    selectedState = state.response.data.stateId;
                  }
                  if (state.response.data.districtId != "") {
                    selectedDistrict = state.response.data.districtId;
                  }
                  if (state.response.data.clinetTypeId != "") {
                    selectedType = state.response.data.clinetTypeId;
                  }
                }
              },
            )
          ],
          child: BlocBuilder<EditClientsCubit, ClientsState>(
            builder: (context, state) {
              final cubit = context.read<EditClientsCubit>();
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
                                return "Enter client name";
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
                                cubit.editClient(
                                    clientId,
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
                            child: LargeButton(title: "Update")),
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
}
