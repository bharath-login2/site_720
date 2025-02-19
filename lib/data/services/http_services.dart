import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:site_720/data/models/galery/galery_list_model.dart';
import 'package:site_720/data/models/project_list/project_list_model.dart';
import '../models/clientlist/client_list_model.dart';
import '../models/complaint/complaint_list_model.dart';
import '../models/contractorlist/contractor_list_model.dart';
import '../models/dashboard/dashboard_model.dart';
import '../models/deductionwork/deductionlist_model.dart';
import '../models/deductionwork/phaselist_model.dart';
import '../models/expenselist/expenselist_model.dart';
import '../models/extraworklist/extra_work_model.dart';
import '../models/galery/stage_pro_model.dart';
import '../models/paymentdetails/paymentdetails_model.dart';
import '../models/login/login_model.dart';
import '../models/project_details/project_detais_model.dart';
import '../models/project_list/edit_data_model.dart';
import '../models/project_list/project_data_model.dart';
import '../models/purchasebilllist/purchasebill_list_model.dart';
import '../models/site_drawings/drawing_list.dart';
import '../models/succes_response/success_response.dart';
import '../models/workdetails/add_work_details_model.dart';
import '../models/stages/stage_model.dart';
import '../models/workdetails/work_detail_model.dart';

class HttpServices {
  static var dev = 'https://dev.login2.in/constructEase/test_dev/v1/api/';
  static var main = 'https://dev.login2.in/constructEase/test_dev/v1/api/';
  static var baseUrl = dev;

