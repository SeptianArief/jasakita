class ReportListModelMaster {
  late int currentPage;
  late int lastPage;
  late List<ReportListModel> data = [];

  ReportListModelMaster.fromJson(Map<String, dynamic> jsonMap) {
    currentPage = jsonMap['current_page'];
    lastPage = jsonMap['last_page'];
    for (var i = 0; i < jsonMap['data'].length; i++) {
      data.add(ReportListModel.fromJson(jsonMap['data'][i]));
    }
  }
}

class ReportListModel {
  late int id;
  late String orderId;
  late String serviceId;
  late String sellerId;
  late String buyerId;
  late String reportTo;
  late String reportFrom;
  late String status;
  late String reportMessage;
  late String createdAt;
  late String? udpatedAt;

  ReportListModel.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'];
    orderId = jsonMap['order_id'];
    serviceId = jsonMap['service_id'];
    sellerId = jsonMap['seller_id'];
    buyerId = jsonMap['buyer_id'];
    reportTo = jsonMap['report_to'];
    reportFrom = jsonMap['report_from'];
    status = jsonMap['status'];
    reportMessage = jsonMap['report'];
    createdAt = jsonMap['created_at'];
    udpatedAt = jsonMap['updated_at'];
  }
}
