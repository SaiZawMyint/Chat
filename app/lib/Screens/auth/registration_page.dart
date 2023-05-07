import 'package:app/Screens/Commons/common_functions.dart';
import 'package:app/Screens/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../Providers/app_provider.dart';
import '../Commons/notification_widget.dart';

class RegistrationPage extends ConsumerWidget{
  RegistrationPage({super.key});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registrationController = ref.read(AppProvider.authController.notifier);
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
                        onChanged: registrationController.setEmail,
                        decoration: InputDecoration(
                          label: const Text("Email"),
                          hintText: "Email",
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        validator: (value) => CommonFunctions.validate(value, 'Email'),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        onChanged: registrationController.setPassword,
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
                        validator: (value) => CommonFunctions.validate(value, "Password"),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                          label: const Text("Confirm Password"),
                          hintText: "Confirm Password",
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
                        validator: (value) => registrationController.password != value && value != null ? "Password do not match!":null,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey,
                                    padding: const EdgeInsets.symmetric(vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    )),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Sign In")),
                          ),
                          const SizedBox(width: 20,),
                          Expanded(
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    )),
                                onPressed: () async{
                                    if (_formKey.currentState!.validate()) {
                                      final authService = ref.watch(AppProvider.firebaseServiceProvider);
                                      final user = await authService.register(registrationController.email, registrationController.password);
                                      if(user != null){
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage(),));
                                      }
                                    }
                                },
                                child: const Text("Sign Up")),
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