import 'dart:convert';

SalaryLedgerResponse salaryLedgerResponseFromJson(String str) =>
    SalaryLedgerResponse.fromJson(json.decode(str));

class SalaryLedgerResponse {
  bool? status;
  String? message;
  SalaryLedgerData? data;

  SalaryLedgerResponse({
    this.status,
    this.message,
    this.data,
  });

  factory SalaryLedgerResponse.fromJson(Map<String, dynamic> json) {
    return SalaryLedgerResponse(
      status: json["status"],
      message: json["message"],
      data:
          json["data"] != null ? SalaryLedgerData.fromJson(json["data"]) : null,
    );
  }
}

class SalaryLedgerData {
  SalarySummary? summary;
  List<SalaryLedgerItem>? ledger;

  SalaryLedgerData({
    this.summary,
    this.ledger,
  });

  factory SalaryLedgerData.fromJson(Map<String, dynamic> json) {
    return SalaryLedgerData(
      summary: json["summary"] != null
          ? SalarySummary.fromJson(json["summary"])
          : null,
      ledger: json["ledger"] == null
          ? []
          : List<SalaryLedgerItem>.from(
              json["ledger"].map((x) => SalaryLedgerItem.fromJson(x)),
            ),
    );
  }
}

class SalarySummary {
  String? totalCredit;
  String? payoutBalance;
  String? totalDebit;

  SalarySummary({
    this.totalCredit,
    this.payoutBalance,
    this.totalDebit,
  });

  factory SalarySummary.fromJson(Map<String, dynamic> json) {
    return SalarySummary(
      totalCredit: json["total_credit"]?.toString(),
      payoutBalance: json["payout_balance"]?.toString(),
      totalDebit: json["total_debit"]?.toString(),
    );
  }
}

class SalaryLedgerItem {
  String? ledgerId;
  DateTime? transactionDate;
  String? accountId;
  String? accountTypeId;
  String? amount;
  String? debitOrCredit;
  String? referenceType;
  String? description;
  String? accountHead;

  SalaryLedgerItem({
    this.ledgerId,
    this.transactionDate,
    this.accountId,
    this.accountTypeId,
    this.amount,
    this.debitOrCredit,
    this.referenceType,
    this.description,
    this.accountHead,
  });

  factory SalaryLedgerItem.fromJson(Map<String, dynamic> json) {
    return SalaryLedgerItem(
      ledgerId: json["ledger_id"]?.toString(),
      transactionDate: json["transaction_date"] != null
          ? DateTime.tryParse(json["transaction_date"])
          : null,
      accountId: json["account_id"]?.toString(),
      accountTypeId: json["account_type_id"]?.toString(),
      amount: json["amount"]?.toString(),
      debitOrCredit: json["debit_or_credit"]?.toString(),
      referenceType: json["reference_type"]?.toString(),
      description: json["description"]?.toString(),
      accountHead: json["account_head"]?.toString(),
    );
  }
}
