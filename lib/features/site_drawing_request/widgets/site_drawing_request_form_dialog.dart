import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/colors.dart';
import '../../../data/models/site_drawing_request/site_drawing_request_model.dart';
import '../cubit/site_drawing_request_cubit.dart';
import '../cubit/site_drawing_request_state.dart';

class SiteDrawingRequestForm extends StatefulWidget {
  final SiteDrawingRequest? request;

  const SiteDrawingRequestForm({
    super.key,
    this.request,
  });

  @override
  State<SiteDrawingRequestForm> createState() => _SiteDrawingRequestFormState();
}

class _SiteDrawingRequestFormState extends State<SiteDrawingRequestForm> {
  late TextEditingController remarkController;

  String? selectedProjectId;
  List<String> selectedStageIds = [];

  @override
  void initState() {
    super.initState();

    remarkController = TextEditingController(
      text: widget.request?.remark ?? "",
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final cubit = context.read<SiteDrawingRequestCubit>();

      // Load project list
      await cubit.getProjectList();

      // EDIT
      if (widget.request != null) {
        selectedProjectId = widget.request!.projectId;

        String stages =
            widget.request!.stages.replaceAll('[', '').replaceAll(']', '');

        selectedStageIds = stages
            .split(',')
            .map((id) => id.trim())
            .where((id) => id.isNotEmpty)
            .toList();

        // Load stages for selected project
        if (selectedProjectId != null && selectedProjectId!.isNotEmpty) {
          await cubit.getStageList(selectedProjectId!);
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
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      title: Text(
        widget.request == null
            ? "Add Site Drawing Request"
            : "Edit Site Drawing Request",
      ),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: BlocBuilder<SiteDrawingRequestCubit, SiteDrawingRequestState>(
            builder: (context, state) {
              final cubit = context.read<SiteDrawingRequestCubit>();

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // PROJECT
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

                        // Clear stages because project changed.
                        selectedStageIds = [];
                      });

                      await cubit.getStageList(value);

                      if (mounted) {
                        setState(() {});
                      }
                    },
                  ),

                  const SizedBox(height: 18),

                  // STAGE
                  const Text(
                    "Stage",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // STAGE

                  Builder(
                    builder: (context) {
                      final cubit = context.read<SiteDrawingRequestCubit>();

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: selectedProjectId == null ||
                                  cubit.stageList.isEmpty
                              ? null
                              : () {
                                  showDialog(
                                    context: context,
                                    builder: (dialogContext) {
                                      return StatefulBuilder(
                                        builder: (context, setDialogState) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                            ),
                                            title: const Text("Select Stage"),
                                            content: SizedBox(
                                              width: 350,
                                              child: ListView(
                                                shrinkWrap: true,
                                                children: cubit.stageList
                                                    .map((stage) {
                                                  final String stageId =
                                                      stage.stageId.toString();

                                                  final bool isSelected =
                                                      selectedStageIds
                                                          .contains(stageId);

                                                  return CheckboxListTile(
                                                    dense: true,
                                                    contentPadding:
                                                        EdgeInsets.zero,
                                                    activeColor:
                                                        AppColors.primaryColor,
                                                    title: Text(
                                                      stage.stageName,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    value: isSelected,
                                                    onChanged: (bool? checked) {
                                                      setDialogState(() {
                                                        if (checked == true) {
                                                          if (!selectedStageIds
                                                              .contains(
                                                                  stageId)) {
                                                            selectedStageIds
                                                                .add(stageId);
                                                          }
                                                        } else {
                                                          selectedStageIds
                                                              .remove(stageId);
                                                        }
                                                      });

                                                      // Update main form immediately
                                                      setState(() {});
                                                    },
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(dialogContext);
                                                },
                                                child: const Text("Done"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Stage",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        selectedProjectId == null
                                            ? "Select project first"
                                            : selectedStageIds.isEmpty
                                                ? "Select Stage"
                                                : cubit.stageList
                                                    .where(
                                                      (stage) =>
                                                          selectedStageIds
                                                              .contains(stage
                                                                  .stageId
                                                                  .toString()),
                                                    )
                                                    .map((stage) =>
                                                        stage.stageName)
                                                    .join(", "),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  // Selected stage count
                  if (selectedStageIds.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      "${selectedStageIds.length} stage(s) selected",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],

                  const SizedBox(height: 18),

                  // REMARK
                  TextField(
                    controller: remarkController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: "Remark",
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),

      // BUTTONS
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () async {
            // VALIDATE PROJECT
            if (selectedProjectId == null || selectedProjectId!.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Please select a project"),
                ),
              );
              return;
            }

            // VALIDATE STAGES
            if (selectedStageIds.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Please select at least one stage",
                  ),
                ),
              );
              return;
            }

            final cubit = context.read<SiteDrawingRequestCubit>();

            try {
              // ADD
              if (widget.request == null) {
                await cubit.addSiteDrawingRequest(
                  projectId: selectedProjectId!,
                  stages: selectedStageIds,
                  remark: remarkController.text.trim(),
                );
              }

              // EDIT
              else {
                await cubit.updateSiteDrawingRequest(
                  requestId: widget.request!.id,
                  projectId: selectedProjectId!,
                  stages: selectedStageIds,
                  remark: remarkController.text.trim(),
                );
              }

              if (!mounted) return;

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    widget.request == null
                        ? "Site Drawing Request Added Successfully"
                        : "Site Drawing Request Updated Successfully",
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
            widget.request == null ? "Submit" : "Update",
          ),
        ),
      ],
    );
  }
}
