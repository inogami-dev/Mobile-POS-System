import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pos_system/core/utilities/dimension.dart';
import 'package:pos_system/core/widgets/container.dart';
import 'package:pos_system/core/widgets/text_formatter.dart';

class MyEmptyUI extends StatelessWidget {
  final Widget child;
  final HugeIcon icon;
  final bool enableDefaultUI;
  const MyEmptyUI({
    super.key,
    required this.icon,
    required this.child,
    this.enableDefaultUI = true,
  });

  @override
  Widget build(BuildContext context) {
    return MyContainer(
      width: MyDimensions.getWidth(context),
      height: MyDimensions.getHeight(context),
      child: (enableDefaultUI)
          ? MyEmptyUI(
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedConfused,
                size: 128,
                color: Colors.grey,
              ),
              child: Column(
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
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 16,
              children: [icon, child],
            ),
    );
  }
}
