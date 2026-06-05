import 'package:flutter/material.dart';

class MyContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  final double? borderRadius;
  final BorderRadius? customBorderRadius;
  final Border? border;
  final Color? borderColor;
  final bool enableShadow;
  final BlurStyle shadowBlurStyle;
  final double blurRadius;
  final Alignment alignment;
  final Clip clipBehavior;
  final Widget? child;

  const MyContainer({
    super.key,
    this.width,
    this.height,
    this.color,
    this.borderRadius,
    this.customBorderRadius,
    this.border,
    this.borderColor,
    this.enableShadow = true,
    this.shadowBlurStyle = BlurStyle.outer,
    this.blurRadius = 4,
    this.alignment = Alignment.center,
    this.clipBehavior = Clip.none,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final myColorScheme = Theme.of(context).colorScheme;

    return Container(
      width: width,
      height: height,
      alignment: alignment,
      clipBehavior: clipBehavior,
      decoration: BoxDecoration(
        color: color ?? myColorScheme.surfaceContainer,
        borderRadius:
            customBorderRadius ?? BorderRadius.circular(borderRadius ?? 10),
        border:
            border ??
            Border.all(color: borderColor ?? myColorScheme.inversePrimary),
        boxShadow: (enableShadow)
            ? [
                BoxShadow(
                  blurStyle: shadowBlurStyle,
                  color: myColorScheme.surfaceContainerHigh,
                  blurRadius: blurRadius,
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
}
