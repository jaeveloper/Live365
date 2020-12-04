import 'dart:async';

import 'package:agorartm/models/live.dart';
import 'package:agorartm/screens/agora/host.dart';
import 'package:agorartm/screens/agora/join.dart';
import 'package:agorartm/theme/style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:agorartm/models/like.dart';
import 'package:agorartm/models/user.dart';
import 'package:agorartm/resources/repository.dart';
import 'package:agorartm/screens/comments_screen.dart';
import 'package:agorartm/screens/insta_friend_profile_screen.dart';
import 'package:agorartm/screens/likes_screen.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class InstaFeedScreen extends StatefulWidget {
  @override
  _InstaFeedScreenState createState() => _InstaFeedScreenState();
}

class _InstaFeedScreenState extends State<InstaFeedScreen> {
  final FlareControls flareControls = FlareControls();
  final databaseReference = Firestore.instance;
  List<Live> list = [];
  bool ready = false;
  Live liveUser;
  var name;
  var image =
      'https://nichemodels.co/wp-content/uploads/2019/03/user-dummy-pic.png';
  var username;
  var postUsername;
  User _user;

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
    loadUserDetails();
    list = [];
    liveUser = new Live(username: username, me: true, image: image);
    setState(() {
      list.add(liveUser);
    });
    dbChangeListen();
  }

  Future<void> loadUserDetails() async {
    FirebaseUser currentUser = await _repository.getCurrentUser();
    User user = await _repository.retrieveUserDetails(currentUser);
    setState(() {
      name = user.name ?? 'Name';
      username = user.displayName ?? 'Username';
      image = user.photoUrl ??
          'https://nichemodels.co/wp-content/uploads/2019/03/user-dummy-pic.png';
    });
  }

  void dbChangeListen() {
    databaseReference
        .collection('liveuser')
        .orderBy("time", descending: true)
        .snapshots()
        .listen((result) {
      // Listens to update in appointment collection

      if (mounted) {
        setState(() {
          list = [];
          liveUser = new Live(username: username, me: true, image: image);
          list.add(liveUser);
        });
      }
      result.documents.forEach((result) {
        if (mounted) {
          setState(() {
            list.add(new Live(
                username: result.data['name'],
                image: result.data['image'],
                channelId: result.data['channel'],
                me: false));
          });
        }
      });
    });
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
          //  padding: EdgeInsets.only(top: 20, left: 50, bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'LIVE',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 11.0, left: 11),
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
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 11.0, left: 11),
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
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
      body: currentUser != null
          ? ListView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                Column(
                  children: [
                    Container(
                      height: 102,
                      child: getStories(),
                    ),
                    Divider(
                      thickness: 0.2,
                      color: Colors.white70,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: postImagesWidget(),
                    ),
                  ],
                ),
              ],
            )
          : Center(
              child: Container(),
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
              child: Container(),
            );
          }
        } else {
          return Center(
            child: Container(),
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
                placeholder: ((context, s) => Container(
                      width: MediaQuery.of(context).size.width / 1.08,
                      height: MediaQuery.of(context).size.height / 2.2,
                      color: Colors.white70,
                      padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                      ),
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
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
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
                                      size: 29,
                                    )
                                  : Icon(
                                      Icons.favorite,
                                      color: Colors.white,
                                      size: 29,
                                    ),
                              onTap: () {
                                if (!_isLiked) {
                                  setState(() {
                                    _isLiked = true;
                                  });
                                  postLike(list[index].reference, currentUser);
                                } else {
                                  setState(() {
                                    _isLiked = false;
                                  });
                                  postUnlike(
                                      list[index].reference, currentUser);
                                }
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
                                return Center(child: Container());
                              }
                            }),
                          ),
                          new SizedBox(
                            width: 16.0,
                          ),
                          GestureDetector(
                            child: Container(
                              height: MediaQuery.of(context).size.height / 30,
                              child: Image.asset(
                                  'assets/Navigation Icons/comment.png'),
                            ),
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
          return Center(child: Container());
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

  Widget getStories() {
    return ListView(
        scrollDirection: Axis.horizontal, children: getUserStories());
  }

  List<Widget> getUserStories() {
    List<Widget> stories = [];
    for (Live users in list) {
      stories.add(getStory(users));
    }
    return stories;
  }

  Widget getStory(Live users) {
    return Container(
      margin: EdgeInsets.all(5),
      child: !users.me
          ? Column(
              children: <Widget>[
                Container(
                    height: 70,
                    width: 70,
                    child: GestureDetector(
                      onTap: () {
                        if (users.me == true) {
                          // Host function
                          onCreate(
                              username: users.username, image: users.image);
                        } else {
                          // Join function
                          onJoin(
                              channelName: users.username,
                              channelId: users.channelId,
                              username: username,
                              hostImage: users.image,
                              userImage: image);
                        }
                      },
                      child: Stack(
                        alignment: Alignment(0, 0),
                        children: <Widget>[
                          !users.me
                              ? Container(
                                  height: 60,
                                  width: 60,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                            colors: [
                                              Colors.indigo,
                                              Colors.blue,
                                              Colors.cyan
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight)),
                                  ),
                                )
                              : SizedBox(
                                  height: 0,
                                ),
                          !users.me
                              ? Container(
                                  height: 55.5,
                                  width: 55.5,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.black,
                                  ),
                                )
                              : SizedBox(
                                  height: 0,
                                ),
                          !users.me
                              ? CachedNetworkImage(
                                  imageUrl: users.image,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    width: 52.0,
                                    height: 52.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                )
                              : Container(),
                          users.me
                              ? Container()
                              : Container(
                                  height: 70,
                                  width: 70,
                                  alignment: Alignment.bottomCenter,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: <Widget>[
                                      Container(
                                        height: 17,
                                        width: 25,
                                        decoration: new BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  4.0) //         <--- border radius here
                                              ),
                                          gradient: LinearGradient(
                                              colors: [
                                                Colors.black,
                                                Colors.black
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight),
                                        ),
                                      ),
                                      Container(
                                          decoration: new BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    2.0) //         <--- border radius here
                                                ),
                                            gradient: LinearGradient(
                                                colors: [
                                                  Colors.indigo,
                                                  Colors.blueAccent
                                                ],
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Text(
                                              'LIVE',
                                              style: TextStyle(
                                                  fontSize: 7,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )),
                                    ],
                                  ))
                        ],
                      ),
                    )),
                SizedBox(
                  height: 3,
                ),
                !users.me
                    ? Text(users.username ?? '', style: textStyle)
                    : SizedBox(
                        height: 0,
                      ),
              ],
            )
          : SizedBox(
              height: 0,
            ),
    );
  }

  Future<void> onJoin(
      {channelName, channelId, username, hostImage, userImage}) async {
    // update input validation
    if (channelName.isNotEmpty) {
      // push video page with given channel name
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => JoinPage(
            channelName: channelName,
            channelId: channelId,
            username: username,
            hostImage: hostImage,
            userImage: userImage,
          ),
        ),
      );
    }
  }

  Future<void> onCreate({username, image}) async {
    // await for camera and mic permissions before pushing video page
    await _handleCameraAndMic();
    var date = DateTime.now();
    var currentTime = '${DateFormat("dd-MM-yyyy hh:mm:ss").format(date)}';
    // push video page with given channel name
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CallPage(
          channelName: username,
          time: currentTime,
          image: image,
        ),
      ),
    );
  }

  Future<void> _handleCameraAndMic() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );
  }
}
