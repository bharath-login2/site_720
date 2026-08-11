import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/estimate_request/estimate_request_model.dart';
import '../cubit/estimate_request_cubit.dart';
import '../cubit/estimate_request_state.dart';
import '../../../core/constants/colors.dart';

class EstimateRequestFormDialog extends StatefulWidget {
  final EstimateRequestModel? estimate;
  final String? projectId;

  const EstimateRequestFormDialog({
    super.key,
    this.projectId,
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

      // If projectId is NOT provided,
      // load projects for the Project dropdown.
      if (widget.projectId == null) {
        await cubit.getProjectList();
      }

      // If projectId IS provided,
      // directly load stages for that project.
      if (widget.projectId != null) {
        selectedProjectId = widget.projectId;

        await cubit.getStageList(widget.projectId!);
      }

      // For edit
      if (widget.estimate != null) {
        selectedStageId = widget.estimate!.stageId;

        // When editing without projectId,
        // use the project's ID from the existing estimate.
        if (widget.projectId == null) {
          selectedProjectId = widget.estimate!.projectId;

          if (selectedProjectId != null && selectedProjectId!.isNotEmpty) {
            await cubit.getStageList(selectedProjectId!);
          }
        }
      }

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

    // Project is fixed when projectId came from navigation.
    final bool isProjectFixed = widget.projectId != null;

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
              /// PROJECT DROPDOWN
              /// Show only when no projectId was passed through navigation.
              if (!isProjectFixed) ...[
                if (widget.projectId == null) ...[
                  DropdownButtonFormField<String>(
                    value: selectedProjectId,
                    isExpanded: true,
                    borderRadius: BorderRadius.circular(12),
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.grey,
                    ),
                    decoration: InputDecoration(
                      labelText: "Project",
                      hintText: "Select Project",
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
                    ),
                    items: cubit.projectList.map((project) {
                      return DropdownMenuItem<String>(
                        value: project.projectId.toString(),
                        child: Text(
                          project.projectName,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) async {
                      if (value == null) return;

                      setState(() {
                        selectedProjectId = value;
                        selectedStageId = null;
                      });

                      await cubit.getStageList(value);

                      if (mounted) {
                        setState(() {});
                      }
                    },
                  ),
                  const SizedBox(height: 15),
                ],
                const SizedBox(height: 15),
              ],

              /// STAGE
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
                      hintText: selectedProjectId == null
                          ? "Select project first"
                          : "Select Stage",
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

                    // Disable stage dropdown until project is available.
                    items: selectedProjectId == null
                        ? []
                        : cubit.stageList.map((stage) {
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

                    onChanged: selectedProjectId == null
                        ? null
                        : (value) {
                            setState(() {
                              selectedStageId = value;
                            });
                          },
                  );
                },
              ),

              const SizedBox(height: 15),

              /// REMARK
              TextField(
                controller: remarkController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Remark",
                  hintText: "Enter Remark",
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
            // Get project ID from either:
            // 1. Parent screen projectId
            // 2. Selected project from dropdown
            final String? finalProjectId =
                widget.projectId ?? selectedProjectId;

            // Validate project
            if (finalProjectId == null || finalProjectId.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Please select a project"),
                ),
              );
              return;
            }

            // Validate stage
            if (selectedStageId == null || selectedStageId!.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Please select a stage"),
                ),
              );
              return;
            }

            final cubit = context.read<EstimateRequestCubit>();

            try {
              if (widget.estimate == null) {
                // ADD
                await cubit.addEstimateRequest(
                  projectId: finalProjectId,
                  stageId: selectedStageId!,
                  remark: remarkController.text.trim(),
                );
              } else {
                // EDIT
                await cubit.updateEstimateRequest(
                  requestId: widget.estimate!.id,
                  projectId: finalProjectId,
                  stageId: selectedStageId!,
                  remark: remarkController.text.trim(),
                );
              }

              if (!mounted) return;

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    widget.estimate == null
                        ? "Estimate Request Added Successfully"
                        : "Estimate Request Updated Successfully",
                  ),
                ),
              );
            } catch (e) {
              if (!mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(e.toString()),
                ),
              );
            }
          },
          child: Text(
            widget.estimate == null ? "Submit" : "Update",
          ),
        ),
      ],
    );
  }
}
