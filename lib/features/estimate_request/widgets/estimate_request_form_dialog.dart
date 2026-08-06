import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/estimate_request/estimate_request_model.dart';
import '../cubit/estimate_request_cubit.dart';
import '../cubit/estimate_request_state.dart';
import '../../../core/constants/colors.dart';

class EstimateRequestFormDialog extends StatefulWidget {
  final EstimateRequestModel? estimate;
  final String projectId;

  const EstimateRequestFormDialog({
    super.key,
    required this.projectId,
    this.estimate,
  });

  @override
  State<EstimateRequestFormDialog> createState() =>
      _EstimateRequestFormDialogState();
}

class _EstimateRequestFormDialogState extends State<EstimateRequestFormDialog> {
  late TextEditingController remarkController;

  String? selectedProjectId;
  String? selectedStageId;

  @override
  void initState() {
    super.initState();

    remarkController = TextEditingController(
      text: widget.estimate?.remark ?? "",
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final cubit = context.read<EstimateRequestCubit>();

      await cubit.getStageList(widget.projectId);

      selectedStageId = widget.estimate?.stageId;

      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    remarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EstimateRequestCubit>();

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      title: Text(
        widget.estimate == null
            ? "Add Estimate Request"
            : "Edit Estimate Request",
      ),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Project
              // DropdownButtonFormField<String>(
              //   value: selectedProjectId,
              //   decoration: const InputDecoration(
              //     labelText: "Project",
              //     border: OutlineInputBorder(),
              //   ),
              //   items: cubit.projectList.map((project) {
              //     return DropdownMenuItem<String>(
              //       value: project.projectId,
              //       child: Text(project.projectName),
              //     );
              //   }).toList(),
              //   onChanged: (value) async {
              //     setState(() {
              //       selectedProjectId = value;
              //       selectedStageId = null;
              //     });

              //     await cubit.getStageList(value!);

              //     if (mounted) {
              //       setState(() {});
              //     }
              //   },
              // ),

              const SizedBox(height: 15),

              /// Stage
              BlocBuilder<EstimateRequestCubit, EstimateRequestState>(
                builder: (context, state) {
                  final cubit = context.read<EstimateRequestCubit>();

                  return DropdownButtonFormField<String>(
                    value: selectedStageId,
                    isExpanded: true,
                    borderRadius: BorderRadius.circular(12),
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.grey,
                    ),
                    decoration: InputDecoration(
                      labelText: "Stage",
                      hintText: "Select Stage",
                      // prefixIcon: const Icon(Icons.account_tree_outlined),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.primaryColor,
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.red,
                        ),
                      ),
                    ),
                    items: cubit.stageList.map((stage) {
                      return DropdownMenuItem<String>(
                        value: stage.stageId,
                        child: Text(
                          stage.stageName,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedStageId = value;
                      });
                    },
                  );
                },
              ),

              const SizedBox(height: 15),

              /// Remark
              TextField(
                controller: remarkController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Remark",
                  border: OutlineInputBorder(),
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
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () async {
            if (selectedStageId == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Please select a stage"),
                ),
              );
              return;
            }

            // if (remarkController.text.trim().isEmpty) {
            //   ScaffoldMessenger.of(context).showSnackBar(
            //     const SnackBar(
            //       content: Text("Please enter a remark"),
            //     ),
            //   );
            //   return;
            // }
            final cubit = context.read<EstimateRequestCubit>();

            if (widget.estimate == null) {
              await cubit.addEstimateRequest(
                projectId: widget.projectId,
                stageId: selectedStageId!,
                remark: remarkController.text.trim(),
              );
            } else {
              await cubit.updateEstimateRequest(
                requestId: widget.estimate!.id,
                projectId: widget.projectId,
                stageId: selectedStageId!,
                remark: remarkController.text.trim(),
              );
            }

            if (!mounted) return;

            Navigator.pop(context);

            widget.estimate == null
                ? ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Estimate Request Added Successfully"),
                    ),
                  )
                : ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Estimate Request Updated Successfully"),
                    ),
                  );
          },
          child: Text(
            widget.estimate == null ? "Submit" : "Update",
          ),
        ),
      ],
    );
  }
}
