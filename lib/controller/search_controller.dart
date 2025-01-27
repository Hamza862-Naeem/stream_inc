import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:stream_inc/constants.dart';

import '../models/user.dart';

class SearchController extends GetxController {
  // Rx to store the list of searched users
  final Rx<List<User>> _searchedUsers = Rx<List<User>>([]);

  // Getter for searched users
  List<User> get searchedUsers => _searchedUsers.value;

  // Search user method
  searchUser(String typedUser) async {
    // If the search query is empty, reset the list to avoid unnecessary queries
    if (typedUser.isEmpty) {
      _searchedUsers.value = [];
      return;
    }

    try {
      // Bind the stream of searched users to _searchedUsers
      _searchedUsers.bindStream(
        firestore
            .collection('users')
            .where('name', isGreaterThanOrEqualTo: typedUser)
            .where('name', isLessThan: typedUser + 'z') // Ensuring a range search
            .snapshots()
            .map((QuerySnapshot query) {
          // Map the query results to a list of User objects
          return query.docs.map((doc) => User.fromSnap(doc)).toList();
        }),
      );
    } catch (e) {
      // Log any errors and optionally show a snackbar for the user
      print("Error searching users: $e");
      Get.snackbar("Error", "Failed to search users: $e");
    }
  }
}

































































// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:stream_inc/constants.dart';

// import '../models/user.dart';

// class SearchController extends GetxController {
//  final Rx<List<User>> _searchedUsers = Rx<List<User>>([]);

//  List<User> get searchedUsers => _searchedUsers.value;

//  searchUser(String typedUser) async{
//    _searchedUsers.bindStream(
//     firestore.collection('users').where('name',
//      isGreaterThanOrEqualTo: typedUser).snapshots()
//      .map((QuerySnapshot query){
//        List<User>retVal = [];
//        for (var elem in query.docs){
//         retVal.add(User.fromSnap(elem));
//        }
//        return retVal;
//     })
//    );
//  }




// }