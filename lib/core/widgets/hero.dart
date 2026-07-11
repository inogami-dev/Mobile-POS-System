import 'package:flutter/material.dart';

class MyHero extends StatelessWidget {
  final Widget child;
  final String tag;
  const MyHero({super.key, required this.child, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      transitionOnUserGestures:
          true, // This creates a beautiful sweeping arc instead of a rigid straight line
      createRectTween: (Rect? begin, Rect? end) {
        return MaterialRectCenterArcTween(begin: begin, end: end);
      },
      child: Material(child: child),
    );
  }
}
