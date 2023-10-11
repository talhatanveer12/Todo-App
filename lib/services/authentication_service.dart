import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(
      String email, String password, String username) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;
      await user!.updateDisplayName(username);
      await user.reload();
      return user;
    } catch (e) {
      print('Error : $e');
    }
    return null;
  }

  Future<User?> signUpWithGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );

    final GoogleSignInAccount? gUser = await googleSignIn.signIn();

    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    UserCredential userCredential = await auth.signInWithCredential(credential);
    print("object");
    print(userCredential.user);

    return userCredential.user;
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } catch (e) {
      print('Error : $e');
    }
    return null;
  }

  Future<User?> updateUsername(String username) async {
    try {
      User? user = auth.currentUser;
      if (user != null) {
        await user.updateDisplayName(username);
        return auth.currentUser;
      } else {
        print('Error :');
      }
    } catch (e) {
      print('Error : $e');
    }
    return null;
  }

  Future<User?> updatePassword(String oldPassword, String newPassword) async {
    final user = FirebaseAuth.instance.currentUser;
    final credential = EmailAuthProvider.credential(
        email: user!.email!, password: oldPassword);
    try {
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: user.email!, password: newPassword);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('Error : $e');
    }
    return null;
  }

  Future<String?> uploadImageToFirebaseStorage(
      String userId, String imagePath) async {
    final Reference storageReference =
        FirebaseStorage.instance.ref().child('profile_pictures/$userId.jpg');
    final UploadTask uploadTask = storageReference.putFile(File(imagePath));

    try {
      await uploadTask.whenComplete(() => null);
      final imageUrl = await storageReference.getDownloadURL();
      return imageUrl;
    } catch (e) {
      // Handle any errors here
      print(e);
      return null;
    }
  }

  Future<User?> updateUserProfilePicture(String userId, String imageUrl) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await user.updatePhotoURL(imageUrl);
        return auth.currentUser;
        // Update the user's profile picture URL in your database if necessary
        // For example, if you're using Firestore, you can update the URL in your user document.
      }
    } catch (e) {
      // Handle any errors here
      print(e);
    }
    return null;
  }
}
