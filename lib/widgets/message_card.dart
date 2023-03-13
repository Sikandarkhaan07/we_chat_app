import 'package:flutter/material.dart';
import 'package:we_chat_app/apis/apis.dart';

import '../controller/message_card_controller.dart';
import '../models/message.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});

  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.user.uid == widget.message.fromId
        ? MessageCardController.blueMessage(widget.message)
        : MessageCardController.greenMessage(widget.message);
  }
}
