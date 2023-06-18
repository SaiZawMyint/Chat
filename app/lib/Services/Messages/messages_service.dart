import 'package:app/Models/Messages/message_model.dart';
import 'package:app/Models/Users/user_model.dart';
import 'package:app/Providers/app_provider.dart';
import 'package:app/Services/Configs/service_config.dart';
import 'package:app/main.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../Firebase/firebase_service.dart';

class MessageServices {
  final Ref ref;
  final FirebaseService firebase;

  MessageServices(this.ref, this.firebase);



  Stream<List<MessageModel>> getRoomMessage(String roomId) {
    return firebase.firestore
        .collection("chat")
        .doc(roomId)
        .collection("messages")
        .doc("conversations")
        .snapshots()
        .map((snapshot) {
      if (snapshot.data() == null) return [];
      final data = snapshot.data() as Map<String, dynamic>;
      if (!data.containsKey("messages")) return [];
      final messages = data["messages"] as List<dynamic>;
      List<MessageModel> messagesList = [];
      var count = 0;
      for (var msg in messages) {
        if (msg["senderId"] == null) continue;
        messagesList.add(MessageModel.fromJson(count++, msg));
      }
      return messagesList;
    });
  }

  Future<bool> sendMessage(String roomId, UserModel sender, UserModel receiver, MessageModel model) async {
    try {
      final userService = ref.watch(AppProvider.userService);
      final fcmService = ref.watch(AppProvider.firebaseCloudServiceProvider);
      final snapshot = firebase.firestore
          .collection("chat")
          .doc(roomId)
          .collection("messages")
          .doc("conversations");
      final snap = await snapshot.get();
      if (snap.exists) {
        final data = snap.data() as Map<String, dynamic>;
        final messages = List<Map<String, dynamic>>.from(data["messages"]);
        messages.add(model.toJson());
        await snapshot.update({"messages": messages, "updatedAt": DateTime.now()});
      } else {
        await snapshot.set({
          "messages": [model.toJson()],
          "updatedAt": DateTime.now()
        });
      }
      final token = await fcmService.getFCMTokenByUser(receiver.id);
      final user = await userService.getUserModel(model.senderId);
      if (token != null && user != null) {
        await fcmService.sendPushNotification(token, user.name, model.message, ServiceConfig.messagePN);
      }

      return true;
    } catch (e) {
      logger.e("Error sending message : ${e.toString()}");
      return false;
    }
  }

  Stream<MessageModel?> getRecentMessageStream(String roomId) {
    return firebase.firestore
        .collection("chat")
        .doc(roomId)
        .collection("messages")
        .doc("conversations")
        .snapshots()
        .map((snapshot) {
      if (snapshot.data() == null) return null;
      final data = snapshot.data() as Map<String, dynamic>;
      if (!data.containsKey("messages")) return null;
      final messages = data["messages"] as List<dynamic>;
      final last = messages.last;
      return MessageModel.fromJson(messages.length, last);
    });
  }
}
