import 'package:app/Models/Users/user_model.dart';
import 'package:app/Providers/Commons/notifications.dart';
import 'package:app/Providers/app_provider.dart';
import 'package:app/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FirebaseService {
  final Ref ref;
  final _firebaseAuth = FirebaseAuth.instance;
  final _fireStoreDatabase = FirebaseFirestore.instance;

  FirebaseService(this.ref);

  Stream<User?> get authStateChange => _firebaseAuth.authStateChanges();

  FirebaseAuth get firebaseAuth => _firebaseAuth;
  FirebaseFirestore get firestore => _fireStoreDatabase;

  Future<User?> signIn(String email, String password) async{
    final notifications = ref.watch(AppProvider.notificationsProvider.notifier);
    try{
      UserCredential signInResponse = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if(signInResponse.user == null) {
        notifications.addNotification(NotificationType.warning,"Sign In Failed", "Invalid email or password!");
        return null;
      }
      return signInResponse.user!;
    }on FirebaseAuthException catch(e){
      logger.e("Login error : ${e.toString()}");
      notifications.addNotification(NotificationType.error,"Sign In Failed", e.message??"Invalid email or password!", (state) => null);
      return null;
    }
  }

  Future<User?> register(String email, String password) async {
    final notifications = ref.watch(AppProvider.notificationsProvider.notifier);
    try{
      UserCredential registerResponse = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      if(registerResponse.user == null) {
        notifications.addNotification(NotificationType.warning,"Registration Failed", "Something went wrong!");
        return null;
      }
      return registerResponse.user!;
    }on FirebaseAuthException catch(e){
      logger.e("Register error : ${e.toString()}");
      notifications.addNotification(NotificationType.error,"Registration Failed", e.message??"Something went wrong!", (state) => null);
      return null;
    }
  }

  Future<bool> accountInformation(UserModel user) async {
    final notifications = ref.watch(AppProvider.notificationsProvider.notifier);
    bool res = false;
    await _fireStoreDatabase.collection("users").doc(_firebaseAuth.currentUser!.uid).set(user.toJson()).then((value){
      notifications.addNotification(NotificationType.info,"Account Information", "Account Information successfully filled!!", (state) => null);
      res = true;
    }).catchError((e){
      res = false;
      notifications.addNotification(NotificationType.error,"Account Information", e.message??"Something went wrong!", (state) => null);
    });
    return res;
  }

  //check if the user exists
  Future<bool> isUserExists() async{
    return (await _fireStoreDatabase.collection("users").doc(_firebaseAuth.currentUser!.uid).get()).exists;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

}