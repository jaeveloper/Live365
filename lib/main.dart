import 'package:agorartm/resources/repository.dart';
import 'package:agorartm/screens/google_signIn_screen.dart';
import 'package:agorartm/screens/splash_screen.dart';
import 'package:agorartm/screens/insta_home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  var _repository = Repository();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instagram',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Color(0xff252E39),
          primaryIconTheme: IconThemeData(color: Colors.white70),
          primaryTextTheme: TextTheme(
              title: TextStyle(color: Colors.white, fontFamily: "Aveny")),
          textTheme: TextTheme(title: TextStyle(color: Colors.white))),
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/HomeScreen': (BuildContext context) => new MainScreen()
      },
      //SplashScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var _repository = Repository();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: _repository.getCurrentUser(),
        builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.hasData) {
            return InstaHomeScreen();
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}
