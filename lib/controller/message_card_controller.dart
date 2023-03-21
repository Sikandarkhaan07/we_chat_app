import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:we_chat_app/apis/messages_apis.dart';
import 'package:we_chat_app/helper/date_utility.dart';
import '../main.dart';
import '../models/message.dart';

class MessageCardController {
  static List<Message> messageList = [];

  //USER MESSAGE
  static Widget blueMessage(Message message, BuildContext context) {
    if (message.read.isEmpty) {
      MessagesAPIs.updateMessageReadStatus(message);
      log('Message updated');
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //message container
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.height * 0.03),
            margin: EdgeInsets.symmetric(
                vertical: mq.height * 0.02, horizontal: mq.width * 0.02),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 135, 219, 255),
                border: Border.all(color: Colors.lightBlue.shade500),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            child: Text(
              message.msg,
              style: const TextStyle(color: Colors.black87, fontSize: 15),
            ),
          ),
        ),

        //time
        Padding(
          padding: EdgeInsets.only(right: mq.width * 0.03),
          child: Text(
            DateUtility.getDate(context: context, time: message.sent),
            style: const TextStyle(color: Colors.black54, fontSize: 13),
          ),
        ),
      ],
    );
  }

  //OTHER USER MESSAGE
  static Widget greenMessage(Message message, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //time
        Row(
          children: [
            if (message.read.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(left: mq.width * 0.03, right: 2),
                child: const Icon(
                  Icons.done_all_rounded,
                  color: Colors.lightBlue,
                ),
              ),
            Text(
              DateUtility.getDate(context: context, time: message.sent),
              style: const TextStyle(color: Colors.black54, fontSize: 13),
            ),
          ],
        ),
        //message container
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.height * 0.03),
            margin: EdgeInsets.symmetric(
                vertical: mq.height * 0.02, horizontal: mq.width * 0.02),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 218, 255, 176),
                border: Border.all(color: Colors.lightGreen),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30))),
            child: Text(
              message.msg,
              style: const TextStyle(color: Colors.black87, fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }
}
