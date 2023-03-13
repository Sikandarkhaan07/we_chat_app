import 'package:cloud_firestore/cloud_firestore.dart';
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
}
