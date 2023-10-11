import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo_app/services/authentication_service.dart';

class UserInformationProvider extends ChangeNotifier {
  User? user;

  XFile? _image;

  XFile? get image => _image;

  void getUserInfo(User? user) {
    this.user = user;
    notifyListeners();
  }

  // Future pickImageForGallery(BuildContext context) async {
  //   final picker = ImagePicker();
  //   final pickerFile =
  //       await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
  //   if (pickerFile != null) {
  //     _image = XFile(pickerFile.path);
  //     return _image;
  //   } else {}
  //   ();
  // }

  Future pickImageForGallery(BuildContext context) async {
    AuthService authService = AuthService();
  final picker = ImagePicker();
    final pickerFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);

  if (pickerFile != null) {
    final imageFile = File(pickerFile.path);
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      final imageUrl = await authService.uploadImageToFirebaseStorage(userId, imageFile.path);

      if (imageUrl != null) {
        User? user =  await authService.updateUserProfilePicture(userId, imageUrl);
        this.user = user;
        
      }
    }
  }
  notifyListeners();
}
}
