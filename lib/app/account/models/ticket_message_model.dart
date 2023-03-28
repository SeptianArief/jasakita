// To parse this JSON data, do
//
//     final ticketMessageModel = ticketMessageModelFromJson(jsonString);

import 'dart:convert';

TicketMessageModel ticketMessageModelFromJson(String str) =>
    TicketMessageModel.fromJson(json.decode(str));

String ticketMessageModelToJson(TicketMessageModel data) =>
    json.encode(data.toJson());

class TicketMessageModel {
  TicketMessageModel({
    this.ticketId,
    required this.allMessages,
    this.q,
  });

  String? ticketId;
  List<AllMessage> allMessages;
  String? q;

  factory TicketMessageModel.fromJson(Map<String, dynamic> json) =>
      TicketMessageModel(
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
    this.id,
    this.message,
    this.notify,
    this.attachment,
    this.type,
    this.supportTicketId,
    required this.createdAt,
    required this.updatedAt,
  });

  int? id;
  String? message;
  String? notify;
  dynamic attachment;
  String? type;
  int? supportTicketId;
  DateTime createdAt;
  DateTime updatedAt;

  factory AllMessage.fromJson(Map<String, dynamic> json) => AllMessage(
        id: json["id"],
        message: json["message"],
        notify: json["notify"] == null ? null : json["notify"],
        attachment: json["attachment"],
        type: json["type"],
        supportTicketId: int.parse(json["support_ticket_id"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "message": message,
        "notify": notify == null ? null : notify,
        "attachment": attachment,
        "type": type,
        "support_ticket_id": supportTicketId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
