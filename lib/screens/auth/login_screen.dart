import 'package:flutter/material.dart';
import 'package:we_chat_app/controller/loginscreen_controller.dart';

import '../../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAnimate = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(
        const Duration(
          milliseconds: 500,
        ), () {
      setState(() {
        _isAnimate = true;
      });
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
          AnimatedPositioned(
            top: mq.height * 0.15,
            right: _isAnimate ? mq.width * 0.25 : -mq.width * 0.5,
            width: mq.width * 0.5,
            duration: const Duration(seconds: 1),
            child: Image.asset('images/chat.png'),
          ),
          Positioned(
            bottom: mq.height * 0.15,
            left: mq.width * 0.05,
            width: mq.width * 0.9,
            height: mq.height * 0.06,
            child: ElevatedButton.icon(
                onPressed: () => LoginScreenController.handleGoogleBtn(context),
                icon: Image.asset(
                  'images/google.png',
                  height: mq.height * 0.05,
                ),
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  elevation: 1,
                ),
                label: RichText(
                    text: const TextSpan(
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        children: [
                      TextSpan(text: 'Sign In with '),
                      TextSpan(
                        text: 'Google ',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ]))),
          ),
        ],
      ),
    );
  }
}
