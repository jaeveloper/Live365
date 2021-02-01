import 'package:agorartm/models/user.dart';
import 'package:agorartm/resources/repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class UserProvider with ChangeNotifier {
  User _user;
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
