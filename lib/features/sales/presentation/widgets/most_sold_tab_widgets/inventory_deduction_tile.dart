import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pos_system/core/utilities/date_formatter.dart';
import 'package:pos_system/core/widgets/text_formatter.dart';
import 'package:pos_system/features/products/data/model/product_model.dart';

class InventoryDeductionTile extends StatelessWidget {
  final ProductModel? product;
  final List<Map<String, double>> weeklySales;
  final int callendarWeekBackwards;
  final double width;

  const InventoryDeductionTile({
    super.key,
    required this.product,
    required this.weeklySales,
    required this.callendarWeekBackwards,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final myColorScheme = Theme.of(context).colorScheme;

    if (product == null) return SizedBox();

    double soldAmount = 0.0;

    // Safely search the sales list for this specific product's name
    for (var saleMap in weeklySales) {
      if (saleMap.containsKey(product!.name)) {
        soldAmount = saleMap[product!.name] ?? 0.0;
        break; // We found the product, no need to keep looping
      }
    }

    // Check if the product even existed during this past week
    int dateTheProductWasRegistered = MyDateFormatter.getCalendarWeekBackwards(
      DateTime.parse(product!.registeredOn),
    );

    bool doesNotExistYetInThisSpecificWeek =
        dateTheProductWasRegistered < callendarWeekBackwards;

    // Adaptive UI Logic variables
    String leftText = "";
    String rightText = "";
    Color? leftColor;
    Color? rightColor = Colors.red.shade100;

    // Product didn't exist yet
    if (doesNotExistYetInThisSpecificWeek) {
      leftText = "";
      rightText = "";
    }
    // THIS WEEK: Show the "Before - Sold" format (e.g., "15 - 5")
    else if (callendarWeekBackwards == 1) {
      double currentQty = product!.quantity.toDouble();
      double beforeSoldQty = currentQty + soldAmount;

      leftText = (soldAmount != 0 || currentQty != 0)
          ? beforeSoldQty.toStringAsFixed(0)
          : "";
      leftColor = (soldAmount != 0) ? myColorScheme.outline : null;
      rightText = (soldAmount != 0)
          ? " - ${soldAmount.toStringAsFixed(0)}"
          : "";
    }
    // PAST WEEKS: Show the exact volume sold without faking the "Before" math (e.g., "Sold: 5")
    else {
      leftText = (soldAmount > 0) ? "Sold: " : "";
      leftColor = myColorScheme.outline;
      rightText = (soldAmount > 0) ? soldAmount.toStringAsFixed(0) : "";
      rightColor = (soldAmount > 0) ? Colors.red.shade100 : null;
    }

    return ListTile(
      title: MyText(
        text: product!.name,
        color: (doesNotExistYetInThisSpecificWeek)
            ? myColorScheme.outlineVariant
            : null,
      ),
      trailing: Container(
        width: width * 0.25,
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            MyText(text: leftText, color: leftColor),
            MyText(text: rightText, color: rightColor),
          ],
        ),
      ),
    );
  }
}
