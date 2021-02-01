import 'package:agorartm/models/user.dart';
import 'package:agorartm/resources/repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  Repository _repository = Repository();

  _buildUserTile(User user) {
    /*  amount() async {
      int userAmount = await DatabaseService.totalAmount(user.id);
      int userAmt = userAmount;
    }*/

    // Future<int> amount = DatabaseService.totalAmount(user.id);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: ListTile(
              leading: CircleAvatar(
                radius: 25,
                backgroundImage: user.photoUrl.isEmpty
                    ? AssetImage('images/user_placeholder.jpg')
                    : CachedNetworkImageProvider(user.photoUrl),
              ),
              title: Text(
                user.name,
                style: TextStyle(
                  fontFamily: 'Bellany',
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              subtitle: Text(
                user.email,
                style: TextStyle(color: Colors.white60, fontSize: 12),
              ),
              trailing: IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () {},
              )),
        ),
        Divider(
          color: Colors.white60,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey, //Color(0xFF2C3F3F),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey, //Color(0xff252E39), //Color(0xFF2C3F3F),
        title: Text(
          'Admin Page',
          style: TextStyle(color: Colors.white70),
        ),
      ),
      body: FutureBuilder(
        future: _repository.displayUsers(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data.documents.length == 0) {
            return Center(
              child: Text('No users found! Please try again.'),
            );
          }
          return ListView.builder(
            scrollDirection: Axis.vertical,
            physics: BouncingScrollPhysics(),
            itemCount: snapshot.data.documents.length,
            itemBuilder: (BuildContext context, int index) {
              User user = User.fromDoc(
                snapshot.data.documents[index],
              );
              return _buildUserTile(user);
            },
          );
        },
      ),
    );
  }
}
