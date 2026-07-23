import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

/// This automatcally process the Image from the database and display it.
class MyImageDisplayer extends StatefulWidget {
  /// Size of the profile image to be displayed.
  /// NOTE: If MyImageDisplayer is placed inside a CircleAvatar, this property will be ignored.
  final double displaySize;

  /// If userID is not  provided, the current logged in user's ID will be used.
  final String? userID;

  /// NOTE: If the base64 is in String format, use
  /// ### MyImageProcessor.decodeStringToUint8List(base64String)
  /// then pass this imageInBase64Format as an argument to base64String parameter.
  final Uint8List? imageInBase64Format;

  /// Returns an Oval shaped picture. Otherwise, the original dimension of the picture
  final bool isOval;

  const MyImageDisplayer({
    super.key,
    this.displaySize = 150,
    this.userID,
    this.imageInBase64Format,
    this.isOval = true,
  });

  @override
  State<MyImageDisplayer> createState() => MyImageDisplayerState();
}

class MyImageDisplayerState extends State<MyImageDisplayer> {
  late ColorScheme myColorScheme;

  @override
  Widget build(BuildContext context) {
    myColorScheme = Theme.of(context).colorScheme;

    if (widget.imageInBase64Format != null) {
      if (widget.isOval) {
        return ClipOval(
          child: Image.memory(
            widget.imageInBase64Format!,
            width: widget.displaySize,
            height: widget.displaySize,
            gaplessPlayback: true,
            fit: BoxFit.cover,
            // Error Builder: Shows an icon if the string is broken
            errorBuilder: (context, error, stackTrace) {
              return errorDisplayDelegate();
            },
          ),
        );
      } else {
        return Image.memory(
          widget.imageInBase64Format!,
          width: widget.displaySize,
          height: widget.displaySize,
          fit: BoxFit.cover,
          // Error Builder: Shows an icon if the string is broken
          errorBuilder: (context, error, stackTrace) {
            return errorDisplayDelegate();
          },
        );
      }
    } else {
      return ClipOval(
        child: SizedBox(
          width: widget.displaySize,
          height: widget.displaySize,
          child: CircularProgressIndicator(),
        ),
      );
    }
  }

  Container errorDisplayDelegate() {
    return Container(
      width: widget.displaySize,
      height: widget.displaySize,
      padding: EdgeInsets.all(widget.displaySize / 7),
      child: HugeIcon(
        icon: HugeIcons.strokeRoundedFolderAttachment,
        // size: widget.displaySize / 1.5,
        color: myColorScheme.surfaceBright,
      ),
    );
  }
}
