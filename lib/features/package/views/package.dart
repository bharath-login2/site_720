// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:site_720/core/constants/colors.dart';
import 'package:site_720/core/widgets/appbar.dart';
import 'package:site_720/features/package/cubit/package_cubit.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../../core/widgets/connectivity_dialog.dart';
import '../../connectivity/cubit/connectivity_cubit.dart';
import '../../connectivity/cubit/connectivity_state.dart';
import '../cubit/package_state.dart';

class Package extends StatelessWidget {
  Package({super.key});

  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  String packageUrl = '';

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    String projectId = args["id"]!;
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: simpleAppbar(context, "Package", true),
        body: BlocProvider(
          create: (context) => PackageCubit(projectId),
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
              BlocListener<PackageCubit, PackageState>(
                listener: (context, state) {
                  if (state is PackageSuccess) {
                    packageUrl = state.response.pdfUrl;
                  }
                },
              )
            ],
            child: BlocBuilder<PackageCubit, PackageState>(
              builder: (context, state) {
                if (packageUrl != "") {
                  return Container(
                    color: Colors.red,
                    child: SfPdfViewer.network(
                      packageUrl,
                      key: _pdfViewerKey,
                    ),
                  );
                } else {
                  return const Center();
                }
              },
            ),
          ),
        ));
  }
}
