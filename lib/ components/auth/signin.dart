// import 'package:firebase/components/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tmaa/%20components/auth/signup.dart';
import 'package:tmaa/main.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {

  final _formKey = GlobalKey<FormState>(); // for validating the email/password entered or not
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<bool> loginUserWithEmailAndPassword() async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
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
      //   title: Text("Sign in Page"),
      //   backgroundColor: Colors.teal,
      // ),
      backgroundColor: offWhite,
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Welcome back!',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
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
                  await loginUserWithEmailAndPassword();
                  print("emailController: ${emailController.text}");
                  print("passwordController: ${passwordController.text}");
                },
                child: const Text(
                  'Sign in',
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
                        builder: (context) => Signup(),
                      ));
                },
                child: RichText(
                  text: TextSpan(
                    text: 'Don\'t have an account? ',
                    style: Theme.of(context).textTheme.titleMedium,
                    // style: TextStyle(color: Colors.black54),
                    children: [
                      TextSpan(
                          text: 'Sign Up',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: secondaryColor)),
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
