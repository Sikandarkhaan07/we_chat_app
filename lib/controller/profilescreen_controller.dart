// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../apis/apis.dart';
import '../main.dart';

class ProfileScreenController {
  static void showBottomSheet(
      BuildContext context, void Function(String img) update) {
    final imagePicker = ImagePicker();
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (_) {
        return ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(top: 10, bottom: 27),
          children: [
            const Text(
              'Pick Profile Image',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: const CircleBorder(),
                    fixedSize: Size(mq.width * 0.3, mq.height * 0.2),
                  ),
                  onPressed: () async {
                    final XFile? image = await imagePicker.pickImage(
                        source: ImageSource.gallery, imageQuality: 80);
                    if (image != null) {
                      log('Image Path: ${image.path} and image name: ${image.name}');
                      APIs.updateProfilePictire(File(image.path));
                      update(image.path);
                      Navigator.pop(context);
                    }
                  },
                  child: Image.asset('images/picture.png'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: const CircleBorder(),
                    fixedSize: Size(mq.width * 0.3, mq.height * 0.2),
                  ),
                  onPressed: () async {
                    final XFile? image = await imagePicker.pickImage(
                        source: ImageSource.camera, imageQuality: 80);
                    if (image != null) {
                      log('Image Path: ${image.path} and image name: ${image.name}');
                      APIs.updateProfilePictire(File(image.path));
                      update(image.path);
                      Navigator.pop(context);
                    }
                  },
                  child: Image.asset('images/camera.png'),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
