import 'package:flutter/material.dart';

class TxtButton extends StatelessWidget {
  final String buttonName;
  final VoidCallback onPressed;
  final TextStyle textStyle = const TextStyle(
      color: const Color(0XFFFFFFFF),
      fontSize: 16.0,
      fontWeight: FontWeight.bold);

  final TextStyle buttonTextStyle;

  //passing props in react style
  TxtButton({
    this.buttonName,
    this.onPressed,
    this.buttonTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return (new FlatButton(
      child: new Text(buttonName,
          textAlign: TextAlign.center, style: buttonTextStyle),
      onPressed: onPressed,
    ));
  }
}
