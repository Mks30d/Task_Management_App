// import 'package:firebase/components/signin_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tmaa/%20components/auth/signin.dart';

import '../../main.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> createUserWithEmailAndPassword() async {
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim());
      print("userCredential:--- $userCredential");
      print("user:--- ${userCredential.user}");
      print("email:--- ${userCredential.user!.email}");
      print("uid:--- ${userCredential.user!.uid}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Successful..."),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print("error:--- $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Sign Up Page"),
      //   backgroundColor: Colors.blue,
      // ),
      backgroundColor: offWhite,
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Let's get Started!",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: 'Email',
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await createUserWithEmailAndPassword();
                  print("emailController: ${emailController.text}");
                  print("passwordController: ${passwordController.text}");
                },
                child: const Text(
                  'Sign up',
                  // style: TextStyle(
                  //   fontSize: 16,
                  //   color: Colors.white,
                  // ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondaryColor, // Button color
                  foregroundColor: white, // Text/icon color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Signin(),
                      ));
                },
                child: RichText(
                  text: TextSpan(
                    text: 'Already have an account? ',
                    style: Theme.of(context).textTheme.titleMedium,
                    children: [
                      TextSpan(
                        text: 'Sign In',
                        // style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold,),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: secondaryColor),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
