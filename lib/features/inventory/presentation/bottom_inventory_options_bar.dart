import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pos_system/core/constants/app_layout.dart';

class MyBottomInventoryPageOptionsBar extends StatelessWidget {
  final bool isInventoryPageVisible;
  final double inventoryPageOptionsBarHeight;
  final List<Widget> children;
  final int durationInMillis;
  final MainAxisAlignment mainAxisAlignment;

  const MyBottomInventoryPageOptionsBar({
    super.key,
    required this.isInventoryPageVisible,
    required this.inventoryPageOptionsBarHeight,
    required this.children,
    this.durationInMillis = 650,
    this.mainAxisAlignment = MainAxisAlignment.spaceEvenly,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final myColorScheme = Theme.of(context).colorScheme;

    return AnimatedOpacity(
      duration: Duration(milliseconds: durationInMillis),
      opacity: isInventoryPageVisible ? 1 : 0,
      child: AnimatedContainer(
        duration: Duration(milliseconds: durationInMillis),
        curve: Curves.easeInOutCubic,
        width: width,
        height: inventoryPageOptionsBarHeight,
        decoration: BoxDecoration(
          color: myColorScheme.surfaceContainerHighest,
          border: Border(
            top: BorderSide(width: 0.4, color: myColorScheme.onSurface),
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        clipBehavior: Clip.hardEdge,
        padding: EdgeInsets.symmetric(horizontal: 8),
        // color: Colors.amber,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            8,
            8,
            8,
            MyAppLayout.bottomNavbarHeight + 8,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    width: width,
                    height: inventoryPageOptionsBarHeight,
                    // color: Colors.amber,
                  ),
                ),
              ),
              Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: mainAxisAlignment,
                children: children,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
