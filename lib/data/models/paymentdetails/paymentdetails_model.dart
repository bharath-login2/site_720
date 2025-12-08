// To parse this JSON data, do
//
//     final getPaymentDetails = getPaymentDetailsFromJson(jsonString);

import 'dart:convert';

GetPaymentDetails getPaymentDetailsFromJson(String str) =>
    GetPaymentDetails.fromJson(json.decode(str));

String getPaymentDetailsToJson(GetPaymentDetails data) =>
    json.encode(data.toJson());

class GetPaymentDetails {
  List<PaymentHistory> data;
  String message;
  bool status;

  GetPaymentDetails({
    required this.data,
    required this.message,
    required this.status,
  });

  factory GetPaymentDetails.fromJson(Map<String, dynamic> json) =>
      GetPaymentDetails(
        data: List<PaymentHistory>.from(
            json["data"].map((x) => PaymentHistory.fromJson(x))),
        message: json["message"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "status": status,
      };
}

class PaymentHistory {
  String phaseName;
  String paidAmount;
  String paymentStatus;
  String transactionDate;
  String collectedBy;
  String accountHead;
  String createdBy;
  PaymentHistory({
    required this.phaseName,
    required this.paidAmount,
    required this.paymentStatus,
    required this.transactionDate,
    required this.collectedBy,
    required this.accountHead,
    required this.createdBy,
  });

  factory PaymentHistory.fromJson(Map<String, dynamic> json) => PaymentHistory(
        phaseName: json["phase_names"] ?? "",
        paidAmount: json["paid_amount"] ?? "",
        paymentStatus: json["payment_method"] ?? "",
        transactionDate: json["transaction_date"] ?? "",
        collectedBy: json["collected_by"] ?? "",
        accountHead: json["account_head"] ?? "",
        createdBy: json["created_by"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "phase_names": phaseName,
        "paid_amount": paidAmount,
        "payment_method": paymentStatus,
        "transaction_date": transactionDate,
        "collected_by": collectedBy,
        "account_head": accountHead,
        "created_by": createdBy,
      };
}
