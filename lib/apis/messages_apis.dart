import 'package:cloud_firestore/cloud_firestore.dart';
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
        .snapshots();
  }

  //sending message
  static Future<void> sendMessage(ChatUser chatUser, String msg) async {
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
        type: Type.text,
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
      {required BuildContext context, required String time}) {
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();

    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return TimeOfDay.fromDateTime(sent).format(context);
    }
    return '${sent.day} ${_getMonth(sent)}';
  }

  static String _getMonth(DateTime date) {
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
}
