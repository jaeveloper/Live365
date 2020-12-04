import 'dart:io';

import 'package:agorartm/chat_functionality/screens/pageviews/chat_list_screen.dart';
import 'package:agorartm/models/user.dart';
import 'package:agorartm/resources/repository.dart';
import 'package:agorartm/screens/agora/host.dart';
import 'package:agorartm/screens/insta_add_screen.dart';
import 'package:agorartm/screens/insta_chat_screen.dart';
import 'package:agorartm/screens/insta_upload_photo_screen.dart';
import 'package:agorartm/utils/custom_tile.dart';
import 'package:agorartm/utils/universal_variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agorartm/screens/home.dart';
import 'package:agorartm/screens/my_add_screen.dart';
import 'package:agorartm/screens/insta_feed_screen.dart';
import 'package:agorartm/screens/insta_profile_screen.dart';
import 'package:agorartm/screens/insta_search_screen.dart';

class InstaHomeScreen extends StatefulWidget {
  @override
  _InstaHomeScreenState createState() => _InstaHomeScreenState();
}

PageController pageController;

class _InstaHomeScreenState extends State<InstaHomeScreen> {
  int _page = 0;
  File imageFile;
  var _repository = Repository();
  User currentUser, user, followingUser;

  Future<File> _pickImage(String action) async {
    File selectedImage;

    action == 'Gallery'
        ? selectedImage =
            await ImagePicker.pickImage(source: ImageSource.gallery)
        : await ImagePicker.pickImage(source: ImageSource.camera);

    return selectedImage;
  }

