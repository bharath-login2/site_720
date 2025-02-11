import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:site_720/data/models/project_list/project_list_model.dart';
import '../models/clientlist/client_list_model.dart';
import '../models/complaint/complaint_list_model.dart';
import '../models/contractorlist/contractor_list_model.dart';
import '../models/dashboard/dashboard_model.dart';
import '../models/expenselist/expenselist_model.dart';
import '../models/extraworklist/extra_work_model.dart';
import '../models/paymentdetails/paymentdetails_model.dart';
import '../models/project_details/project_detais_model.dart';
import '../models/purchasebilllist/purchasebill_list_model.dart';
import '../models/succes_response/success_response.dart';
import '../models/workdetails/add_work_details_model.dart';
import '../models/stages/stage_model.dart';
import '../models/workdetails/work_detail_model.dart';

class HttpServices {
  static var dev = 'https://dev.login2.in/constructEase/test_dev/v1/api/';
  static var main = 'https://dev.login2.in/constructEase/test_dev/v1/api/';
  static var baseUrl = dev;

  static Future login(mobile, password) async {
    try {
      http.Response response = await http.post(Uri.parse("${baseUrl}login"),
          body: ({'phone_number': mobile, 'password': password}));
      if (response.statusCode == 200) {
        // return loginmodelFromJson(response.body); 
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future dashboard(fromDate, toDate) async {
    try {
      http.Response response = await http.post(
          Uri.parse("${baseUrl}get_dashboard"),
          body: ({'token': "", 'from_date': fromDate, 'to_date': toDate}));
      if (response.statusCode == 200) {
        return dashboardModelFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getProjectList(status, searchKey) async {
    try {
      http.Response response = await http.post(
          Uri.parse("${baseUrl}get_project_list"),
          body: ({
            'token': "",
            'status': status == "null" || status == "all" ? "" : status,
            'searchkey': searchKey
          }));
      if (response.statusCode == 200) {
        return projectListModelFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getProjectDetails(projectId) async {
    try {
      http.Response response = await http.post(
          Uri.parse("${baseUrl}get_project_detailed"),
          body: ({'token': "", 'project_id': projectId}));
      if (response.statusCode == 200) {
        return projectDetailsModelFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getClientList() async {
    try {
      http.Response response =
          await http.post(Uri.parse("${baseUrl}get_client_list"));
      if (response.statusCode == 200) {
        return clientListModelFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getWorkDetails(projectId) async {
    try {
      http.Response response = await http.post(
          Uri.parse("${baseUrl}get_work_detailed"),
          body: {"project_id": projectId});
      if (response.statusCode == 200) {
        return workDetailModelFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getWorkIssues() async {
    try {
      http.Response response = await http.post(
        Uri.parse("${baseUrl}get_status_issues"),
      );
      if (response.statusCode == 200) {
        return addWorkDetailsModelFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getComplaintList() async {
    try {
      http.Response response = await http.post(
        Uri.parse("${baseUrl}get_complaint_list"),
      );
      if (response.statusCode == 200) {
        return complaintListModelFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  } 

  static Future getContractorList() async {
    try {
      http.Response response = await http.post(
        Uri.parse("${baseUrl}get_contractor_list"),
      );
      if (response.statusCode == 200) {
        return contractorListModelFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getExtraWorkList(projectId) async {
    try {
      http.Response response = await http.post(
          Uri.parse("${baseUrl}get_extrawork_list"),
          body: {"project_id": projectId});
      if (response.statusCode == 200) {
        return extraWorkListModelFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  } 

  static Future getPurchaseBillList(projectId) async {
    try {
      http.Response response = await http.post(
          Uri.parse("${baseUrl}get_purchase_bill"),
          body: {"project_id": projectId});
      if (response.statusCode == 200) {
        return purchaseBillListModelFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future addWorkDetails(
      String projectId,
      String clintId,
      String isWorking,
      String date,
      String noOfLabours,
      String status,
      String description) async {
    try {
      http.Response response =
          await http.post(Uri.parse("${baseUrl}add_work_details"), body: {
        "project_id": projectId,
        "client_id": clintId,
        "is_working": isWorking,
        "date": date,
        "no_of_labours": noOfLabours,
        "status": status,
        "description": description,
      });
      if (response.statusCode == 200) {
        return successResponseFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future addStages(
      String projectId,
      String clintId,
      String stages,
      String startDate,
      String endDate,
    ) async {
    try {
      http.Response response =
          await http.post(Uri.parse("${baseUrl}add_stages"), body: {
        "project_id": projectId,
        "client_id": clintId,
        "stages": stages,
        "startDate": startDate,
        "endDate": endDate,
      });
      if (response.statusCode == 200) {
        return successResponseFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getStagesList(projectId) async {
    try {
      http.Response response = await http.post(
          Uri.parse("${baseUrl}get_stages"),
          body: {
            "project_id":projectId
          }
          );
      if (response.statusCode == 200) {
        return getStagesModelFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }


  static Future getExpenseList(projectId) async {
    try {
      http.Response response = await http.post(
          Uri.parse("${baseUrl}expense_list"),
          body: {
            "project_id":projectId
          }
          );
      if (response.statusCode == 200) {
        return getExpenseListFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

   static Future getPaymentDetails(projectId) async {
    try {
      http.Response response = await http.post(
          Uri.parse("${baseUrl}get_payment_history"),
          body: {
            "project_id":projectId
          }
          );
      if (response.statusCode == 200) {
        return getPaymentDetailsFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

}
