import 'package:app/Providers/Commons/notifications.dart';
import 'package:app/Services/User/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Models/Users/user.dart';
import '../Services/Auth/firebase_service.dart';
import 'Auth/auth_controller.dart';
import 'Users/user_controller.dart';

class AppProvider {
  ///notification provider
  static final notificationsProvider = StateNotifierProvider<NotificationController, List<NotificationState>>((ref) => NotificationController());

  ///a computed provider for firebase service provider
  static final firebaseServiceProvider = Provider((ref) => FirebaseService(ref));

  ///auth state provider to handle firebase authentication changes
  static final authStateProvider = StreamProvider.autoDispose<User?>((ref) => ref.read(AppProvider.firebaseServiceProvider).authStateChange);

  ///auth controller provider to perform auth states
  static final authController = StateNotifierProvider<AuthController, UserModel>((ref) => AuthController(ref));

  ///a computed user service provider for user service
  static final userService = Provider((ref) => UserService(ref));

  ///a state to handle user
  static final userProvider = StateNotifierProvider.family<UserController, UserModel,String>((ref, id) => UserController(ref.watch(AppProvider.userService), id));

  ///a disposable user list stream provider
  static final allUsersProvider = StreamProvider.autoDispose<List<UserModel>>((ref)=> ref.watch(userService).getAllUserLists());

}