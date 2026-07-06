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
      flightShuttleBuilder:
          (
            BuildContext flightContext,
            Animation<double> animation,
            HeroFlightDirection flightDirection,
            BuildContext fromHeroContext,
            BuildContext toHeroContext,
          ) {
            // Cross-fade between the small widget and the big widget during flight
            return AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Opacity(
                      opacity: 1.0 - animation.value,
                      child:
                          fromHeroContext.widget, // What it looked like before
                    ),
                    Opacity(
                      opacity: animation.value,
                      child: toHeroContext.widget, // What it will look like
                    ),
                  ],
                );
              },
            );
          },
      placeholderBuilder: (context, heroSize, child) {
        // Leaves a transparent version behind so the layout doesn't shift
        return Opacity(opacity: 0.2, child: child);
      },
      child: child,
    );
  }
}
