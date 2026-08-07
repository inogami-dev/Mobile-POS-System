import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

PieChartSectionData myPieChartSectionData({
  double value = 40,
  Color color = Colors.blue,
  String title = '40%',
  double titlePositionPercentageOffset = 1.5,
  double? cornerRadius,
  double titleFontSize = kDefaultFontSize,
  FontWeight titleFontWeight = FontWeight.w600,
  Widget? badgeWidget,
}) {
  return PieChartSectionData(
    value: value,
    color: color,
    title: title,
    titleStyle: TextStyle(
      fontSize: titleFontSize,
      fontFamily: "Quicksand",
      fontWeight: titleFontWeight,
    ),
    cornerRadius: cornerRadius,
    titlePositionPercentageOffset: titlePositionPercentageOffset,
    badgeWidget: badgeWidget,
  );
}
