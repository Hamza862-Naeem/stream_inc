

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stream_inc/constants.dart';
import 'package:stream_inc/controller/auth_controller.dart';
import 'package:stream_inc/screens/auth/home_screen.dart';
import 'package:stream_inc/screens/auth/login_screen.dart';
import 'package:stream_inc/screens/auth/signup_screen.dart';

import 'firebase_options.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) {
    Get.put(AuthController());
  });
  DefaultFirebaseOptions.currentPlatform;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tik-Tok-Stream-Inc',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
      ),
      home:  LoginScreen()
      );
    
  }
}