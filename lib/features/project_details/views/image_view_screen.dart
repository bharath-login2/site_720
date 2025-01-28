import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:site_720/core/widgets/appbar.dart';

class ImageViewer extends StatelessWidget {
  const ImageViewer({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    String image = args["image"]!;
    log(image);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: simpleAppbar(context, args["title"]!),
      body: Center(
        child: Image.network(image),
      ),
    );
  }
}
