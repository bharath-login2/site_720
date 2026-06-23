import 'dart:convert';

SubContractDetailsModel subContractDetailsModelFromJson(String str) =>
    SubContractDetailsModel.fromJson(json.decode(str));

String subContractDetailsModelToJson(SubContractDetailsModel data) =>
    json.encode(data.toJson());

class SubContractDetailsModel {
  bool status;
  String message;
  Data data;

  SubContractDetailsModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SubContractDetailsModel.fromJson(Map<String, dynamic> json) =>
      SubContractDetailsModel(
        status: json["status"] ?? false,
        message: json["message"] ?? "",
        data: Data.fromJson(json["data"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  ContractorDetails contractorDetails;
  WorkDetails workDetails;
  ProjectDetails projectDetails;
  List<PaymentList> paymentList;
  List<StageSchedule> stageSchedules;
  Data({
    required this.contractorDetails,
    required this.workDetails,
    required this.projectDetails,
    required this.paymentList,
    required this.stageSchedules,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        contractorDetails: ContractorDetails.fromJson(
          json["contractor_details"] ?? {},
        ),
        workDetails: WorkDetails.fromJson(
          json["work_details"] ?? {},
        ),
        paymentList: List<PaymentList>.from(
          (json["payment_list"] ?? []).map((x) => PaymentList.fromJson(x)),
        ),
        projectDetails: ProjectDetails.fromJson(
          json["project_details"] ?? {},
        ),
        stageSchedules: List<StageSchedule>.from(
          (json["stageschedules"] ?? []).map((x) => StageSchedule.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {};
}

class ContractorDetails {
  String name;
  String phone;
  String address;
  String contactPerson;
  String gstNo;
  String panNo;
  String aadharNo;
  String bankAccount;
  String ifscCode;
  String bankName;
  String branchName;

  ContractorDetails({
    required this.name,
    required this.phone,
    required this.address,
    required this.contactPerson,
    required this.gstNo,
    required this.panNo,
    required this.aadharNo,
    required this.bankAccount,
    required this.ifscCode,
    required this.bankName,
    required this.branchName,
  });

  factory ContractorDetails.fromJson(Map<String, dynamic> json) =>
      ContractorDetails(
        name: json["name"] ?? "",
        phone: json["phone"] ?? "",
        address: json["address"] ?? "",
        contactPerson: json["contact_person"] ?? "",
        gstNo: json["gst_no"] ?? "",
        panNo: json["pan_no"] ?? "",
        aadharNo: json["aadhar_no"] ?? "",
        bankAccount: json["bank_account"] ?? "",
        ifscCode: json["ifsc_code"] ?? "",
        bankName: json["bank_name"] ?? "",
        branchName: json["branch_name"] ?? "",
      );
}

class WorkDetails {
  String subcontractWorkName;
  String contractType;
  String description;
  String totalNoOfWorks;
  String totalEstimatedAmount;
  String totalPayableAmount;
  String balancePayableAmount;
  String billingAddress;

  WorkDetails({
    required this.subcontractWorkName,
    required this.contractType,
    required this.description,
    required this.totalNoOfWorks,
    required this.totalEstimatedAmount,
    required this.totalPayableAmount,
    required this.balancePayableAmount,
    required this.billingAddress,
  });

  factory WorkDetails.fromJson(Map<String, dynamic> json) => WorkDetails(
        subcontractWorkName: json["subcontract_work_name"]?.toString() ?? "",
        contractType: json["contract_type"]?.toString() ?? "",
        description: json["description"]?.toString() ?? "",
        totalNoOfWorks: json["total_no_of_works"]?.toString() ?? "",
        totalEstimatedAmount: json["total_estimated_amount"]?.toString() ?? "",
        totalPayableAmount: json["total_payable_amount"]?.toString() ?? "",
        balancePayableAmount: json["balance_payable_amount"]?.toString() ?? "",
        billingAddress: json["billing_address"]?.toString() ?? "",
      );
}

class ProjectDetails {
  String projectName;
  String location;
  String clientName;
  String phoneNumber;
  String workStatus;

  ProjectDetails({
    required this.projectName,
    required this.location,
    required this.clientName,
    required this.phoneNumber,
    required this.workStatus,
  });

  factory ProjectDetails.fromJson(Map<String, dynamic> json) => ProjectDetails(
        projectName: json["project_name"] ?? "",
        location: json["location"] ?? "",
        clientName: json["client_name"] ?? "",
        phoneNumber: json["phone_number"] ?? "",
        workStatus: json["work_status"] ?? "",
      );
}

class PaymentList {
  String paymentId;
  String paidAmount;
  String paidDate;
  String paymentMethod;
  String remarks;

  PaymentList({
    required this.paymentId,
    required this.paidAmount,
    required this.paidDate,
    required this.paymentMethod,
    required this.remarks,
  });

  factory PaymentList.fromJson(Map<String, dynamic> json) => PaymentList(
        paymentId: json["payment_id"] ?? "",
        paidAmount: json["paid_amount"] ?? "",
        paidDate: json["paid_date"] ?? "",
        paymentMethod: json["payment_method"] ?? "",
        remarks: json["remarks"] ?? "",
      );
}

class StageSchedule {
  String itemName;
  String scheduleAmount;
  String totalPaidAmount;

  StageSchedule({
    required this.itemName,
    required this.scheduleAmount,
    required this.totalPaidAmount,
  });

  factory StageSchedule.fromJson(Map<String, dynamic> json) => StageSchedule(
        itemName: json["item_name"]?.toString() ?? "",
        scheduleAmount: json["schedule_amount"]?.toString() ?? "0",
        totalPaidAmount: json["total_paid_amount"]?.toString() ?? "0",
      );
}
