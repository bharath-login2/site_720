import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:site_720/core/constants/colors.dart';
import '../widgets/site_drawing_request_card.dart';
import '../cubit/site_drawing_request_cubit.dart';
import '../cubit/site_drawing_request_state.dart';
import '../widgets/site_drawing_request_form_dialog.dart';

class SiteDrawingRequestScreen extends StatefulWidget {
  const SiteDrawingRequestScreen({super.key});

  @override
  State<SiteDrawingRequestScreen> createState() =>
      _SiteDrawingRequestScreenState();
}

class _SiteDrawingRequestScreenState extends State<SiteDrawingRequestScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SiteDrawingRequestCubit>().getSiteDrawingRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      "Site Drawing Requests ",
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
                    InkWell(
                      onTap: () {
                        final cubit = context.read<SiteDrawingRequestCubit>();

                        showDialog(
                          context: context,
                          builder: (_) => BlocProvider.value(
                            value: cubit,
                            child: const SiteDrawingRequestForm(),
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
      body: BlocBuilder<SiteDrawingRequestCubit, SiteDrawingRequestState>(
        builder: (context, state) {
          if (state is SiteDrawingRequestLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is SiteDrawingRequestError) {
            return Center(
              child: Text(state.message),
            );
          }

          if (state is SiteDrawingRequestLoaded) {
            final requests = state.response.data;

            if (requests.isEmpty) {
              return const Center(
                child: Text("No drawing requests found"),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              // itemCount: state.response.data.length,
              itemCount: requests.length,
              separatorBuilder: (context, index) {
                return const SizedBox(height: 12);
              },
              itemBuilder: (context, index) {
                return SiteDrawingRequestCard(
                  item: requests[index],
                );
              },
            );
          }

          return const Center(
            child: Text("No data"),
          );
        },
      ),
    );
  }
}
