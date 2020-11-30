import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:image/image.dart' as Im;
import 'package:path_provider/path_provider.dart';
import 'dart:math';

import 'package:agorartm/resources/repository.dart';
import 'package:agorartm/screens/insta_home_screen.dart';

class InstaUploadPhotoScreen extends StatefulWidget {
  File imageFile;
  InstaUploadPhotoScreen({this.imageFile});

  @override
  _InstaUploadPhotoScreenState createState() => _InstaUploadPhotoScreenState();
}

class _InstaUploadPhotoScreenState extends State<InstaUploadPhotoScreen> {
  var _locationController;
  var _captionController;
  final _repository = Repository();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _locationController = TextEditingController();
    _captionController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _locationController?.dispose();
    _captionController?.dispose();
  }

  bool _visibility = true;

  void _changeVisibility(bool visibility) {
    setState(() {
      _visibility = visibility;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff252E39), //Color(0xFF2C3F3F),
      appBar: AppBar(
        title: Center(child: Text('New Post')),
        backgroundColor: Color(0xff252E39), //Color(0xFF2C3F3F),
        elevation: 0,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0, top: 20.0),
            child: GestureDetector(
              child: Text('Share',
                  style: TextStyle(color: Colors.blue, fontSize: 16.0)),
              onTap: () {
                // To show the CircularProgressIndicator
                _changeVisibility(false);

                _repository.getCurrentUser().then((currentUser) {
                  if (currentUser != null) {
                    compressImage();
                    _repository.retrieveUserDetails(currentUser).then((user) {
                      _repository
                          .uploadImageToStorage(widget.imageFile)
                          .then((url) {
                        _repository
                            .addPostToDb(user, url, _captionController.text,
                                _locationController.text)
                            .then((value) {
                          print("Post added to db");
                          Navigator.pop(context);
                        }).catchError((e) =>
                                print("Error adding current post to db : $e"));
                      }).catchError((e) {
                        print("Error uploading image to storage : $e");
                      });
                    });
                  } else {
                    print("Current User is null");
                  }
                });
              },
            ),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 12.0, left: 12.0),
                child: Container(
                  width: 80.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: FileImage(widget.imageFile))),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 8.0),
                  child: TextField(
                    controller: _captionController,
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: 'Write a caption...',
                    ),
                    onChanged: ((value) {
                      setState(() {
                        _captionController.text = value;
                      });
                    }),
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Offstage(
              child: CircularProgressIndicator(),
              offstage: _visibility,
            ),
          )
        ],
      ),
    );
  }

  void compressImage() async {
    print('starting compression');
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = Random().nextInt(10000);

    Im.Image image = Im.decodeImage(widget.imageFile.readAsBytesSync());
    Im.copyResize(image, width: 500);

    var newim2 = new File('$path/img_$rand.jpg')
      ..writeAsBytesSync(Im.encodeJpg(image, quality: 85));

    setState(() {
      widget.imageFile = newim2;
    });
    print('done');
  }
}
