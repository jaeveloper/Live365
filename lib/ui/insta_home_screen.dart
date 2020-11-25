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
            color: Color(0xff252E39), //Colors.white,
            child: HomePage(), //InstaFeedScreen(),
          ),
          new Container(
            color: Color(0xff252E39), //Color(0xFF2C3F3F),
            child: InstaSearchScreen(),
          ),
          new Container(
            color: Color(0xff252E39), //Colors.white,
            child: InstaAddScreen(),
          ),
          new Container(
            color: Color(0xff252E39), //Colors.white,
            child: ChatScreen(),
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
      bottomNavigationBar: new CupertinoTabBar(
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
                child: Image.asset('assets/Navigation Icons/Home White.png'),
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
                child: Image.asset('assets/Navigation Icons/Search White.png'),
              ),
              title: Text(
                'Search',
                style: TextStyle(
                    color: (_page == 1) ? Colors.orange : Colors.white),
              ),
              backgroundColor: Colors.white),
          new BottomNavigationBarItem(
              activeIcon: Container(
                height: MediaQuery.of(context).size.height / 20,
                child: Image.asset('assets/Navigation Icons/Camera.png'),
              ),
              icon: Container(
                height: MediaQuery.of(context).size.height / 22,
                child: Image.asset('assets/Navigation Icons/Camera.png'),
              ),
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
                child: Image.asset('assets/Navigation Icons/Inbox White.png'),
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
                child:
                    Image.asset('assets/Navigation Icons/Me When Selected.png'),
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
    );
  }
}
