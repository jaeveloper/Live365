import 'package:flutter/material.dart';

class UniversalVariables {
  static final Color blueColor = Color(0xff2b9ed4);
  static final Color blackColor = Color(0xff252E39); //Color(0xff19191b);
  static final Color greyColor = Color(0xff8f8f8f);
  static final Color userCircleBackground = Color(0xff2b2b33);
  static final Color onlineDotColor = Color(0xff46dc64);
  static final Color lightBlueColor = Color(0xff0077d7);
  static final Color separatorColor = Color(0xff272c35);

  static final Color gradientColorStart = Colors.orangeAccent;
  static final Color gradientColorEnd = Colors.orange;

  static final Color senderColor = Colors.white;
  static final Color receiverColor = Colors.orangeAccent;

  static final Gradient fabGradient = LinearGradient(
      colors: [gradientColorStart, gradientColorEnd],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight);
}
