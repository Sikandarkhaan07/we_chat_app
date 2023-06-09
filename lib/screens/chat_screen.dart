import 'dart:developer';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;

import '../apis/messages_apis.dart';
import '../controller/chat_screen_controller.dart';
import '../controller/message_card_controller.dart';
import '../main.dart';
import '../models/chat_user.dart';
import '../models/message.dart';
import '../widgets/message_card.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool showEmoji = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: WillPopScope(
          onWillPop: () {
            if (showEmoji) {
              setState(() => showEmoji = !showEmoji);
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: ChatScreenController.appBar(widget.user, context),
            ),
            backgroundColor: const Color.fromARGB(255, 135, 219, 255),
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: MessagesAPIs.getAllMessages(widget.user),
                    builder: (context, snapshot) {
                      if (snapshot.hasData ||
                          MessageCardController.messageList.isNotEmpty) {
                        switch (snapshot.connectionState) {
                          //waiting for list to be updated
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                            return const SizedBox();
                          //list has been updated
                          case ConnectionState.active:
                          case ConnectionState.done:
                            final data = snapshot.data!.docs;
                            MessageCardController.messageList = data
                                .map((e) => Message.fromJson(e.data()))
                                .toList();
                            return ListView.builder(
                                reverse: true,
                                itemCount:
                                    MessageCardController.messageList.length,
                                itemBuilder: (context, index) {
                                  return MessageCard(
                                    message: MessageCardController
                                        .messageList[index],
                                  );
                                });
                        }
                      } else {
                        //if no data is in the list
                        return const Center(
                          child: Text('Say hi! 👋'),
                        );
                      }
                    },
                  ),
                ),
                ChatScreenController.chatInput(widget.user, () {
                  setState(() {
                    if (FocusScope.of(context).hasFocus) {
                      FocusScope.of(context).unfocus();
                    }
                    showEmoji = !showEmoji;
                  });
                }, () {
                  if (showEmoji) {
                    setState(() => showEmoji = !showEmoji);
                  }
                }),
                if (showEmoji)
                  SizedBox(
                    height: mq.height * 0.35,
                    child: EmojiPicker(
                      textEditingController:
                          ChatScreenController.textController,
                      config: Config(
                        bgColor: const Color.fromARGB(255, 135, 219, 255),
                        columns: 7,
                        emojiSizeMax: 32 *
                            (foundation.defaultTargetPlatform ==
                                    TargetPlatform.iOS
                                ? 1.30
                                : 1.0),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
