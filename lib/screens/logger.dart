import 'package:agorartm/resources/repository.dart';
import 'package:agorartm/screens/insta_home_screen.dart';
import 'package:agorartm/screens/login-google_screen.dart';
import 'package:agorartm/screens/regScreen.dart';
import 'package:agorartm/utils/universal_variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Logger extends StatefulWidget {
  @override
  _LoggerState createState() => _LoggerState();
}

class _LoggerState extends State<Logger> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff252E39), //UniversalVariables.blackColor,
      body: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/agoraLogo.png',
                  width: MediaQuery.of(context).size.width * .4,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Center(
                child: loginButton(),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Center(
                child: Text(
                  'OR',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Center(
                child: signInButton(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget loginButton() {
    return GestureDetector(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.06,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.indigo //Color(0xFF4285F4),
            ),
        child: Text('Login',
            style: TextStyle(color: Colors.white, fontSize: 20.0)),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ));
      },
    );
  }

  Widget signInButton() {
    return GestureDetector(
      child: Center(
        child: Text('Sign Up Here',
            style: TextStyle(color: Colors.indigo, fontSize: 20.0)),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RegScreen(),
            ));
      },
    );
  }
}
