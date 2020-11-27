import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agorartm/models/user.dart';
import 'package:agorartm/resources/repository.dart';
import 'package:agorartm/screens/agora/host.dart';
import 'package:agorartm/screens/insta_upload_photo_screen.dart';

class MyAddScreen extends StatefulWidget {
  @override
  _MyAddScreenState createState() => _MyAddScreenState();
}

class _MyAddScreenState extends State<MyAddScreen> {
  File imageFile;
  var _repository = Repository();
  User currentUser, user, followingUser;

  @override
  void initState() {
    super.initState();
    fetchFeed();
    // loadSharedPref();
    // list = [];
    // liveUser = new Live(username: username, me: true, image: image);
    // setState(() {
    //   list.add(liveUser);
    // });
    // dbChangeListen();
  }

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
      backgroundColor: Color(0xff252E39), //Color(0xFF2C3F3F),
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: Color(0xFF2C3F3F),
      //   title: Center(
      //       child: Text(
      //     'Add Photo',
      //     style: TextStyle(color: Colors.white70),
      //   )),
      // ),
      body: Center(
          child: RaisedButton.icon(
        splashColor: Colors.yellow,
        shape: StadiumBorder(),
        color: Colors.black,
        label: Text(
          'Go Live ',
          style: TextStyle(color: Colors.white),
        ),
        icon: Icon(
          Icons.cloud_upload,
          color: Colors.white,
        ),
        onPressed: () {
          onCreate(
              username: currentUser.displayName, image: currentUser.photoUrl);
        },
      )),
    );
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
