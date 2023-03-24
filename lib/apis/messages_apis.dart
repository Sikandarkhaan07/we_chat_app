import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../models/chat_user.dart';
import '../models/message.dart';
import './apis.dart';

class MessagesAPIs {
  //getting all messages for a specific conversation
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser chatUser) {
    return APIs.fireStore
        .collection('chats/${getConversationID(chatUser.id!)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  //sending message
  static Future<void> sendMessage(
      ChatUser chatUser, String msg, Type type) async {
    //taking unique time as a message id
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    //creating reference
    final ref = APIs.fireStore
        .collection('chats/${getConversationID(chatUser.id!)}/messages/');

    //message to send
    final Message message = Message(
        msg: msg,
        read: '',
        toId: chatUser.id!,
        type: type,
        fromId: APIs.user.uid,
        sent: time);

    //adding message
    await ref.doc(time).set(message.toJson());
  }

  //getting conversation id
  static String getConversationID(String id) =>
      APIs.user.uid.hashCode <= id.hashCode
          ? '${APIs.user.uid}_$id'
          : '${id}_${APIs.user.uid}';
  //update read message status
  static Future<void> updateMessageReadStatus(Message msg) async {
    APIs.fireStore
        .collection('chats/${getConversationID(msg.fromId)}/messages/')
        .doc(msg.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  //get last message of user
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      ChatUser chatUser) {
    return APIs.fireStore
        .collection('chats/${getConversationID(chatUser.id!)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  //get last message time
  static String getLastMessageTime(
      {required BuildContext context,
      required String time,
      bool showYear = false}) {
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();

    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return TimeOfDay.fromDateTime(sent).format(context);
    }
    return showYear
        ? '${sent.day} ${getMonth(sent)} ${sent.year}'
        : '${sent.day} ${getMonth(sent)}';
  }

  static String getMonth(DateTime date) {
    switch (date.month) {
      case 1:
        return 'JAN';
      case 2:
        return 'FEB';
      case 3:
        return 'MAR';
      case 4:
        return 'APR';
      case 5:
        return 'MAY';
      case 6:
        return 'JUN';
      case 7:
        return 'JUL';
      case 8:
        return 'AUG';
      case 9:
        return 'SEP';
      case 10:
        return 'OCT';
      case 11:
        return 'NOV';
      case 12:
        return 'DEC';
      default:
        return 'NA';
    }
  }

  static Future<void> sendChatImage(ChatUser user, File file) async {
    final ext = file.path.split('.').last;

    final ref = APIs.storage.ref().child(
        'images/${getConversationID(user.id!)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Transfered: ${p0.bytesTransferred / 1000} kb');
    });

    final imageUrl = await ref.getDownloadURL();
    await sendMessage(user, imageUrl, Type.image);
  }
}
