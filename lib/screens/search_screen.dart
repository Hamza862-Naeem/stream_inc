import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stream_inc/controller/search_controller.dart' as Controller;

import '../models/user.dart';
import 'profile_screen.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

final Controller.SearchController searchController = Get.put(Controller.SearchController());
 
  @override
  Widget build(BuildContext context) {
    return Obx(
       () {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: TextFormField(
              decoration: const InputDecoration(
                  filled: false,
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                  )),
              onFieldSubmitted: (value) => searchController.searchUser(value),
            ),
          ),
          body: searchController.searchedUsers.isEmpty ? const Center(
            child: Text(
              'Search for users!',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ):ListView.builder(
            itemCount: searchController.searchedUsers.length,
            itemBuilder: (context,index) {
              User user = searchController.searchedUsers[index];
              return InkWell(
                onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProfileScreen(uid: user.uid,),),),
                child: ListTile(
                  leading:CircleAvatar(
  backgroundImage: NetworkImage(user.ProfilePhoto),
  onBackgroundImageError: (exception, stackTrace) {
    // You could also use a default avatar if the network image fails.
  },
),

                  title: Text(user.name,style: TextStyle(fontSize: 18.0, color: Colors.white),),
                ),
               );
          }
        )
        );
      }
    );
  }
}
