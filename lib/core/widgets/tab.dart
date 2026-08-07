import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pos_system/core/utilities/dimension.dart';
import 'package:pos_system/core/widgets/text_formatter.dart';

class MyTab extends StatelessWidget {
  final double? height;
  final HugeIcon icon;
  final Widget? child;
  final double iconTextSpacing;
  final String text;
  final bool isTextSizeAdaptive;
  final double fontSize;
  final FontWeight fontWeight;

  const MyTab({
    super.key,
    this.height,
    required this.text,
    required this.icon,
    this.iconTextSpacing = 8.0,
    this.child,
    this.isTextSizeAdaptive = false,
    this.fontSize = kDefaultFontSize,
    this.fontWeight = FontWeight.w500,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveHeight = height ?? MyDimensions.getHeight(context) * 0.07;

    return Tab(
      height: effectiveHeight,
      iconMargin: EdgeInsets.symmetric(horizontal: iconTextSpacing),
      icon: icon,
      child: child ?? textSizeDeterminer(),
    );
  }

  Widget textSizeDeterminer() {
    if (isTextSizeAdaptive) {
      return FittedBox(
        child: MyText(text: text, fontWeight: fontWeight),
      );
    } else {
      return MyText(text: text, fontSize: fontSize - 4, fontWeight: fontWeight);
    }
  }
}
