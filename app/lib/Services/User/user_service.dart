import 'package:app/Models/Users/user_model.dart';
import 'package:app/Providers/Commons/notifications.dart';
import 'package:app/Providers/app_provider.dart';
import 'package:app/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../Models/Users/user_friend_model.dart';
import '../Firebase/firebase_service.dart';

class UserService {
  final Ref ref;
  final FirebaseService firebase;

  UserService(this.ref, this.firebase);

  Stream<UserModel> getUserStream(String uid) {
    Stream<DocumentSnapshot<Map<String, dynamic>>> snapShootStream =
        firebase.firestore.collection('users').doc(uid).snapshots();
    return snapShootStream.map((event) {
      final data = event.data();
      if (data == null) return UserModel();
      data["id"] = event.id;
      UserModel model = UserModel.fromJson(data);
      model = model.copyWith(id: event.id);
      return model;
    });
  }

  Future<UserModel?> getUserModel(String uid) async {
    final snapshot =
        await firebase.firestore.collection('users').doc(uid).get();
    final data = snapshot.data();
    if (data == null) {
      return null;
    } else {
      data["id"] = snapshot.id;
      return UserModel.fromJson(data);
    }
  }

  Stream<bool> checkUser() {
    final snapShootStream = firebase.firestore
        .collection('users')
        .doc(firebase.firebaseAuth.currentUser!.uid)
        .snapshots();
    return snapShootStream.map((event) {
      return event.exists;
    });
  }

  Stream<List<UserModel>> getAllUserLists() {
    final snapShootStream = firebase.firestore.collection('users').snapshots();

    return snapShootStream.asyncMap((event) async {
      List<UserModel> userModel = [];
      for (var doc in event.docs) {
        if (doc.id == firebase.firebaseAuth.currentUser!.uid) continue;
        final friends = await getFriendsFuture();
        int index = friends.indexWhere((element) => element.user.id == doc.id);
        if (index != -1) {
          continue;
        }
        UserModel user = UserModel.fromJson(doc.data());
        user = user.copyWith(id: doc.id);
        userModel.add(user);
      }
      return userModel;
    });
  }

  Future<List<UserFriendModel>> getFriendsFuture() async {
    String uid = firebase.firebaseAuth.currentUser!.uid;
    final friends =
        await firebase.firestore.collection("friendship").doc(uid).get();
    final data = friends.data();
    if (data == null || !data.containsKey("friends")) return [];
    List<Map<String, dynamic>> friendList =
        List<Map<String, dynamic>>.from(data["friends"]);
    final futureFriends = friendList.map((friend) async {
      DocumentReference friendRef = friend["user"];
      DocumentSnapshot userDoc = await friendRef.get();
      return UserFriendModel.fromFirestore(
          friend["status"], friend["roomId"] ?? "", "", userDoc);
    });
    return await Future.wait(futureFriends);
  }

  Stream<List<UserFriendModel>> getFriends() {
    try {
      String uid = firebase.firebaseAuth.currentUser!.uid;
      final friendshipSnapshot =
          firebase.firestore.collection("friendship").doc(uid).snapshots();
      return friendshipSnapshot.asyncMap((snap) async {
        if (!snap.exists && snap.data() == null ||
            !snap.data()!.containsKey("friends")) return [];
        List<Map<String, dynamic>> friendData =
            List<Map<String, dynamic>>.from(await snap.get("friends"));
        List<Future<UserFriendModel>> futureFriends =
            friendData.reversed.map((friend) async {
          DocumentReference friendRef = friend["user"];
          DocumentSnapshot userDoc = await friendRef.get();
          return UserFriendModel.fromFirestore(
              friend["status"], friend["roomId"] ?? "", "", userDoc);
        }).toList();
        List<UserFriendModel> friends = await Future.wait(futureFriends);
        return friends;
      });
    } catch (e) {
      logger.e("Error : ${e.toString()}");
      return Stream.error(e);
    }
  }

