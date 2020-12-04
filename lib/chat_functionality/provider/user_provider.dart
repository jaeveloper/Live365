import 'package:agorartm/chat_functionality/resources/auth_methods.dart';
import 'package:agorartm/models/user.dart';
import 'package:agorartm/resources/repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class UserProvider with ChangeNotifier {
  User _user;
  AuthMethods _authMethods = AuthMethods();
  var _repository = Repository();

  User get getUser => _user;

  void refreshUser() async {
    FirebaseUser currentUser = await _repository.getCurrentUser();

    User user = await _repository.fetchUserDetailsById(currentUser.uid);
    //User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
