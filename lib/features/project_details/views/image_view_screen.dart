import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:site_720/core/widgets/appbar.dart';

class ImageViewer extends StatelessWidget {
  const ImageViewer({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    String image = args["image"]!;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: simpleAppbar(context, args["title"]!, true),
      body: Center(
        child: PhotoView(
          imageProvider: CachedNetworkImageProvider(image),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 2,
          initialScale: PhotoViewComputedScale.contained,
          backgroundDecoration:
              const BoxDecoration(color: Colors.black), // Background color
          loadingBuilder: (context, event) => const Center(
            child: CircularProgressIndicator(), // Loading indicator
          ),
          errorBuilder: (context, error, stackTrace) => const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, color: Colors.red, size: 30),
                SizedBox(height: 8),
                Text(
                  'Failed to load image',
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
              ],
            ), // Error widget
          ),
        ),
      ),
    );
  }
}
