import 'package:app/Models/Messages/message_model.dart';
import 'package:app/Services/Configs/service_config.dart';

class Conversation {
  String id;
  List<MessageModel>? messages;
  DateTime? updatedAt;
  DateTime? createdAt;

  Conversation(this.id, this.messages, this.createdAt, this.updatedAt);

  factory Conversation.fromJson(String cId, int id, Map<String, dynamic> json) {
    List<MessageModel>? messages;
    if (json['messages'] != null) {
      final messageList = json['messages'] as List<dynamic>;
      messages = messageList.map((e) => MessageModel.fromJson(id, e)).toList();
    }

    return Conversation(
        cId,
        messages ?? [],
        ServiceConfig.timeStampToDateTime(json, 'createdAt'),
        ServiceConfig.timeStampToDateTime(json, 'updatedAt'));
  }
}
