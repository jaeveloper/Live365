import 'dart:io';

import 'package:agorartm/chat_functionality/utils/universal_variables.dart';
import 'package:agorartm/firebaseDB/auth.dart';
import 'package:agorartm/resources/repository.dart';
import 'package:agorartm/screens/insta_home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegScreen extends StatefulWidget {
  static final String id = 'login_screen';

  @override
  _RegScreenState createState() => _RegScreenState();
}

class _RegScreenState extends State<RegScreen> {
  Repository _repository = Repository();

  bool isLoginPressed = false;

  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  bool passwordVisible = false;
  File _image;
  bool submitted = false;
  bool boolEmail = false,
      boolPass = false,
      boolName = false,
      boolUser = false,
      invalidError = false,
      passwordError = false;

  void _submit() async {
    setState(() {
      submitted = true;
    });
    if (_image == null) {
      setState(() {
        submitted = false;
      });
      imageDialog();
      return;
    }
    passwordError = false;
    invalidError = false;
    //existsError=false;
    final pass = _passController.text.toString().trim();
    final email = _emailController.text.toString().trim();
    final name = _nameController.text.toString().trim();
    final username = _usernameController.text.toString().trim();

    var result = await registerUser(
        email: email,
        name: name,
        username: username,
        pass: pass,
        image: _image);
    switch (result) {
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
      case -1:
        usernameError();
        setState(() {
          submitted = false;
        });
        break;
      case -2:
        setState(() {
          invalidError = true;
          submitted = false;
        });
        break;
      case -3:
        setState(() {
          emailExists();
          submitted = false;
        });
        break;
      case -4:
        setState(() {
          passwordError = true;
          submitted = false;
        });
        break;
    }
  }

  void usernameError() {
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
                            'Username Not Available',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 30, right: 25, top: 15),
                          child: Text(
                            "The username you entered is not available.",
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

  void imageDialog() {
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
                            'Select Image',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 30, right: 25, top: 15),
                          child: Text(
                            "Image is not selected for avatar.",
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

  void emailExists() {
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
                            'This Email is on Another Account',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 30, right: 25, top: 15),
                          child: Text(
                            "You can log into the account associated with that email.",
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
                        Navigator.popUntil(
                            context, ModalRoute.withName('/HomeScreen'));
                      },
                      child: Text(
                        'Log in to Existing Account',
                        style: TextStyle(color: Colors.lightBlue[400]),
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
  void initState() {
    super.initState();
    _emailController.addListener(setEmail);
    _passController.addListener(setPass);
    _nameController.addListener(setName);
    _usernameController.addListener(setUser);
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
    if (_passController.text.toString().trim() == '') {
      setState(() {
        boolPass = false;
      });
    } else
      setState(() {
        boolPass = true;
      });
  }

  void setName() {
    if (_nameController.text.toString().trim() == '') {
      setState(() {
        boolName = false;
      });
    } else
      setState(() {
        boolName = true;
      });
  }

  void setUser() {
    if (_usernameController.text.toString().trim() == '') {
      setState(() {
        boolUser = false;
      });
    } else
      setState(() {
        boolUser = true;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height - 45,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      chooseFile();
                    },
                    child: Container(
                      height: 120,
                      width: 120,
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage: _image == null
                            ? AssetImage('assets/images/dummy.png')
                            : FileImage(_image),
                        //NetworkImage('https://firebasestorage.googleapis.com/v0/b/xperion-vxatbk.appspot.com/o/image_picker82875791.jpg?alt=media&token=09bf83c8-6d3b-4626-9058-85294f457b70'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 13,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 30.0,
                          vertical: 5.0,
                        ),
                        child: TextField(
                          controller: _nameController,
                          cursorColor: Colors.white,
                          textCapitalization: TextCapitalization.words,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            fillColor: Colors.grey[700],
                            filled: false,
                            hintText: '   Full Name',
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
                          controller: _usernameController,
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            fillColor: Colors.grey[700],
                            filled: false,
                            hintText: '   Username',
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
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: Colors.white,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            fillColor: Colors.grey[700],
                            filled: false,
                            hintText: '   Email Address',
                            hintStyle:
                                TextStyle(color: Colors.white70, fontSize: 13),
                            errorText: invalidError
                                ? '   Please enter a valid email'
                                : null,
                            errorStyle:
                                TextStyle(color: Colors.red, fontSize: 10),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.indigo),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.indigo),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
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
                          controller: _passController,
                          obscureText: !passwordVisible,
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            fillColor: Colors.grey[700],
                            filled: false,
                            hintText: '  Password',
                            hintStyle:
                                TextStyle(color: Colors.white70, fontSize: 13),
                            errorText: passwordError
                                ? 'Week Password! Min 6 characters'
                                : null,
                            errorStyle:
                                TextStyle(color: Colors.red, fontSize: 10),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.indigo),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.indigo),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color:
                                    passwordVisible ? Colors.blue : Colors.grey,
                              ),
                              onPressed: () {
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
                        width: MediaQuery.of(context).size.width *
                            .4, //double.infinity,
                        height: MediaQuery.of(context).size.height * .05,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          onPressed: (boolPass != false &&
                                  boolEmail != false &&
                                  boolName != false &&
                                  boolUser != false)
                              ? _submit
                              : null,
                          color: Colors.indigo,
                          disabledColor: Colors.indigo,
                          disabledTextColor: Colors.white60,
                          textColor: Colors.white,
                          child: submitted
                              ? Center(
                                  child: SizedBox(
                                    height: 15,
                                    width: 15,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: 20.0),
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
                height: 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          "Already have an account? ",
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                        Text(
                          'Log in.',
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

  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });
  }
}
