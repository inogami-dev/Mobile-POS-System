import 'package:flutter/material.dart';
import 'package:pos_system/core/utilities/dimension.dart';
import 'package:pos_system/core/widgets/container.dart';
import 'package:pos_system/features/products/presentation/widgets/scanner.dart';

class MyCounterScanner extends StatelessWidget {
  const MyCounterScanner({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MyDimensions.getWidth(context);
    final height = MyDimensions.getHeight(context);
    final myColorScheme = Theme.of(context).colorScheme;

    return MyContainer(
      width: (width * 0.8) + 2,
      height: (height * 0.32) + 2,
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(top: height * 0.05),
      color: myColorScheme.surfaceContainer,
      border: Border.all(color: myColorScheme.outline.withAlpha(156), width: 2),
      child: MyContainer(
        width: width,
        height: height,
        padding: EdgeInsets.all(0),
        border: Border.all(
          color: myColorScheme.outline.withAlpha(56),
          width: 2,
        ),
        // color: myColorScheme.outline,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(9),
          child: MyScanner(
            isUsedToScanMultipleTimes: true,
            millDelayPerScan: 1200,
            snackbarMovingDistance: (height * 0.32) + 40,
            productName: "Counter",
          ),
        ),
      ),
    );
  }
}