  _showImageDialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                child: Text('Choose from Gallery'),
                onPressed: () {
                  _pickImage('Gallery').then((selectedImage) {
                    setState(() {
                      imageFile = selectedImage;
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => InstaUploadPhotoScreen(
                                  imageFile: imageFile,
                                ))));
                  });
                },
              ),
              SimpleDialogOption(
                child: Text('Take Photo'),
                onPressed: () {
                  _pickImage('Camera').then((selectedImage) {
                    setState(() {
                      imageFile = selectedImage;
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => InstaUploadPhotoScreen(
                                  imageFile: imageFile,
                                ))));
                  });
                },
              ),
              SimpleDialogOption(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        }));
  }

  void navigationTapped(int page) {
    //Animating Page
    pageController.jumpToPage(
      page,
      /* curve: Curves.easeIn, duration: Duration(milliseconds: 200)*/
    );
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  @override
  void initState() {
    super.initState();

    pageController = new PageController();
    fetchFeed();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void fetchFeed() async {
    FirebaseUser currentUser = await _repository.getCurrentUser();

    User user = await _repository.fetchUserDetailsById(currentUser.uid);
    if (mounted) {
      setState(() {
        this.currentUser = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new PageView(
        children: [
          new Container(
            color: Color(0xff252E39), //Colors.white,
            child: InstaFeedScreen(), //InstaFeedScreen(),
          ),
          new Container(
            color: Color(0xff252E39), //Color(0xFF2C3F3F),
            child: InstaSearchScreen(),
          ),
          null,
          new Container(
            color: Color(0xff252E39), //Colors.white,
            child: ChatListScreen(),
          ), //InstaActivityScreen()),
          new Container(
            color: Color(0xff252E39), //Color(0xFF2C3F3F),
            child: InstaProfileScreen(),
          ),
        ],
        controller: pageController,
        physics: new NeverScrollableScrollPhysics(),
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: Stack(
        alignment: Alignment(0, 0),
        children: [
          new CupertinoTabBar(
            backgroundColor:
                Color(0xff252E39), //Color(0xff242A37), //Colors.grey[100],
            //  activeColor: Colors.orange,
            items: <BottomNavigationBarItem>[
              new BottomNavigationBarItem(
                  activeIcon: Container(
                    height: MediaQuery.of(context).size.height / 35,
                    child: Image.asset(
                        'assets/Navigation Icons/Home When Selected.png'),
                  ),
                  icon: Container(
                    height: MediaQuery.of(context).size.height / 35,
                    child:
                        Image.asset('assets/Navigation Icons/Home White.png'),
                  ),
                  title: Text(
                    'Home',
                    style: TextStyle(
                        color: (_page == 0) ? Colors.orange : Colors.white),
                  ),
                  backgroundColor: Colors.white),
              new BottomNavigationBarItem(
                  activeIcon: Container(
                    height: MediaQuery.of(context).size.height / 35,
                    child: Image.asset(
                        'assets/Navigation Icons/Search When Selected.png'),
                  ),
                  icon: Container(
                    height: MediaQuery.of(context).size.height / 35,
                    child:
                        Image.asset('assets/Navigation Icons/Search White.png'),
                  ),
                  title: Text(
                    'Search',
                    style: TextStyle(
                        color: (_page == 1) ? Colors.orange : Colors.white),
                  ),
                  backgroundColor: Colors.white),
              new BottomNavigationBarItem(
                  activeIcon: Container(),
                  icon: Container(),
                  //label: '',
                  backgroundColor: Colors.white),
              new BottomNavigationBarItem(
                  activeIcon: Container(
                    height: MediaQuery.of(context).size.height / 35,
                    child: Image.asset(
                        'assets/Navigation Icons/Inbox When Selected.png'),
                  ),
                  icon: Container(
                    height: MediaQuery.of(context).size.height / 35,
                    child:
                        Image.asset('assets/Navigation Icons/Inbox White.png'),
                  ),
                  title: Text(
                    'Inbox',
                    style: TextStyle(
                        color: (_page == 3) ? Colors.orange : Colors.white),
                  ),
                  backgroundColor: Colors.white),
              new BottomNavigationBarItem(
                  activeIcon: Container(
                    height: MediaQuery.of(context).size.height / 35,
                    padding: EdgeInsets.all(0),
                    margin: EdgeInsets.all(0),
                    child: Image.asset(
                        'assets/Navigation Icons/Me When Selected.png'),
                  ),
                  icon: Container(
                    height: MediaQuery.of(context).size.height / 35,
                    child: Image.asset('assets/Navigation Icons/Me White.png'),
                  ),
                  title: Text(
                    'Me',
                    style: TextStyle(
                        color: (_page == 4) ? Colors.orange : Colors.white),
                  ),
                  backgroundColor: Colors.white),
            ],
            onTap: navigationTapped,
            currentIndex: _page,
          ),
          GestureDetector(
            onTap: () => {addMediaModal(context)},
            child: Container(
              padding: EdgeInsets.only(),
              height: MediaQuery.of(context).size.height / 16,
              child: Image.asset('assets/Navigation Icons/Camera.png'),
            ),
          ),
        ],
      ),
    );
  }

  addMediaModal(context) {
    return showModalBottomSheet(
        context: context,
        elevation: 0,
        backgroundColor: UniversalVariables.blackColor,
        builder: (context) {
          return Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                      padding: EdgeInsets.only(left: 20),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Create',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )),
                  ],
                ),
              ),
              Flexible(
                  child: ListView(
                children: [
                  GestureDetector(
                    onTap: _showImageDialog,
                    child: ModalTile(
                      title: 'Video',
                      subTitle: 'Upload short video',
                      icon: Icons.video_label,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      onCreate(
                          username: currentUser.displayName,
                          image: currentUser.photoUrl);
                    },
                    child: ModalTile(
                      title: 'Live',
                      subTitle: 'Go live now',
                      icon: Icons.network_wifi,
                    ),
                  ),
                ],
              ))
            ],
          );
        });
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

class ModalTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData icon;

  const ModalTile({
    Key key,
    this.title,
    this.subTitle,
    this.icon,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: CustomTile(
        mini: false,
        leading: Container(
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(color: UniversalVariables.receiverColor),
          padding: EdgeInsets.all(10),
          child: Icon(
            icon,
            color: UniversalVariables.greyColor,
            size: 38,
          ),
        ),
        subtitle: Text(
          subTitle,
          style: TextStyle(color: UniversalVariables.greyColor, fontSize: 14),
        ),
        title: Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
