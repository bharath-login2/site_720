import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/estimate_request/estimate_request_model.dart';
import '../../../data/models/extraworklist/staffListModel.dart';
import '../cubit/estimate_request_cubit.dart';

class EstimateRequestApproveFormDialog extends StatefulWidget {
  final EstimateRequestModel estimate;

  const EstimateRequestApproveFormDialog({
    super.key,
    required this.estimate,
  });

  @override
  State<EstimateRequestApproveFormDialog> createState() =>
      _EstimateRequestApproveFormDialogState();
}

class _EstimateRequestApproveFormDialogState
    extends State<EstimateRequestApproveFormDialog> {
  List<String> selectedStaffIds = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //await context.read<EstimateRequestCubit>().getStaffList();

      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<EstimateRequestCubit>();

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      title: const Text(
        "Approve & Assign Staff",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Assign Staff *",
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade400,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: cubit.staffList.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount: cubit.staffList.length,
                      itemBuilder: (context, index) {
                        final StaffList staff = cubit.staffList[index];

                        return CheckboxListTile(
                          dense: true,
                          value: selectedStaffIds.contains(
                            staff.staffId,
                          ),
                          title: Text(staff.staffName),
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (value) {
                            setState(() {
                              if (value == true) {
                                selectedStaffIds.add(
                                  staff.staffId,
                                );
                              } else {
                                selectedStaffIds.remove(
                                  staff.staffId,
                                );
                              }
                            });
                          },
                        );
                      },
                    ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Selecting at least one staff member is mandatory.",
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            "Cancel",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade700,
          ),
          onPressed: () async {
            if (selectedStaffIds.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Please select at least one staff member.",
                  ),
                ),
              );
              return;
            }

            // TODO:
            // await cubit.approveEstimateRequest(
            //   requestId: widget.estimate.id,
            //   staffIds: selectedStaffIds,
            // );

            if (!mounted) return;

            Navigator.pop(context);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "Estimate Request Approved Successfully",
                ),
              ),
            );
          },
          child: const Text(
            "Approve & Assign",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
