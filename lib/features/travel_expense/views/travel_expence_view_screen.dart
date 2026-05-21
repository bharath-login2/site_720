import 'package:flutter/material.dart';

class TravelExpenseViewScreen extends StatelessWidget {
  final Map<String, dynamic> item;

  const TravelExpenseViewScreen({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(247, 100, 38, 53),
        title: const Text(
          "Travel Details",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// TOP PROFILE
              Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: const Color.fromARGB(
                      247,
                      100,
                      38,
                      53,
                    ).withOpacity(0.1),
                    child: const Icon(
                      Icons.person,
                      size: 30,
                      color: Color.fromARGB(
                        247,
                        100,
                        38,
                        53,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item["name"],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: item["status"] == "Approved"
                                ? Colors.green.withOpacity(0.12)
                                : item["status"] == "Pending"
                                    ? Colors.orange.withOpacity(0.12)
                                    : Colors.red.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            item["status"],
                            style: TextStyle(
                              color: item["status"] == "Approved"
                                  ? Colors.green
                                  : item["status"] == "Pending"
                                      ? Colors.orange
                                      : Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// DETAILS GRID
              Row(
                children: [
                  Expanded(
                    child: buildDetails(
                      "Date",
                      item["date"],
                    ),
                  ),
                  Expanded(
                    child: buildDetails(
                      "KM",
                      item["km"],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: buildDetails(
                      "From",
                      item["from"],
                    ),
                  ),
                  Expanded(
                    child: buildDetails(
                      "To",
                      item["to"],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              buildFullDetails(
                "Vehicle Type",
                item["vehicle"],
              ),

              buildFullDetails(
                "Total Amount",
                "₹ ${item["amount"]}",
              ),

              buildFullDetails(
                "Remark",
                item["remark"],
              ),

              const SizedBox(height: 24),

              /// ATTACHMENT TITLE
              const Text(
                "Attachments",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              /// DUMMY ATTACHMENTS
              Row(
                children: [
                  buildAttachment(),
                  const SizedBox(width: 14),
                  buildAttachment(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDetails(
    String title,
    String value,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget buildFullDetails(
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAttachment() {
    return Container(
      height: 90,
      width: 90,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(
        Icons.image,
        size: 40,
        color: Colors.grey,
      ),
    );
  }
}
