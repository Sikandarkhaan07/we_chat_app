import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../apis/apis.dart';
import '../helper/routes/routes_name.dart';
import '../../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
        const Duration(
          seconds: 2,
        ), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
      ));
      log('User splash: ${APIs.auth.currentUser}');
      if (APIs.auth.currentUser != null) {
        Navigator.pushReplacementNamed(context, RoutesName.homeScreen);
      } else {
        Navigator.pushReplacementNamed(context, RoutesName.loginScreen);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Welcome to We Chat'),
      ),
      body: Stack(
        children: [
          Positioned(
            top: mq.height * 0.15,
            right: mq.width * 0.25,
            width: mq.width * 0.5,
            child: Image.asset('images/chat.png'),
          ),
          Positioned(
            bottom: mq.height * 0.05,
            width: mq.width,
            left: mq.width * 0.25,
            child: const Text(
              'MADE IN PAKISTAN WITH 🧡',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
