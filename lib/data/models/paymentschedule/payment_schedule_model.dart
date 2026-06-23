import 'dart:convert';

PaymentScheduleModel paymentScheduleModelFromJson(String str) =>
    PaymentScheduleModel.fromJson(json.decode(str));

String paymentScheduleModelToJson(PaymentScheduleModel data) =>
    json.encode(data.toJson());

class PaymentScheduleModel {
  final List<PaymentScheduleItem> data;

  PaymentScheduleModel({
    required this.data,
  });

  factory PaymentScheduleModel.fromJson(Map<String, dynamic> json) {
    return PaymentScheduleModel(
      data: json["data"] == null
          ? []
          : List<PaymentScheduleItem>.from(
              json["data"].map((x) => PaymentScheduleItem.fromJson(x)),
            ),
    );
  }

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class PaymentScheduleItem {
  final String id;
  final String phaseNo;
  final String description;
  final String estCost;
  final String paidAmount;
  final String balanceAmount;
  final String status;
  final String extraWorkAmount;
  final String deductionAmount;
  final String percentage;
  final String totalAmount;

  PaymentScheduleItem({
    required this.id,
    required this.phaseNo,
    required this.description,
    required this.estCost,
    required this.paidAmount,
    required this.balanceAmount,
    required this.status,
    required this.extraWorkAmount,
    required this.deductionAmount,
    required this.percentage,
    required this.totalAmount,
  });

  factory PaymentScheduleItem.fromJson(Map<String, dynamic> json) {
    return PaymentScheduleItem(
      id: json["id"]?.toString() ?? "",
      phaseNo: json["phase_no"]?.toString() ?? "",
      description: json["description"]?.toString() ?? "",
      estCost: json["est_cost"]?.toString() ?? "0",
      paidAmount: json["paid_amount"]?.toString() ?? "0",
      balanceAmount: json["balance_amount"]?.toString() ?? "0",
      status: json["status"]?.toString() ?? "",
      extraWorkAmount: json["extra_work_amount"]?.toString() ?? "0",
      deductionAmount: json["deduction_amount"]?.toString() ?? "0",
      percentage: json["percentage"]?.toString() ?? "0",
      totalAmount: json["total_cost"]?.toString() ?? "0",
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "phase_no": phaseNo,
        "description": description,
        "est_cost": estCost,
        "paid_amount": paidAmount,
        "balance_amount": balanceAmount,
        "status": status,
        "percentage": percentage,
        "total_cost": totalAmount,
      };
}
