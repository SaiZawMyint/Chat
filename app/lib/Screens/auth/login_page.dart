import 'dart:ui';

import 'package:app/Providers/app_provider.dart';
import 'package:app/Screens/Commons/common_functions.dart';
import 'package:app/Screens/Commons/notification_widget.dart';
import 'package:app/Screens/Commons/widget_utils.dart';
import 'package:app/Screens/auth/registration_page.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rive/rive.dart' as rive;


class LoginPage extends ConsumerWidget {
  LoginPage({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.watch(AppProvider.authController.notifier);
    return Scaffold(
      // backgroundColor: Colors.blue,
      body: Stack(
        children: [
          const rive.RiveAnimation.asset("assets/rives/shapes.riv", fit: BoxFit.cover,),
          Positioned.fill(child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: const SizedBox(),
          ),),
          const rive.RiveAnimation.asset("assets/rives/messenger_icon.riv"),
          SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextFormField(
                        onChanged: authController.setEmail,
                        decoration: InputDecoration(
                          label: const Text("Email"),
                          hintText: "Email",
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        validator: (value) =>
                            CommonFunctions.validate(value, 'Email'),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        onChanged: authController.setPassword,
                        decoration: InputDecoration(
                          label: const Text("Password"),
                          hintText: "Password",
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: Colors.grey.shade800,
                              width: 3.0,
                            ),
                          ),
                        ),
                        obscureText: true,
                        validator: (value) =>
                            CommonFunctions.validate(value, "Password"),
                      ),
                      // Text("${notifications.length} notifications!"),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ElevatedButton(

                                style: ElevatedButton.styleFrom(
                                  elevation: 1,
                                    backgroundColor: Colors.black12,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    )),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            RegistrationPage(),
                                      ));
                                },
                                child: const Text("Sign Up")),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: WidgetUtils.appColors,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    )),
                                onPressed: () async{
                                  if (_formKey.currentState!.validate()) {
                                      final authService = ref.read(AppProvider.firebaseServiceProvider);
                                      await authService.signIn(authController.email, authController.password);
                                    }
                                },
                                child: const Text("Sign In")),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 10,
            child: Center(
              child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width,
                    maxHeight: MediaQuery.of(context).size.height * 0.6,
                  ),
                  child: const NotificationWidget()),
            ),
          ),
        ],
      ),
    );
  }
}
