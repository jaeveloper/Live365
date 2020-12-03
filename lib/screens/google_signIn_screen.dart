import 'package:agorartm/resources/repository.dart';
import 'package:agorartm/screens/insta_home_screen.dart';
import 'package:agorartm/utils/universal_variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Repository _repository = Repository();

  bool isLoginPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff252E39), //UniversalVariables.blackColor,
      body: Stack(
        children: <Widget>[
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.6,
                width: 80,
                child: Center(
                  child: Image.asset('assets/images/3333.jpg'),
                ),
              ),
              Center(
                child: loginButton(),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Center(
                child: facebookLoginButton(),
              ),
            ],
          ),
          isLoginPressed ? loadingScreen() : Container(),
        ],
      ),
    );
  }

  Widget loadingScreen() {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Color(0xff252E39), //Colors.black,
      child: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
                backgroundColor: Colors.white,
              ),
              const SizedBox(height: 10.0),
              Text(
                'Loading',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 18.0),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget loginButton() {
    return GestureDetector(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.61,
        height: MediaQuery.of(context).size.height * 0.072,
        decoration: BoxDecoration(
            color: Color(0xFF4285F4), border: Border.all(color: Colors.black)),
        child: Row(
          children: <Widget>[
            Image.asset('assets/google_icon.jpg'),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text('Sign in with Google',
                  style: TextStyle(color: Colors.white, fontSize: 16.0)),
            )
          ],
        ),
      ),
      onTap: () => performLogin(),
    );
  }

  Widget facebookLoginButton() {
    return GestureDetector(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.61,
        height: MediaQuery.of(context).size.height * 0.072,
        decoration: BoxDecoration(
            color: Color(0xFF4285F4), border: Border.all(color: Colors.black)),
        child: Row(
          children: <Widget>[
            Image.asset('assets/google_icon.jpg'),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text('Sign in with Facebook',
                  style: TextStyle(color: Colors.white, fontSize: 16.0)),
            )
          ],
        ),
      ),
      onTap: () {},
    );
  }

  void performLogin() {
    print('Trying to Login');

    setState(() {
      isLoginPressed = true;
    });
    _repository.signIn().then((FirebaseUser user) {
      if (user != null) {
        authenticateUser(user);
      } else {
        print('There was an error');
      }
    });
  }

  void authenticateUser(FirebaseUser user) {
    _repository.authenticateUser(user).then((isNewUser) {
      setState(() {
        isLoginPressed = false;
      });
      if (isNewUser) {
        _repository.addDataToDb(user).then((value) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => InstaHomeScreen(),
            ),
          );
        });
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => InstaHomeScreen(),
          ),
        );
      }
    });
  }
}
