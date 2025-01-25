import 'package:cloud_firestore/cloud_firestore.dart'; // Add this line
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:stream_inc/screens/auth/add_video_screen.dart';
import 'package:stream_inc/screens/auth/video_screen.dart';
import 'package:stream_inc/screens/profile_screen.dart';
import 'package:stream_inc/screens/search_screen.dart';

import 'controller/auth_controller.dart';

List pages =[
  VideoScreen(),
  SearchScreen(),
 const AddVideoScreen(),
  const Text('Messages Screen'),
  ProfileScreen(uid: authController.user!.uid),
  
  

];
const backgroundColor = Colors.black;
var buttonColor = Colors.red;
const borderColor = Colors.grey;


//firebase 
var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage= FirebaseStorage.instance;
var firestore = FirebaseFirestore.instance;


//Controlller
var authController = AuthController.instance;