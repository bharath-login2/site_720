import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/services/http_services.dart';
import 'package:flutter/material.dart';

import '../../../data/models/stockconsume/project_dropdown_model.dart';
import '../../../data/models/stockconsume/stage_dropdown_model.dart';
import '../../../data/models/stockconsume/material_dropdown_model.dart';
import '../../../data/models/stockconsume/material_details_consumption_model.dart';
import '../../../core/constants/colors.dart';

class AddConsumptionDialog extends StatefulWidget {
  final String projectId;

  const AddConsumptionDialog({
    Key? key,
    required this.projectId,
  }) : super(key: key);

  @override
  State<AddConsumptionDialog> createState() => _AddConsumptionDialogState();
}

class _AddConsumptionDialogState extends State<AddConsumptionDialog> {
  final TextEditingController remarksController = TextEditingController();
  final consumedDateController = TextEditingController();
  List<TextEditingController> quantityControllers = [];
  DateTime selectedDate = DateTime.now();
  StageData? selectedStage;
  MaterialData? selectedMaterial;

  List<StageData> stages = [];
  List<MaterialData> materials = [];

  List<MaterialDetails> materialDetails = [];

  double grandTotal = 0;
  @override
  void initState() {
    super.initState();

    consumedDateController.text =
        DateFormat('dd-MM-yyyy').format(DateTime.now());
    selectedDate = DateTime.now();
    loadMaterials(widget.projectId);
    loadStages(widget.projectId);
  }

  bool get canSave {
    if (materialDetails.isEmpty) return false;

    return materialDetails.any(
      (item) => (double.tryParse(item.availableQuantity) ?? 0) > 0,
    );
  }

  @override
  void dispose() {
    consumedDateController.dispose();
    remarksController.dispose();
    super.dispose();
  }

  Future<void> loadStages(String projectId) async {
    final response = await HttpServices.getStages(
      projectId: projectId,
    );

    if (response != null && response.status) {
      setState(() {
        stages = response.data;
      });
    }
  }

  Future<void> loadMaterials(String projectId) async {
    final response = await HttpServices.getMaterials(
      projectId: projectId,
    );

    if (response != null && response.status) {
      setState(() {
        materials = response.data;
      });
    }
  }

  Future<void> loadMaterialDetails(
    String locationId,
    String materialId,
  ) async {
    /// getMaterialDetailsConsuption
  }
  Widget _infoTile(
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: Colors.grey,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void calculateGrandTotal() {
    double total = 0;

    for (int i = 0; i < materialDetails.length; i++) {
      final price = double.tryParse(materialDetails[i].unitPrice) ?? 0;

      final qty = double.tryParse(quantityControllers[i].text) ?? 0;

      total += price * qty;
    }

    setState(() {
      grandTotal = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(12),
      child: SizedBox(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * .85,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.inventory_2_outlined,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      "Add Stock Consumption",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: .5,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: consumedDateController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: "Consumed Date *",
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_month),
                      ),
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );

                        if (pickedDate != null) {
                          consumedDateController.text =
                              DateFormat('dd-MM-yyyy').format(pickedDate);
                        }
                      },
                    ),
                    const SizedBox(height: 15),
                    DropdownButtonFormField<StageData>(
                      value: selectedStage,
                      decoration: const InputDecoration(
                        labelText: "Stage",
                      ),
                      items: stages.map((e) {
                        return DropdownMenuItem<StageData>(
                          value: e,
                          child: Text(
                            e.stageName,
                          ),
                        );
                      }).toList(),
                      onChanged: (StageData? value) {
                        setState(() {
                          selectedStage = value;
                        });
                      },
                    ),
                    const SizedBox(height: 15),
                    DropdownButtonFormField<MaterialData>(
                      value: selectedMaterial,
                      decoration: const InputDecoration(
                        labelText: "Material",
                        border: OutlineInputBorder(),
                      ),
                      items: materials.map((material) {
                        return DropdownMenuItem<MaterialData>(
                          value: material,
                          child: Text(material.materialName),
                        );
                      }).toList(),
                      onChanged: (MaterialData? value) async {
                        if (value == null) return;

                        setState(() {
                          selectedMaterial = value;
                        });

                        final response =
                            await HttpServices.getMaterialDetailsConsumption(
                          locationId: widget.projectId,
                          materialId: value.materialId,
                        );

                        if (response != null && response.status) {
                          setState(() {
                            materialDetails.clear();
                            materialDetails.addAll(response.data);

                            quantityControllers = List.generate(
                              materialDetails.length,
                              (_) => TextEditingController(text: "1"),
                            );

                            calculateGrandTotal();
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    if (materialDetails.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: materialDetails.length,
                        itemBuilder: (context, index) {
                          final item = materialDetails[index];

                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.materialName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Divider(height: 20),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _infoTile(
                                          "Unit",
                                          item.unit,
                                          Icons.straighten,
                                        ),
                                      ),
                                      Expanded(
                                        child: _infoTile(
                                          "Amount",
                                          "₹${item.unitPrice}",
                                          Icons.currency_rupee,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _infoTile(
                                          "Available",
                                          item.availableQuantity,
                                          Icons.inventory_2_outlined,
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Quantity",
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            SizedBox(
                                                height: 45,
                                                child: TextFormField(
                                                  controller:
                                                      quantityControllers[
                                                          index],
                                                  keyboardType:
                                                      TextInputType.number,
                                                  onChanged: (value) {
                                                    calculateGrandTotal();
                                                  },
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                      horizontal: 10,
                                                      vertical: 8,
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                  ),
                                                )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                    const SizedBox(height: 15),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Grand Total : ₹$grandTotal",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Cancel",
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: canSave
                          ? () async {
                              if (materialDetails.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Please select a material"),
                                  ),
                                );
                                return;
                              }

                              final List<Map<String, dynamic>> materials = [];

                              for (int i = 0; i < materialDetails.length; i++) {
                                final item = materialDetails[i];

                                materials.add({
                                  "location_id": widget.projectId,
                                  "material_id": item.materialId,
                                  "quantity": quantityControllers[i].text,
                                  "unit_id": item.unitId,
                                  "in_stock": item.availableQuantity,
                                  "supplier_id": item.supplierId,
                                  "date_consumed": DateFormat(
                                    'dd-MM-yyyy',
                                  ).format(selectedDate),
                                });
                              }

                              final success =
                                  await HttpServices.addConsumedStock(
                                materials: materials,
                              );

                              if (success) {
                                if (context.mounted) {
                                  Navigator.pop(context, true);
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Failed to add stock consumption",
                                    ),
                                  ),
                                );
                              }
                            }
                          : null,
                      child: const Text("Save"),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
