// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:site_720/core/constants/colors.dart';

class AmountContainer extends StatelessWidget {
  String title;
  String amount;
  AmountContainer({
    super.key,
    required this.title,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * .28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppColors.backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.8),
              blurRadius: 6,
              offset: const Offset(1, 1),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 9, color: AppColors.primaryColor),
              ),
              Text(
                amount,
                style: const TextStyle(color: AppColors.primaryColor),
              ),
            ],
          ),
        ));
  }
}

class SmallContainer extends StatelessWidget {
  String title;
  String amount;
  SmallContainer({
    super.key,
    required this.title,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * .25,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppColors.backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.8),
              blurRadius: 6,
              offset: const Offset(1, 1),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 9, color: AppColors.primaryColor),
              ),
              Text(
                amount,
                style: const TextStyle(color: AppColors.primaryColor),
              ),
            ],
          ),
        ));
  }
}
