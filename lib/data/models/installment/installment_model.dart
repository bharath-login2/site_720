import 'dart:convert';

InstallmentModel installmentModelFromJson(String str) =>
    InstallmentModel.fromJson(json.decode(str));

String installmentModelToJson(InstallmentModel data) =>
    json.encode(data.toJson());

class InstallmentModel {
  final List<InstallmentItem> data;

  InstallmentModel({
    required this.data,
  });

  factory InstallmentModel.fromJson(Map<String, dynamic> json) {
    return InstallmentModel(
      data: json["data"] == null
          ? []
          : List<InstallmentItem>.from(
              json["data"].map(
                (x) => InstallmentItem.fromJson(x),
              ),
            ),
    );
  }

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(
          data.map((x) => x.toJson()),
        ),
      };
}

class InstallmentItem {
  final String id;
  final String installmentAmount;
  final String installmentDate;
  final String status;

  InstallmentItem({
    required this.id,
    required this.installmentAmount,
    required this.installmentDate,
    required this.status,
  });

  factory InstallmentItem.fromJson(Map<String, dynamic> json) {
    return InstallmentItem(
      id: json["id"]?.toString() ?? "",
      installmentAmount: json["installment_amount"]?.toString() ?? "0",
      installmentDate: json["installment_date"]?.toString() ?? "",
      status: json["status"]?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "installment_amount": installmentAmount,
        "installment_date": installmentDate,
        "status": status,
      };
}
