import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String name;
  String email;
  String ProfilePhoto;  // Changed to lowercase for consistency
  String uid;

  User({
    required this.name,
    required this.email,
    required this.ProfilePhoto, // Changed to lowercase
    required this.uid,
  });

  // Convert User object to JSON for Firestore storage
  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'profilePhoto': ProfilePhoto,  // Changed to lowercase
        'uid': uid,
      };

  // Convert Firestore document snapshot to User object
  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    // Add error handling for missing or null fields
    return User(
      name: snapshot['name'] ?? 'Unknown',  // Provide default value if missing
      email: snapshot['email'] ?? 'Unknown',  // Provide default value if missing
      ProfilePhoto: snapshot['profilePhoto'] ?? '',  // Provide default value if missing
      uid: snapshot['uid'] ?? '',  // Provide default value if missing
    );
  }
}
