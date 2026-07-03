import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  final String text;
  final double fontSize;
  final int maxLines;
  final TextOverflow textOverFlow;
  final FontWeight fontWeight;
  final String fontFamily;
  final Color? color;
  final double? letterSpacing;
  final double? lineHeight;

  const MyText({
    super.key,
    required this.text,
    this.fontSize = kDefaultFontSize,
    this.maxLines = 1,
    this.textOverFlow = TextOverflow.clip,
    this.fontWeight = FontWeight.w400,
    this.fontFamily = "Quicksand",
    this.color,
    this.letterSpacing,
    this.lineHeight,
  });

  @override
  Widget build(BuildContext context) {
    // final currentColorTheme = ref.watch(myAppThemeStateProvider);
    final myColorScheme = Theme.of(context).colorScheme;

    return Text(
      text,
      softWrap: (maxLines > 1) ? true : false,
      maxLines: maxLines,
      style: TextStyle(
        fontSize: fontSize,
        // wordSpacing: 0.5,
        height: lineHeight,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
        overflow: (maxLines > 1)
            ? TextOverflow.ellipsis
            : textOverFlow, // to be observed pa
        color: color ?? myColorScheme.onSurface,
        letterSpacing: letterSpacing,
      ),
    );
  }
}
