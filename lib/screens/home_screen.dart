// ignore_for_file: prefer_null_aware_operators
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:we_chat_app/widgets/chat_user_card.dart';

import '../apis/apis.dart';
import '../helper/routes/routes_name.dart';
import '../main.dart';
import '../models/chat_user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //storing all users
  List<ChatUser> _userList = [];

  // for storing search users
  final List<ChatUser> _searchList = [];

  //for search status

  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    //getting your info before loading screen
    APIs.getSelfInfo();

    APIs.updateActiveStatus(true);

    SystemChannels.lifecycle.setMessageHandler((message) {
      if (APIs.auth.currentUser != null) {
        if (message.toString().contains('paused')) {
          APIs.updateActiveStatus(false);
        }
        if (message.toString().contains('resumed')) {
          APIs.updateActiveStatus(true);
        }
      }

      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //hiding keyword
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: const Icon(CupertinoIcons.home),
            title: _isSearching
                ? TextField(
                    //searching algorithm
                    onChanged: (val) {
                      _searchList.clear();
                      for (var i in _userList) {
                        if (i.name!.toLowerCase().contains(val.toLowerCase()) ||
                            i.email!
                                .toLowerCase()
                                .contains(val.toLowerCase())) {
                          _searchList.add(i);
                        }
                        setState(() {
                          _searchList;
                        });
                      }
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Name, email, ....',
                    ),
                    autofocus: true,
                    style: const TextStyle(
                      fontSize: 17,
                      letterSpacing: 1,
                    ),
                  )
                : const Text('We Chat'),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _isSearching = !_isSearching;
                  });
                },
                icon: Icon(
                  _isSearching
                      ? CupertinoIcons.clear_circled_solid
                      : Icons.search,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    RoutesName.profileScreen,
                  );
                },
                icon: const Icon(CupertinoIcons.profile_circled),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: const Icon(
              Icons.add_comment_rounded,
            ),
          ),
          body: SizedBox(
            height: mq.height,
            child: StreamBuilder<QuerySnapshot>(
              stream: APIs.getAllUser(),
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  _userList = snapshot.data!.docs
                      .map((e) => ChatUser.fromJson(e.data()))
                      .toList();
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    case ConnectionState.active:
                    case ConnectionState.done:
                      return ChatUserCard(
                          user: _isSearching ? _searchList : _userList);
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
