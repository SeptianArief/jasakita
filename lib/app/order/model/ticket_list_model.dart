import 'dart:convert';

class TicketMasterModel {
  late int currentPage;
  late int lastPage;
  late List<TicketModel> data = [];

  TicketMasterModel.fromJson(Map<String, dynamic> jsonMap) {
    currentPage = jsonMap['current_page'];
    lastPage = jsonMap['last_page'];
    for (var i = 0; i < jsonMap['data'].length; i++) {
      data.add(TicketModel.fromJson(jsonMap['data'][i]));
    }
  }
}

class TicketModel {
  late int id;
  late String title;
  late String desc;
  late String priority;
  late String status;
  late String seller_id;
  late String buyer_id;

  TicketModel.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'];
    title = jsonMap['subject'];
    priority = jsonMap['priority'];
    status = jsonMap['status'];
    try {
      Map<String, dynamic> dataRaw = json.decode(jsonMap['description']);
      desc = dataRaw['data'];
      seller_id = dataRaw['seller_id'];
      buyer_id = dataRaw['buyer_id'];
    } catch (e) {
      desc = jsonMap['description'];
      seller_id = '';
      buyer_id = '';
    }
  }
}
