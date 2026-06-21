import 'package:flutter/material.dart';
import 'package:pos_system/core/utilities/dimension.dart';

class MyButton extends StatefulWidget {
  final double widthPercentage;
  final double height;
  final Color? color;
  final String buttonText;
  final FontWeight buttonTextFontWeight;
  final double borderRadius;
  final double borderWidth;
  final Color borderColor;
  final Color? buttonTextColor;
  final double buttonTextSpacing;
  final String buttonTextFontFamily;
  final VoidCallback onTap;
  final bool enableShadow;
  final Color? buttonShadowColor;
  final double buttonTextFontSize;
  final double? buttonWidth;
  final bool isUsedAsAbortButton;

  // To be implemented pa ni in the future haha
  // final bool isDecorated;

  const MyButton({
    super.key,
    this.widthPercentage = 0.35,
    this.height = 40,
    this.color,
    required this.buttonText,
    this.buttonTextFontWeight = FontWeight.w400,
    this.borderRadius = 30,
    this.borderWidth = 1.5,
    this.borderColor = const Color.fromARGB(254, 209, 232, 253),
    this.buttonTextColor,
    this.buttonTextSpacing = 2.5,
    this.buttonTextFontFamily = "Poppins",
    required this.onTap,
    this.enableShadow = true,
    this.buttonShadowColor,
    this.buttonTextFontSize = 14,
    this.buttonWidth,
    this.isUsedAsAbortButton = false,
    // this.isDecorated = true,
  });

  @override
  State<MyButton> createState() => _MyCustButtonState();
}

class _MyCustButtonState extends State<MyButton> {
  late ColorScheme myColorScheme;
  late String _buttonText;
  late double? _buttonWidth;
  late double _buttonWidthPercentage;
  late Color? _buttonColor;
  late Color _buttonBorderColor;
  late bool _isShadowEnabled;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    myColorScheme = Theme.of(context).colorScheme;
    _buttonText = widget.buttonText;
    _buttonWidth = widget.buttonWidth;
    _buttonWidthPercentage = widget.widthPercentage;
    _buttonColor = widget.color;
    _buttonBorderColor = widget.borderColor;
    _isShadowEnabled = widget.enableShadow;

    // Presets of a default cancel button
    if (widget.isUsedAsAbortButton) {
      _buttonText = "Cancel";
      _buttonWidth = null;
      _buttonWidthPercentage = 0.35;
      _buttonColor = myColorScheme.surfaceContainer;
      _buttonBorderColor = Colors.transparent;
      _isShadowEnabled = false;
    }

    return Container(
      width: (_buttonWidth != null)
          ? _buttonWidth
          : MyDimensions.getWidth(context) * _buttonWidthPercentage,
      height: widget.height,
      decoration: BoxDecoration(
        // color: widget.color ?? myColorScheme.primary,
        color: _buttonColor ?? myColorScheme.primary,
        border: BoxBorder.all(
          color: _buttonBorderColor,
          width: widget.borderWidth,
        ),
        borderRadius: BorderRadius.circular(widget.borderRadius),
        boxShadow: [boxShadow(Offset(1, 2)), boxShadow(Offset(-1, 2))],
      ),
      // Material will act as the canvas of Inkwell's ripple effect
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          // splashColor: MyColorPalette.splashColor,
          splashColor: myColorScheme.primary,
          onTap: () {
            widget.onTap();
          },
          child: Center(
            child: Text(
              _buttonText,
              style: TextStyle(
                fontWeight: widget.buttonTextFontWeight,
                color: widget.buttonTextColor ?? myColorScheme.onPrimary,
                letterSpacing: widget.buttonTextSpacing,
                fontFamily: widget.buttonTextFontFamily,
                fontSize: widget.buttonTextFontSize,
              ),
            ),
          ),
        ),
      ),
    );
  }

  BoxShadow boxShadow(Offset offset) {
    return BoxShadow(
      // color: const Color.fromARGB(50, 33, 149, 243),
      color: (_isShadowEnabled)
          ? widget.buttonShadowColor?.withAlpha(50) ?? myColorScheme.shadow
          : Colors.transparent,
      offset: offset,
      blurRadius: 2,
      blurStyle: BlurStyle.normal,
    );
  }

  //// (not yet fully tested as of March 29, 2026)
  // BoxShadow myBoxShadow(Offset offset) {
  //   return BoxShadow(
  //     // color: const Color.fromARGB(50, 33, 149, 243),
  //     color: (widget.enableShadow)
  //         ? widget.buttonShadowColor.withAlpha(100)
  //         : Colors.transparent,
  //     offset: offset,
  //     blurRadius: 3,
  //     blurStyle: BlurStyle.outer,
  //   );
  // }
}
