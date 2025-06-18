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

  final _formKey = GlobalKey<FormState>(); // for validating the email/password entered or not
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<bool> createUserWithEmailAndPassword() async {
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
      return true;
    } catch (e) {
      print("error:--- $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
      return false;
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
          key: _formKey,
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
                  validator: (value) { // for showing error when email is not enteredAdd commentMore actions
                    if (value!.isEmpty) {
                      return "Enter email...";
                    }
                    return null;
                  },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
                obscureText: true,
                  validator: (value) { // for showing error when password is not enteredAdd commentMore actions
                    if (value!.isEmpty) {
                      return "Enter password...";
                    }
                    return null;
                  },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) { // return true if email/password is entered else falseAdd commentMore actions
                    if (await createUserWithEmailAndPassword()) {
                      _formKey.currentState!.reset(); // to reset form field state
                    }
                  }
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
