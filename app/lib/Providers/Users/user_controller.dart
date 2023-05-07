import 'package:app/Models/Users/user_model.dart';
import 'package:app/Services/User/user_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserController extends StateNotifier<UserModel> {
  final UserService userService;

  UserController(this.userService, String uid) : super(UserModel()) {
    final stream = userService.getUserStream(uid);
    stream.listen((event) {
      state = event;
    });
  }

  UserService get getUserService => userService;
}