import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:we_chat_app/helper/routes/routes_name.dart';

import '../apis/apis.dart';
import 'dialogs.dart';

class AuthHelper {
  static Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    try {
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await APIs.auth.signInWithCredential(credential);
    } catch (e) {
      log('\nSignIn: $e');
      Dialogs.showAlert(e.toString(), context);
      return null;
    }
  }

  static void signOut(BuildContext context) async {
    Dialogs.showProgressBar(context);
    APIs.updateActiveStatus(false);
    await APIs.auth.signOut().then(
      (value) async {
        await GoogleSignIn().signOut().then((value) {
          //poping progress indicator
          Navigator.of(context).pop();
          //poping home screen
          Navigator.of(context).pop();
          APIs.auth = FirebaseAuth.instance;
          //navigating to login screen
          Navigator.pushReplacementNamed(context, RoutesName.loginScreen);
        });
      },
    );
  }
}
