import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:site_720/core/utilities/shared_preferences.dart';
import 'package:site_720/data/models/galery/galery_list_model.dart';
import 'package:site_720/data/models/project_list/project_list_model.dart';
import '../../core/config/config.dart';
import '../models/clientlist/client_details.dart';
import '../models/clientlist/client_list_model.dart';
import '../models/clientlist/client_type_list.dart';
import '../models/clientlist/district_list.dart';
import '../models/clientlist/state_list_model.dart';
import '../models/complaint/complaint_details_model.dart';
import '../models/complaint/complaint_list_model.dart';
import '../models/contractorlist/contractor_list_model.dart';
import '../models/dashboard/dashboard_model.dart';
import '../models/deductionwork/deductionlist_model.dart';
import '../models/deductionwork/phaselist_model.dart';
import '../models/expenselist/expenselist_model.dart';
import '../models/extraworklist/extra_work_model.dart';
import '../models/galery/stage_pro_model.dart';
import '../models/login/api_auth.dart';
import '../models/notification/notification_list.dart';
import '../models/package/package_model.dart';
import '../models/paymentdetails/paymentdetails_model.dart';
import '../models/login/login_model.dart';
import '../models/project_details/project_detais_model.dart';
import '../models/project_list/add_project_response.dart';
import '../models/project_list/edit_data_model.dart';
import '../models/project_list/project_data_model.dart';
import '../models/purchasebilllist/purchasebill_list_model.dart';
import '../models/site_drawings/drawing_list.dart';
import '../models/stages/stagephase_model.dart';
import '../models/stock/stock_list.dart';
import '../models/stockconsume/stockconsume_model.dart';
import '../models/succes_response/success_response.dart';
import '../models/task/task_details_model.dart';
import '../models/task/task_history.dart';
import '../models/task/task_status.dart';
import '../models/task/tasklist_model.dart';
import '../models/version/version_model.dart';
import '../models/workdetails/add_work_details_model.dart';
import '../models/stages/stage_model.dart';
import '../models/workdetails/work_detail_model.dart';

