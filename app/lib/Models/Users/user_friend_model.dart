import 'package:app/Models/Users/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserFriendModel {
  int status;
  String roomId;
  UserModel user;
  String? recentMessage;

  UserFriendModel(
      {required this.status,
      required this.user,
      required this.roomId,
      this.recentMessage});

  UserFriendModel copyWith(
      {int? status, String? roomId, UserModel? user, String? recentMessage}) {
    return UserFriendModel(
        status: status ?? this.status,
        user: user ?? this.user,
        roomId: roomId ?? this.roomId,
        recentMessage: recentMessage ?? this.recentMessage);
  }

  factory UserFriendModel.fromJson(Map<String, dynamic> json) {
    return UserFriendModel(
        status: json["status"],
        user: UserModel.fromJson(json["user"]),
        roomId: json["roomId"] ?? "");
  }

  static UserFriendModel fromFirestore(
      int status, String roomId,String recentMessage, DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
    if (data == null) throw Exception('Document data was null');
    UserModel user = UserModel.fromJson(data);
    user = user.copyWith(id: doc.id);
    return UserFriendModel(status: status, user: user, roomId: roomId, recentMessage: recentMessage);
  }
}
