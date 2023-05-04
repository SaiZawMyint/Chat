import 'package:flutter/material.dart';

import '../auth/login_page.dart';

class PageLoadingError extends StatelessWidget{

  final String message;

  const PageLoadingError({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Error: $message"),
              ElevatedButton(onPressed: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(),));
              }, child: const Text("Login again"))
            ],
          ),
        ),
      ),
    );
  }

}