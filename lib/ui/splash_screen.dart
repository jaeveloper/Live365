import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:agorartm/resources/repository.dart';
import 'package:agorartm/screens/Login/index.dart';
import 'package:agorartm/screens/SignUp/index.dart';
import 'package:agorartm/ui/insta_home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var _repository = Repository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2C3F3F),
      appBar: AppBar(
          backgroundColor: Color(0xFF2C3F3F),
          centerTitle: true,
          elevation: 0,
          title: SizedBox(
              height: 35.0, child: Image.asset("assets/insta_logo.png"))),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 250.0,
                  height: 50.0,
                  child: RaisedButton(
                    elevation: 0,
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignUpScreen())),
                    color: Colors.grey,
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  width: 250.0,
                  height: 50.0,
                  child: RaisedButton(
                    elevation: 0,
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen())),
                    color: Colors.grey,
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Center(
            child: GestureDetector(
              child: Container(
                width: 250.0,
                height: 50.0,
                decoration: BoxDecoration(
                    color: Color(0xFF4285F4),
                    border: Border.all(color: Colors.black)),
                child: Row(
                  children: <Widget>[
                    Image.asset('assets/google_icon.jpg'),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text('Sign in with Google',
                          style:
                              TextStyle(color: Colors.white, fontSize: 16.0)),
                    )
                  ],
                ),
              ),
              onTap: () {
                _repository.signIn().then((user) {
                  if (user != null) {
                    authenticateUser(user);
                  } else {
                    print("Error");
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  void authenticateUser(FirebaseUser user) {
    print("Inside Login Screen -> authenticateUser");
    _repository.authenticateUser(user).then((value) {
      if (value) {
        print("VALUE : $value");
        print("INSIDE IF");
        _repository.addDataToDb(user).then((value) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return InstaHomeScreen();
          }));
        });
      } else {
        print("INSIDE ELSE");
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return InstaHomeScreen();
        }));
      }
    });
  }
}
