import 'package:app/Models/user.dart';
import 'package:app/Providers/app_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


typedef FormSubmitCallback = Function(bool result);

class AuthController extends StateNotifier<AuthState> {
  final Ref ref;

  bool isLoading = false;
  bool isErrorOccur = false;

  AuthController(this.ref):super(AuthState());

  void setName(String name) {
    state = state.copyWith(name: name);
  }

  void setEmail(String email) {
    state = state.copyWith(email: email);
  }

  void setPassword(String password) {
    state = state.copyWith(password: password);
  }

  String get name => state.name;
  String get email => state.email;
  String get password => state.password;

  void submit(GlobalKey<FormState> formKey, bool signIn,FormSubmitCallback callback) async{
    final form = formKey.currentState;
    if(form != null && form.validate()){
      final authService = ref.watch(AppProvider.authServiceProvider);
      UserModel? user = signIn ? await authService.signIn(email, password): await authService.register(name, email, password);
      callback(user != null);
    }
    // callback(false);
  }

  String? validate(String? value, [String? label]) {
    String prefix = label ?? "Text";
    if (value == null) return "$prefix cannot be empty!";
    if (value.length < 4) return "$prefix must be at least 4 characters";
    return null;
  }
}

class AuthState {
  AuthState({
    this.name = '',
    this.email = '',
    this.password = '',
  });

  final String name;
  final String email;
  final String password;

  AuthState copyWith({
    String? name,
    String? email,
    String? password,
  }) {
    return AuthState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
