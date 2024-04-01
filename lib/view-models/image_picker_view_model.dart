import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/message_model.dart';

class ImagePickerViewModel with ChangeNotifier {
  String? imagePath;
  showOptions(
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose Image'),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            ElevatedButton(
              onPressed: () async {
                imagePath = await pickImageFromCamera();
              },
              child: const Text('Camera'),
            ),
            ElevatedButton(
              onPressed: () async {
                imagePath = await pickImageFromGallery();
              },
              child: const Text('Gallery'),
            ),
          ]),
        );
      },
    );
  }

  Future<String?> pickImageFromCamera() async {
    // Open the camera to capture an image
    final ImagePicker picker = ImagePicker();
    picker.pickImage(source: ImageSource.camera).then((value) {
      if (value != null) {
        log("image path: ${value.path}");
        return value.path;
      }
      return null;
    });
  }

  Future<String?> pickImageFromGallery() async {
    // Open the gallery to select an image
    final ImagePicker picker = ImagePicker();
    XFile? value = await picker.pickImage(source: ImageSource.gallery);

    if (value != null) {
      log("image path: ${value.path}");
      return value.path;
    } else {
      return null;
    }
  }
}
