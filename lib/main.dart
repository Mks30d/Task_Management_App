import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tmaa/%20components/home/home_ui/home_page.dart';
import 'package:tmaa/%20splash_screen.dart';

import 'firebase_options.dart';

Color white = Color(0xffffffff);
Color offWhite = Color(0xffF7F7F7);
Color black = Color(0xff000000);
Color primaryColor = Color(0xff878AF5);
Color secondaryColor = Color(0xff666AF6);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}
