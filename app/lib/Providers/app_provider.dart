import 'package:app/Providers/Commons/notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Services/auth_service.dart';
import 'Auth/auth_controller.dart';

class AppProvider {

  //notification
  static final notificationsProvider = StateNotifierProvider<NotificationController, List<NotificationState>>((ref) => NotificationController());

  static final authServiceProvider = Provider((ref) => AuthService(ref));

  static final authStateProvider = StreamProvider<User?>((ref) => ref.read(AppProvider.authServiceProvider).authStateChange);

  static final authController = StateNotifierProvider<AuthController, AuthState>((ref) => AuthController(ref));


}