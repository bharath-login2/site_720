// To parse this JSON data, do
//
//     final getPaymentDetails = getPaymentDetailsFromJson(jsonString);

import 'dart:convert';

GetPaymentDetails getPaymentDetailsFromJson(String str) => GetPaymentDetails.fromJson(json.decode(str));

String getPaymentDetailsToJson(GetPaymentDetails data) => json.encode(data.toJson());

class GetPaymentDetails {
    List<PaymentHistory> data;
    String message;
    bool status;

    GetPaymentDetails({
        required this.data,
        required this.message,
        required this.status,
    });

    factory GetPaymentDetails.fromJson(Map<String, dynamic> json) => GetPaymentDetails(
        data: List<PaymentHistory>.from(json["data"].map((x) => PaymentHistory.fromJson(x))),
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
    String percentage;
    String amount;
    String paidAmount;
    String balanceAmount;
    String paymentStatus;
    String stageName;

    PaymentHistory({
        required this.phaseName,
        required this.percentage,
        required this.amount,
        required this.paidAmount,
        required this.balanceAmount,
        required this.paymentStatus,
        required this.stageName,
    });

    factory PaymentHistory.fromJson(Map<String, dynamic> json) => PaymentHistory(
        phaseName: json["phase_name"],
        percentage: json["percentage"],
        amount: json["amount"],
        paidAmount: json["paid_amount"],
        balanceAmount: json["balance_amount"],
        paymentStatus: json["payment_status"],
        stageName: json["stage_name"],
    );

    Map<String, dynamic> toJson() => {
        "phase_name": phaseName,
        "percentage": percentage,
        "amount": amount,
        "paid_amount": paidAmount,
        "balance_amount": balanceAmount,
        "payment_status": paymentStatus,
        "stage_name": stageName,
    };
}
