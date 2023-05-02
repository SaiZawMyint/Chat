import 'package:app/Providers/app_provider.dart';
import 'package:app/Screens/Commons/notification_widget.dart';
import 'package:app/Screens/auth/registration_page.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
                            authController.validate(value, 'Email'),
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
                            authController.validate(value, "Password"),
                      ),
                      // Text("${notifications.length} notifications!"),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey,
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    )),
                                onPressed: () {
                                  authController.submit(
                                      _formKey,
                                      true,
                                      (result) => {
                                            logger.i(
                                                result ? "no error" : "error")
                                          });
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
