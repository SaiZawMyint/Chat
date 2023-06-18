import 'package:app/Models/Users/user_model.dart';
import 'package:app/Services/User/user_service.dart';
import 'package:app/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserStateNotifier extends StateNotifier<UserModel> {
  final UserService userService;

  UserStateNotifier(this.userService, String uid) : super(UserModel()) {
    try{
      final stream = userService.getUserStream(uid);
      stream.listen((event) {
        state = event;
      });
    }catch(e){
      logger.w("Watching user stream containing errors : ${e.toString()}");
    }
  }

  UserService get getUserService => userService;
}