class HttpServices {
  static Future apiAuth() async {
    try {
      http.Response response = await http.get(
        Uri.parse("https://site720.com/api/apiAuth.php"),
      );
      if (response.statusCode == 200) {
        return apiAuthFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getVersion() async {
    try {
      http.Response response =
          await http.post(Uri.parse("${await Config.getUrl()}get_version"));
      if (response.statusCode == 200) {
        return versionModelFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future login(mobile, password, firebaseId) async {
    try {
      http.Response response = await http.post(
          Uri.parse("${await Config.getUrl()}login"),
          body: ({
            'user_name': mobile,
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
    log(await getSharedPreference('token'));
    try {
      http.Response response =
          await http.post(Uri.parse("${await Config.getUrl()}get_dashboard"),
              body: ({
                'token': await getSharedPreference('token'),
                'from_date': fromDate,
                'to_date': toDate
              }));
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
          await http.post(Uri.parse("${await Config.getUrl()}get_project_list"),
              body: ({
                'token': await getSharedPreference('token'),
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
          Uri.parse("${await Config.getUrl()}get_project_detailed"),
          body: ({
            'token': await getSharedPreference('token'),
            'project_id': projectId
          }));
      if (response.statusCode == 200) {
        return projectDetailsModelFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getClientList() async {
    try {
      http.Response response = await http.post(
          Uri.parse("${await Config.getUrl()}get_client_list"),
          body: ({'token': await getSharedPreference('token')}));
      if (response.statusCode == 200) {
        return clientListModelFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getWorkDetails(projectId) async {
    try {
      http.Response response = await http
          .post(Uri.parse("${await Config.getUrl()}get_work_detailed"), body: {
        'token': await getSharedPreference('token'),
        "project_id": projectId
      });
      if (response.statusCode == 200) {
        return workDetailModelFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getWorkIssuesList(statesId) async {
    try {
      http.Response response = await http
          .post(Uri.parse("${await Config.getUrl()}get_work_issues_list"), body: {
        'token': await getSharedPreference('token'),
        "status_id": statesId
      });
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
          Uri.parse("${await Config.getUrl()}get_status_issues"),
          body: ({'token': await getSharedPreference('token')}));
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
          Uri.parse("${await Config.getUrl()}get_complaint_list"),
          body: ({'token': await getSharedPreference('token')}));
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
          Uri.parse("${await Config.getUrl()}get_contractor_list"),
          body: ({'token': await getSharedPreference('token')}));
      if (response.statusCode == 200) {
        return contractorListModelFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getExtraWorkList(projectId) async {
    try {
      http.Response response = await http
          .post(Uri.parse("${await Config.getUrl()}get_extrawork_list"), body: {
        "project_id": projectId,
        'token': await getSharedPreference('token'),
      });
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
          Uri.parse("${await Config.getUrl()}deduction_work_list"),
          body: {
            'token': await getSharedPreference('token'),
            "project_id": projectId
          });
      if (response.statusCode == 200) {
        return getDeductionWorkFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getPurchaseBillList(projectId) async {
    try {
      http.Response response = await http
          .post(Uri.parse("${await Config.getUrl()}get_purchase_bill"), body: {
        'token': await getSharedPreference('token'),
        "project_id": projectId
      });
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
      http.Response response = await http
          .post(Uri.parse("${await Config.getUrl()}add_work_details"), body: {
        'token': await getSharedPreference('token'),
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
      http.Response response = await http
          .post(Uri.parse("${await Config.getUrl()}edit_work_details"), body: {
        'token': await getSharedPreference('token'),
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
          Uri.parse("${await Config.getUrl()}delete_work_details"),
          body: ({
            'token': await getSharedPreference('token'),
            'work_id': workId
          }));
      if (response.statusCode == 200) {
        return successResponseFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getPhaseNew(projectId) async {
    try {
      http.Response response = await http
          .post(Uri.parse("${await Config.getUrl()}phase_list_new"), body: {
        'token': await getSharedPreference('token'),
        "project_id": projectId
      });
      if (response.statusCode == 200) {
        return stagePhaseListFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future addStages(
    String projectId,
    String clintId,
    selectedStatus,
    String stages,
    String startDate,
    String endDate,
  ) async {
    try {
      http.Response response = await http
          .post(Uri.parse("${await Config.getUrl()}add_stages"), body: {
        'token': await getSharedPreference('token'),
        "project_id": projectId,
        "client_id": clintId,
        "phase_id": selectedStatus,
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

  static Future editStages(
    String projectId,
    String clintId,
    String stageId,
    selectedStatus,
    String stages,
    String startDate,
    String endDate,
  ) async {
    try {
      http.Response response = await http
          .post(Uri.parse("${await Config.getUrl()}edit_stages"), body: {
        'token': await getSharedPreference('token'),
        "project_id": projectId,
        "client_id": clintId,
        "stage_id": stageId,
        "phase_id": selectedStatus,
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
      http.Response response = await http
          .post(Uri.parse("${await Config.getUrl()}get_stages"), body: {
        'token': await getSharedPreference('token'),
        "project_id": projectId
      });
      if (response.statusCode == 200) {
        return getStagesModelFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getExpenseList(projectId) async {
    try {
      http.Response response = await http
          .post(Uri.parse("${await Config.getUrl()}expense_list"), body: {
        'token': await getSharedPreference('token'),
        "project_id": projectId
      });
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
          Uri.parse("${await Config.getUrl()}get_payment_history"),
          body: {
            'token': await getSharedPreference('token'),
            "project_id": projectId
          });
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
          Uri.parse("${await Config.getUrl()}project_data"),
          body: ({'token': await getSharedPreference('token')}));
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
      var uri = Uri.parse("${await Config.getUrl()}add_project");
      var request = http.MultipartRequest('POST', uri);
      request.fields['token'] = await getSharedPreference('token');
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
        return addProjectResponseFromJson(
            await response.stream.bytesToString());
      } else {
        return {'error': 'Failed to add project'};
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future editDetails(String projectId) async {
    try {
      http.Response response = await http
          .post(Uri.parse("${await Config.getUrl()}edit_datalist"), body: {
        'token': await getSharedPreference('token'),
        "project_id": projectId
      });
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
      var uri = Uri.parse("${await Config.getUrl()}edit_project");
      var request = http.MultipartRequest('POST', uri);

      request.fields['token'] = await getSharedPreference('token');
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
          Uri.parse("${await Config.getUrl()}delete_project"),
          body: ({
            'token': await getSharedPreference('token'),
            'project_id': projectId
          }));
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
          Uri.parse("${await Config.getUrl()}get_stages_pro"),
          body: ({
            'token': await getSharedPreference('token'),
            'project_id': projectId
          }));
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
      var uri = Uri.parse("${await Config.getUrl()}add_gallery");
      var request = http.MultipartRequest('POST', uri);

      request.fields['token'] = await getSharedPreference('token');
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
          Uri.parse("${await Config.getUrl()}list_gallery"),
          body: ({
            'token': await getSharedPreference('token'),
            'project_id': projectId
          }));
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
          Uri.parse("${await Config.getUrl()}delete_gallery"),
          body: ({
            'token': await getSharedPreference('token'),
            'image_id': id
          }));
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
      http.Response response = await http
          .post(Uri.parse("${await Config.getUrl()}add_extra_work"), body: {
        'token': await getSharedPreference('token'),
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
      http.Response response = await http
          .post(Uri.parse("${await Config.getUrl()}edit_extra_work"), body: {
        'token': await getSharedPreference('token'),
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
      http.Response response = await http
          .post(Uri.parse("${await Config.getUrl()}delete_extrawork"), body: {
        'token': await getSharedPreference('token'),
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
      http.Response response = await http
          .post(Uri.parse("${await Config.getUrl()}get_phase_details"), body: {
        'token': await getSharedPreference('token'),
        "project_id": projectId
      });
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
      http.Response response = await http
          .post(Uri.parse("${await Config.getUrl()}add_deduction_work"), body: {
        'token': await getSharedPreference('token'),
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
      http.Response response = await http.post(
          Uri.parse("${await Config.getUrl()}edit_deduction_work"),
          body: {
            'token': await getSharedPreference('token'),
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
      http.Response response = await http.post(
          Uri.parse("${await Config.getUrl()}delete_deduction_work"),
          body: {
            'token': await getSharedPreference('token'),
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
      http.Response response = await http
          .post(Uri.parse("${await Config.getUrl()}list_site_drawings"), body: {
        'token': await getSharedPreference('token'),
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
      var uri = Uri.parse("${await Config.getUrl()}add_site_drawings");
      var request = http.MultipartRequest('POST', uri);
      request.fields['token'] = await getSharedPreference('token');
      request.fields['project_id'] = projectId;
      request.fields['client_id'] = clientId;
      request.fields['remarks'] = remark;

      if (image.path.isNotEmpty) {
        request.files
            .add(await http.MultipartFile.fromPath('site_drawing', image.path));
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        return successResponseFromJson(await response.stream.bytesToString());
      }
    } catch (e) {
      log("Error: ${e.toString()}");
    }
  }

  static Future deleteDrawing(
    String siteId,
  ) async {
    try {
      http.Response response = await http.post(
          Uri.parse("${await Config.getUrl()}delete_site_drawings"),
          body: {
            'token': await getSharedPreference('token'),
            "site_id": siteId,
          });
      if (response.statusCode == 200) {
        return successResponseFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getComplaintDetails() async {
    try {
      http.Response response = await http.post(
          Uri.parse("${await Config.getUrl()}complaints_details_n"),
          body: {
            'token': await getSharedPreference('token'),
          });
      if (response.statusCode == 200) {
        return complaintDetailsModelFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getPackage(projectId) async {
    try {
      http.Response response = await http
          .post(Uri.parse("${await Config.getUrl()}package_data"), body: {
        'token': await getSharedPreference('token'),
        "project_id": projectId
      });
      if (response.statusCode == 200) {
        return packageModelFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getStockList(projectId) async {
    try {
      http.Response response = await http
          .post(Uri.parse("${await Config.getUrl()}stock_list_view"), body: {
        'token': await getSharedPreference('token'),
        "project_id": projectId
      });
      if (response.statusCode == 200) {
        return stockListModelFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getConsumeList(projectId) async {
    try {
      http.Response response = await http.post(
          Uri.parse("${await Config.getUrl()}stock_consumption_view"),
          body: {
            'token': await getSharedPreference('token'),
            "project_id": projectId
          });
      if (response.statusCode == 200) {
        return stockConsumeModelFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getStates() async {
    try {
      http.Response response = await http.post(
          Uri.parse("${await Config.getUrl()}state_list"),
          body: ({'token': await getSharedPreference('token')}));
      if (response.statusCode == 200) {
        return stateListModelFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getDistricts(stateId) async {
    try {
      http.Response response = await http
          .post(Uri.parse("${await Config.getUrl()}district_list"), body: {
        'token': await getSharedPreference('token'),
        "state_id": stateId
      });
      if (response.statusCode == 200) {
        return districtListModelFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getClientTypes() async {
    try {
      http.Response response = await http.post(
          Uri.parse("${await Config.getUrl()}client_type_list"),
          body: ({'token': await getSharedPreference('token')}));
      if (response.statusCode == 200) {
        return clientTypeListModelFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future addClient(
      String clientName,
      String contactPerson,
      String phoneNumber,
      String whatsappNumber,
      String companyName,
      String emailId,
      String address,
      String civil,
      String gstNo,
      String stateId,
      String districtId,
      String clientTypeId) async {
    try {
      http.Response response = await http
          .post(Uri.parse("${await Config.getUrl()}add_client"), body: {
        'token': await getSharedPreference('token'),
        "client_name": clientName,
        "contact_person": contactPerson,
        "phone_number": phoneNumber,
        "whatsapp_number": whatsappNumber,
        "company_name": companyName,
        "email_id": emailId,
        "address": address,
        "civil_id": civil,
        "gst_no": gstNo,
        "state_id": stateId,
        "district_id": districtId,
        "client_type_id": clientTypeId,
      });
      if (response.statusCode == 200) {
        return successResponseFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getClientDetails(clientId) async {
    try {
      http.Response response = await http.post(
          Uri.parse("${await Config.getUrl()}edit_details_client"),
          body: {
            'token': await getSharedPreference('token'),
            "client_id": clientId
          });
      if (response.statusCode == 200) {
        return clientDetailsModelFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future editClient(
      String clientId,
      String clientName,
      String contactPerson,
      String phoneNumber,
      String whatsappNumber,
      String companyName,
      String emailId,
      String address,
      String civil,
      String gstNo,
      String stateId,
      String districtId,
      String clientTypeId) async {
    try {
      http.Response response = await http
          .post(Uri.parse("${await Config.getUrl()}edit_client"), body: {
        'token': await getSharedPreference('token'),
        "client_id": clientId,
        "client_name": clientName,
        "contact_person": contactPerson,
        "phone_number": phoneNumber,
        "whatsapp_number": whatsappNumber,
        "company_name": companyName,
        "email_id": emailId,
        "address": address,
        "civil_id": civil,
        "gst_no": gstNo,
        "state_id": stateId,
        "district_id": districtId,
        "client_type_id": clientTypeId,
      });
      if (response.statusCode == 200) {
        return successResponseFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getTaskList() async {
    try {
      http.Response response = await http
          .post(Uri.parse("${await Config.getUrl()}get_task_list"), body: {
        'token': await getSharedPreference('token'),
      });
      if (response.statusCode == 200) {
        return getTaskListFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getTaskDetails(String taskId) async {
    try {
      http.Response response = await http
          .post(Uri.parse("${await Config.getUrl()}get_task_details"), body: {
        'token': await getSharedPreference('token'),
        'task_id': taskId,
      });
      if (response.statusCode == 200) {
        return taskDetailsModelFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getTaskStatus() async {
    try {
      http.Response response = await http
          .post(Uri.parse("${await Config.getUrl()}get_task_status"), body: {
        'token': await getSharedPreference('token'),
      });
      if (response.statusCode == 200) {
        return taskStatusModelFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future updateTaskStatus(
    String taskId,
    String imagePath,
    String comment,
    String status,
  ) async {
    try {
      var uri = Uri.parse("${await Config.getUrl()}update_task_status");
      var request = http.MultipartRequest('POST', uri);
      request.fields.addAll({
        'token': await getSharedPreference('token'),
        'task_id': taskId,
        'status': status,
        'comment': comment
      });
      if (imagePath.isNotEmpty) {
        request.files
            .add(await http.MultipartFile.fromPath('task_image', imagePath));
      }
      var response = await request.send();
      if (response.statusCode == 200) {
        return successResponseFromJson(await response.stream.bytesToString());
      }
    } catch (e) {
      log("Error: ${e.toString()}");
    }
  }

  static Future addAttendance(
    String taskId,
    String imagePath,
    String latitude,
    String longitude,
  ) async {
    try {
      var uri = Uri.parse("${await Config.getUrl()}add_attendance");
      var request = http.MultipartRequest('POST', uri);
      request.fields.addAll({
        'token': await getSharedPreference('token'),
        'task_id': taskId,
        'latitude': latitude,
        'longitude': longitude
      });
      if (imagePath.isNotEmpty) {
        request.files.add(
            await http.MultipartFile.fromPath('attendance_image', imagePath));
      }
      var response = await request.send();
      if (response.statusCode == 200) {
        return successResponseFromJson(await response.stream.bytesToString());
      }
    } catch (e) {
      log("Error: ${e.toString()}");
    }
  }

  static Future getTaskHistory(String taskId) async {
    try {
      http.Response response = await http
          .post(Uri.parse("${await Config.getUrl()}get_task_history"), body: {
        'token': await getSharedPreference('token'),
        'task_id': taskId,
      });
      if (response.statusCode == 200) {
        return taskHistoryModelFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getNotifications() async {
    try {
      http.Response response = await http
          .post(Uri.parse("${await Config.getUrl()}get_notifications"), body: {
        'token': await getSharedPreference('token'),
      });
      if (response.statusCode == 200) {
        return notificationListModelFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
