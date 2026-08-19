import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pos_system/core/widgets/text_formatter.dart';
import 'package:pos_system/core/widgets/tooltip.dart';

class InventoryDeductionListTitle extends StatelessWidget {
  final ColorScheme myColorScheme;
  final String curretlyInViewChart;
  const InventoryDeductionListTitle({
    super.key,
    required this.myColorScheme,
    required this.curretlyInViewChart,
  });

  @override
  Widget build(BuildContext context) {
    return // List of all items based on the inventory an sold items label
    MyTooltip(
      message:
          "The RED colored number indicates the sold quantity from the inventory.",
      widthPercentage: 0.65,
      triggerMode: TooltipTriggerMode.tap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyText(text: "Inventory deduction ${curretlyInViewChart}"),
          SizedBox(width: 16),
          HugeIcon(
            icon: HugeIcons.strokeRoundedInformationCircle,
            color: myColorScheme.outlineVariant,
            size: kDefaultFontSize + 6,
          ),
        ],
      ),
    );
  }
}
