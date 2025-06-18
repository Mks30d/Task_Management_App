import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tmaa/%20components/auth/signin.dart';
import 'package:tmaa/main.dart';

class HomePage extends StatelessWidget {
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task Management App"),
        backgroundColor: primaryColor,
      ),
      body: Container(
        child: ElevatedButton(
          onPressed: () async {
            auth.signOut().then(
              (value) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Signin(),
                    ));
              },
            );
          },
          child: Text("SIGN OUT"),
        ),
      ),
    );
  }
}