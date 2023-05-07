import 'package:app/Models/Users/user_model.dart';
import 'package:app/Providers/Commons/notifications.dart';
import 'package:app/Providers/app_provider.dart';
import 'package:app/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../Models/Users/user_friend_model.dart';
import '../Auth/firebase_service.dart';

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
      return UserModel.fromJson(data);
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
    return snapShootStream.map((event) {
      List<UserModel> userModel = [];
      for (var doc in event.docs) {
        logger.i(
            'current logged user id is : ${firebase.firebaseAuth.currentUser!.uid}');
        if (doc.id == firebase.firebaseAuth.currentUser!.uid) continue;

        UserModel user = UserModel.fromJson(doc.data());
        user = user.copyWith(id: doc.id);
        userModel.add(user);
      }
      return userModel;
    });
  }

  Stream<List<UserFriendModel>> getFriends() {
    String uid = firebase.firebaseAuth.currentUser!.uid;
    logger.i("Current friend user : $uid");
    final friendshipSnapshot =
        firebase.firestore.collection("friendship").doc(uid).snapshots();
    return friendshipSnapshot.asyncMap((snap) async {
      if (!snap.exists) return [];
      List<Map<String, dynamic>> friendData =
          List<Map<String, dynamic>>.from(await snap.get("friends"));
      List<Future<UserFriendModel>> futureFriends =
          friendData.map((friend) async {
        DocumentReference friendRef = friend["user"];
        DocumentSnapshot userDoc = await friendRef.get();
        return UserFriendModel.fromFirestore(friend["status"], userDoc);
      }).toList();
      List<UserFriendModel> friends = await Future.wait(futureFriends);
      return friends;
    });
  }

  Future<UserFriendModel?> getUserFriend(Map<String, dynamic> data) async {
    UserModel? user = await getUserModel(data["id"]);
    if (user == null) return null;
    return UserFriendModel(status: data["status"], user: user);
  }

  ///request a friend
  Future<bool> requestFriend(String requestId) async {
    final notifications = ref.watch(AppProvider.notificationsProvider.notifier);
    try {
      String uid = firebase.firebaseAuth.currentUser!.uid;
      final friendshipCollection = firebase.firestore.collection("friendship");
      final requester = friendshipCollection.doc(requestId);
      DocumentReference fRef = firebase.firestore.collection("users").doc(uid);
      return await _applyFriendRequest(requester, fRef, 0);
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
      DocumentReference uRef = firebase.firestore.collection("users").doc(requestId);
      return await _applyFriendRequest(requester, fRef, 1) && await _applyFriendRequest(receiver,uRef,1);
    } catch (e) {
      logger.e("Request failed : ${e.toString()}");
      notifications.addNotification(
          NotificationType.error, "Request Friend", e.toString());
      return false;
    }
  }

  Future<bool> _applyFriendRequest(DocumentReference<Map<String, dynamic>> sender,
      DocumentReference receiver, int status) async {
    final snapshot = await sender.get();
    final data = snapshot.data();
    if (data != null && data.containsKey("friends")) {
      final updateFriends = List<Map<String, dynamic>>.from(data["friends"]);
      bool check = true, sCheck = false;
      Map<String, dynamic> x = {};
      for (var element in updateFriends) {
        if (element.containsKey("user") &&
            element["user"] == receiver
            ) {
          if(element.containsKey("status") &&
              element["status"] == status){
            check = false;
            break;
          }else{
            sCheck = true;
            x = element;
          }
        }
      }
      if (check) {
        if(sCheck){
          logger.i("Status change detected");
          updateFriends.remove(x);
        }
        updateFriends.add({"user": receiver, "status": status});
        await sender.update({"friends": updateFriends});
        return true;
      }else{
        logger.e("Friend already requested");
        return false;
      }
    } else {
      await sender.set({
        "friends": [
          {"user": receiver, "status": status}
        ]
      });
      return true;
    }
  }
}
