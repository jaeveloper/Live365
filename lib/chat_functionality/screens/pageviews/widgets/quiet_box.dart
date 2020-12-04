import 'package:agorartm/chat_functionality/screens/search_screen.dart';
import 'package:agorartm/chat_functionality/utils/universal_variables.dart';
import 'package:flutter/material.dart';

class QuietBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Container(
          // color: UniversalVariables.separatorColor,
          padding: EdgeInsets.symmetric(vertical: 35, horizontal: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'This is where all the contacts are listed',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.white70,
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                'Search for your friends to start chatting with them',
                textAlign: TextAlign.center,
                style: TextStyle(
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                  color: Colors.white70,
                ),
              ),
              SizedBox(
                height: 25,
              ),
              FlatButton(
                  color: Colors.orangeAccent,
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => SearchScreen())),
                  child: Text(
                    'Start Searching',
                    style: TextStyle(color: Colors.black54),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
