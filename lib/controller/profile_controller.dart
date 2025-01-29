import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../constants.dart';

class ProfileController extends GetxController {
  final Rx<Map<String, dynamic>> _user = Rx<Map<String, dynamic>>({});

  Map<String, dynamic> get user => _user.value;
  final Rx<String> _uid = "".obs;

  void updateUserId(String uid) {
    _uid.value = uid;
    getUserData();
  }

  Future<void> getUserData() async {
    try {
      List<String> thumbnails = [];
      // Fetch user's videos
      QuerySnapshot myVideos = await firestore
          .collection('videos')
          .where('uid', isEqualTo: _uid.value)
          .get();

      for (var doc in myVideos.docs) {
        var data = doc.data() as Map<String, dynamic>?;
        if (data != null && data['thumbnail'] != null) {
          thumbnails.add(data['thumbnail']);
        }
      }

      // Fetch user document
      DocumentSnapshot userDoc = await firestore.collection('users').doc(_uid.value).get();

      if (!userDoc.exists || userDoc.data() == null) {
        print('User document does not exist or data is null.');
        return;
      }

      final userData = userDoc.data()! as Map<String, dynamic>;
      String name = userData['name'] ?? '';
      String profilePhoto = userData['profilePhoto'] ?? '';
      int likes = 0;
      int followers = 0;
      int following = 0;
      bool isFollowing = false;

      // Calculate total likes
      for (var item in myVideos.docs) {
        var likesList = (item.data() as Map<String, dynamic>)['likes'] as List?;
        likes += (likesList?.length ?? 0);
      }

      // Fetch followers and following count
      var followerDoc = await firestore
          .collection('users')
          .doc(_uid.value)
          .collection('followers')
          .get();
      var followingDoc = await firestore
          .collection('users')
          .doc(_uid.value)
          .collection('following')
          .get();

      followers = followerDoc.docs.length;
      following = followingDoc.docs.length;

      // Check if the current user is following
      var currentUserUid = authController.user?.uid;
      if (currentUserUid != null) {
        var followerCheck = await firestore
            .collection('users')
            .doc(_uid.value)
            .collection('followers')
            .doc(currentUserUid)
            .get();
        isFollowing = followerCheck.exists;
      }

      // Update user data
      _user.value = {
        'followers': followers.toString(),
        'following': following.toString(),
        'isFollowing': isFollowing,
        'likes': likes.toString(),
        'profilePhoto': profilePhoto,
        'name': name,
        'thumbnails': thumbnails,
      };
      update();
    } catch (e) {
      print('Error in getUserData: $e');
    }
  }

  Future<void> followUser() async {
    try {
      var currentUserUid = authController.user?.uid;
      if (currentUserUid == null) {
        print('Current user UID is null');
        return;
      }

      var doc = await firestore
          .collection('users')
          .doc(_uid.value)
          .collection('followers')
          .doc(currentUserUid)
          .get();

      if (!doc.exists) {
        // Add follower
        await firestore
            .collection('users')
            .doc(_uid.value)
            .collection('followers')
            .doc(currentUserUid)
            .set({});
        await firestore
            .collection('users')
            .doc(currentUserUid)
            .collection('following')
            .doc(_uid.value)
            .set({});
        _user.value.update(
            'followers', (value) => (int.parse(value) + 1).toString());
      } else {
        // Remove follower
        await firestore
            .collection('users')
            .doc(_uid.value)
            .collection('followers')
            .doc(currentUserUid)
            .delete();
        await firestore
            .collection('users')
            .doc(currentUserUid)
            .collection('following')
            .doc(_uid.value)
            .delete();
        _user.value.update(
            'followers', (value) => (int.parse(value) - 1).toString());
      }
      _user.value.update('isFollowing', (value) => !value);
      update();
    } catch (e) {
      print('Error in followUser: $e');
    }
  }
}
