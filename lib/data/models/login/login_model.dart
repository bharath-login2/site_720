// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  Data data;
  String message;
  bool status;

  LoginModel({
    required this.data,
    required this.message,
    required this.status,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        data: Data.fromJson(json["data"]),
        message: json["message"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "message": message,
        "status": status,
      };
}

class Data {
  String token;
  String userId;
  String userStaffId;
  String branchId;
  String name;
  String role;
  String roleId;
  String accountId;
  String accountName;
  String isMultiBranch;
  String staffName;
  String designation;

  Data({
    required this.token,
    required this.userId,
    required this.userStaffId,
    required this.branchId,
    required this.name,
    required this.role,
    required this.roleId,
    required this.accountId,
    required this.accountName,
    required this.isMultiBranch,
    required this.staffName,
    required this.designation,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        token: json["token"],
        userId: json["user_id"],
        userStaffId: json["userStaffId"],
        branchId: json["branch_id"],
        name: json["name"],
        role: json["role"],
        roleId: json["role_id"],
        accountId: json["account_id"],
        accountName: json["account_name"],
        isMultiBranch: json["is_multi_branch"],
        staffName: json["staff_name"],
        designation: json["designation"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "user_id": userId,
        "userStaffId": userStaffId,
        "branch_id": branchId,
        "name": name,
        "role": role,
        "role_id": roleId,
        "account_id": accountId,
        "account_name": accountName,
        "is_multi_branch": isMultiBranch,
        "staff_name": staffName,
        "designation": designation,
      };
}
