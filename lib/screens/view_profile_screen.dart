// ignore_for_file: prefer_null_aware_operators

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:we_chat_app/apis/messages_apis.dart';

import 'package:we_chat_app/main.dart';

import '../models/chat_user.dart';

class ViewProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ViewProfileScreen({super.key, required this.user});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //hiding keyword when click anywhere on screen
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.user.name!),
        ),
        //signing out button

        //profile
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: mq.height * 0.02, horizontal: mq.width * 0.03),
            child: Column(
              children: [
                SizedBox(
                  width: mq.width,
                  height: mq.height * 0.01,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * 0.1),
                  child: CachedNetworkImage(
                    height: mq.height * 0.2,
                    width: mq.height * 0.2,
                    fit: BoxFit.fill,
                    imageUrl: widget.user.image!,
                    errorWidget: (context, url, error) => const CircleAvatar(
                      radius: 10,
                      child: Icon(
                        CupertinoIcons.person,
                        size: 70,
                      ),
                    ),
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
                SizedBox(
                  height: mq.height * 0.02,
                ),
                //email
                Text(
                  widget.user.email!,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                SizedBox(
                  height: mq.height * 0.03,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'About: ',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(widget.user.about!),
                  ],
                ),
                SizedBox(
                  height: mq.height * 0.4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Joined On: ',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(MessagesAPIs.getLastMessageTime(
                        context: context,
                        time: widget.user.createdAt!,
                        showYear: true)),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
