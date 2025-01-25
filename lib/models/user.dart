import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String name;
  String email;
  String ProfilePhoto;
  String uid;
  User({
    required this.name,
    required this.email,
    required this.ProfilePhoto,
    required this.uid,
  });

  Map<String,dynamic> toJson()=>{
    'name':name,
    'email':email,
    'ProfilePhoto':ProfilePhoto,
    'uid':uid,
  };
  static User fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String,dynamic>;
    return User(
      name: snapshot['name'],
      email: snapshot['email'],
      ProfilePhoto: snapshot['ProfilePhoto'],
      uid: snapshot['uid'],
    );
  }
}