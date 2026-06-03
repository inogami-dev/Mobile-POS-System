import 'package:flutter/material.dart';

class MyDimensions {
  MyDimensions._(); // Private constructor to prevent instantiation

  static double getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
}
