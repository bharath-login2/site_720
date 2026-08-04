import 'package:flutter/material.dart';

import '../../../data/models/livemap/livemap_model.dart';
import 'build_info_row.dart';

class ProjectPopup extends StatelessWidget {
  final LiveMapData project;
  final VoidCallback onClose;
  final Map<String, Color> Function(String) getStatusColor;

  const ProjectPopup({
    super.key,
    required this.project,
    required this.onClose,
    required this.getStatusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(
          color: Colors.black,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    project.projectName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'BarlowCondensed',
                      color: Colors.black87,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onClose,
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            BuildInfoRow(
              title: "Location",
              value: project.location,
            ),
            BuildInfoRow(
              title: "District",
              value: project.district,
            ),
            BuildInfoRow(
              title: "Type",
              value: project.projectType,
            ),
            BuildInfoRow(
              title: "Supervisor",
              value: project.supervisor,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text(
                  "Status",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: getStatusColor(project.status)["bg"],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    project.status.toUpperCase(),
                    style: TextStyle(
                      color: getStatusColor(project.status)["text"],
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
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
