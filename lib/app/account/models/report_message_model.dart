// To parse this JSON data, do
//
//     final reportMessageModel = reportMessageModelFromJson(jsonString);

import 'dart:convert';

ReportMessageModel reportMessageModelFromJson(String str) =>
    ReportMessageModel.fromJson(json.decode(str));

String reportMessageModelToJson(ReportMessageModel data) =>
    json.encode(data.toJson());

class ReportMessageModel {
  ReportMessageModel({
    required this.ticketId,
    required this.allMessages,
    required this.q,
  });

  String ticketId;
  List<AllMessage> allMessages;
  String q;

  factory ReportMessageModel.fromJson(Map<String, dynamic> json) =>
      ReportMessageModel(
        ticketId: json["ticket_id"],
        allMessages: List<AllMessage>.from(
            json["all_messages"].map((x) => AllMessage.fromJson(x))),
        q: json["q"],
      );

  Map<String, dynamic> toJson() => {
        "ticket_id": ticketId,
        "all_messages": List<dynamic>.from(allMessages.map((x) => x.toJson())),
        "q": q,
      };
}

class AllMessage {
  AllMessage({
    required this.id,
    required this.reportId,
    this.adminId,
    this.sellerId,
    this.buyerId,
    required this.message,
    required this.type,
    this.notify,
    this.attachment,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int reportId;
  dynamic adminId;
  int? sellerId;
  int? buyerId;
  String message;
  String type;
  String? notify;
  dynamic attachment;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory AllMessage.fromJson(Map<String, dynamic> json) => AllMessage(
        id: json["id"],
        reportId: int.parse(json["report_id"]),
        adminId: json["admin_id"],
        sellerId: int.parse(json["seller_id"] ?? '0'),
        buyerId: int.parse(json["buyer_id"] ?? '0'),
        message: json["message"],
        type: json["type"],
        notify: json["notify"],
        attachment: json["attachment"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "report_id": reportId,
        "admin_id": adminId,
        "seller_id": sellerId,
        "buyer_id": buyerId,
        "message": message,
        "type": type,
        "notify": notify,
        "attachment": attachment,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
      };
}
