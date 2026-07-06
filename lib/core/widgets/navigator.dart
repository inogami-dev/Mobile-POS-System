import 'package:flutter/material.dart';

class MyNavigator {
  /// Navigates to the [nextPage] with a custom animation.
  static void goTo(
    BuildContext context,
    Widget nextPage, {
    int animationType = 0,
  }) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => nextPage,

        // Slightly longer duration for a smoother, premium feel
        transitionDuration: const Duration(milliseconds: 600),
        reverseTransitionDuration: const Duration(milliseconds: 600),

        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Apply a universal smooth curve (easeOutCubic) to the animation
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve:
                Curves.easeInCubic, // Speeds up slightly when popping back
          );

          switch (animationType) {
            // ----------------------------------------------------------------
            // OPTION 1: SLIDE FROM BOTTOM (Good for Modal/Details pages)
            // ----------------------------------------------------------------
            case 1:
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 1.0),
                  end: Offset.zero,
                ).animate(curvedAnimation),
                child: child,
              );

            // ----------------------------------------------------------------
            // OPTION 2: FADE TRANSITION (Simple & Elegant)
            // ----------------------------------------------------------------
            case 2:
              return FadeTransition(opacity: curvedAnimation, child: child);

            // ----------------------------------------------------------------
            // OPTION 3: SCALE TRANSITION (Zooms in from center)
            // ----------------------------------------------------------------
            case 3:
              return ScaleTransition(
                scale: Tween<double>(
                  begin: 0.0,
                  end: 1.0,
                ).animate(curvedAnimation),
                child: child,
              );

            // ----------------------------------------------------------------
            // OPTION 4: ROTATION + SCALE (Playful/Crazy)
            // ----------------------------------------------------------------
            case 4:
              return RotationTransition(
                turns: Tween<double>(
                  begin: 0.5,
                  end: 1.0,
                ).animate(curvedAnimation),
                child: ScaleTransition(
                  scale: Tween<double>(
                    begin: 0.0,
                    end: 1.0,
                  ).animate(curvedAnimation),
                  child: child,
                ),
              );

            // ----------------------------------------------------------------
            // DEFAULT (0): SLIDE FROM RIGHT (Standard iOS/Android feel)
            // ----------------------------------------------------------------
            default:
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(curvedAnimation),
                child: child,
              );
          }
        },
      ),
    );
  }
}
