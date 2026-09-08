import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:site_720/core/constants/colors.dart';
import '../cubit/deduction_work_request_cubit.dart';
import '../cubit/deduction_work_request_state.dart';
import '../widgets/deduction_work_request_card.dart';
import '../widgets/deduction_work_request_form_dialog.dart';

typedef DeductionWorkRequestListPage = DeductionWorkRequestScreen;

class DeductionWorkRequestScreen extends StatefulWidget {
  final String projectId;

  const DeductionWorkRequestScreen({
    super.key,
    required this.projectId,
  });

  @override
  State<DeductionWorkRequestScreen> createState() =>
      _DeductionWorkRequestScreenState();
}

class _DeductionWorkRequestScreenState
    extends State<DeductionWorkRequestScreen> {
  late String effectiveProjectId;

  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    effectiveProjectId = widget.projectId;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!isInitialized) {
      isInitialized = true;

      final args = ModalRoute.of(context)?.settings.arguments;

      // Handle route arguments if passed via named route
      if (args is Map<String, dynamic>) {
        final argProjectId = args["project_id"]?.toString();
        if (argProjectId != null && argProjectId.isNotEmpty) {
          effectiveProjectId = argProjectId;
        }
      } else if (args is Map<String, String>) {
        final argProjectId = args["project_id"];
        if (argProjectId != null && argProjectId.isNotEmpty) {
          effectiveProjectId = argProjectId;
        }
      } else if (args is String && args.isNotEmpty) {
        effectiveProjectId = args;
      }

      print(
        "DEDUCTION WORK EFFECTIVE PROJECT ID: $effectiveProjectId",
      );

      // Load Deduction Work Requests
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        context.read<DeductionWorkRequestCubit>().getDeductionWorkRequests(
              projectId: effectiveProjectId,
            );
      });
    }
  }

  // ============================================================
  // OPEN ADD REQUEST DIALOG
  // ============================================================

  void _openAddRequestDialog() {
    print(
      "========== OPEN DEDUCTION ADD DIALOG ==========",
    );
    print(
      "PROJECT ID -> DIALOG : $effectiveProjectId",
    );
    print(
      "===============================================",
    );

    final cubit = context.read<DeductionWorkRequestCubit>();

    showDialog(
      context: context,
      builder: (_) {
        return BlocProvider.value(
          value: cubit,
          child: DeductionWorkRequestFormDialog(
            projectId: effectiveProjectId,
          ),
        );
      },
    ).then((result) {
      if (result == true) {
        cubit.getDeductionWorkRequests(
          projectId: effectiveProjectId,
        );
      }
    });
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      // ========================================================
      // APP BAR
      // ========================================================
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          MediaQuery.of(context).size.height * 0.2,
        ),
        child: Container(
          height: MediaQuery.of(context).size.height * .15,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/images/appbar.png",
              ),
              fit: BoxFit.fill,
            ),
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
              top: 35,
              right: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title
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
                    const SizedBox(width: 10),
                    const Text(
                      "Deduction Work Request",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        fontFamily: "Lobster",
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                // Add Button
                InkWell(
                  onTap: _openAddRequestDialog,
                  borderRadius: BorderRadius.circular(20),
                  child: const CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.lightPrimary,
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================
      body: BlocBuilder<DeductionWorkRequestCubit, DeductionWorkRequestState>(
        builder: (context, state) {
          // Loading
          if (state is DeductionWorkRequestLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Error
          if (state is DeductionWorkRequestError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      state.message.replaceAll("Exception: ", ""),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        context
                            .read<DeductionWorkRequestCubit>()
                            .getDeductionWorkRequests(
                              projectId: effectiveProjectId,
                            );
                      },
                      icon: const Icon(
                        Icons.refresh,
                        size: 18,
                      ),
                      label: const Text("Retry"),
                    ),
                  ],
                ),
              ),
            );
          }

          // Loaded
          if (state is DeductionWorkRequestLoaded) {
            final requests = state.response.data;

            // Empty
            if (requests.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.assignment_outlined,
                      size: 56,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "No Deduction work requests found",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _openAddRequestDialog,
                      icon: const Icon(
                        Icons.add,
                        size: 18,
                      ),
                      label: const Text(
                        "Create Deduction Work Request",
                      ),
                    ),
                  ],
                ),
              );
            }

            // Request List
            return RefreshIndicator(
              onRefresh: () async {
                await context
                    .read<DeductionWorkRequestCubit>()
                    .getDeductionWorkRequests(
                      projectId: effectiveProjectId,
                    );
              },
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                itemCount: requests.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 12);
                },
                itemBuilder: (context, index) {
                  return DeductionWorkRequestCard(
                    item: requests[index],
                    projectId: effectiveProjectId,
                  );
                },
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
