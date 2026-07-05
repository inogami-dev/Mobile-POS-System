// import 'package:flutter/material.dart';
// import 'package:pos_system/core/constants/app_layout.dart';

// AnimatedOpacity bottomInventoryPageOptionsBar({
//   required bool isInventoryPageVisible,
//   required double width,
//   required double inventoryPageOptionsBarHeight,
//   required ColorScheme myColorScheme,
//   required BuildContext context,
//   required List<Widget> children,
// }) {
//   return AnimatedOpacity(
//     duration: Duration(milliseconds: 650),
//     opacity: isInventoryPageVisible ? 1 : 0,
//     child: AnimatedContainer(
//       duration: Duration(milliseconds: 650),
//       curve: Curves.easeIn,
//       width: width,
//       height: inventoryPageOptionsBarHeight,
//       color: myColorScheme.surfaceContainerHighest,
//       clipBehavior: Clip.hardEdge,
//       padding: EdgeInsets.symmetric(horizontal: 16),
//       // color: Colors.amber,
//       child: Padding(
//         padding: const EdgeInsets.fromLTRB(
//           8,
//           8,
//           8,
//           MyAppLayout.bottomNavbarHeight + 8,
//         ),
//         child: Flex(direction: Axis.horizontal, children: children),
//       ),
//     ),
//   );
// }

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
        curve: Curves.easeIn,
        width: width,
        height: inventoryPageOptionsBarHeight,
        color: myColorScheme.surfaceContainerHighest,
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
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: mainAxisAlignment,
            children: children,
          ),
        ),
      ),
    );
  }
}
