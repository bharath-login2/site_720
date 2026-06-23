import 'package:flutter/material.dart';

class TravelExpenseViewScreen extends StatefulWidget {
  final Map<String, dynamic> item;

  const TravelExpenseViewScreen({
    super.key,
    required this.item,
  });

  @override
  State<TravelExpenseViewScreen> createState() =>
      _TravelExpenseViewScreenState();
}

class _TravelExpenseViewScreenState extends State<TravelExpenseViewScreen> {
  String selectedStatus = "Approved";

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    final List travelDetails = (item["travel_details"] ?? []) as List;

    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),

      /// APPBAR
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(
          247,
          100,
          38,
          53,
        ),
        title: const Text(
          "Travel Details",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      /// BODY
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
              /// PROFILE SECTION
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
                          item["name"]?.toString() ?? "",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        /// STATUS BADGE
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: item["status"] == "Approved"
                                ? Colors.green.withOpacity(
                                    0.12,
                                  )
                                : item["status"] == "Pending"
                                    ? Colors.orange.withOpacity(
                                        0.12,
                                      )
                                    : Colors.red.withOpacity(
                                        0.12,
                                      ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            item["status"]?.toString() ?? "",
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

              /// DATE + KM
              Row(
                children: [
                  Expanded(
                    child: buildDetails(
                      "Date",
                      item["date"]?.toString() ?? "",
                    ),
                  ),
                  Expanded(
                    child: buildDetails(
                      "KM",
                      item["total_km"]?.toString() ??
                          item["km"]?.toString() ??
                          "",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// FROM + TO
              Row(
                children: [
                  Expanded(
                    child: buildDetails(
                      "From",
                      item["from"]?.toString() ?? "",
                    ),
                  ),
                  Expanded(
                    child: buildDetails(
                      "To",
                      item["to"]?.toString() ?? "",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              /// OTHER DETAILS
              buildFullDetails(
                "Vehicle Type",
                item["vehicle"]?.toString() ?? "",
              ),

              buildFullDetails(
                "Total Amount",
                "₹ ${item["amount"]?.toString() ?? "0"}",
              ),

              buildFullDetails(
                "Remark",
                item["remark"]?.toString() ?? "",
              ),

              const SizedBox(height: 24),

              /// ATTACHMENT TITLE
              const Text(
                "Travel Images",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              /// IMAGES LIST
              ListView.builder(
                itemCount: travelDetails.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final travel = travelDetails[index];

                  final imageUrl = (travel["image"] ?? "")
                      .toString()
                      .replaceAll(
                        "//travel_expense",
                        "/travel_expense",
                      )
                      .trim();

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// TO + KM
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "To : ${travel["to"] ?? ""}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Text(
                              "${travel["km"] ?? "0"} KM",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        /// IMAGE
                        /// IMAGE
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            height: 220,
                            width: double.infinity,
                            color: Colors.grey.shade200,
                            child: Image.network(
                              (travel["image"] ?? "")
                                  .toString()
                                  .replaceAll(
                                      "//travel_expense", "/travel_expense")
                                  .trim(),
                              headers: const {
                                "Accept": "*/*",
                              },
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.high,
                              loadingBuilder: (
                                context,
                                child,
                                loadingProgress,
                              ) {
                                if (loadingProgress == null) {
                                  return child;
                                }

                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                              errorBuilder: (
                                context,
                                error,
                                stackTrace,
                              ) {
                                return Container(
                                  height: 220,
                                  width: double.infinity,
                                  color: Colors.grey.shade300,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.broken_image,
                                        size: 45,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        "Image not available",
                                      ),
                                      const SizedBox(height: 5),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                        ),
                                        child: Text(
                                          (travel["image"] ?? "").toString(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // const SizedBox(height: 30),

              // /// APPROVE / REJECT
              // const Text(
              //   "Select Action",
              //   style: TextStyle(
              //     fontSize: 17,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),

              // const SizedBox(height: 10),

              // Row(
              //   children: [
              //     Expanded(
              //       child: Container(
              //         padding: const EdgeInsets.symmetric(
              //           horizontal: 10,
              //         ),
              //         decoration: BoxDecoration(
              //           border: Border.all(
              //             color: Colors.green,
              //           ),
              //           borderRadius: BorderRadius.circular(14),
              //         ),
              //         child: RadioListTile(
              //           value: "Approved",
              //           groupValue: selectedStatus,
              //           activeColor: Colors.green,
              //           contentPadding: EdgeInsets.zero,
              //           title: const Text(
              //             "Accept",
              //           ),
              //           onChanged: (value) {
              //             setState(() {
              //               selectedStatus = value.toString();
              //             });
              //           },
              //         ),
              //       ),
              //     ),
              //     const SizedBox(width: 12),
              //     Expanded(
              //       child: Container(
              //         padding: const EdgeInsets.symmetric(
              //           horizontal: 10,
              //         ),
              //         decoration: BoxDecoration(
              //           border: Border.all(
              //             color: Colors.red,
              //           ),
              //           borderRadius: BorderRadius.circular(14),
              //         ),
              //         child: RadioListTile(
              //           value: "Rejected",
              //           groupValue: selectedStatus,
              //           activeColor: Colors.red,
              //           contentPadding: EdgeInsets.zero,
              //           title: const Text(
              //             "Reject",
              //           ),
              //           onChanged: (value) {
              //             setState(() {
              //               selectedStatus = value.toString();
              //             });
              //           },
              //         ),
              //       ),
              //     ),
              //   ],
              // ),

              // const SizedBox(height: 30),

              // /// SUBMIT BUTTON
              // SizedBox(
              //   width: double.infinity,
              //   height: 55,
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: const Color.fromARGB(
              //         247,
              //         100,
              //         38,
              //         53,
              //       ),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(16),
              //       ),
              //     ),
              //     onPressed: () {
              //       ScaffoldMessenger.of(context).showSnackBar(
              //         SnackBar(
              //           content: Text(
              //             "Status : $selectedStatus",
              //           ),
              //         ),
              //       );
              //     },
              //     child: const Text(
              //       "Submit",
              //       style: TextStyle(
              //         fontSize: 16,
              //         fontWeight: FontWeight.bold,
              //         color: Colors.white,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  /// SMALL DETAILS
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

  /// FULL WIDTH DETAILS
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
}
