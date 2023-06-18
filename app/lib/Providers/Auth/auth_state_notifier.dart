import 'package:hooks_riverpod/hooks_riverpod.dart';

class AuthScreenStateNotifier extends StateNotifier<AuthPage>{
  AuthScreenStateNotifier() : super(AuthPage.login);

  void changePage(AuthPage screen){
    state = screen;
  }
}
enum AuthPage{
  login, registration
}