  ///request a friend
  Future<bool> requestFriend(String requestId) async {
    final notifications = ref.watch(AppProvider.notificationsProvider.notifier);
    try {
      String uid = firebase.firebaseAuth.currentUser!.uid;
      final friendshipCollection = firebase.firestore.collection("friendship");
      final requester = friendshipCollection.doc(requestId);
      DocumentReference fRef = firebase.firestore.collection("users").doc(uid);
      final receiver = friendshipCollection.doc(uid);
      DocumentReference uRef =
          firebase.firestore.collection("users").doc(requestId);
      return await _applyFriendRequest(requester, fRef, 0) &&
          await _applyFriendRequest(receiver, uRef, 3);
    } catch (e) {
      logger.e("Request failed : ${e.toString()}");
      notifications.addNotification(
          NotificationType.error, "Request Friend", e.toString());
      return false;
    }
  }

  Future<bool> acceptFriend(String requestId) async {
    final notifications = ref.watch(AppProvider.notificationsProvider.notifier);
    try {
      String uid = firebase.firebaseAuth.currentUser!.uid;
      final friendshipCollection = firebase.firestore.collection("friendship");
      final requester = friendshipCollection.doc(requestId);
      DocumentReference fRef = firebase.firestore.collection("users").doc(uid);
      final receiver = friendshipCollection.doc(uid);
      DocumentReference uRef =
          firebase.firestore.collection("users").doc(requestId);
      final roomService = ref.watch(AppProvider.roomServiceProvider);
      String roomId = await roomService.createChatRoom();
      return await _applyFriendRequest(requester, fRef, 1, roomId) &&
          await _applyFriendRequest(receiver, uRef, 1, roomId);
    } catch (e) {
      logger.e("Request failed : ${e.toString()}");
      notifications.addNotification(
          NotificationType.error, "Request Friend", e.toString());
      return false;
    }
  }

  Future<bool> cancelFriendRequest(String requestId) async {
    try {
      String uid = firebase.firebaseAuth.currentUser!.uid;
      final friendshipCollection = firebase.firestore.collection("friendship");
      final requester = friendshipCollection.doc(requestId);
      DocumentReference fRef = firebase.firestore.collection("users").doc(uid);
      final receiver = friendshipCollection.doc(uid);
      DocumentReference uRef =
          firebase.firestore.collection("users").doc(requestId);

      return await _cancelFriendRequest(requester, fRef, 3) &&
          await _cancelFriendRequest(receiver, uRef, 0);
    } catch (e) {
      logger.e("Error while cancelling request: ${e.toString()}");
      return false;
    }
  }

  Future<bool> _applyFriendRequest(
      DocumentReference<Map<String, dynamic>> sender,
      DocumentReference receiver,
      int status,
      [String? roomId]) async {
    final snapshot = await sender.get();
    final data = snapshot.data();
    if (data != null && data.containsKey("friends")) {
      final updateFriends = List<Map<String, dynamic>>.from(data["friends"]);
      bool check = true, sCheck = false;
      Map<String, dynamic> x = {};
      for (var element in updateFriends) {
        if (element.containsKey("user") && element["user"] == receiver) {
          if (element.containsKey("status") && element["status"] == status) {
            check = false;
            break;
          } else {
            sCheck = true;
            x = element;
          }
        }
      }
      if (check) {
        if (sCheck) {
          logger.i("Status change detected");
          updateFriends.remove(x);
        }
        updateFriends
            .add({"user": receiver, "status": status, "roomId": roomId ?? ""});
        await sender.update({"friends": updateFriends});
        return true;
      } else {
        logger.e("Friend already requested");
        return false;
      }
    } else {
      await sender.set({
        "friends": [
          {"user": receiver, "status": status, "roomId": ""}
        ]
      });
      return true;
    }
  }

  Future<bool> _cancelFriendRequest(
      DocumentReference<Map<String, dynamic>> sender,
      DocumentReference receiver,
      int status) async {
    final snapshot = await sender.get();
    bool result = false;
    final data = snapshot.data();
    if (data == null || !data.containsKey("friends")) {
      return false;
    }
    final updateFriends = List<Map<String, dynamic>>.from(data["friends"]);
    for (var element in updateFriends) {
      if (element.containsKey("user") &&
          element["user"] == receiver &&
          element.containsKey("status") &&
          element["status"] == status) {
        updateFriends.remove(element);
        result = true;
        await sender.update({"friends": updateFriends});
        break;
      }
    }
    return result;
  }
}
