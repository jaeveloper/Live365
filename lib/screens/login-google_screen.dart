import 'package:agorartm/firebaseDB/auth.dart';
import 'package:agorartm/resources/repository.dart';
import 'package:agorartm/screens/insta_home_screen.dart';
import 'package:agorartm/utils/universal_variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Repository _repository = Repository();

  bool isLoginPressed = false;

  //final _formKey = GlobalKey<FormState>();
  bool passwordVisible = false;
  var submitted = false;
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool boolEmail = false;
  bool boolPass = false;

  void _submit() async {
    setState(() {
      submitted = true;
    });
    final pass = _passController.text.toString().trim();
    final email = _emailController.text.toString().trim();
    var user = await loginFirebase(email, pass);
    switch (user) {
      case -1:
        invalidPass();
        setState(() {
          submitted = false;
        });
        break;
      case -2:
      case -3:
        invalidEmail();
        setState(() {
          submitted = false;
        });
        break;
      case 1:
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('login', true);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => InstaHomeScreen(),
          ),
        );

        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(setEmail);
    _passController.addListener(setPass);
  }

  void setEmail() {
    if (_emailController.text.toString().trim() == '') {
      setState(() {
        boolEmail = false;
      });
    } else
      setState(() {
        boolEmail = true;
      });
  }

  void setPass() {
    print(_passController.text.toString().trim());
    if (_passController.text.toString().trim() == '') {
      setState(() {
        boolPass = false;
      });
    } else
      setState(() {
        boolPass = true;
      });
  }

  void invalidEmail() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                color: Colors.grey[800],
              ),
              height: 190,
              child: Column(
                children: [
                  Container(
                    height: 140,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: Text(
                            'Incorrect Email',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 30, right: 25, top: 15),
                          child: Text(
                            "The email you entered doesn't appear to belong to an account. Please check your email and try again",
                            style: TextStyle(color: Colors.white60),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    thickness: 0,
                    height: 0,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Try Again',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  void invalidPass() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                color: Colors.grey[800],
              ),
              height: 170,
              child: Column(
                children: [
                  Container(
                    height: 120,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: Text(
                            'Incorrect Password',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 30, right: 25, top: 15),
                          child: Text(
                            'The password you entered is incorrect. Please try again.',
                            style: TextStyle(color: Colors.white60),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    thickness: 0,
                    height: 0,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Try Again',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff252E39), //UniversalVariables.blackColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
            ),
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * .3,
              child: Image.asset(
                'assets/images/agoraLogo.png',
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 30.0,
                          vertical: 5.0,
                        ),
                        child: TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(color: Colors.white),
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            fillColor: Colors.grey[700],
                            filled: false,
                            hintText: '   Email Address',
                            hintStyle:
                                TextStyle(color: Colors.white70, fontSize: 13),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.indigo),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.indigo),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 30.0,
                          vertical: 5.0,
                        ),
                        child: TextField(
                          onChanged: (text) {
                            if (text.length == 0) {
                              boolPass = false;
                            } else
                              boolPass = true;
                          },
                          controller: _passController,
                          obscureText: !passwordVisible,
                          style: TextStyle(color: Colors.white),
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            fillColor: Colors.grey[700],
                            filled: false,
                            hintText: '   Password',
                            hintStyle:
                                TextStyle(color: Colors.white70, fontSize: 13),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.indigo),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.indigo),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                // Based on passwordVisible state choose the icon
                                passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color:
                                    passwordVisible ? Colors.blue : Colors.grey,
                              ),
                              onPressed: () {
                                // Update the state i.e. toogle the state of passwordVisible variable
                                setState(() {
                                  passwordVisible = !passwordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: loginButton(),
                          ),
                          Center(
                            child: facebookLoginButton(),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.height * 0.045,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          onPressed: (boolPass == true && boolEmail == true)
                              ? _submit
                              : null,
                          color: Colors.indigo,
                          disabledColor: Colors.indigo,
                          disabledTextColor: Colors.white60,
                          textColor: Colors.white,
                          child: submitted
                              ? SizedBox(
                                  height: 15,
                                  width: 15,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : Text(
                                  'Log In',
                                  style: TextStyle(
                                    fontSize: 13.0,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .1,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: MediaQuery.of(context).size.height * .05,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Divider(
                      color: Colors.white,
                      height: 0,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                        Text(
                          'Sign Up.',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.3,
          height: MediaQuery.of(context).size.height * 0.05,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.transparent, //Color(0xFF4285F4),
          ),
          child: Row(
            children: <Widget>[
              ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.asset('assets/google_icon.jpg')),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text('Google',
                    style: TextStyle(color: Colors.white, fontSize: 13.0)),
              )
            ],
          ),
        ),
      ),
      onTap: () => performLogin(),
    );
  }

  Widget facebookLoginButton() {
    return GestureDetector(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.3,
          height: MediaQuery.of(context).size.height * 0.05,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.transparent, //Color(0xFF4285F4),
          ),
          child: Row(
            children: <Widget>[
              ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Container(
                      alignment: Alignment.center,
                      color: Colors.white,
                      child: Image.asset('assets/facebook.png'))),
              Container(
                padding: const EdgeInsets.only(left: 10.0),
                alignment: Alignment.center,
                child: Text('  Facebook',
                    style: TextStyle(color: Colors.white, fontSize: 13.0)),
              )
            ],
          ),
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
