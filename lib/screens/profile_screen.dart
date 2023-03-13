// ignore_for_file: prefer_null_aware_operators

import 'dart:io';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:we_chat_app/controller/profilescreen_controller.dart';
import 'package:we_chat_app/helper/auth_helper.dart';
import 'package:we_chat_app/helper/dialogs.dart';
import 'package:we_chat_app/main.dart';

import '../apis/apis.dart';
import '../models/chat_user.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? image;
  //changing image
  void changeImage(String img) {
    setState(() {
      image = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    log('building profile screen......');
    return GestureDetector(
      //hiding keyword when click anywhere on screen
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        //signing out button
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            AuthHelper.signOut(context);
          },
          icon: const Icon(
            Icons.exit_to_app,
          ),
          backgroundColor: Colors.orange,
          label: const Text('Logout'),
        ),
        //profile
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: mq.height * 0.02, horizontal: mq.width * 0.03),
              child: Column(
                children: [
                  SizedBox(
                    width: mq.width,
                    height: mq.height * 0.01,
                  ),
                  Stack(
                    children: [
                      //profile image
                      image != null
                          ? ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(mq.height * 0.1),
                              child: Image.file(
                                File(image!),
                                width: mq.height * 0.2,
                                height: mq.height * 0.2,
                                fit: BoxFit.cover,
                              ),
                            )
                          : ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(mq.height * 0.1),
                              child: CachedNetworkImage(
                                height: mq.height * 0.2,
                                width: mq.height * 0.2,
                                fit: BoxFit.fill,
                                imageUrl: widget.user.image!,
                                errorWidget: (context, url, error) =>
                                    const CircleAvatar(
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
                      //edit button
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: MaterialButton(
                          elevation: 1,
                          shape: const CircleBorder(),
                          onPressed: () {
                            ProfileScreenController.showBottomSheet(
                                context, changeImage);
                          },
                          color: Colors.white,
                          child: const Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
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
                        color: Colors.black54),
                  ),
                  SizedBox(
                    height: mq.height * 0.05,
                  ),
                  //text fields
                  TextFormField(
                    initialValue: widget.user.name,
                    onSaved: (val) => APIs.me.name = val ?? '',
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : 'Required Field',
                    decoration: InputDecoration(
                      hintText: 'eg. Sikandar khan',
                      labelText: 'Name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      focusColor: Colors.blue,
                      prefixIcon: const Icon(
                        CupertinoIcons.person,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: mq.height * 0.02,
                  ),
                  TextFormField(
                    onSaved: (val) => APIs.me.about = val ?? '',
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : 'Required Field',
                    initialValue: widget.user.about,
                    decoration: InputDecoration(
                      hintText: 'eg. Hi there!',
                      labelText: 'About',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      focusColor: Colors.blue,
                      prefixIcon: const Icon(
                        CupertinoIcons.info_circle,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: mq.height * 0.05,
                  ),
                  //update button
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(50, 40),
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        APIs.updateUserInfo().then((value) {
                          Dialogs.showAlert('Updated successfully!', context);
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.edit,
                      size: 25,
                    ),
                    label: const Text(
                      'UPDATE',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
