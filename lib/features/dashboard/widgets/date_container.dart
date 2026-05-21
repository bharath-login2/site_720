// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
// For DateFormat

import '../../../core/constants/colors.dart';

class DateContainer extends StatelessWidget {
  String count;

  DateContainer({
    super.key,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .4,
  
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: const Color.fromARGB(255, 255, 255, 255),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 10,
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              child: Icon(
                Icons.calendar_month,
                size: 12,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              count,  // Display date next to the icon
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
