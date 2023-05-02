import 'package:app/Models/user.dart';
import 'package:app/Providers/Commons/notifications.dart';
import 'package:app/Providers/app_provider.dart';
import 'package:app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthService {
  final Ref ref;
  final _firebaseAuth = FirebaseAuth.instance;
  AuthService(this.ref);

  Stream<User?> get authStateChange => _firebaseAuth.authStateChanges();

  Future<UserModel?> signIn(String email, String password) async{
    final notifications = ref.watch(AppProvider.notificationsProvider.notifier);
    try{
      UserCredential signInResponse = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if(signInResponse.user == null) {
        notifications.addNotification(Type.warning,"Sign In Failed", "Invalid email or password!");
        return null;
      }
      User user = signInResponse.user!;
      return UserModel(
          id: user.uid,
          username: user.displayName ?? "",
          email: user.email ?? "");
    }on FirebaseAuthException catch(e){
      logger.e("Login error : ${e.toString()}");
      notifications.addNotification(Type.error,"Sign In Failed", e.message??"Invalid email or password!", (state) => null);
      return null;
    }
  }

  Future<UserModel?> register(String name, String email, String password) async {
    final notifications = ref.watch(AppProvider.notificationsProvider.notifier);
    try{
      UserCredential registerResponse = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      if(registerResponse.user == null) {
        notifications.addNotification(Type.warning,"Registration Failed", "Something went wrong!");
        return null;
      };
      User user = registerResponse.user!;
      return UserModel(
          id: user.uid,
          username: user.displayName ?? "",
          email: user.email ?? "");
    }on FirebaseAuthException catch(e){
      logger.e("Register error : ${e.toString()}");
      notifications.addNotification(Type.error,"Registration Failed", e.message??"Something went wrong!", (state) => null);
      return null;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

}