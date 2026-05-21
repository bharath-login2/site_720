import 'package:flutter/material.dart';

class ExpenseListScreen extends StatelessWidget {
  final String title;

  const ExpenseListScreen({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> expenseList = [
      {
        "name": "Arun Kumar",
        "date": "14-05-2026",
        "vehicle": "Car",
        "from": "Kochi",
        "to": "Trivandrum",
        "km": "220",
        "amount": "4500",
        "status": "Approved",
        "remark": "Client Meeting",
      },
      {
        "name": "Rahul",
        "date": "13-05-2026",
        "vehicle": "Bike",
        "from": "Aluva",
        "to": "Kakkanad",
        "km": "35",
        "amount": "500",
        "status": "Pending",
        "remark": "Office Visit",
      },
      {
        "name": "Vishnu",
        "date": "12-05-2026",
        "vehicle": "Bus",
        "from": "Thrissur",
        "to": "Kochi",
        "km": "90",
        "amount": "1200",
        "status": "Rejected",
        "remark": "Site Inspection",
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),

      /// APPBAR
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(247, 100, 38, 53),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: expenseList.length,
        itemBuilder: (context, index) {
          final item = expenseList[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
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
                /// TOP
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: const Color.fromARGB(247, 100, 38, 53)
                          .withOpacity(0.1),
                      child: const Icon(
                        Icons.person,
                        color: Color.fromARGB(247, 100, 38, 53),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item["name"],
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item["date"],
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
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

                const SizedBox(height: 18),

                /// DETAILS
                buildRow(
                  Icons.directions_car,
                  "Vehicle",
                  item["vehicle"],
                ),

                buildRow(
                  Icons.location_on_outlined,
                  "From",
                  item["from"],
                ),

                buildRow(
                  Icons.location_city,
                  "To",
                  item["to"],
                ),

                buildRow(
                  Icons.route,
                  "KM",
                  item["km"],
                ),

                buildRow(
                  Icons.currency_rupee,
                  "Amount",
                  item["amount"],
                ),

                buildRow(
                  Icons.notes,
                  "Remark",
                  item["remark"],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: const Color.fromARGB(247, 100, 38, 53),
          ),
          const SizedBox(width: 10),
          Text(
            "$title : ",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
