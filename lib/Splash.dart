import 'package:flutter/material.dart';
import 'dart:async';
import '../Login/Login.dart';

class SplashScreen extends StatefulWidget {
  static String id = "/splash";
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const Login(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE4EDF3),
      body: Center(
        child: Align(
          alignment: Alignment.center,
          child: Container(
            width: 250,
            height: 150,
            child: Image.asset("assets/logo.png"),
          ),
        ),
      ),
    );
  }
}
