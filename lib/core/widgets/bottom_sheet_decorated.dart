import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pos_system/core/widgets/container.dart';

class MyDecoratedBottomSheet extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final bool enableBlurEffect;
  final double blurSigmaX;
  final double blurSigmaY;

  const MyDecoratedBottomSheet({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.enableBlurEffect = true,
    this.blurSigmaX = 1.0,
    this.blurSigmaY = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final myColorScheme = Theme.of(context).colorScheme;

    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: (enableBlurEffect) ? blurSigmaX : 0,
        sigmaY: (enableBlurEffect) ? blurSigmaY : 0,
      ),
      child: MyContainer(
        width: width,
        height: height,
        color: myColorScheme.surface,
        clipBehavior: Clip.antiAlias,
        child: child,
      ),
    );
  }
}
