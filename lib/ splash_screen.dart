import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tmaa/%20components/auth/signup.dart';
import 'package:tmaa/%20components/home/home_ui/home_page.dart';
import 'package:tmaa/main.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   body: Container(
    //     color: offWhite,
    //     child: Center(
    //       child: Image.asset("assets/img/tick.png"),
    //     ),
    //   ),
    // );
    return Scaffold(
        backgroundColor: offWhite,
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
              child: Column(
                children: [
                  Center(
                      child: Image.asset(
                    "assets/img/tick.png",
                    height: 200,
                  )),
                  SizedBox(
                    height: 22,
                  ),
                  Text(
                    "Get things done.",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Just a click away from",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0x5C000000)),
                  ),
                  Text(
                    "planning your tasks.",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0x5C000000),
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 70,
              right: 50,
              child: InkWell(
                onTap: () {
                  print("object");
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) {
                      return StreamBuilder(
                          stream: FirebaseAuth.instance.authStateChanges(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (snapshot.data != null) {
                              return HomePage();
                            }
                            return Signup();
                          });
                    },
                  ));
                },
                child: Container(
                  child: Text(
                    "Next >",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
