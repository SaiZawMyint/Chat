import 'package:app/Models/Users/user.dart';
import 'package:app/Providers/app_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef FormSubmitCallback = Function(User result);

class AuthController extends StateNotifier<UserModel> {
  final Ref ref;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool isLoading = false;
  bool isErrorOccur = false;

  AuthController(this.ref) : super(UserModel());

  void setName(String name) {
    state = state.copyWith(name: name);
  }

  void setEmail(String email) {
    state = state.copyWith(email: email);
  }

  void setPassword(String password) {
    state = state.copyWith(password: password);
  }

  void setBio(String bio) {
    state = state.copyWith(bio: bio);
  }

  void setGender(String gender) {
    state = state.copyWith(gender: gender);
  }

  void setDob(DateTime dob){
    state = state.copyWith(dob: dob);
  }

  String get name => state.name;

  String get email => state.email;

  String get password => state.password;

  String get gender => state.gender;

  String get bio => state.bio;

  DateTime? get dob => state.dob;

  void submit(GlobalKey<FormState> formKey, bool signIn,
      FormSubmitCallback callback) async {
    final form = formKey.currentState;
    if (form != null && form.validate()) {
      final authService = ref.watch(AppProvider.firebaseServiceProvider);
      User? user = signIn
          ? await authService.signIn(email, password)
          : await authService.register(email, password);
      if (user != null) callback(user);
    }
    // callback(false);
  }

  Future<bool> fillAccountInformation(GlobalKey<FormState> formKey) async{
    final form = formKey.currentState;
    if(form != null && form.validate()) {
      final authService = ref.watch(AppProvider.firebaseServiceProvider);
      if(email.isEmpty) setEmail(getLoggedEmail()??"");
      return await authService.accountInformation(state);
    }
    return false;
  }

  String? validate(String? value, [String? label]) {
    String prefix = label ?? "Text";
    if (value == null) return "$prefix cannot be empty!";
    if (value.length < 4) return "$prefix must be at least 4 characters";
    return null;
  }

  String? getLoggedEmail(){
    if(_firebaseAuth.currentUser == null) return null;
    return (_firebaseAuth.currentUser!.email!);
  }
}


