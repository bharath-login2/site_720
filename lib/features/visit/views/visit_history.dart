import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/widgets/appbar.dart';
import '../../../core/constants/routes.dart';
import '../../../core/widgets/connectivity_dialog.dart';
import '../../../core/widgets/shimmer.dart';
import '../../../data/models/visit/visit_history_model.dart';
import '../../connectivity/cubit/connectivity_cubit.dart';
import '../../connectivity/cubit/connectivity_state.dart';
import '../cubit/visit_history_cubit.dart';
import '../cubit/visit_history_state.dart';
import '../cubit/visit_state.dart';

class VisitHistory extends StatelessWidget {
  VisitHistory({super.key});

  final formKey = GlobalKey<FormState>();
  XFile? image;
  String visitId = "";

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    visitId = args["visit_id"]!;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: simpleAppbar(context, "Visit History", false),
      body: BlocProvider(
        create: (context) =>
            VisitHistoryCubit(visitId)..getVisitHistoryDetails(),
        child: MultiBlocListener(
          listeners: [
            BlocListener<ConnectivityCubit, ConnectivityState>(
              listener: (context, state) {
                if (state is ConnectivityDisconnected) {
                  if (connStatus == true) {
                    connStatus = false;
                    connectivityDialog(context);
                  }
                } else {
                  connStatus = true;
                }
              },
            ),
          ],
          child: BlocBuilder<VisitHistoryCubit, VisitHistoryState>(
            builder: (context, state) {
              final cubit = context.read<VisitHistoryCubit>();

              if (state is VisitLoading || state is VisitInitial) {
                return ListView.builder(
                  itemCount: 7,
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: shimmerContainer(100, 70),
                    );
                  },
                );
              }

              if (state is VisitHistoryDetailsSuccess &&
                  state.response.data.data.isNotEmpty) {
                final vistList = state.response.data.data;

                return RefreshIndicator(
                  onRefresh: () async {
                    cubit.getVisitHistoryDetails();
                  },
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    itemCount: vistList.length,
                    itemBuilder: (context, index) {
                      final item = vistList[index];
                      return Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: InkWell(
                          onTap: () {
                            connStatus = true;
                            Navigator.pushNamed(
                              context,
                              AppRoutes.vistDetails,
                              arguments: {"visit_id": item.questionId},
                            );
                          },
                          child: buildVisitCard(context, cubit, item),
                        ),
                      );
                    },
                  ),
                );
              }

              if (state is VisitHistoryDetailsSuccess &&
                  state.response.data.data.isEmpty) {
                return const Center(child: Text("Visit Answers is Empty"));
              }

              return const Center(child: Text("Something went wrong"));
            },
          ),
        ),
      ),
    );
  }

  Widget buildVisitCard(
      BuildContext context, VisitHistoryCubit cubit, VisitHistoryMode item) {
    return Container(
      width: MediaQuery.of(context).size.width * .9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.grey.shade50,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
            blurRadius: 3,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Question: ${item.question}',
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    item.fileType == "0" || item.fileType == "1"
                        ? Text(
                            'Answer: ${item.answer}',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : item.fileType == "2"
                            ? GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/imageViewer', 
                                    arguments: {
                                      "image": item.filePath,
                                      "title": "View Image"
                                    },
                                  );
                                },
                                child: Hero(
                                  tag: item.filePath,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CachedNetworkImage(
                                      imageUrl: item.filePath,
                                      height: 150,
                                      width: 150,
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) {
                                        return const Icon(Icons.error,
                                            color: Colors.red);
                                      },
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
