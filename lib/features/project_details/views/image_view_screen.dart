import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:site_720/core/widgets/appbar.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ImageViewer extends StatelessWidget {
  const ImageViewer({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    final String file = args["image"]!;
    final bool isPdf = file.toLowerCase().endsWith(".pdf");

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: simpleAppbar(context, args["title"]!, true),
      body: isPdf
          ? SfPdfViewer.network(
              file,
            )
          : PhotoView(
              imageProvider: CachedNetworkImageProvider(file),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2,
              initialScale: PhotoViewComputedScale.contained,
              backgroundDecoration: const BoxDecoration(
                color: Colors.black,
              ),
              loadingBuilder: (context, event) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 40,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Failed to load file",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
