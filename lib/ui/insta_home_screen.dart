import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agorartm/screens/home.dart';
import 'package:agorartm/ui/chat_screen.dart';
import 'package:agorartm/ui/insta_activity_screen.dart';
import 'package:agorartm/ui/insta_add_screen.dart';
import 'package:agorartm/ui/insta_feed_screen.dart';
import 'package:agorartm/ui/insta_profile_screen.dart';
import 'package:agorartm/ui/insta_search_screen.dart';

class InstaHomeScreen extends StatefulWidget {
  @override
  _InstaHomeScreenState createState() => _InstaHomeScreenState();
}

PageController pageController;

class _InstaHomeScreenState extends State<InstaHomeScreen> {
  int _page = 0;

  void navigationTapped(int page) {
    //Animating Page
    pageController.jumpToPage(page);
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
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new PageView(
        children: [
          new Container(
            color: Colors.white,
            child: HomePage(), //InstaFeedScreen(),
          ),
          new Container(
            color: Color(0xFF2C3F3F),
            child: InstaSearchScreen(),
          ),
          new Container(
            color: Colors.white,
            child: InstaAddScreen(),
          ),
          new Container(
            color: Colors.white,
            child: ChatScreen(),
          ), //InstaActivityScreen()),
          new Container(
            color: Color(0xFF2C3F3F),
            child: InstaProfileScreen(),
          ),
        ],
        controller: pageController,
        physics: new NeverScrollableScrollPhysics(),
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: new CupertinoTabBar(
        backgroundColor: Color(0xFF2C3F3F),
        activeColor: Colors.orange,
        items: <BottomNavigationBarItem>[
          new BottomNavigationBarItem(
              icon: new Icon(
                Icons.home,
                color: (_page == 0) ? Colors.orange : Colors.white,
                size: 25,
              ),
              title: new Container(height: 0.0),
              backgroundColor: Colors.white),
          new BottomNavigationBarItem(
              icon: new Icon(
                Icons.search,
                color: (_page == 1) ? Colors.orange : Colors.white,
                size: 25,
              ),
              title: new Container(height: 0.0),
              backgroundColor: Colors.white),
          new BottomNavigationBarItem(
              icon: new Icon(
                Icons.camera_alt,
                color: (_page == 2) ? Colors.orange : Colors.white,
                size: 25,
              ),
              title: new Container(height: 0.0),
              backgroundColor: Colors.white),
          new BottomNavigationBarItem(
              icon: new Icon(
                FontAwesomeIcons.comments,
                color: (_page == 3) ? Colors.orange : Colors.white,
                size: 23,
              ),
              title: new Container(height: 0.0),
              backgroundColor: Colors.white),
          new BottomNavigationBarItem(
              icon: new Icon(
                Icons.person,
                color: (_page == 4) ? Colors.orange : Colors.white,
                size: 25,
              ),
              title: new Container(height: 0.0),
              backgroundColor: Colors.white),
        ],
        onTap: navigationTapped,
        currentIndex: _page,
      ),
    );
  }
}
