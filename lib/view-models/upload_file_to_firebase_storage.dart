import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';


class UploadFileToFirebaseStorage with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  setLoding(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  bool _isCompleted = false;
  bool get isCompleted => _isCompleted;
setCompleted(bool value) {
    _isCompleted = value;
    notifyListeners();
  }
  Future<String> uploadImageToFirebase(File imageFile) async {
   
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference storageReference = storage.ref().child('images/$id.png');
    UploadTask uploadTask = storageReference.putFile(imageFile);

    TaskSnapshot taskSnapshot = await uploadTask;
  
    log("full path: ${taskSnapshot.ref.fullPath}");

    return taskSnapshot.ref.fullPath;
  }
}
