
import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stream_inc/constants.dart';
import 'package:stream_inc/models/user.dart' as model;
import 'package:stream_inc/screens/auth/home_screen.dart';
import 'package:stream_inc/screens/auth/login_screen.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
late  Rx<User?> _user;
//observable are to checkked the of var change or not 
  late Rx<File?> _pickedImage;

  File? get profilePhoto => _pickedImage.value;
  User? get user => _user.value!;

    @override
    // it is similar to onInit but it run after one frame of onInit
  void onReady() {
    super.onReady();
    _user = Rx<User?>(firebaseAuth.currentUser);
    _user.bindStream(firebaseAuth.authStateChanges());
    ever(_user, _setInitialScreen);
  }

  _setInitialScreen (User? user){
    if (user == null){
      Get.offAll(()=> LoginScreen());
    }else{
      Get.offAll(()=>  HomeScreen());
    }
  }

   void _pickImage( )async{
    final  pickedImage =await ImagePicker().pickImage(source: ImageSource.gallery);
    if(pickedImage != null){
      Get.snackbar('Profile Picture', 'You have successfully selected your profile picture');
    }
    _pickedImage = Rx<File?>(File(pickedImage!.path));
   }
  //upload to firebase storage
  Future<String>_uploadToStorage(File image)async{
   Reference ref = firebaseStorage.
   ref()
   .child('profilePics')
   .child(firebaseAuth.currentUser!.uid);
     
     UploadTask uploadTask= ref.putFile(image);
     TaskSnapshot snap= await uploadTask;
     String downloadUrl= await snap.ref.getDownloadURL();
     return downloadUrl;
   
  }
  
  //register the user
  Future<void> registerUser(String username, String email, String password,File? image) async {
  try{
  if(username.isNotEmpty && 
  email.isNotEmpty && 
  password.isNotEmpty &&
  image !=null){
    //save user to our auth and firestore
    UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
       password: password);
      String downloadUrl=await _uploadToStorage(image);

       model.User user = model.User(
         name: username,
         email: email,
         ProfilePhoto: downloadUrl,
         uid: cred.user!.uid,
       );
     await  firestore.collection('users').doc(cred.user!.uid).set(user.toJson());
  } else{
    Get.snackbar('Error Creating Accout',
    'Please fill all the fields',
    );
  }
  } catch (e) {
Get.snackbar('Error Creating Accout',
e.toString(),
);
  }
   } 

   void LoginUser(String email, String password)async{
    try{
      if(email.isNotEmpty && password.isNotEmpty){
     await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
     print('Log successfully');
      }else{
        Get.snackbar('Error Logging in',
         'Please enter all the fields',);
      }
    }catch(e){
      Get.snackbar('Error Logging in In',
      e.toString(),
      );
    }
   }
       void signOut() async {
        await firebaseAuth.signOut();
       }

}