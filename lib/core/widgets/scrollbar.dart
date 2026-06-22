import 'package:flutter/material.dart';

class MyScrollBar extends StatelessWidget {
  final Widget child;
  final ScrollController controller;
  final bool isThumbVisible;
  final bool isTrackVisible;
  final Color? trackColor;
  final double trackRadius;
  final Color? trackBorderColor;
  final Color? thumbColor;
  final double thickness;
  final double radius;
  final EdgeInsets padding;

  const MyScrollBar({
    super.key,
    required this.child,
    required this.controller,
    this.isThumbVisible = true,
    this.isTrackVisible = true,
    this.trackColor,
    this.trackRadius = 50,
    this.trackBorderColor,
    this.thumbColor,
    this.thickness = 5,
    this.radius = 50,
    this.padding = const EdgeInsets.all(5),
  });

  @override
  Widget build(BuildContext context) {
    final myColorScheme = Theme.of(context).colorScheme;

    return RawScrollbar(
      controller: controller,
      thumbVisibility: isThumbVisible,
      trackVisibility: isTrackVisible,
      trackColor: trackColor ?? myColorScheme.onSurface.withAlpha(100),
      trackRadius: Radius.circular(trackRadius),
      trackBorderColor: trackBorderColor ?? Colors.transparent,
      thickness: thickness,
      radius: Radius.circular(radius),
      padding: padding,
      thumbColor: thumbColor ?? myColorScheme.onPrimaryContainer.withAlpha(200),
      child: child,
    );
  }
}
