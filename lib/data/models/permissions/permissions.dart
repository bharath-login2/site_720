class PermissionResponse {
  final PermissionData data;
  final bool status;
  final String message;

  PermissionResponse({
    required this.data,
    required this.status,
    required this.message,
  });

  factory PermissionResponse.fromJson(Map<String, dynamic> json) {
    return PermissionResponse(
      data: PermissionData.fromJson(json['data'] ?? {}),
      status: json['status'] ?? false,
      message: json['message'] ?? '',
    );
  }
}

class PermissionData {
  final List<String> permissions;

  PermissionData({
    required this.permissions,
  });

  factory PermissionData.fromJson(Map<String, dynamic> json) {
    return PermissionData(
      permissions: List<String>.from(
        json['permissions'] ?? [],
      ),
    );
  }
}
 

///use in the flag modules
// class PermissionResponse {
//   final PermissionData data;
//   final bool status;
//   final String message;

//   PermissionResponse({
//     required this.data,
//     required this.status,
//     required this.message,
//   });

//   factory PermissionResponse.fromJson(Map<String, dynamic> json) {
//     return PermissionResponse(
//       data: PermissionData.fromJson(json['data'] ?? {}),
//       status: json['status'] ?? false,
//       message: json['message'] ?? '',
//     );
//   }
// }

// class PermissionData {
//   final List<String> permissions;
//   final String? uploadCallLog;
//   final String? multipleUsers;
//   final String? multipleWorks;
//   final String? addLeadSource;
//   final String? proformaInvoicesMenu;
//   final String? gstInvoicesMenu;
//   final String? receiptsMenu;
//   final String? pendingInvoicesMenu;
//   final String? invoicesMenu;
//   final String? expenseDashboard;
//   final String? expenseMenu;
//   final String? staffManagementModule;
//   final String? projectManagementModule;
//   final String? supplierModule;
//   final String? subcontractorWorksModule;
//   final String? taskManagementModule;
//   final String? staffRequestModule;
//   final String? stageWiseScheduleModule;
//   final List<UserMenu> userMenus;

//   PermissionData({
//     required this.permissions,
//     this.uploadCallLog,
//     this.multipleUsers,
//     this.multipleWorks,
//     this.addLeadSource,
//     this.proformaInvoicesMenu,
//     this.gstInvoicesMenu,
//     this.receiptsMenu,
//     this.pendingInvoicesMenu,
//     this.invoicesMenu,
//     this.expenseDashboard,
//     this.expenseMenu,
//     this.staffManagementModule,
//     this.projectManagementModule,
//     this.supplierModule,
//     this.subcontractorWorksModule,
//     this.taskManagementModule,
//     this.staffRequestModule,
//     this.stageWiseScheduleModule,
//     required this.userMenus,
//   });

//   factory PermissionData.fromJson(Map<String, dynamic> json) {
//     return PermissionData(
//       permissions: List<String>.from(
//         json['permissions'] ?? [],
//       ),
//       uploadCallLog: json['upload_call_log'],
//       multipleUsers: json['multiple_users'],
//       multipleWorks: json['multiple_works'],
//       addLeadSource: json['add_lead_source'],
//       proformaInvoicesMenu: json['proforma_invoices_menu'],
//       gstInvoicesMenu: json['gst_invoices_menu'],
//       receiptsMenu: json['receipts_menu'],
//       pendingInvoicesMenu: json['pending_invoices_menu'],
//       invoicesMenu: json['invoices_menu'],
//       expenseDashboard: json['expense_dashboard'],
//       expenseMenu: json['expense_menu'],
//       staffManagementModule: json['staff_management_module'],
//       projectManagementModule: json['project_management_module'],
//       supplierModule: json['supplier_module'],
//       subcontractorWorksModule: json['subcontractor_works_module'],
//       taskManagementModule: json['task_management_module'],
//       staffRequestModule: json['staff_request_module'],
//       stageWiseScheduleModule: json['stage_wise_schedule_module'],
//       userMenus: (json['userMenus'] as List? ?? [])
//           .map((e) => UserMenu.fromJson(e))
//           .toList(),
//     );
//   }
// }

// class UserMenu {
//   final String categoryName;

//   UserMenu({
//     required this.categoryName,
//   });

//   factory UserMenu.fromJson(Map<String, dynamic> json) {
//     return UserMenu(
//       categoryName: json['category_name'] ?? '',
//     );
//   }
// }