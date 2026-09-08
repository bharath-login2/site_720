import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/routes.dart';

class RequestDropdownCard extends StatefulWidget {
  const RequestDropdownCard({super.key});

  @override
  State<RequestDropdownCard> createState() => _RequestDropdownCardState();
}

class _RequestDropdownCardState extends State<RequestDropdownCard> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
            blurRadius: 3,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
            onTap: () {
              setState(() {
                isOpen = !isOpen;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 12,
              ),
              decoration: const BoxDecoration(
                color: AppColors.dashContainer,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Staff Request",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: isOpen ? 0.25 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: const CircleAvatar(
                      radius: 12,
                      backgroundColor: AppColors.primaryColor,
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(5),
              bottomRight: Radius.circular(5),
            ),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: isOpen
                  ? Material(
                      color: Colors.white,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildItem(
                            context,
                            "Estimation Request",
                            () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.estimateRequest,
                              );
                            },
                          ),
                          const Divider(height: 1),
                          _buildItem(
                            context,
                            "Site drawing Request",
                            () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.SiteDrawingRequest,
                              );
                            },
                          ),
                          const Divider(height: 1),
                          _buildItem(
                            context,
                            "Deduction Work Request",
                            () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.deductionWorkRequestProjectSelect,
                              );
                            },
                          ),

                          const Divider(height: 1),
                          _buildItem(
                            context,
                            "Extra Work Request",
                            () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.extraWorkProjectSelect,
                              );
                            },
                          ),
                          // _buildItem(
                          //   context,
                          //   "Extra Work Request",
                          //   () {
                          //     Navigator.pushNamed(context, "/extraWork");
                          //   },
                          // ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(
    BuildContext context,
    String text,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: () {
        setState(() {
          isOpen = false;
        });

        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const CircleAvatar(
              radius: 11,
              backgroundColor: AppColors.primaryColor,
              child: Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
