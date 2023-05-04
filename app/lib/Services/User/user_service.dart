import 'package:app/Models/Users/user.dart';
import 'package:app/Providers/app_provider.dart';
import 'package:app/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserService {
  final Ref ref;

  UserService(this.ref);

  Stream<UserModel> getUserStream(String uid) {
    final firebase = ref.watch(AppProvider.firebaseServiceProvider);
    Stream<DocumentSnapshot<Map<String, dynamic>>> snapShootStream = firebase.firestore.collection('users').doc(uid).snapshots();
    return snapShootStream.map((event){
      final data = event.data();
      if(data == null) return UserModel();
      data["id"] = event.id;
      return UserModel.fromJson(data);
    });
  }

  Stream<bool> checkUser(){
    final firebase = ref.watch(AppProvider.firebaseServiceProvider);
    final snapShootStream = firebase.firestore.collection('users').doc(firebase.firebaseAuth.currentUser!.uid).snapshots();
    return snapShootStream.map((event){
      return event.exists;
    });
  }

  Stream<List<UserModel>> getAllUserLists() {
    final firebase = ref.watch(AppProvider.firebaseServiceProvider);
    final snapShootStream = firebase.firestore.collection('users').snapshots();
    return snapShootStream.map((event){
      List<UserModel> userModel = [];
      for(var doc in event.docs){
        logger.i('current logged user id is : ${firebase.firebaseAuth.currentUser!.uid}');
        if(doc.id == firebase.firebaseAuth.currentUser!.uid) continue;
        doc.data()["id"] = doc.id;
        UserModel user = UserModel.fromJson(doc.data());
        userModel.add(user);
      }
      return userModel;
    });
  }
}