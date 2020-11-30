import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:agorartm/models/comment.dart';
import 'package:agorartm/models/user.dart';

class CommentsScreen extends StatefulWidget {
  final DocumentReference documentReference;
  final User user;
  CommentsScreen({this.documentReference, this.user});

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  TextEditingController _commentController = TextEditingController();
  var _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _commentController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff252E39), //Color(0xFF2C3F3F),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xff252E39), //Color(0xFF2C3F3F),
        title: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(right: 30),
          child: Text(
            'Comments',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              commentsListWidget(),
              Divider(
                height: 20.0,
                color: Colors.grey,
              ),
              commentInputWidget()
            ],
          ),
        ),
      ),
    );
  }

  Widget commentInputWidget() {
    return Container(
      height: 55.0,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Container(
            width: 40.0,
            height: 40.0,
            margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.0),
                image:
                    DecorationImage(image: NetworkImage(widget.user.photoUrl))),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: TextFormField(
                validator: (String input) {
                  if (input.isEmpty) {
                    return "Please enter comment";
                  }
                },
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: "Add a comment...",
                ),
                onFieldSubmitted: (value) {
                  _commentController.text = value;
                },
              ),
            ),
          ),
          GestureDetector(
            child: Container(
              margin: const EdgeInsets.only(right: 8.0),
              child: Text('Post', style: TextStyle(color: Colors.blue)),
            ),
            onTap: () {
              if (_formKey.currentState.validate()) {
                postComment();
              }
            },
          )
        ],
      ),
    );
  }

  postComment() {
    var _comment = Comment(
        comment: _commentController.text,
        timeStamp: FieldValue.serverTimestamp(),
        ownerName: widget.user.displayName,
        ownerPhotoUrl: widget.user.photoUrl,
        ownerUid: widget.user.uid);
    widget.documentReference
        .collection("comments")
        .document()
        .setData(_comment.toMap(_comment))
        .whenComplete(() {
      _commentController.text = "";
    });
  }

  Widget commentsListWidget() {
    print("Document Ref : ${widget.documentReference.path}");
    return Flexible(
      child: StreamBuilder(
        stream: widget.documentReference
            .collection("comments")
            .orderBy('timestamp', descending: false)
            .snapshots(),
        builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: ((context, index) =>
                  commentItem(snapshot.data.documents[index])),
            );
          }
        }),
      ),
    );
  }

  Widget commentItem(DocumentSnapshot snapshot) {
    //   var time;
    //   List<String> dateAndTime;
    //   print('${snapshot.data['timestamp'].toString()}');
    //   if (snapshot.data['timestamp'].toString() != null) {
    //       Timestamp timestamp =snapshot.data['timestamp'];
    //  // print('${timestamp.seconds}');
    //  // print('${timestamp.toDate()}');
    //    time =timestamp.toDate().toString();
    //    dateAndTime = time.split(" ");
    //   }

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(snapshot.data['ownerPhotoUrl']),
              radius: 20,
            ),
          ),
          SizedBox(
            width: 15.0,
          ),
          Row(
            children: <Widget>[
              Text(snapshot.data['ownerName'],
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 16)),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, bottom: 2),
                child: Text(snapshot.data['comment'],
                    style: TextStyle(color: Colors.white70)),
              ),
            ],
          )
        ],
      ),
    );
  }
}
