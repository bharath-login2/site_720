import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';

Widget shimmerContainer(double height, double width) {
  return FadeShimmer(
    height: height,
    width: width,
    radius: 4,
    // highlightColor: Colors.black,
    // baseColor: Colors.grey.shade300,
    fadeTheme: FadeTheme.light,
  );
}
