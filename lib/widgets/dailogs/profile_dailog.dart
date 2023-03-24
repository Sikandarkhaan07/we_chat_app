import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:we_chat_app/helper/routes/routes_name.dart';

import '../../main.dart';
import '../../models/chat_user.dart';

class ProfileDialog extends StatelessWidget {
  final ChatUser user;
  const ProfileDialog({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        width: mq.width * 0.6,
        height: mq.height * 0.35,
        child: Stack(
          children: [
            //profile picture
            Align(
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(mq.height * 0.25),
                child: CachedNetworkImage(
                  height: mq.height * 0.2,
                  width: mq.height * 0.2,
                  fit: BoxFit.fill,
                  imageUrl: user.image!,
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
            ),
            //user name
            Positioned(
              top: 15,
              left: 15,
              width: 150,
              child: Text(
                user.name!,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            //information icon
            Align(
                alignment: Alignment.topRight,
                child: MaterialButton(
                  minWidth: 0,
                  padding: const EdgeInsets.all(0),
                  shape: const CircleBorder(),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, RoutesName.viewProfileScreen,
                        arguments: user);
                  },
                  child: const Icon(
                    Icons.info_outline,
                    color: Colors.lightBlue,
                    size: 30,
                  ),
                )),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
