import 'package:app/Models/Users/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserFriendModel {
  int status;
  UserModel user;

  UserFriendModel({required this.status, required this.user});

  factory UserFriendModel.fromJson(Map<String, dynamic> json) {
    return UserFriendModel(
      status: json["status"],
      user: UserModel.fromJson(json["user"]),
    );
  }

  static Future<UserFriendModel> fromFirestore(int status,DocumentSnapshot doc) async {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
    if (data == null) throw Exception('Document data was null');
    UserModel user = UserModel.fromJson(data);
    user = user.copyWith(id: doc.id);
    return UserFriendModel(status: status, user: user);
  }

}