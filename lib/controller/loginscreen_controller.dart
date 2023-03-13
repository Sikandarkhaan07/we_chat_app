// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';

import '../apis/apis.dart';
import '../helper/auth_helper.dart';
import '../helper/dialogs.dart';
import '../helper/routes/routes_name.dart';
import '../screens/home_screen.dart';

class LoginScreenController {
  static void handleGoogleBtn(BuildContext context) {
    Dialogs.showProgressBar(context);
    AuthHelper.signInWithGoogle(context).then((user) async {
      if (user != null) {
        if (await APIs.userExists()) {
          Navigator.of(context).pop();
          log('User: $user');
          Navigator.pushReplacementNamed(
            context,
            RoutesName.homeScreen,
          );
        } else {
          await APIs.createUser().then((value) {
            Navigator.pushReplacementNamed(
              context,
              RoutesName.homeScreen,
            );
          });
        }
      }
    });
  }
}
