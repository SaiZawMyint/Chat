import 'package:app/Services/Firebase/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RoomService{
  final Ref ref;
  final FirebaseService firebase;

  RoomService(this.ref, this.firebase);

  Future<String> createChatRoom([String? roomName, String? type]) async {
    final chatRef = FirebaseFirestore.instance.collection("chat").doc();
    final roomId = chatRef.id;
    await chatRef.set({
      'name': roomName ?? "Private Room",
      'type': type ?? "private_chat",
      'createdAt': FieldValue.serverTimestamp(),
    });
    await chatRef.collection('messages').doc('initialMessage').set({
      'message': 'Say hi to friend!',
      'senderId': null,
      'createdAt': FieldValue.serverTimestamp(),
    });
    await chatRef.collection('messages').doc('conversations').set({
      "messages":[
        {
          'message': 'Say hi to friend!',
          'senderId': null,
          'readBy': []
        }
      ],
      "createdAt": DateTime.now(),
      "updatedAt": DateTime.now()
    });
    return roomId;
  }

}