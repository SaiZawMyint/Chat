import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final int? id;
  final String senderId;
  final String message;
  final DateTime? createdAt;
  final List readBy;

  const MessageModel(
      this.id, this.senderId, this.message, this.createdAt, this.readBy);

  MessageModel.name(
      {required this.senderId,
      required this.message,
      this.createdAt,
      required this.readBy,
      this.id});

  factory MessageModel.fromJson(int id, Map<String, dynamic> json) {
    DateTime cAt = DateTime.now();
    if(json["createdAt"]!=null) {
      final d = json["createdAt"] as Timestamp;
      cAt = d.toDate();
    }
    return MessageModel(id, json["senderId"]??"", json["message"],
        cAt, json["readBy"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "senderId": senderId,
      "message": message,
      "createdAt": Timestamp.fromDate(createdAt ?? DateTime.now()),
      "readBy": readBy
    };
  }
}
