import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff252E39),
      appBar: AppBar(
        backgroundColor: Color(0xff252E39), //Colors.grey[100],
        elevation: 0,
        title: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 5, left: 0),
          child: Text(
            'ChatScreen',
            style: TextStyle(
                //fontFamily: 'Billabong',
                color: Colors.grey[100],
                fontSize: 19.0,
                fontWeight: FontWeight.w700),
          ),
        ),
      ),
      body: Center(
        child: Text('CHAT'),
      ),
    );
  }
}
