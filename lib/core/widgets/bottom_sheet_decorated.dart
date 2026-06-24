import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pos_system/core/widgets/container.dart';

class MyDecoratedBottomSheet extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;

  const MyDecoratedBottomSheet({
    super.key,
    required this.child,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final myColorScheme = Theme.of(context).colorScheme;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
      child: MyContainer(
        width: width,
        height: height,
        color: myColorScheme.surface.withAlpha(180),
        clipBehavior: Clip.antiAlias,
        child: child,
      ),
    );
  }
}