  static Future login(mobile, password, firebaseId) async {
    try {
      http.Response response = await http.post(Uri.parse("${baseUrl}login"),
          body: ({
            'phone_number': mobile,
            'password': password,
            "firebase_id": firebaseId
          }));
      if (response.statusCode == 200) {
        return loginModelFromJson(response.body);
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
      http.Response response =
          await http.post(Uri.parse("${baseUrl}get_project_list"),
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

  static Future getDeductionWorkList(projectId) async {
    try {
      http.Response response = await http.post(
          Uri.parse("${baseUrl}deduction_work_list"),
          body: {"project_id": projectId});
      if (response.statusCode == 200) {
        return getDeductionWorkFromJson(response.body);
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

  static Future editWorkDetails(
      String projectId,
      String clintId,
      String isWorking,
      String date,
      String noOfLabours,
      String status,
      String description,
      String workId) async {
    try {
      http.Response response =
          await http.post(Uri.parse("${baseUrl}edit_work_details"), body: {
        "work_id": workId,
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

  static Future deleteWorkDetails(String workId) async {
    try {
      http.Response response = await http.post(
          Uri.parse("${baseUrl}delete_work_details"),
          body: ({'token': "", 'work_id': workId}));
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
          body: {"project_id": projectId});
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
          body: {"project_id": projectId});
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
          body: {"project_id": projectId});
      if (response.statusCode == 200) {
        return getPaymentDetailsFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getAddProjectDetails() async {
    try {
      http.Response response = await http.post(
        Uri.parse("${baseUrl}project_data"),
      );
      if (response.statusCode == 200) {
        return projectDataModelFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future addProject(
    String clientId,
    String projectName,
    String projectType,
    String projectCategory,
    String referenceNo,
    String location,
    String locationArea,
    String cctvId,
    String priority,
    String packageId,
    String bhkNo,
    String startDate,
    String compDate,
    String planImg,
    String elevImg,
    String fixedRateValue,
    List<Map<String, dynamic>> unitList,
    String estBudAmt,
    String gst,
    String gstAmt,
    String totalAmt,
    String descripion,
    String ipoNo,
    String workOrderNo,
  ) async {
    try {
      var uri = Uri.parse("${baseUrl}add_project");
      var request = http.MultipartRequest('POST', uri);
      request.fields['token'] = "";
      request.fields["client_id"] = clientId;
      request.fields["project_name"] = projectName;
      request.fields["project_type"] = projectType;
      request.fields["reference_no"] = referenceNo;
      request.fields["location"] = location;
      request.fields["location_area"] = locationArea;
      request.fields["cctv_id"] = cctvId;
      request.fields["priority"] = priority;
      request.fields["package_id"] = packageId;
      request.fields["bhk_no"] = bhkNo;
      request.fields["start_date"] = startDate;
      request.fields["comp_date"] = compDate;
      request.fields["fixed_rate_value"] = fixedRateValue;
      request.fields["est_bud_amt"] = estBudAmt;
      request.fields["gst"] = gst;
      request.fields["gst_amt"] = gstAmt;
      request.fields["total_amt"] = totalAmt;
      request.fields["description"] = descripion;
      request.fields["lpo_no"] = ipoNo;
      request.fields["order_no"] = workOrderNo;
      request.fields["category_name"] = projectCategory;
      request.fields["unit_list"] = jsonEncode(unitList);
      if (planImg != "") {
        request.files
            .add(await http.MultipartFile.fromPath('plan_img', planImg));
      }
      if (elevImg != "") {
        request.files
            .add(await http.MultipartFile.fromPath('elev_img', elevImg));
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        return successResponseFromJson(await response.stream.bytesToString());
      } else {
        return {'error': 'Failed to add project'};
      }
    } catch (e) {
      log(e.toString());
      return {'error': e.toString()};
    }
  }

  static Future editDetails(String projectId) async {
    try {
      http.Response response = await http.post(
          Uri.parse("${baseUrl}edit_datalist"),
          body: {"project_id": projectId});
      if (response.statusCode == 200) {
        return editDataModelFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future updateProject(
    String projectId,
    String clientId,
    String projectName,
    String projectType,
    String projectCategory,
    String referenceNo,
    String location,
    String locationArea,
    String cctvId,
    String priority,
    String packageId,
    String bhkNo,
    String startDate,
    String compDate,
    String planImg,
    String elevImg,
    String fixedRateValue,
    List<Map<String, dynamic>> unitList,
    String estBudAmt,
    String gst,
    String gstAmt,
    String totalAmt,
    String description,
    String ipoNo,
    String workOrderNo,
  ) async {
    try {
      var uri = Uri.parse("${baseUrl}edit_project");
      var request = http.MultipartRequest('POST', uri);

      request.fields['token'] = "";
      request.fields["project_id"] = projectId;
      request.fields["client_id"] = clientId;
      request.fields["project_name"] = projectName;
      request.fields["project_type"] = projectType;
      request.fields["reference_no"] = referenceNo;
      request.fields["location"] = location;
      request.fields["location_area"] = locationArea;
      request.fields["cctv_id"] = cctvId;
      request.fields["priority"] = priority;
      request.fields["package_id"] = packageId;
      request.fields["bhk_no"] = bhkNo;
      request.fields["start_date"] = startDate;
      request.fields["comp_date"] = compDate;
      request.fields["fixed_rate_value"] = fixedRateValue;
      request.fields["est_bud_amt"] = estBudAmt;
      request.fields["gst"] = gst;
      request.fields["gst_amt"] = gstAmt;
      request.fields["total_amt"] = totalAmt;
      request.fields["description"] = description;
      request.fields["lpo_no"] = ipoNo;
      request.fields["order_no"] = workOrderNo;
      request.fields["category_name"] = projectCategory;
      request.fields["unit_list"] = jsonEncode(unitList);

      if (planImg.isNotEmpty) {
        request.files
            .add(await http.MultipartFile.fromPath('plan_img', planImg));
      }
      if (elevImg.isNotEmpty) {
        request.files
            .add(await http.MultipartFile.fromPath('elev_img', elevImg));
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        return successResponseFromJson(await response.stream.bytesToString());
      } else {
        return {
          'error':
              'Failed to update project, Status Code: ${response.statusCode}'
        };
      }
    } catch (e) {
      log("Error updating project: ${e.toString()}");
      return {'error': 'Error updating project: ${e.toString()}'};
    }
  }

  static Future deleteProject(String projectId) async {
    try {
      http.Response response = await http.post(
          Uri.parse("${baseUrl}delete_project"),
          body: ({'token': "", 'project_id': projectId}));
      if (response.statusCode == 200) {
        return successResponseFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getStagePro(String projectId) async {
    try {
      http.Response response = await http.post(
          Uri.parse("${baseUrl}get_stages_pro"),
          body: ({'project_id': projectId}));
      if (response.statusCode == 200) {
        return satgeProModelFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future postGallery(
    String projectId,
    String clientId,
    String stageId,
    List<XFile> images,
    String ytLink,
  ) async {
    try {
      var uri = Uri.parse("${baseUrl}add_gallery");
      var request = http.MultipartRequest('POST', uri);

      request.fields['project_id'] = projectId;
      request.fields['client_id'] = clientId;
      request.fields['stage_id'] = stageId;
      request.fields['yt_link'] = ytLink;

      for (var image in images) {
        if (image.path.isNotEmpty) {
          request.files
              .add(await http.MultipartFile.fromPath('image_list', image.path));
        }
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        return successResponseFromJson(await response.stream.bytesToString());
      }
    } catch (e) {
      log("Error: ${e.toString()}");
    }
  }

  static Future galleryList(String projectId) async {
    try {
      http.Response response = await http.post(
          Uri.parse("${baseUrl}list_gallery"),
          body: ({'project_id': projectId}));
      if (response.statusCode == 200) {
        return galleryListModelFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future deleteGalery(String id) async {
    try {
      http.Response response = await http.post(
          Uri.parse("${baseUrl}delete_gallery"),
          body: ({'image_id': id}));
      if (response.statusCode == 200) {
        return successResponseFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future addExtraWork(
    String projectId,
    String clintId,
    String work,
    String amount,
    String description,
  ) async {
    try {
      http.Response response =
          await http.post(Uri.parse("${baseUrl}add_extra_work"), body: {
        "project_id": projectId,
        "client_id": clintId,
        "work": work,
        "amount": amount,
        "description": description,
      });
      if (response.statusCode == 200) {
        return successResponseFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future editExtraWork(
    String projectId,
    String clintId,
    String workId,
    String work,
    String amount,
    String description,
  ) async {
    try {
      http.Response response =
          await http.post(Uri.parse("${baseUrl}edit_extra_work"), body: {
        "project_id": projectId,
        "client_id": clintId,
        "work_id": workId,
        "work": work,
        "amount": amount,
        "description": description,
      });
      if (response.statusCode == 200) {
        return successResponseFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future deleteExtraWork(
    String workId,
  ) async {
    try {
      http.Response response =
          await http.post(Uri.parse("${baseUrl}delete_extrawork"), body: {
        "work_id": workId,
      });
      if (response.statusCode == 200) {
        return successResponseFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getPhaseList(projectId) async {
    try {
      http.Response response = await http.post(
          Uri.parse("${baseUrl}get_phase_details"),
          body: {"project_id": projectId});
      if (response.statusCode == 200) {
        return phaseListFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future adddeductionWork(
      String projectId,
      String clintId,
      String work,
      selectedStatus,
      String percentage,
      String amount,
      String description) async {
    try {
      http.Response response =
          await http.post(Uri.parse("${baseUrl}add_deduction_work"), body: {
        "project_id": projectId,
        "client_id": clintId,
        "work": work,
        "phase": selectedStatus,
        "percentage": percentage,
        "amount": amount,
        "description": description,
      });
      if (response.statusCode == 200) {
        return successResponseFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future editdeductionWork(
      String projectId,
      String clintId,
      String workId,
      String work,
      selectedStatus,
      String percentage,
      String amount,
      String description) async {
    try {
      http.Response response =
          await http.post(Uri.parse("${baseUrl}edit_deduction_work"), body: {
        "project_id": projectId,
        "client_id": clintId,
        "deduction_id": workId,
        "work": work,
        "phase": selectedStatus,
        "percentage": percentage,
        "amount": amount,
        "description": description,
      });
      if (response.statusCode == 200) {
        return successResponseFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future deletedeductionwork(
    String projectId,
    String workId,
  ) async {
    try {
      http.Response response =
          await http.post(Uri.parse("${baseUrl}delete_deduction_work"), body: {
        "project_id": projectId,
        "work_id": workId,
      });
      if (response.statusCode == 200) {
        return successResponseFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getDrawingList(
    String projectId,
  ) async {
    try {
      http.Response response =
          await http.post(Uri.parse("${baseUrl}list_site_drawings"), body: {
        "project_id": projectId,
      });
      if (response.statusCode == 200) {
        return siteDrawingsListFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

   static Future uploadDrawings(
    String projectId,
    String clientId,
    XFile image,
    String remark,
  ) async {
    try {
      var uri = Uri.parse("${baseUrl}add_site_drawings");
      var request = http.MultipartRequest('POST', uri);

      request.fields['project_id'] = projectId;
      request.fields['client_id'] = clientId;
      request.fields['remarks'] = remark; 

        if (image.path.isNotEmpty) {
          request.files
              .add(await http.MultipartFile.fromPath('file_name', image.path));
        }

      var response = await request.send();

      if (response.statusCode == 200) {
        return successResponseFromJson(await response.stream.bytesToString());
      }
    } catch (e) {
      log("Error: ${e.toString()}"); 
    }
  }
}
