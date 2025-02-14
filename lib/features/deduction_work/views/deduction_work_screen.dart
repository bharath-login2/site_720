// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/widgets/shimmer.dart';
import 'package:site_720/core/widgets/snack_bar.dart';
import '../../../core/widgets/buttons.dart';
import '../../../data/models/deductionwork/phaselist_model.dart';
import '../../payment_details/widgets/amount_container.dart';
import '../cubit/deducion_work_cubit.dart';
import '../cubit/deduction_work_state.dart';

class DeductionWork extends StatelessWidget {
  DeductionWork({super.key});
  final formKey = GlobalKey<FormState>();
  TextEditingController searchController = TextEditingController();
  TextEditingController work = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController percentage = TextEditingController();
  TextEditingController description = TextEditingController();
  List<Phases> phaseList = [];
  String? selectedStatus;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    String projectId = args["id"]!;
    String clientId = args["client_id"]!;

    return BlocProvider(
      create: (context) => DeductionWorkCubit(projectId),
      child: BlocListener<DeductionWorkCubit, DeductionWorkState>(
        listener: (context, state) {
          if (state is PhaselistSuccess) {
            phaseList = state.response.data;
          }
          if(state is AddedSuccess){
            snackBar(context, state.response.message, Colors.green);
          }
        },
        child: BlocBuilder<DeductionWorkCubit, DeductionWorkState>(
              builder: (context, state) {
                final cubit = context.read<DeductionWorkCubit>();
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
                      padding:
                          const EdgeInsets.only(left: 20.0, top: 35, right: 20),
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
                                "Deduction Work",
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
                              workDialog(context, cubit, phaseList, projectId,
                                  clientId,"add","add");
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
                body: state is DeductionWorkSuccess
                    ? RefreshIndicator(
                        onRefresh: () async {
                          cubit.getDeductionWorkList(projectId);
                        },
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          itemCount: state.response.data.length,
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
                                    width:
                                        MediaQuery.of(context).size.width * .7,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0,
                                          left: 8.0,
                                          right: 8.0,
                                          bottom: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    state.response.data[index]
                                                        .workName,
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            AppColors.coffie),
                                                  ),
                                                  Text(
                                                    state.response.data[index]
                                                        .stageName,
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                  Text(
                                                    state.response.data[index]
                                                        .description,
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Row(
                                                    children: [
                                                      InkWell(
                                                       onTap: () {

                                                        work.text=state.response.data[index].workName;
                                                        selectedStatus=state.response.data[index].phaseId;
                                                        percentage.text = state.response.data[index].percentage;
                                                         amount.text = state.response.data[index].amount;
                                                          description.text = state.response.data[index].description;
                                                      workDialog(context, cubit, phaseList, projectId,
                                                          clientId , "edit","update");
                                                    },
                                                                                child: Container(
                                                          height: 25,
                                                          width: 25,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(5),
                                                            color: AppColors
                                                                .lightBlue,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors.grey
                                                                    .withOpacity(
                                                                        0.8),
                                                                blurRadius: 6,
                                                                offset:
                                                                    const Offset(
                                                                        1, 1),
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
                                                            String workId = state.response.data[index].id;
                                                          deleteDialog(context,cubit,projectId,workId, () {
                                                            Navigator.pop(
                                                                context);
                                                          });
                                                        },
                                                        child: Container(
                                                          height: 25,
                                                          width: 25,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            color: Colors.red,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.8),
                                                                blurRadius: 6,
                                                                offset:
                                                                    const Offset(
                                                                        1, 1),
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
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  AmountContainer(
                                                    title: "Cost",
                                                    amount:
                                                        "${state.response.data[index].amount}₹",
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
                      )
                    : state is DeductionWorkLoading
                        ? ListView.builder(
                            itemBuilder: (context, index) {
                             return shimmerContainer(100, 70);
                            },
                          )
                        : const Center(
                            child: Text("No Deduction Work Added"),
                          ));
          },
        ),
      ),
    );
  }

  Future<void> deleteDialog(BuildContext context, DeductionWorkCubit cubit,
  String projectId , String workId,
   onTap) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: SizedBox(
            height: 200,
            child: SingleChildScrollView(
              child: Form(
                key:formKey,
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
                      onTap: () async{
                           if (formKey.currentState!.validate()) {
                            cubit.deleteDeductionWork(
                             projectId,
                             workId,
                             
                            );
                             Navigator.pop(context);
                           }
                        },
                      child: LargeButton(title: "Delete"),
                    ),
                    TextButton(
                      onPressed: () {
                        
                          Navigator.pop(context);
                      },
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> workDialog(BuildContext context, DeductionWorkCubit cubit,
      List<Phases> list, String projectId, String clientId , String status,String buttontype) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: SizedBox(
            height: 470,
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                     Padding(
                      padding: EdgeInsets.only(top: 16.0, bottom: 25),
                      child: Text(
                        status =="add"?"Add Deduction Work":"Edit Deduction Work",
                        style: const TextStyle(
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
                          labelText: 'work',
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
                      child: DropdownButtonFormField<String>(
                        value: selectedStatus,
                        items: list.map((data) {
                          return DropdownMenuItem<String>(
                            value: data.id.toString(),
                            child: Text(
                              data.phaseName.toString(),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          selectedStatus = value;
                        },
                        validator: (value) {
                          if (value == null) {
                            return "Select a Status";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(10),
                          labelText: 'Phase',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          prefixIcon: const Icon(Icons.info),
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
                            return "Enter Percentage";
                          } else {
                            return null;
                          }
                        },
                        onTap: () {},
                        controller: percentage,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(10),
                          labelText: 'Percentage',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          prefixIcon: const Icon(Icons.percent),
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
                        if (formKey.currentState!.validate()) {
                          cubit.addDeductionworkList(
                              projectId,
                              clientId,
                              work.text,
                              selectedStatus,
                              percentage.text,
                              amount.text,
                              description.text);
                        }
                         work.clear();
                         selectedStatus=null;
                         percentage.clear();
                          amount.clear();
                          description.clear();
                          Navigator.pop(context);
                      },
                      child: LargeButton(title: buttontype=="add"?"Add":"Update"),
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
          ),
        );
      },
    );
  }
}
