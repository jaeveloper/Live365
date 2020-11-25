import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:agorartm/components/Buttons/roundedButton.dart';
import 'package:agorartm/components/Buttons/textButton.dart';
import 'package:agorartm/components/TextFields/inputField.dart';
import 'package:agorartm/services/authentication.dart';
import 'package:agorartm/services/validations.dart';
import 'package:agorartm/theme/style.dart';
import 'style.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  LoginScreenState createState() => new LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  BuildContext context;
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController scrollController = new ScrollController();
  String _name, _email, _password;
  UserAuth userAuth = new UserAuth();
  bool autovalidate = false;
  bool _isLoading = false;
  Validations validations = new Validations();

  _onPressed() {
    print("button clicked");
  }

  onPressed(String routeName) {
    Navigator.of(context).pushNamed(routeName);
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  void _handleSubmitted() {
    final FormState form = formKey.currentState;
    if (!form.validate()) {
      autovalidate = true; // Start validating on every change.
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      setState(() {
        _isLoading = true;
      });
      userAuth.verifyUser(context, _email, _password).then((onValue) {
        if (onValue == "Login Successfull") {
          // Navigator.pushNamed(context, "/HomePage");
        } else
          showInSnackBar(onValue);
      }).catchError((PlatformException onError) {
        showInSnackBar(onError.message);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    final Size screenSize = MediaQuery.of(context).size;
    //print(context.widget.toString());
    Validations validations = new Validations();
    return new Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color(0xFF2C3F3F),
        body: _isLoading
            ? Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 2.4,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 6,
                      height: MediaQuery.of(context).size.width / 6,
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.blue.shade300,
                        strokeWidth: 6,
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                  ],
                ),
              )
            : new SingleChildScrollView(
                controller: scrollController,
                child: new Container(
                  padding: new EdgeInsets.all(16.0),
                  child: new Column(
                    children: <Widget>[
                      new Container(
                        height: screenSize.height / 2,
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Center(
                              child: Text(
                                'XXBASE',
                                style: TextStyle(
                                  fontFamily: 'Billabong',
                                  color: Color(0xFFE0E0E0),
                                  fontSize: 50.0,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      new Container(
                        height: screenSize.height / 2,
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Form(
                              key: formKey,
                              autovalidate: autovalidate,
                              child: new Column(
                                children: <Widget>[
                                  new InputField(
                                      hintText: "Email",
                                      obscureText: false,
                                      textInputType: TextInputType.text,
                                      textStyle: textStyle,
                                      textFieldColor: textFieldColor,
                                      icon: Icons.mail_outline,
                                      iconColor: Colors.white,
                                      bottomMargin: 20.0,
                                      validateFunction:
                                          validations.validateEmail,
                                      onSaved: (String email) {
                                        _email = email;
                                      }),
                                  new InputField(
                                      hintText: "Password",
                                      obscureText: true,
                                      textInputType: TextInputType.text,
                                      textStyle: textStyle,
                                      textFieldColor: textFieldColor,
                                      icon: Icons.lock_open,
                                      iconColor: Colors.white,
                                      bottomMargin: 30.0,
                                      validateFunction:
                                          validations.validatePassword,
                                      onSaved: (String password) {
                                        _password = password;
                                      }),
                                  new RoundedButton(
                                    buttonName: "Log In",
                                    onTap: _handleSubmitted,
                                    width: screenSize.width,
                                    height: 50.0,
                                    bottomMargin: 10.0,
                                    borderWidth: 0.0,
                                    buttonColor: primaryColor,
                                  ),
                                ],
                              ),
                            ),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new TxtButton(
                                    buttonName: "Create Account",
                                    onPressed: () => Navigator.pop(context),
                                    buttonTextStyle: buttonTextStyle),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )));
  }
}
