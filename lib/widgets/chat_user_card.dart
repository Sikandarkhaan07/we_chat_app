import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../helper/routes/routes_name.dart';
import '../models/chat_user.dart';

class ChatUserCard extends StatefulWidget {
  final List<ChatUser> user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
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
              child: ListTile(
                title: Text(widget.user[index].name ?? 'unknown'),
                // leading: const CircleAvatar(child: Icon(CupertinoIcons.person)),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: CachedNetworkImage(
                    height: 50,
                    width: 50,
                    imageUrl: widget.user[index].image!,
                    errorWidget: (context, url, error) => const CircleAvatar(
                      child: Icon(CupertinoIcons.person),
                    ),
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
                subtitle: Text(
                  widget.user[index].about ?? 'No conversation!',
                  maxLines: 1,
                ),
                trailing: Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                    color: Colors.greenAccent.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                // const Text(
                //   '12 PM',
                //   style: TextStyle(
                //     color: Colors.grey,
                //   ),
                // ),
              ),
            ));
      },
    );
  }
}
