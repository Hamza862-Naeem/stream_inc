import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:stream_inc/models/video.dart';
import 'package:video_compress/video_compress.dart';

import '../constants.dart';

class UploadVideoController extends GetxController {
  
  // Compress video if necessary
  Future<File> _compressVideo(String videoPath) async {
    try {
      final compressedVideo = await VideoCompress.compressVideo(
        videoPath,
        quality: VideoQuality.MediumQuality,
      );
      return compressedVideo!.file!;
    } catch (e) {
      throw 'Error compressing video: $e';
    }
  }

  // Upload video to Firebase Storage
  Future<String> _uploadVideoToStorage(String videoId, String videoPath) async {
    try {
      // Compress the video before uploading
      File videoFile = await _compressVideo(videoPath);
      Reference ref = firebaseStorage.ref().child('videos').child('$videoId.mp4');
      UploadTask uploadTask = ref.putFile(videoFile);
      TaskSnapshot snap = await uploadTask;
      return await snap.ref.getDownloadURL();
    } catch (e) {
      throw 'Error uploading video: $e';
    }
  }

  // Get video thumbnail
  Future<File> _getThumbnail(String videoPath) async {
    try {
      final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
      return thumbnail!;
    } catch (e) {
      throw 'Error getting thumbnail: $e';
    }
  }

  // Upload thumbnail to Firebase Storage
  Future<String> _uploadImageToStorage(String videoId, String videoPath) async {
    try {
      // Get thumbnail
      File thumbnail = await _getThumbnail(videoPath);
      Reference ref = firebaseStorage.ref().child('thumbnails').child('$videoId.jpg');
      UploadTask uploadTask = ref.putFile(thumbnail);
      TaskSnapshot snap = await uploadTask;
      return await snap.ref.getDownloadURL();
    } catch (e) {
      throw 'Error uploading thumbnail: $e';
    }
  }

  // Main function to upload the video
  Future<void> uploadVideo(String songName, String caption, String videoPath) async {
    try {
      String uid = firebaseAuth.currentUser!.uid;
      DocumentSnapshot userDoc = await firestore.collection('users').doc(uid).get();

      // Generate a unique video ID
      String videoId = firestore.collection('videos').doc().id;

      // Upload the video and thumbnail
      String videoUrl = await _uploadVideoToStorage(videoId, videoPath);
      String thumbnailUrl = await _uploadImageToStorage(videoId, videoPath);

      // Create a video model object
      Video video = Video(
        username: (userDoc.data()! as Map<String, dynamic>)['name'],
        uid: uid,
        id: videoId,
        likes: [],
        commentCount: 0,
        shareCount: 0,
        songName: songName,
        caption: caption,
        videoUrl: videoUrl,
        thumbnail: thumbnailUrl,
        profilePhoto: (userDoc.data()! as Map<String, dynamic>)['profilePhoto'],
      );

      // Save video data to Firestore
      await firestore.collection('videos').doc(videoId).set(video.toJson());

      // Go back to the previous screen
      Get.back();
    } catch (e) {
      // Handle errors and show a snackbar
      print('Error: $e');
      Get.snackbar(
        "Error Uploading Video",
        e.toString(),
      );
    }
  }
}
