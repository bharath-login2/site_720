import 'dart:convert';

class SaveExtraWorkRequestResponse {
  final dynamic data;
  final bool status;
  final String message;

  SaveExtraWorkRequestResponse({
    this.data,
    required this.status,
    required this.message,
  });

  factory SaveExtraWorkRequestResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return SaveExtraWorkRequestResponse(
      data: json['data'],
      status: json['status'] == true ||
          json['status'] == 'true' ||
          json['status'] == 1,
      message: json['message']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'status': status,
      'message': message,
    };
  }
}

class ExtraWorkRequestListResponse {
  final bool status;
  final String message;
  final List<ExtraWorkRequestModel> data;

  ExtraWorkRequestListResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ExtraWorkRequestListResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    List<ExtraWorkRequestModel> itemsList = [];

    if (json['data'] is List) {
      itemsList = (json['data'] as List)
          .whereType<Map<String, dynamic>>()
          .map(
            (item) => ExtraWorkRequestModel.fromJson(item),
          )
          .toList();
    }

    return ExtraWorkRequestListResponse(
      status: json['status'] == true ||
          json['status'] == 'true' ||
          json['status'] == 1,
      message: json['message']?.toString() ?? '',
      data: itemsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class ExtraWorkItem {
  String id;
  String itemName;
  String qty;
  String remarks;
  String isApproved;

  ExtraWorkItem({
    this.id = '',
    required this.itemName,
    required this.qty,
    required this.remarks,
    this.isApproved = 'N',
  });

  factory ExtraWorkItem.fromJson(Map<String, dynamic> json) {
    return ExtraWorkItem(
      id: json['id']?.toString() ?? '',
      itemName: json['item_name']?.toString() ?? '',
      qty: json['qty']?.toString() ?? '',
      remarks: json['remarks']?.toString() ?? '',
      isApproved: json['is_approved']?.toString() ?? 'N',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'item_name': itemName,
      'qty': qty,
      'remarks': remarks,
      'is_approved': isApproved,
    };
  }
}

class ExtraWorkRequestModel {
  final String id;
  final String projectId;
  final String projectName;
  final String clientId;
  final String status;
  final String createdAt;
  final String createdBy;
  final String updatedAt;
  final String updatedBy;
  final String itemName;
  final String qty;
  final String remarks;
  final String isApproved;
  final List<ExtraWorkItem> items;

  ExtraWorkRequestModel({
    required this.id,
    required this.projectId,
    required this.projectName,
    required this.clientId,
    required this.status,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
    required this.itemName,
    required this.qty,
    required this.remarks,
    required this.isApproved,
    required this.items,
  });

  factory ExtraWorkRequestModel.fromJson(
    Map<String, dynamic> json,
  ) {
    List<ExtraWorkItem> parsedItems = [];

    final modelId = json['id']?.toString() ??
        json['request_id']?.toString() ??
        json['row_id']?.toString() ??
        '';

    final approvalStatus = json['is_approved']?.toString() ?? 'N';

    // request_data
    if (json['request_data'] != null) {
      if (json['request_data'] is String) {
        try {
          final decoded = jsonDecode(json['request_data']);

          if (decoded is List) {
            parsedItems = decoded.whereType<Map<String, dynamic>>().map((e) {
              final item = ExtraWorkItem.fromJson(e);

              if (item.id.isEmpty) {
                item.id = modelId;
              }

              return item;
            }).toList();
          } else if (decoded is Map<String, dynamic>) {
            final item = ExtraWorkItem.fromJson(decoded);

            if (item.id.isEmpty) {
              item.id = modelId;
            }

            parsedItems = [item];
          }
        } catch (_) {}
      } else if (json['request_data'] is List) {
        parsedItems = (json['request_data'] as List)
            .whereType<Map<String, dynamic>>()
            .map((e) {
          final item = ExtraWorkItem.fromJson(e);

          if (item.id.isEmpty) {
            item.id = modelId;
          }

          return item;
        }).toList();
      }
    }

    // items
    else if (json['items'] is List) {
      parsedItems =
          (json['items'] as List).whereType<Map<String, dynamic>>().map((e) {
        final item = ExtraWorkItem.fromJson(e);

        if (item.id.isEmpty) {
          item.id = modelId;
        }

        return item;
      }).toList();
    }

    final singleItemName = json['item_name']?.toString() ??
        json['itemName']?.toString() ??
        json['work']?.toString() ??
        '';

    final singleQty = json['qty']?.toString() ??
        json['quantity']?.toString() ??
        json['amount']?.toString() ??
        '';

    final singleRemarks = json['remarks']?.toString() ??
        json['remark']?.toString() ??
        json['description']?.toString() ??
        '';

    // Your current LIST API returns one item directly.
    //
    // Example:
    // {
    //   "id": "2569",
    //   "item_name": "hi",
    //   "qty": "2",
    //   "remarks": "qq",
    //   "is_approved": "N"
    // }
    //
    // Therefore create an ExtraWorkItem from that object.
    if (parsedItems.isEmpty &&
        (singleItemName.isNotEmpty ||
            singleQty.isNotEmpty ||
            singleRemarks.isNotEmpty)) {
      parsedItems.add(
        ExtraWorkItem(
          id: modelId,
          itemName: singleItemName,
          qty: singleQty,
          remarks: singleRemarks,
          isApproved: approvalStatus,
        ),
      );
    }

    return ExtraWorkRequestModel(
      id: modelId,

      projectId: json['project_id']?.toString() ?? '',

      projectName: json['project_name']?.toString() ??
          json['projectName']?.toString() ??
          '',

      clientId: json['client_id']?.toString() ?? '',

      status: json['status']?.toString() ?? 'Pending',

      createdAt:
          json['created_at']?.toString() ?? json['date']?.toString() ?? '',

      createdBy: json['created_by_name']?.toString() ??
          json['created_by']?.toString() ??
          json['creator_name']?.toString() ??
          '',

      updatedAt: json['updated_at']?.toString() ?? '',

      updatedBy: json['updated_by_name']?.toString() ??
          json['updated_by']?.toString() ??
          '',

      itemName: singleItemName,

      qty: singleQty,

      remarks: singleRemarks,

      // IMPORTANT
      isApproved: approvalStatus,

      items: parsedItems,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project_id': projectId,
      'project_name': projectName,
      'client_id': clientId,
      'status': status,
      'created_at': createdAt,
      'created_by': createdBy,
      'updated_at': updatedAt,
      'updated_by': updatedBy,
      'item_name': itemName,
      'qty': qty,
      'remarks': remarks,
      'is_approved': isApproved,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }
}
