import 'package:flutter/material.dart';
import 'package:pos_system/core/utilities/dimension.dart';
import 'package:pos_system/core/widgets/text_formatter.dart';

class NoRoleYetLandingPage extends StatelessWidget {
  final String userNameToDisplay;
  const NoRoleYetLandingPage({super.key, required this.userNameToDisplay});

  @override
  Widget build(BuildContext context) {
    ColorScheme myColorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // backgroundColor: MyColorPalette.formColor,
      backgroundColor: myColorScheme.surface,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Icon(
              Icons.lock_outline_rounded,
              size: 85,
              color: Colors.grey.shade500,
            ),
          ),
          Container(
            width: MyDimensions.getHeight(context),
            // margin: EdgeInsets.only(left: 50, right: 40),
            padding: EdgeInsets.only(top: 32, left: 50, right: 20, bottom: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    MyText(
                      text: "Hello there, ",
                      fontSize: kDefaultFontSize + 6,
                      color: myColorScheme.onSurface,
                    ),
                    SizedBox(
                      width: MyDimensions.getWidth(context) * 0.45,
                      // color: Colors.amber,
                      child: MyText(
                        text: "$userNameToDisplay!",
                        fontSize: kDefaultFontSize + 10,
                        fontWeight: FontWeight.bold,
                        color: myColorScheme.onSurface,
                        maxLines: 10,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32),
                MyText(
                  maxLines: 5,
                  text: "Access Pending",
                  fontWeight: FontWeight.w500,
                  fontSize: kDefaultFontSize + 1,
                  color: myColorScheme.onSurface,
                ),
                SizedBox(height: 8),
                SizedBox(
                  width: MyDimensions.getWidth(context) * 0.78,
                  child: MyText(
                    color: myColorScheme.onSurfaceVariant,
                    maxLines: 5,
                    text:
                        "You do not have an assigned role yet. Please wait for the admin to assign you one. You may exit now, and login later.",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
