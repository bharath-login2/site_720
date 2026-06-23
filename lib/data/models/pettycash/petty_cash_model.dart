import 'dart:convert';

PettyCashResponse pettyCashResponseFromJson(String str) =>
    PettyCashResponse.fromJson(json.decode(str));

class PettyCashResponse {
  bool? status;
  String? message;
  PettyCashData? data;

  PettyCashResponse({
    this.status,
    this.message,
    this.data,
  });

  factory PettyCashResponse.fromJson(Map<String, dynamic> json) {
    return PettyCashResponse(
      status: json["status"],
      message: json["message"],
      data: json["data"] != null
          ? PettyCashData.fromJson(json["data"])
          : null,
    );
  }
}

class PettyCashData {
  List<PettyCashLedger>? ledger;

  PettyCashData({
    this.ledger,
  });

  factory PettyCashData.fromJson(Map<String, dynamic> json) {
    return PettyCashData(
      ledger: json["ledger"] == null
          ? []
          : List<PettyCashLedger>.from(
              json["ledger"].map(
                (x) => PettyCashLedger.fromJson(x),
              ),
            ),
    );
  }
}

class PettyCashLedger {
  String? ledgerId;
  DateTime? transactionDate;
  String? amount;
  String? debitOrCredit;
  String? referenceType;
  String? description;
  String? accountHead;

  PettyCashLedger({
    this.ledgerId,
    this.transactionDate,
    this.amount,
    this.debitOrCredit,
    this.referenceType,
    this.description,
    this.accountHead,
  });

  factory PettyCashLedger.fromJson(Map<String, dynamic> json) {
    return PettyCashLedger(
      ledgerId: json["ledger_id"]?.toString(),
      transactionDate:
          json["transaction_date"] != null &&
                  json["transaction_date"] != "0000-00-00"
              ? DateTime.tryParse(json["transaction_date"])
              : null,
      amount: json["amount"]?.toString(),
      debitOrCredit: json["debit_or_credit"]?.toString(),
      referenceType: json["reference_type"]?.toString(),
      description: json["description"]?.toString(),
      accountHead: json["account_head"]?.toString(),
    );
  }
}