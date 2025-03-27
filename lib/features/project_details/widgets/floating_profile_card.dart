import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class FloatingProfileCard extends StatelessWidget {
  final String name;
  final String address;
  final String phoneNumber;

  const FloatingProfileCard(
      {super.key,
      required this.name,
      required this.address,
      required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
            blurRadius: 3,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColors.primaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.8),
                      blurRadius: 6,
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                )),
            const SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (address != '')
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .6,
                    child: Text(
                      address,
                      // overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                if (phoneNumber != '')
                  Text(
                    phoneNumber,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
