// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:we_chat_app/apis/messages_apis.dart';
import 'package:we_chat_app/helper/date_utility.dart';
import 'package:we_chat_app/helper/routes/routes_name.dart';

import '../apis/apis.dart';
import '../main.dart';
import '../models/chat_user.dart';
import '../models/message.dart';

class ChatScreenController {
  //handle text input field
  static final textController = TextEditingController();

  //variable for storing emoji value
  bool showEmoji = false;

  //app bar for chat screen
  static Widget appBar(ChatUser user, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, RoutesName.viewProfileScreen,
            arguments: user);
      },
      child: StreamBuilder(
        stream: APIs.getUserInfo(user),
        builder: (context, snapshot) {
          final data = snapshot.data?.docs;
          final list =
              data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
          return Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black54,
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  height: 42,
                  width: 42,
                  imageUrl: list.isNotEmpty ? list[0].image! : user.image!,
                  errorWidget: (context, url, error) => const CircleAvatar(
                    child: Icon(CupertinoIcons.person),
                  ),
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    list.isNotEmpty ? list[0].name! : user.name ?? 'Unknown',
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    list.isNotEmpty
                        ? list[0].isOnline!
                            ? 'Online'
                            : DateUtility.getLastActiveTime(
                                context: context,
                                lastActive: list[0].lastActive!)
                        : DateUtility.getLastActiveTime(
                            context: context, lastActive: user.lastActive!),
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }

  //chat input for chatscreen
  static Widget chatInput(
      ChatUser user, VoidCallback updateEmoji, VoidCallback hideEmoji) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: mq.height * 0.01, horizontal: mq.width * 0.02),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  IconButton(
                    onPressed: updateEmoji,
                    icon: const Icon(
                      Icons.emoji_emotions,
                      color: Colors.blueAccent,
                    ),
                  ),
                  Expanded(
                      child: TextField(
                    onTap: hideEmoji,
                    controller: textController,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Type Something....',
                        hintStyle: TextStyle(color: Colors.blueAccent)),
                  )),
                  IconButton(
                    onPressed: () async {
                      final picker = ImagePicker();

                      final List<XFile> image = await picker.pickMultiImage(
                        imageQuality: 80,
                      );
                      for (var img in image) {
                        await MessagesAPIs.sendChatImage(user, File(img.path));
                      }
                    },
                    icon: const Icon(
                      Icons.image,
                      color: Colors.blueAccent,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final picker = ImagePicker();
                      final XFile? image = await picker.pickImage(
                        source: ImageSource.camera,
                        imageQuality: 80,
                      );
                      if (image != null) {
                        await MessagesAPIs.sendChatImage(
                            user, File(image.path));
                      }
                    },
                    icon: const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              if (textController.text.isNotEmpty) {
                MessagesAPIs.sendMessage(user, textController.text, Type.text);
                textController.text = '';
              }
            },
            minWidth: 0,
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 10,
              left: 10,
              right: 5,
            ),
            shape: const CircleBorder(),
            color: Colors.green,
            child: const Icon(
              Icons.send,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}
