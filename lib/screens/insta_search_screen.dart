import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:agorartm/models/user.dart';
import 'package:agorartm/resources/repository.dart';
import 'package:agorartm/screens/insta_friend_profile_screen.dart';
import 'package:agorartm/screens/post_detail_screen.dart';

class InstaSearchScreen extends StatefulWidget {
  @override
  _InstaSearchScreenState createState() => _InstaSearchScreenState();
}

class _InstaSearchScreenState extends State<InstaSearchScreen> {
  var _repository = Repository();
  List<DocumentSnapshot> list = List<DocumentSnapshot>();
  User _user = User();
  User currentUser;
  List<User> usersList = List<User>();

  @override
  void initState() {
    super.initState();
    _repository.getCurrentUser().then((user) {
      _user.uid = user.uid;
      _user.displayName = user.displayName;
      _user.photoUrl = user.photoUrl;
      _repository.fetchUserDetailsById(user.uid).then((user) {
        if (mounted) {
          setState(() {
            currentUser = user;
          });
        }
      });
      print("USER : ${user.displayName}");
      _repository.retrievePosts(user).then((updatedList) {
        if (mounted) {
          setState(() {
            list = updatedList;
          });
        }
      });
      _repository.fetchAllUsers(user).then((list) {
        if (mounted) {
          setState(() {
            usersList = list;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print("INSIDE BUILD");
    return Scaffold(
      backgroundColor: Color(0xff252E39), //Color(0xFF2C3F3F),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xff252E39), //Color(0xFF2C3F3F),
        title: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 30),
            child: Text(
              'Search',
              style: TextStyle(color: Colors.white70),
            )),
        actions: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(top: 12, right: 10),
            child: GestureDetector(
              child: Container(
                height: MediaQuery.of(context).size.height / 20,
                child: Image.asset('assets/Navigation Icons/icon2.png'),
              ),
              onTap: () {
                showSearch(
                    context: context,
                    delegate: DataSearch(userList: usersList));
              },
            ),
          ),
        ],
      ),
      body: GridView.builder(
          //  shrinkWrap: true,
          itemCount: list.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 0.0,
            mainAxisSpacing: 10.0,
          ),
          itemBuilder: ((context, index) {
            print("LIST : ${list.length}");
            return Padding(
              padding: const EdgeInsets.only(right: 8.0, left: 10),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: GestureDetector(
                    child: CachedNetworkImage(
                      imageUrl: list[index].data['imgUrl'],
                      placeholder: ((context, s) => Center(
                            child: CircularProgressIndicator(),
                          )),
                      width: 200.0,
                      height: 200.0,
                      fit: BoxFit.cover,
                    ),
                    onTap: () {
                      print("SNAPSHOT : ${list[index].reference.path}");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => PostDetailScreen(
                                    user: _user,
                                    currentuser: currentUser,
                                    documentSnapshot: list[index],
                                  ))));
                    },
                  ),
                ),
              ),
            );
          })),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  List<User> userList;
  DataSearch({this.userList});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
    // return Center(child: Container(width: 50.0, height: 50.0, color: Colors.red, child: Text(query),));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionsList = query.isEmpty
        ? userList
        : userList.where((p) => p.displayName.startsWith(query)).toList();
    return ListView.builder(
      itemCount: suggestionsList.length,
      itemBuilder: ((context, index) => Container(
            color: Colors.orange, //Color(0xFF2C3F3F),
            child: ListTile(
              onTap: () {
                //   showResults(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => InstaFriendProfileScreen(
                            name: suggestionsList[index].displayName))));
              },
              leading: CircleAvatar(
                backgroundImage: NetworkImage(suggestionsList[index].photoUrl),
              ),
              title: Text(suggestionsList[index].displayName),
            ),
          )),
    );
  }
}
