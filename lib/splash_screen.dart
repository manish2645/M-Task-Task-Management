import 'dart:async';
import 'package:flutter/material.dart';
import 'package:m_task/login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),
          () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset("assets/logo.png",
              height: 150,
              width: 150,
            ),
            const SizedBox(height: 20),
            const Text(
              'Welcome to M-Task',
              style: TextStyle(
                fontSize: 26,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
