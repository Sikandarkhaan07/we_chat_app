import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:we_chat_app/apis/messages_apis.dart';
import 'package:we_chat_app/helper/date_utility.dart';

import '../apis/apis.dart';
import '../helper/routes/routes_name.dart';
import '../models/chat_user.dart';
import '../models/message.dart';

class ChatUserCard extends StatefulWidget {
  final List<ChatUser> user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  Message? _message;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.user.length,
      itemBuilder: (context, index) {
        return Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.symmetric(
              horizontal: 7,
              vertical: 5,
            ),
            child: InkWell(
              onTap: () {
                var x = widget.user[index];
                Navigator.pushNamed(
                  context,
                  RoutesName.chatScreen,
                  arguments: x,
                );
              },
              child: StreamBuilder(
                  stream: MessagesAPIs.getLastMessage(widget.user[index]),
                  builder: (context, snapshot) {
                    final data = snapshot.data?.docs;
                    if (data != null && data.first.exists) {
                      _message = Message.fromJson(data.first.data());
                    }

                    return ListTile(
                      title: Text(widget.user[index].name ?? 'unknown'),
                      // leading: const CircleAvatar(child: Icon(CupertinoIcons.person)),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: CachedNetworkImage(
                          height: 50,
                          width: 50,
                          imageUrl: widget.user[index].image!,
                          errorWidget: (context, url, error) =>
                              const CircleAvatar(
                            child: Icon(CupertinoIcons.person),
                          ),
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                      subtitle: Text(
                        _message != null ? _message!.msg : 'Hi there!',
                        maxLines: 1,
                      ),
                      trailing: _message == null
                          ? null
                          : _message!.read.isEmpty &&
                                  _message!.fromId != APIs.user.uid
                              ? Container(
                                  height: 10,
                                  width: 10,
                                  decoration: BoxDecoration(
                                    color: Colors.greenAccent.shade400,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                )
                              : Text(
                                  DateUtility.getDate(
                                      context: context, time: _message!.sent),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                    );
                  }),
            ));
      },
    );
  }
}
