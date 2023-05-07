import 'package:app/Models/Users/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

typedef FormSubmitCallback = Function(User result);

class AuthController extends StateNotifier<UserModel> {
  final Ref ref;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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

  String? getLoggedEmail(){
    if(_firebaseAuth.currentUser == null) return null;
    return (_firebaseAuth.currentUser!.email!);
  }
}


