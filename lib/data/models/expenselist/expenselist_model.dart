// To parse this JSON data, do
//
//     final getExpenseList = getExpenseListFromJson(jsonString);

import 'dart:convert';

GetExpenseList getExpenseListFromJson(String str) =>
    GetExpenseList.fromJson(json.decode(str));

String getExpenseListToJson(GetExpenseList data) => json.encode(data.toJson());

class GetExpenseList {
  List<ExpenseList> data;
  String message;
  bool status;

  GetExpenseList({
    required this.data,
    required this.message,
    required this.status,
  });

  factory GetExpenseList.fromJson(Map<String, dynamic> json) => GetExpenseList(
        data: List<ExpenseList>.from(
            json["data"].map((x) => ExpenseList.fromJson(x))),
        message: json["message"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "status": status,
      };
}

class ExpenseList {
  String expenseTypeId;
  String billAmount;
  String billNo;
  String billDate;
  String expenseType;
  String createdBy;

  ExpenseList({
    required this.expenseTypeId,
    required this.billAmount,
    required this.billNo,
    required this.billDate,
    required this.expenseType,
    required this.createdBy,
  });

  factory ExpenseList.fromJson(Map<String, dynamic> json) => ExpenseList(
        expenseTypeId: json["expense_type_id"] ?? "",
        billAmount: json["bill_amount"] ?? "",
        billNo: json["bill_no"] ?? "",
        billDate: json["bill_date"] ?? "",
        expenseType: json["expense_type"] ?? "",
        createdBy: json["created_by"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "expense_type_id": expenseTypeId,
        "bill_amount": billAmount,
        "bill_no": billNo,
        "expense_type": expenseType,
        "created_by": createdBy,
      };
}
