import 'package:flutter/cupertino.dart';

class InputController{
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  InputController(this.emailController, this.passwordController,
      this.confirmPasswordController);

  void clear(){
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }
}