import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:agorartm/models/like.dart';
import 'package:agorartm/models/user.dart';
import 'package:agorartm/resources/repository.dart';
import 'package:agorartm/screens/comments_screen.dart';
import 'package:agorartm/screens/insta_friend_profile_screen.dart';
import 'package:agorartm/screens/likes_screen.dart';

class InstaFeedScreen extends StatefulWidget {
  @override
  _InstaFeedScreenState createState() => _InstaFeedScreenState();
}

class _InstaFeedScreenState extends State<InstaFeedScreen> {
  var _repository = Repository();
  User currentUser, user, followingUser;
  IconData icon;
  Color color;
  List<User> usersList = List<User>();
  Future<List<DocumentSnapshot>> _future;
  bool _isLiked = false;
  List<String> followingUIDs = List<String>();

  @override
  void initState() {
    super.initState();
    fetchFeed();
  }

  void fetchFeed() async {
    FirebaseUser currentUser = await _repository.getCurrentUser();

    User user = await _repository.fetchUserDetailsById(currentUser.uid);
    if (mounted) {
      setState(() {
        this.currentUser = user;
      });
    }

    followingUIDs = await _repository.fetchFollowingUids(currentUser);

    for (var i = 0; i < followingUIDs.length; i++) {
      print("DSDASDASD : ${followingUIDs[i]}");
      // _future = _repository.retrievePostByUID(followingUIDs[i]);
      this.user = await _repository.fetchUserDetailsById(followingUIDs[i]);
      print("user : ${this.user.uid}");
      usersList.add(this.user);
      print("USERSLIST : ${usersList.length}");

      for (var i = 0; i < usersList.length; i++) {
        if (mounted) {
          setState(() {
            followingUser = usersList[i];
            print("FOLLOWING USER : ${followingUser.uid}");
          });
        }
      }
    }
    _future = _repository.fetchFeed(currentUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff252E39), //Color(0xFF2C3F3F),
      appBar: AppBar(
        backgroundColor: Color(0xff252E39), //Color(0xFF2C3F3F),
        elevation: 0,
        title: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 20, left: 50, bottom: 20),
          child: Row(
            children: <Widget>[
              Text(
                'LIVE',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w500),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0, left: 10),
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(5)),
                ),
              ),
              Text(
                'RECOMMENDED',
                style: TextStyle(
                    color: Colors.white60,
                    fontSize: 17,
                    fontWeight: FontWeight.w500),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0, left: 10),
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(5)),
                ),
              ),
              Text(
                'FOLLOW',
                style: TextStyle(
                    color: Colors.white60,
                    fontSize: 17,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
      body: currentUser != null
          ? ListView(
              scrollDirection: Axis.vertical,
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: postImagesWidget(),
                ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget postImagesWidget() {
    return FutureBuilder(
      future: _future,
      builder: ((context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.hasData) {
          // print("FFFF : ${followingUser.uid}");
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: ((context, index) => listItem(
                      list: snapshot.data,
                      index: index,
                      user: followingUser,
                      currentUser: currentUser,
                    )));
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        } else {
          return Center(
            child: Text(
              'No Posts to show',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500),
            ),
          );
        }
      }),
    );
  }

  Widget listItem(
      {List<DocumentSnapshot> list, User user, User currentUser, int index}) {
    print("dadadadad : ${user.uid}");
    return GestureDetector(
      //  onTap: ,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CachedNetworkImage(
                imageUrl: list[index].data['imgUrl'],
                placeholder: ((context, s) => Center(
                      child: CircularProgressIndicator(),
                    )),
                width: MediaQuery.of(context).size.width / 1.08,
                height: MediaQuery.of(context).size.height / 2.2,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 2.2,
            padding: EdgeInsets.only(left: 20, bottom: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          InstaFriendProfileScreen(
                                            name: list[index]
                                                .data['postOwnerName'],
                                          ))));
                            },
                            child: new Container(
                              height: 40.0,
                              width: 40.0,
                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                image: new DecorationImage(
                                    fit: BoxFit.fill,
                                    image: new NetworkImage(
                                        list[index].data['postOwnerPhotoUrl'])),
                              ),
                            ),
                          ),
                          new SizedBox(
                            width: 10.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) =>
                                              InstaFriendProfileScreen(
                                                name: list[index]
                                                    .data['postOwnerName'],
                                              ))));
                                },
                                child: new Text(
                                  list[index].data['postOwnerName'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                              list[index].data['location'] != null
                                  ? new Text(
                                      list[index].data['location'],
                                      style: TextStyle(color: Colors.grey),
                                    )
                                  : Container(),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          GestureDetector(
                              child: _isLiked
                                  ? Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                    )
                                  : Icon(
                                      FontAwesomeIcons.heart,
                                      color: Colors.white,
                                    ),
                              onTap: () {
                                if (!_isLiked) {
                                  setState(() {
                                    _isLiked = true;
                                  });
                                  // saveLikeValue(_isLiked);
                                  postLike(list[index].reference, currentUser);
                                } else {
                                  setState(() {
                                    _isLiked = false;
                                  });
                                  //saveLikeValue(_isLiked);
                                  postUnlike(
                                      list[index].reference, currentUser);
                                }

                                // _repository.checkIfUserLikedOrNot(_user.uid, snapshot.data[index].reference).then((isLiked) {
                                //   print("reef : ${snapshot.data[index].reference.path}");
                                //   if (!isLiked) {
                                //     setState(() {
                                //       icon = Icons.favorite;
                                //       color = Colors.red;
                                //     });
                                //     postLike(snapshot.data[index].reference);
                                //   } else {

                                //     setState(() {
                                //       icon =FontAwesomeIcons.heart;
                                //       color = null;
                                //     });
                                //     postUnlike(snapshot.data[index].reference);
                                //   }
                                // });
                                // updateValues(
                                //     snapshot.data[index].reference);
                              }),
                          FutureBuilder(
                            future: _repository
                                .fetchPostLikes(list[index].reference),
                            builder: ((context,
                                AsyncSnapshot<List<DocumentSnapshot>>
                                    likesSnapshot) {
                              if (likesSnapshot.hasData) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: ((context) => LikesScreen(
                                                  user: currentUser,
                                                  documentReference:
                                                      list[index].reference,
                                                ))));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: Text(
                                      "${(likesSnapshot.data.length).toString()}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    // child: likesSnapshot.data.length > 1
                                    //     ? Text(
                                    //         "Liked by ${likesSnapshot.data[0].data['ownerName']} and ${(likesSnapshot.data.length - 1).toString()} others",
                                    //         style: TextStyle(fontWeight: FontWeight.bold),
                                    //       )
                                    //     : Text(likesSnapshot.data.length == 1
                                    //         ? "Liked by ${likesSnapshot.data[0].data['ownerName']}"
                                    //         : "0 Likes"),
                                  ),
                                );
                              } else {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                            }),
                          ),
                          new SizedBox(
                            width: 16.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => CommentsScreen(
                                            documentReference:
                                                list[index].reference,
                                            user: currentUser,
                                          ))));
                            },
                            child: new Icon(
                              FontAwesomeIcons.comment,
                              color: Colors.white,
                            ),
                          ),
                          new SizedBox(
                            width: 16.0,
                          ),
                          Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: commentWidget(list[index].reference))
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget commentWidget(DocumentReference reference) {
    return FutureBuilder(
      future: _repository.fetchPostComments(reference),
      builder: ((context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.hasData) {
          return GestureDetector(
            child: Text(
              '${snapshot.data.length}',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => CommentsScreen(
                            documentReference: reference,
                            user: currentUser,
                          ))));
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      }),
    );
  }

  void postLike(DocumentReference reference, User currentUser) {
    var _like = Like(
        ownerName: currentUser.displayName,
        ownerPhotoUrl: currentUser.photoUrl,
        ownerUid: currentUser.uid,
        timeStamp: FieldValue.serverTimestamp());
    reference
        .collection('likes')
        .document(currentUser.uid)
        .setData(_like.toMap(_like))
        .then((value) {
      print("Post Liked");
    });
  }

  void postUnlike(DocumentReference reference, User currentUser) {
    reference
        .collection("likes")
        .document(currentUser.uid)
        .delete()
        .then((value) {
      print("Post Unliked");
    });
  }
}
