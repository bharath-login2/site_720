// ignore_for_file: must_be_immutable

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/widgets/buttons.dart';
import 'package:site_720/features/purchase/cubit/purchase_cubit.dart';
import 'package:site_720/features/purchase/cubit/purchase_state.dart';
import '../../../core/widgets/appbar.dart';

class AddPurchase extends StatelessWidget {
  AddPurchase({super.key});
  final formKey = GlobalKey<FormState>();
  TextEditingController purchaseDate = TextEditingController();
  TextEditingController shopName = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController remarks = TextEditingController();
  TextEditingController stageController = TextEditingController();
  TextEditingController productController = TextEditingController();
  TextEditingController unitController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController shopNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  var commonRes;
  var details;
  List filteredStages = [];
  List filteredProducts = [];
  List<Map<String, dynamic>> selectedPurchase = [];
  List imageList = [];
  String prodId = "";
  String stageId = "";
  final GlobalKey<FormState> _prodKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
      final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: simpleAppbar(context, "Add Purchase",true),
      body: BlocProvider(
        create: (context) => PurchaseCubit(args["id"]!),
        child: BlocConsumer<PurchaseCubit, PurchaseState>(
          listener: (context, state) {
           },
          builder: (context, state) {
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
                          onTap: () async {
                            String? selectedDate = await selectDate(context);
                            purchaseDate.text = selectedDate!;
                            if (context.mounted) {
                              context
                                  .read<PurchaseCubit>()
                                  .updatePurchasedDate(selectedDate);
                            }
                          },
                          readOnly: true,
                          controller: purchaseDate,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            labelText: 'Purchased Date',
                            prefixIcon: const Icon(
                              Icons.calendar_today,
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
                        height: 15,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .9,
                        child: TextFormField(
                          controller: shopName,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            labelText: 'Shop Name',
                            prefixIcon: const Icon(
                              Icons.shop_two,
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
                        height: 15,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .9,
                        child: TextFormField(
                          controller: phoneNumber,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              // Custom border
                              borderRadius: BorderRadius.circular(5),
                            ),
                            labelText: 'Phone Number',
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
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 8),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * .9,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Add Product",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                    fontFamily: "Lobster",
                                    color: AppColors.primaryColor),
                              ),
                              InkWell(
                                onTap: () {
                                  productsDialog(context);
                                },
                                child: Container(
                                    width: 30,
                                    height: 30,
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
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () async {
                          imageDialog(context);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * .9,
                          height: 60,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(width: 10),
                              const Icon(Icons.image, color: Colors.grey),
                              const SizedBox(width: 10),
                              Expanded(
                                child:
                                    BlocBuilder<PurchaseCubit, PurchaseState>(
                                  builder: (context, state) {
                                    if (state is ImageSuccess) {
                                      final images = state.imageList;
                                      return ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: images.length,
                                        itemBuilder: (context, index) {
                                          final image = images[index];
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.file(
                                              File(image.path),
                                              width: 40,
                                              height: 40,
                                              fit: BoxFit.cover,
                                            ),
                                          );
                                        },
                                      );
                                    } else if (state is PurchaseFailure) {
                                      return Center(
                                          child: Text(
                                        state.message,
                                        style:
                                            const TextStyle(color: Colors.red),
                                      ));
                                    } else {
                                      return const Text(
                                        'Choose Image',
                                        style: TextStyle(color: Colors.grey),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .9,
                        child: TextFormField(
                          controller: remarks,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              // Custom border
                              borderRadius: BorderRadius.circular(5),
                            ),
                            labelText: 'Remarks',
                            prefixIcon: const Icon(
                              Icons.text_fields,
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
                        height: 40,
                      ),
                      // InkWell(
                      //     onTap: () {
                      //       context.read<PurchaseCubit>().addPurchase(
                      //             "",
                      //             "",
                      //           );
                      //     },
                      //     child: LargeButton(title: "Submit")),
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
    );
  }

  Future<dynamic> productsDialog(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: SizedBox(
            height: 420,
            child: Form(
              key: _prodKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0, bottom: 25),
                      child: Text(
                        "Add Product",
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
                            return "Select stage";
                          } else {
                            return null;
                          }
                        },
                        onTap: () {
                          selectStageDialog(context).then((_) {});
                        },
                        readOnly: true,
                        controller: stageController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(10),
                          labelText: 'Select stage',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
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
                            return "Select product";
                          } else {
                            return null;
                          }
                        },
                        onTap: () {
                          selectProductsDialog(context).then((_) {});
                        },
                        readOnly: true,
                        controller: productController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(10),
                          labelText: 'Select product',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.32,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextFormField(
                            controller: unitController,
                            readOnly: true,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(10),
                              labelText: 'Unit',
                              border: OutlineInputBorder(
                                // borderSide: const BorderSide(
                                //     color: ColorConstant.greyyy),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.32,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextFormField(
                            controller: qtyController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(10),
                              labelText: 'Qty',
                              // labelStyle: TextingStyle.font14NormalBlack,

                              // fillColor: ColorConstant.greyyy,
                              border: OutlineInputBorder(
                                // borderSide: const BorderSide(
                                //     color: ColorConstant.greyyy),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ),
                      ],
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
                          } else if (double.parse(value!) <= 0) {
                            return "Enter Valid Amount";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        controller: amountController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(10),
                          labelText: 'Amount',
                          // labelStyle: TextingStyle.font14NormalBlack,
                          // fillColor: ColorConstant.greyyy,
                          border: OutlineInputBorder(
                            // borderSide:
                            //     const BorderSide(color: ColorConstant.greyyy),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (_prodKey.currentState!.validate()) {}
                      },
                      child: LargeButton(title: "Add"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        stageController.clear();
                        productController.clear();
                        unitController.clear();
                        qtyController.clear();
                        amountController.clear();
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

  Future<dynamic> selectStageDialog(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
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
                      'Stages',
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
                        setState(() {
                          filteredStages = details!.data.stageLists
                              .where((item) => item.stageName
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                              .toList();
                        });
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
                        // physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: filteredStages.length,
                        itemBuilder: (context, i) {
                          return ListTile(
                            onTap: () {
                              stageController.text =
                                  filteredStages[i].stageName;
                              stageId = filteredStages[i].id;
                              filteredStages.clear();
                              filteredStages.addAll(details!.data.stageLists);
                            },
                            title: Text(filteredStages[i].stageName),
                            // subtitle: Text(
                            //     "Duration : ${filteredStages[i].} Days"),
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
                  filteredStages.clear();
                  filteredStages.addAll(details!.data.stageLists);
                },
                child: const Text('Close'),
              ),
            ],
          );
        });
      },
    );
  }

  Future<dynamic> selectProductsDialog(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
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
                      'Stages',
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
                        setState(() {
                          filteredProducts = details!.data.productLists
                              .where((item) => item.productName
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                              .toList();
                        });
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
                        // physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, i) {
                          return ListTile(
                            onTap: () {
                              productController.text =
                                  filteredProducts[i].productName;
                              unitController.text =
                                  filteredProducts[i].unitName;
                              prodId = filteredProducts[i].id;
                              filteredProducts.clear();
                              filteredProducts
                                  .addAll(details!.data.productLists);
                            },
                            title: Text(filteredProducts[i].productName),
                            subtitle: const Text("Unit"),
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
                onPressed: () {},
                child: const Text('Close'),
              ),
            ],
          );
        });
      },
    );
  }

  addProduct() {
    selectedPurchase.add({
      "product_id": prodId,
      "product_name": productController.text,
      "stage_id": stageId,
      "stage_name": stageController.text,
      "Unit": unitController.text,
      "product_qty": qtyController.text,
      "product_amount": amountController.text,
    });
    stageController.clear();
    productController.clear();
    unitController.clear();
    qtyController.clear();
    amountController.clear();
  }

  Future<void> imageDialog(
    BuildContext context,
  ) async {
    return showDialog(
      barrierColor: Colors.white.withOpacity(.4),
      context: context,
      builder: (ctx) {
        return Material(
          type: MaterialType.transparency,
          color: Colors.grey.shade200,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(),
                ),
                height: 200,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const CircleAvatar(
                              radius: 10,
                              foregroundColor: AppColors.backgroundColor,
                              backgroundColor: AppColors.primaryColor,
                              child: Center(
                                child: Icon(
                                  Icons.close,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () async {
                            await context
                                .read<PurchaseCubit>()
                                .selectMultiImage(ImageSource.camera);
                            if(context.mounted)  { Navigator.pop(context);}
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Camera",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        InkWell(
                          onTap: () async {
                            await context
                                .read<PurchaseCubit>()
                                .selectMultiImage(null);
                            if(context.mounted)   {Navigator.pop(context);}
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Choose File",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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

  selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      return DateFormat('dd-MM-yyyy').format(pickedDate);
    }
  }
}
