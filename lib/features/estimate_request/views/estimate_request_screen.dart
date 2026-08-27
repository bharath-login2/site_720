import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/estimate_request_cubit.dart';
import '../cubit/estimate_request_state.dart';
import 'package:site_720/core/constants/colors.dart';
import '../widgets/estimate_request_card.dart';
import '../widgets/estimate_request_form_dialog.dart';
import '../../../core/utilities/permission_manager.dart';

class EstimateRequestScreen extends StatelessWidget {
  const EstimateRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final String? projectId = args?["id"]?.toString();

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
            padding: const EdgeInsets.only(left: 20.0, top: 35, right: 20),
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
                      "Estimate Requests ",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          fontFamily: "Lobster",
                          color: Colors.white),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(width: 10),
                    if (PermissionManager.hasPermission('add estimate request'))
                      InkWell(
                        onTap: () {
                          final cubit = context.read<EstimateRequestCubit>();

                          showDialog(
                            context: context,
                            builder: (_) => BlocProvider.value(
                              value: cubit,
                              child: EstimateRequestFormDialog(
                                projectId: projectId,
                              ),
                            ),
                          );
                        },
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
              ],
            ),
          ),
        ),
      ),
      body: BlocBuilder<EstimateRequestCubit, EstimateRequestState>(
        builder: (context, state) {
          if (state is EstimateRequestLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is EstimateRequestError) {
            return Center(
              child: Text(state.message),
            );
          }

          if (state is EstimateRequestLoaded) {
            final requests = state.response.data;

            if (requests.isEmpty) {
              return const Center(
                child: Text("No Estimate requests found"),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                await context
                    .read<EstimateRequestCubit>()
                    .getEstimateRequests();
              },
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                itemCount: state.response.data.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 12);
                },
                itemBuilder: (context, index) {
                  return EstimateRequestCard(
                    item: state.response.data[index],
                    projectId: projectId,
                    onTap: () {},
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
