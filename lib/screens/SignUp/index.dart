import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:agorartm/components/Buttons/roundedButton.dart';
import 'package:agorartm/components/Buttons/textButton.dart';
import 'package:agorartm/components/TextFields/inputField.dart';
import 'package:agorartm/services/authentication.dart';
import 'package:agorartm/services/validations.dart';
import 'package:agorartm/theme/style.dart';
import 'style.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key key}) : super(key: key);

  @override
  SignUpScreenState createState() => new SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _name, _email, _password;
  UserAuth userAuth = new UserAuth();
  bool _autovalidate = false;
  bool _isLoading = false;
  Validations _validations = new Validations();

  _onPressed() {
    print("button clicked");
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  void _handleSubmitted() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      setState(() {
        _isLoading = true;
      });
      userAuth.createUser(context, _name, _email, _password).then((onValue) {
        showInSnackBar(onValue);
      }).catchError((PlatformException onError) {
        showInSnackBar(onError.message);
      });
      setState(() {
        _isLoading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Size screenSize = MediaQuery.of(context).size;
    //print(context.widget.toString());
    return new Scaffold(
        backgroundColor: Color(0xFF2C3F3F),
        key: _scaffoldKey,
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
                child: new Container(
                  padding: new EdgeInsets.all(16.0),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new SizedBox(
                          height: screenSize.height / 2,
                          child: new Column(
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
                          )),
                      new SizedBox(
                        height: screenSize.height / 2,
                        child: new Column(
                          children: <Widget>[
                            new Form(
                                key: _formKey,
                                autovalidate: _autovalidate,
                                //onWillPop: _warnUserAboutInvalidData,
                                child: new Column(
                                  children: <Widget>[
                                    new InputField(
                                      hintText: "Username",
                                      obscureText: false,
                                      textInputType: TextInputType.text,
                                      textStyle: textStyle,
                                      textFieldColor: textFieldColor,
                                      icon: Icons.person_outline,
                                      iconColor: Colors.white,
                                      bottomMargin: 20.0,
                                      validateFunction:
                                          _validations.validateName,
                                      onSaved: (String name) {
                                        _name = name;
                                      },
                                    ),
                                    new InputField(
                                        hintText: "Email",
                                        obscureText: false,
                                        textInputType:
                                            TextInputType.emailAddress,
                                        textStyle: textStyle,
                                        textFieldColor: textFieldColor,
                                        icon: Icons.mail_outline,
                                        iconColor: Colors.white,
                                        bottomMargin: 20.0,
                                        validateFunction:
                                            _validations.validateEmail,
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
                                        bottomMargin: 40.0,
                                        validateFunction:
                                            _validations.validatePassword,
                                        onSaved: (String password) {
                                          _password = password;
                                        }),
                                    new RoundedButton(
                                        buttonName: "Continue",
                                        onTap: _handleSubmitted,
                                        width: screenSize.width,
                                        height: 50.0,
                                        bottomMargin: 10.0,
                                        borderWidth: 1.0)
                                  ],
                                )),
                            new TxtButton(
                              buttonName: "Terms & Condition",
                              onPressed: _onPressed,
                              buttonTextStyle: buttonTextStyle,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ));
  }
}
