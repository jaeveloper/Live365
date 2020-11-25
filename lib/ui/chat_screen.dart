import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:agorartm/models/user.dart';
import 'package:agorartm/resources/repository.dart';
import 'package:agorartm/ui/chat_detail_screen.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var _repository = Repository();
  User _user = User();
  List<User> usersList = List<User>();

  @override
  void initState() {
    super.initState();
    _repository.getCurrentUser().then((user) {
      print("USER : ${user.displayName}");

      _repository.fetchAllUsers(user).then((updatedList) {
        setState(() {
          usersList = updatedList;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF2C3F3F),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xFF2C3F3F),
          title: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 30),
            child: Text(
              'Messages',
              style: TextStyle(color: Colors.white),
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.orange,
              ),
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: ChatSearch(usersList: usersList));
              },
            )
          ],
        ),
        body: ListView.builder(
          itemCount: usersList.length,
          itemBuilder: ((context, index) {
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => ChatDetailScreen(
                                    photoUrl: usersList[index].photoUrl,
                                    name: usersList[index].displayName,
                                    receiverUid: usersList[index].uid,
                                  ))));
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(usersList[index].photoUrl),
                      ),
                      title: Text(
                        usersList[index].displayName,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Divider(),
                )
              ],
            );
          }),
        ));
  }
}

class ChatSearch extends SearchDelegate<String> {
  List<User> usersList;
  ChatSearch({this.usersList});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<User> suggestionsList = query.isEmpty
        ? usersList
        : usersList.where((p) => p.displayName.startsWith(query)).toList();
    return ListView.builder(
      itemCount: suggestionsList.length,
      itemBuilder: ((context, index) => ListTile(
            onTap: () {
              //   showResults(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => ChatDetailScreen(
                            photoUrl: suggestionsList[index].photoUrl,
                            name: suggestionsList[index].displayName,
                            receiverUid: suggestionsList[index].uid,
                          ))));
            },
            leading: CircleAvatar(
              backgroundImage: NetworkImage(suggestionsList[index].photoUrl),
            ),
            title: Text(suggestionsList[index].displayName),
          )),
    );
  }
}
