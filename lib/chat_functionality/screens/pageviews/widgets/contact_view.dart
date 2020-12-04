import 'package:agorartm/chat_functionality/models/contact.dart';
import 'package:agorartm/chat_functionality/provider/user_provider.dart';
import 'package:agorartm/chat_functionality/resources/auth_methods.dart';
import 'package:agorartm/chat_functionality/resources/chat_methods.dart';
import 'package:agorartm/chat_functionality/screens/chatscreens/chat_screen.dart';
import 'package:agorartm/chat_functionality/screens/chatscreens/widgets/cached_image.dart';
import 'package:agorartm/chat_functionality/screens/pageviews/widgets/last_message_container.dart';
import 'package:agorartm/chat_functionality/screens/pageviews/widgets/online_dot_indicator.dart';
import 'package:agorartm/chat_functionality/widgets/custom_tile.dart';
import 'package:agorartm/models/user.dart';
import 'package:agorartm/resources/repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactView extends StatelessWidget {
  final Contact contact;
  final AuthMethods _authMethods = AuthMethods();
  var _repository = Repository();
  User currentUser, user, followingUser;

  ContactView(this.contact);

  @override
  Widget build(BuildContext context) {
    print(contact.uid);
    return FutureBuilder<User>(
        future: _repository.fetchUserDetailsById(contact.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            User user = snapshot.data;

            return ViewLayout(contact: user);
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}

class ViewLayout extends StatefulWidget {
  final User contact;

  ViewLayout({@required this.contact});

  @override
  _ViewLayoutState createState() => _ViewLayoutState();
}

class _ViewLayoutState extends State<ViewLayout> {
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

    return CustomTile(
      mini: false,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatScreen(
            receiver: widget.contact,
          ),
        ),
      ),
      title: Text(
        widget.contact?.name ?? "..",
        style:
            TextStyle(color: Colors.white, fontFamily: "Arial", fontSize: 19),
      ),
      subtitle: LastMessageContainer(
        stream: _chatMethods.fetchLastMessageBetween(
            senderId: currentUser.uid, receiverId: widget.contact.uid),
      ),
      leading: Container(
        constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            CachedImage(
              widget.contact.photoUrl,
              radius: 80,
              isRound: true,
            ),
            OnlineDotIndicator(uid: widget.contact.uid),
          ],
        ),
      ),
    );
  }
}
