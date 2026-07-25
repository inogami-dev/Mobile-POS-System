import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pos_system/core/widgets/progress_indicator_static.dart';
import 'package:pos_system/core/widgets/text_formatter.dart';

/// [onPressed] is a callback function (){}
/// A Dialog that is primary used for decision making (Yes/No)
/// But can be used for other things too, just pass an appropriate widget into [contentWidget]
void myAlertDialogue({
  required BuildContext context,
  String alertTitle = "Alert",
  String alertContent = "",
  Color barrierColor = const Color.fromARGB(180, 60, 84, 104),
  bool isDismissible = true,
  required VoidCallback onApprovalPressed,
  String onApprovalButtonText = "Yes",
  Widget? contentWidget,
  // Color onApprovalButtonColor = MyColorPalette.splashColor,
  Color onApprovalButtonColor = const Color.fromARGB(255, 26, 139, 232),
  Color onApprovalButtonTextColor = Colors.white,
  String onCancelButtonText = "No",
  bool isLoading = false,
}) {
  showCupertinoDialog(
    barrierColor: barrierColor,
    context: context,
    barrierDismissible: isDismissible,
    builder: (context) {
      return CupertinoAlertDialog(
        title: Text(alertTitle, style: TextStyle(fontFamily: "Quicksand")),
        content: Column(
          children: [
            Text(alertContent, style: TextStyle(fontFamily: "Quicksand")),
            if (contentWidget != null) contentWidget,
          ],
        ),

        actions: [
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: MyText(
              text: onCancelButtonText,
              // color: Colors.grey.shade800,
            ),
          ),
          (!isLoading)
              ? CupertinoDialogAction(
                  onPressed: onApprovalPressed,
                  child: MyText(
                    text: onApprovalButtonText,
                    color: onApprovalButtonColor,
                    fontWeight: FontWeight.w600,
                    fontSize: kDefaultFontSize + 2.5,
                  ),
                )
              : Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: MyProgressIndicator(),
                  ),
                ),
        ],
      );
    },
  );
}
