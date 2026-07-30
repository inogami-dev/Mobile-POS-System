import 'package:flutter/material.dart';
import 'package:pos_system/core/utilities/dimension.dart';

class MyTooltip extends StatelessWidget {
  final String message;
  final Widget child;
  final double heightConstraints;
  final double widthPercentage;
  final int duration;
  final TooltipTriggerMode triggerMode;
  final int opacity;

  ///##### A custom tooltip widget with predefined styling. This widget helps the user know what a component does by showing [message] information/help about a certain component/widget.
  const MyTooltip({
    super.key,
    required this.child,
    required this.message,
    this.duration = 2500,
    this.widthPercentage = 0.56,
    this.heightConstraints = 50,
    this.triggerMode = TooltipTriggerMode.longPress,
    this.opacity = 200,
  });

  @override
  Widget build(BuildContext context) {
    final myColorScheme = Theme.of(context).colorScheme;

    return Tooltip(
      triggerMode: triggerMode,
      message: message,
      showDuration: Duration(milliseconds: duration),
      textStyle: TextStyle(
        color: myColorScheme.onSurface,
        fontWeight: FontWeight.w500,
        fontFamily: "Quicksand",
      ),
      constraints: BoxConstraints.expand(
        height: heightConstraints,
        width: MyDimensions.getWidth(context) * widthPercentage,
      ),
      decoration: BoxDecoration(
        color: myColorScheme.surfaceBright.withAlpha(
          (opacity > 255)
              ? 255
              : (opacity < 0)
              ? 0
              : opacity,
        ),
        // color: myColorScheme.surfaceContainerHigh.withAlpha(opacity),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: myColorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: myColorScheme.shadow.withAlpha(56),
            blurRadius: 4,
            spreadRadius: 3,
            offset: Offset.zero,
            blurStyle: BlurStyle.outer,
          ),
        ],
      ),
      child: child,
    );
  }
}
