import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agorartm/models/live.dart';
import 'package:agorartm/models/user.dart';
import 'package:agorartm/resources/repository.dart';
import 'package:agorartm/theme/style.dart';

import '../models/global.dart';
import 'agora/host.dart';
import 'agora/join.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  var _repository = Repository();
  User _user;

  @override
  Widget build(BuildContext context) {
    return getMain();
  }

  @override
  void initState() {
    super.initState();
    loadUserDetails();
    list = [];
    liveUser = new Live(username: username, me: false, image: image);
    setState(() {
      list.add(liveUser);
    });
    dbChangeListen();
    /*var date = DateTime.now();
    var newDate = '${DateFormat("dd-MM-yyyy hh:mm:ss").format(date)}';
    */
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
          liveUser = new Live(username: username, me: false, image: image);
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

  Widget getMain() {
    return Scaffold(
      backgroundColor: Color(0xff252E39),
      floatingActionButton: Align(
          child: FloatingActionButton(
            backgroundColor: Color(0xffF19920), //Colors.orange,
            elevation: 1,
            tooltip: 'Go Live',
            onPressed: () {},
            //  => Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (_) => Google(),
            //   ),
            // ),
            child: Icon(
              Icons.wifi_tethering,
              size: 30,
              color: Colors.white,
            ),
          ),
          alignment: Alignment(1, 0.99)),
      //Color(0xFF2C3F3F),
      //Color(0xFF2C3F3F),
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
      body: Container(
          color: Color(0xff252E39), //Color(0xFF2C3F3F),
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    height: 1000,
                    child: getStories(),
                  ),
                  // Divider(
                  //   height: 0,
                  // ),
                  // Column(
                  //   children: getPosts(context),
                  // ),
                  // SizedBox(height: 10,)
                ],
              )
            ],
          )),
    );
  }

  Widget getStories() {
    return ListView(scrollDirection: Axis.vertical, children: getUserStories());
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
      child: Column(
        children: <Widget>[
          Container(
              height: 70,
              width: 70,
              child: GestureDetector(
                onTap: () {
                  if (users.me == true) {
                    // Host function
                    onCreate(username: users.username, image: users.image);
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
                    Container(
                      height: 55.5,
                      width: 55.5,
                      child: CircleAvatar(
                        backgroundColor: Colors.black,
                      ),
                    ),
                    CachedNetworkImage(
                      imageUrl: users.image,
                      imageBuilder: (context, imageProvider) => Container(
                        width: 52.0,
                        height: 52.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    users.me
                        ? Container(
                            height: 55,
                            width: 55,
                            alignment: Alignment.bottomRight,
                            child: Container(
                              decoration: new BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                Icons.add,
                                size: 13.5,
                                color: Colors.white,
                              ),
                            ))
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
                                        colors: [Colors.black, Colors.black],
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
          Text(users.username ?? '', style: textStyle)
        ],
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
