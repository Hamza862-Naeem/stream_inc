import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stream_inc/constants.dart';
import 'package:stream_inc/models/user.dart' as model;
import 'package:stream_inc/screens/auth/home_screen.dart';
import 'package:stream_inc/screens/auth/login_screen.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<User?> _user;
  Rx<File?> _pickedImage = Rx<File?>(null); // Initialize as null

  File? get profilePhoto => _pickedImage.value;
  User get user => _user.value!;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(firebaseAuth.currentUser);
    _user.bindStream(firebaseAuth.authStateChanges());
    ever(_user, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => LoginScreen());
    } else {
      Get.offAll(() => HomeScreen());
    }
  }

  Future pickImage() async {
    print("Attempting to pick an image.");
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      print("Image selected: ${pickedImage.path}");
      Get.snackbar(
          'Profile Picture', 'You have successfully selected your profile picture!');
      _pickedImage.value = File(pickedImage.path); // Use .value to update the Rx<File?>
    } else {
      print("No image selected.");
    }
  }

  Future<String> _uploadToStorage(File image) async {
    print("Uploading image to Firebase Storage...");
    Reference ref = firebaseStorage
        .ref()
        .child('profilePics')
        .child(firebaseAuth.currentUser!.uid);

    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    print("Image uploaded. Download URL: $downloadUrl");
    return downloadUrl;
  }

  void registerUser(
      String username, String email, String password, File? image) async {
    try {
      print("Attempting to register user: $email");
      if (username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          image != null) {
        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        print("User created with UID: ${cred.user!.uid}");

        String downloadUrl = await _uploadToStorage(image);
        print("Profile picture uploaded.");

        model.User user = model.User(
          name: username,
          email: email,
          uid: cred.user!.uid,
          ProfilePhoto: downloadUrl,
        );

        await firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());
        print("User data saved to Firestore.");
      } else {
        print("All fields are required.");
        Get.snackbar(
          'Error Creating Account',
          'Please enter all the fields',
        );
      }
    } catch (e) {
      print("Error registering user: $e");
      Get.snackbar(
        'Error Creating Account',
        e.toString(),
      );
    }
  }

  void loginUser(String email, String password) async {
    try {
      print("Attempting to log in user: $email");
      if (email.isNotEmpty && password.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        print("User logged in successfully.");
      } else {
        print("Email and password are required.");
        Get.snackbar(
          'Error Logging in',
          'Please enter all the fields',
        );
      }
    } catch (e) {
      print("Error logging in user: $e");
      Get.snackbar(
        'Error Logging in',
        e.toString(),
      );
    }
  }

  void signOut() async {
    print("Signing out user.");
    await firebaseAuth.signOut();
    print("User signed out.");
  }
}
