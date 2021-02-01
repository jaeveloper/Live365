import 'dart:async';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var image = Image.asset('assets/images/agoraLogo.png');

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(image.image, context);
  }

  startTime() async {
    var _duration = new Duration(seconds: 1);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/HomeScreen');
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage("assets/images/agoraLogo.png"), context);
    return Scaffold(
      backgroundColor: Color(0xff252E39), //Color(0xFF2C3F3F),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Color(0xff252E39), //Color(0xFF2C3F3F),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 80,
              width: 80,
              child: Center(
                child: image,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
