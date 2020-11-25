import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:agorartm/ui/insta_home_screen.dart';

class UserAuth {
  String statusMsg = "Account Created Successfully";
  static final _auth = FirebaseAuth.instance;
  static final _firestore = Firestore.instance;
  //To create new User
  Future<String> createUser(
      BuildContext context, String name, String email, String password) async {
    AuthResult authResult = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    FirebaseUser signedInUser = authResult.user;
    if (signedInUser != null) {
      _firestore.collection('/users').document(signedInUser.uid).setData({
        'name': name,
        'uid': signedInUser.uid,
        'email': email,
        'photoUrl': '',
        'displayName': name,
        'followers': '0',
        'following': '0',
        'posts': '0',
        'bio': '',
        'phone': '',
      });
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      //   return InstaHomeScreen();
      // }));
      //Provider.of<UserData>(context).currentUserId = signedInUser.uid;
      String currentUserId = signedInUser.uid;
    }

    return statusMsg;
  }

  static void logout(BuildContext context) {
    _auth.signOut();
  }

  //To verify new User
  Future<String> verifyUser(
      BuildContext context, String email, String password) async {
    try {
      AuthResult authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser signedInUser = authResult.user;
    } catch (onError) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Invalid Credentials')));
    }
    // Provider.of<UserData>(context).currentUserId = signedInUser.uid;
    //String currentUserId = signedInUser.uid;
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
    //   return InstaHomeScreen();
    // }));
    return "Login Successfull";
  }
}
