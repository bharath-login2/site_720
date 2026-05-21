// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';

class DashContainer extends StatelessWidget {
  String title;
  String count;
  DashContainer({
    super.key,
    required this.title,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * .4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppColors.dashContainer,
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
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  // color: AppColors.coffie,
                ),
              ),
              Text(
                count,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  // color: AppColors.coffie,
                ),
              ),
              const Align(
                alignment: Alignment.bottomRight,
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  child: Icon(
                    Icons.arrow_forward,
                    size: 15,
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
