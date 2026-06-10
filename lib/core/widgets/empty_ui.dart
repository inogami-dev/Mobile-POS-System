import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pos_system/core/utilities/dimension.dart';
import 'package:pos_system/core/widgets/container.dart';
import 'package:pos_system/core/widgets/text_formatter.dart';

class MyEmptyUI extends StatelessWidget {
  final Widget? child;
  final HugeIcon? icon;
  final bool enableDefaultUI;
  final bool isWholeScreen;
  final double heightPercentage;
  final double widthPercentage;
  const MyEmptyUI({
    super.key,
    this.icon,
    this.child,
    this.enableDefaultUI = true,
    this.isWholeScreen = false,
    this.heightPercentage = 0.4,
    this.widthPercentage = 0.8,
  });

  @override
  Widget build(BuildContext context) {
    if (!enableDefaultUI && child == null && icon == null) {
      throw ErrorDescription(
        "If enableDefaultUI is false, child and icon cannot be null",
      );
    }

    return MyContainer(
      width:
          MyDimensions.getWidth(context) *
          ((isWholeScreen) ? 1 : widthPercentage),
      height:
          MyDimensions.getHeight(context) *
          ((isWholeScreen) ? 1 : heightPercentage),
      child: (enableDefaultUI)
          ? Column(
              children: [
                HugeIcon(
                  icon: HugeIcons.strokeRoundedConfused,
                  size: 128,
                  color: Colors.grey,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 16,
                  children: [
                    MyText(
                      text: "Oops!",
                      fontSize: kDefaultFontSize + 16,
                      maxLines: 8,
                      fontWeight: FontWeight.w700,
                    ),
                    MyText(
                      text: "Something went wrong!\nPlease try again.",
                      fontSize: kDefaultFontSize + 8,
                      maxLines: 8,
                    ),
                  ],
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 16,
              children: [icon!, child!],
            ),
    );
  }
}
