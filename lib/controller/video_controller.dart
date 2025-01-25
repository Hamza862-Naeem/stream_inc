
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import '../constants.dart';
import '../models/video.dart';

class VideoController  extends GetxController{
  Rx<List<Video>> _videoList = Rx<List<Video>>([]);

  List<Video> get videos => _videoList.value;

  @override 
  void onInit(){
    super.onInit();
    _videoList.bindStream(firestore.collection('videos').snapshots()
    .map((QuerySnapshot query) {
     List<Video> retVal = []; 
     for(var element in query.docs){
      retVal.add(Video.fromSnap(element));
     }
     return retVal;
    }));
  }
  likeVideo(String id)async{
    DocumentSnapshot doc = await firestore.collection('videos').doc(id).get();
    var uid = authController.user?.uid;
    if((doc.data()! as dynamic)['likes'].contains(uid)){
      await firestore.collection('videos').doc(id).update({
        'likes': FieldValue.arrayRemove([uid])
      });
    }
    else{
      await firestore.collection('videos').doc(id).update({
        'likes': FieldValue.arrayUnion([uid])
      });
    }
  }

}