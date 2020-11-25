import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:agorartm/models/like.dart';
import 'package:agorartm/models/user.dart';
import 'package:agorartm/resources/repository.dart';
import 'package:agorartm/ui/comments_screen.dart';
import 'package:agorartm/ui/likes_screen.dart';

class PostDetailScreen extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  final User user, currentuser;

  PostDetailScreen({this.documentSnapshot, this.user, this.currentuser});

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  var _repository = Repository();
  bool _isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF2C3F3F),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: new Color(0xFF2C3F3F),
          title: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(right: 30),
              child: Text(
                'Photo',
                style: TextStyle(color: Colors.white60),
              )),
        ),
        body: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 8.0, 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      new Container(
                        height: 40.0,
                        width: 40.0,
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: new NetworkImage(widget
                                  .documentSnapshot.data['postOwnerPhotoUrl'])),
                        ),
                      ),
                      new SizedBox(
                        width: 10.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: 0),
                            child: new Text(
                              widget.documentSnapshot.data['postOwnerName'],
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                          ),
                          widget.documentSnapshot.data['location'] != null
                              ? new Text(
                                  widget.documentSnapshot.data['location'],
                                  style: TextStyle(color: Colors.grey),
                                )
                              : Container(
                                  width: 0,
                                  height: 0,
                                ),
                        ],
                      )
                    ],
                  ),
                  // new IconButton(
                  //   icon: Icon(Icons.more_vert),
                  //   onPressed: null,
                  // )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: widget.documentSnapshot.data['imgUrl'],
                  placeholder: ((context, s) => Center(
                        child: CircularProgressIndicator(),
                      )),
                  width: MediaQuery.of(context).size.width / 1.08,
                  height: MediaQuery.of(context).size.height / 2,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, bottom: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            GestureDetector(
                                child: _isLiked
                                    ? Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                      )
                                    : Icon(
                                        FontAwesomeIcons.heart,
                                        color: Colors.white,
                                      ),
                                onTap: () {
                                  if (!_isLiked) {
                                    setState(() {
                                      _isLiked = true;
                                    });
                                    // saveLikeValue(_isLiked);
                                    postLike(widget.documentSnapshot.reference);
                                  } else {
                                    setState(() {
                                      _isLiked = false;
                                    });
                                    //saveLikeValue(_isLiked);
                                    postUnlike(
                                        widget.documentSnapshot.reference);
                                  }
                                }),
                            FutureBuilder(
                              future: _repository.fetchPostLikes(
                                  widget.documentSnapshot.reference),
                              builder: ((context,
                                  AsyncSnapshot<List<DocumentSnapshot>>
                                      likesSnapshot) {
                                if (likesSnapshot.hasData) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: ((context) =>
                                                  LikesScreen(
                                                    user: widget.currentuser,
                                                    documentReference: widget
                                                        .documentSnapshot
                                                        .reference,
                                                  ))));
                                    },
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: Text(
                                          "${(likesSnapshot.data.length).toString()} ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        )),
                                  );
                                } else {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                              }),
                            ),
                            new SizedBox(
                              width: 16.0,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) => CommentsScreen(
                                              documentReference: widget
                                                  .documentSnapshot.reference,
                                              user: widget.currentuser,
                                            ))));
                              },
                              child: new Icon(
                                FontAwesomeIcons.comment,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: commentWidget(
                                    widget.documentSnapshot.reference)),
                            SizedBox(
                              width: 16.0,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget commentWidget(DocumentReference reference) {
    return FutureBuilder(
      future: _repository.fetchPostComments(reference),
      builder: ((context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.hasData) {
          return GestureDetector(
            child: Text(
              '${snapshot.data.length}',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => CommentsScreen(
                            documentReference: reference,
                            user: widget.currentuser,
                          ))));
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      }),
    );
  }

  void postLike(DocumentReference reference) {
    var _like = Like(
        ownerName: widget.currentuser.displayName,
        ownerPhotoUrl: widget.currentuser.photoUrl,
        ownerUid: widget.currentuser.uid,
        timeStamp: FieldValue.serverTimestamp());
    reference
        .collection('likes')
        .document(widget.currentuser.uid)
        .setData(_like.toMap(_like))
        .then((value) {
      print("Post Liked");
    });
  }

  void postUnlike(DocumentReference reference) {
    reference
        .collection("likes")
        .document(widget.currentuser.uid)
        .delete()
        .then((value) {
      print("Post Unliked");
    });
  }
}
