import 'package:flutter/material.dart';
import '../../data/models/task/milestoneModel.dart';


class MilestoneWidget extends StatelessWidget {
  final List<Milestone> milestoneList;
  final String currentMilestone;

  const MilestoneWidget({
    super.key,
    required this.milestoneList,
    required this.currentMilestone,
  });

  @override
  Widget build(BuildContext context) {
    final currentIndex = milestoneList.indexWhere(
      (m) => m.milestone == currentMilestone,
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(milestoneList.length * 2 - 1, (index) {
          if (index.isEven) {
            // Milestone dot and label
            int milestoneIndex = index ~/ 2;
            final milestone = milestoneList[milestoneIndex];

            bool isCompleted = milestoneIndex < currentIndex;
            bool isCurrent = milestoneIndex == currentIndex;

            Color circleColor = isCompleted
                ? Colors.green
                : isCurrent
                    ? Colors.orange
                    : Colors.grey;

            return Column(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: circleColor,
                  child: isCompleted
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
                const SizedBox(height: 4),
                Text(
                  milestone.milestone,
                  style: TextStyle(
                    fontSize: 10,
                    color: circleColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          } else {
            // Connector line between milestones
            int lineIndex = index ~/ 2;
            bool isPassed = lineIndex < currentIndex;

            return Container(
              width: 30,
              height: 4,
              color: isPassed ? Colors.green : Colors.grey,
            );
          }
        }),
      ),
    );
  }
}
