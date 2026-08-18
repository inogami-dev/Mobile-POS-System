import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pos_system/core/widgets/text_formatter.dart';
import 'package:pos_system/features/products/data/model/product_model.dart';
import 'package:pos_system/features/sales/domain/constant/piechart_constants.dart';
import 'package:pos_system/features/sales/presentation/widgets/piechart/pie_chart_section_data.dart';

// A curated palette of soft, distinct colors
// final List<Color> _chartColors = [
//   const Color.fromARGB(255, 51, 121, 179),
//   const Color.fromARGB(255, 183, 81, 81),
//   const Color(0xFF66BB6A),
//   Colors.yellow.shade400,
//   Colors.orange.shade400,
//   Colors.purple.shade400,
//   Colors.pink.shade400,
//   Colors.teal.shade400,
//   Colors.indigo.shade400,
//   Colors.brown.shade400,
//   // const Color(0xFF5C6BC0), // Soft Indigo
//   // const Color(0xFF66BB6A), // Muted Green
//   // const Color(0xFFEF5350), // Soft Red
//   // const Color(0xFFFFCA28), // Warm Amber
//   // const Color(0xFF26C6DA), // Gentle Cyan
//   // const Color(0xFFAB47BC), // Muted Purple
//   // const Color(0xFF8D6E63), // Soft Brown
//   // const Color(0xFF78909C), // Blue Grey
// ];

/// Used in myPieChartItterator
final List<Color> _chartColors = [
  const Color(0xFF64B5F6), // Soft Blue
  const Color(0xFFE57373), // Soft Red
  const Color(0xFF81C784), // Soft Green
  const Color(0xFFFFD54F), // Soft Yellow (Amber-toned for better contrast)
  const Color(0xFFFFB74D), // Soft Orange
  const Color(0xFFBA68C8), // Soft Purple
  const Color(0xFFF06292), // Soft Pink
  const Color(0xFF4DB6AC), // Soft Teal
  const Color(0xFF7986CB), // Soft Indigo
  const Color(0xFFA1887F), // Soft Brown
];

// List<PieChartSectionData> _myPieChartItterator(
//   List<Map<String, double>> items,
// ) {
//   List<PieChartSectionData> pie = [];
//   for (var item in items) {
//     pie.add(
//       myPieChartSectionData(
//         title: item.keys.first,
//         value: item.values.first,
//         color: Colors.green,
//       ),
//     );
//   }

//   return pie;
// }

List<PieChartSectionData> myPieChartItterator({
  required List<Map<String, double>> items,
  required List<ProductModel> inventoryItems,
  required double width,
  required ColorScheme myColorScheme,
}) {
  List<PieChartSectionData> pie = [];
  double totalSum = items.fold(0.0, (sum, item) => sum + item.values.first);

  // Change to a standard for-loop so we can track the index (i)
  for (int i = 0; i < items.length; i++) {
    var item = items[i];

    // The Magic Math: Use modulo (%) to safely cycle through the palette.
    // If you have 15 items but only 8 colors, it seamlessly loops back to the start!
    Color sliceColor = _chartColors[i % _chartColors.length];

    String tempTitleFormat = "";
    if (item.keys.first.length >= MyPiechartConstants.maxNameCharInPie) {
      tempTitleFormat =
          "${item.keys.first.substring(0, MyPiechartConstants.maxNameCharInPie)}...";
    } else {
      tempTitleFormat = item.keys.first;
    }
    double percentage = (totalSum > 0)
        ? (item.values.first / totalSum) * 100
        : 0.0;

    double price = 0;
    double totalAmount = 0;
    for (var product in inventoryItems) {
      if (product.name == item.keys.first) {
        price = product.price;
        totalAmount = product.price * item.values.first;
        break;
      }
    }

    String formattedTitle =
        "${tempTitleFormat}\n(${price}x${item.values.first.toStringAsFixed(0)})\n${totalAmount}";

    if (tempTitleFormat == "Others") {
      formattedTitle = "Others\n${item.values.first.toStringAsFixed(0)}";
    }

    pie.add(
      myPieChartSectionData(
        title: formattedTitle,
        value: item.values.first,
        radius: width * 0.20,
        cornerRadius: 8,
        titleFontColor: (tempTitleFormat == "Others")
            ? myColorScheme.outline
            : null,
        color:
            (i == items.length - 1 &&
                items.length > MyPiechartConstants.maxNumberOfItemInPie)
            ? Colors.grey
            : sliceColor, // Apply the dynamic color here
        badgeWidget: MyText(
          text: "${percentage.toStringAsFixed(0)}%",
          fontWeight: FontWeight.bold,
          color: myColorScheme.surface,
        ),
      ),
    );
  }

  return pie;
}
