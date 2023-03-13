import 'dart:io';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:we_chat_app/models/chat_user.dart';

class APIs {
  //firebase auth instance
  static FirebaseAuth auth = FirebaseAuth.instance;

  //firebase firestore instance
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;

  //firebase storage instance
  static FirebaseStorage storage = FirebaseStorage.instance;

  //current user
  static User get user => auth.currentUser!;

  //self object
  static late ChatUser me;

  //get current user info
  static Future<void> getSelfInfo() async {
    await fireStore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data());
      } else {
        await createUser().then((user) {
          getSelfInfo();
        });
      }
    });
  }

  //check user existence
  static Future<bool> userExists() async {
    return (await fireStore.collection('users').doc(user.uid).get()).exists;
  }

  //create new user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatUser = ChatUser(
      name: user.displayName,
      about: 'Hi there! how are you?',
      email: user.email,
      image: user.photoURL,
      isOnline: false,
      lastActive: time,
      createdAt: DateTime.now().toIso8601String(),
      pushToken: '',
      id: user.uid,
    );

    return await fireStore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  //get all users from database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUser() {
    return fireStore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  //update user info
  static Future<void> updateUserInfo() async {
    await fireStore.collection('users').doc(user.uid).update({
      'name': me.name,
      'about': me.about,
    });
  }

  //update profile picture
  static Future<void> updateProfilePictire(File file) async {
    //getting file extension
    final extension = file.path.split('.').last;
    log('Extension: $extension');

    //store file
    final ref = storage.ref().child('profile_picture/${user.uid}.$extension');
    //upload
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$extension'))
        .then((p0) {
      log('Data transferred: ${p0.bytesTransferred / 1000} kb');
    });

    //update image in firebasefirestore
    me.image = await ref.getDownloadURL();
    await fireStore.collection('users').doc(user.uid).update({
      'image': me.image,
    });
  }
}
