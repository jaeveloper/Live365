import 'package:agorartm/chat_functionality/models/contact.dart';
import 'package:agorartm/chat_functionality/provider/image_upload_provider.dart';
import 'package:agorartm/chat_functionality/provider/user_provider.dart';
import 'package:agorartm/chat_functionality/resources/chat_methods.dart';
import 'package:agorartm/chat_functionality/screens/pageviews/widgets/contact_view.dart';
import 'package:agorartm/chat_functionality/screens/pageviews/widgets/quiet_box.dart';
import 'package:agorartm/chat_functionality/screens/search_screen.dart';
import 'package:agorartm/chat_functionality/utils/universal_variables.dart';
import 'package:agorartm/chat_functionality/widgets/appbar.dart';
import 'package:agorartm/models/user.dart';
import 'package:agorartm/resources/repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatListScreen extends StatelessWidget {
  CustomAppBar customAppBar(BuildContext context) {
    return CustomAppBar(
      leading: Container(),
      title: Text(
        'MESSAGES',
        style: TextStyle(color: Colors.white70, fontSize: 18),
      ),
      centerTitle: true,
      actions: <Widget>[
        GestureDetector(
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 25,
            child: Image.asset(
              'assets/Navigation Icons/icon2.png',
              height: MediaQuery.of(context).size.height / 25,
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: ((context) => SearchScreen()),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: customAppBar(context),
      body: ChatListContainer(),
    );
  }
}

class ChatListContainer extends StatefulWidget {
  @override
  _ChatListContainerState createState() => _ChatListContainerState();
}

class _ChatListContainerState extends State<ChatListContainer> {
  final ChatMethods _chatMethods = ChatMethods();
  var _repository = Repository();
  User currentUser, user, followingUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchFeed();
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
    // final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: _chatMethods.fetchContacts(userId: currentUser.uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var docList = snapshot.data.documents;
              if (docList.isEmpty) {
                return QuietBox();
              }

              return ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: docList.length,
                itemBuilder: (context, index) {
                  Contact contact = Contact.fromMap(docList[index].data);

                  return ContactView(contact);
                },
              );
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
