import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

PieChartSectionData myPieChartSectionData({
  double? value,
  Color? color,
  String? title,
  double titlePositionPercentageOffset = 1.5,
  double? cornerRadius,
  double titleFontSize = kDefaultFontSize,
  FontWeight titleFontWeight = FontWeight.w600,
  Widget? badgeWidget,
}) {
  return PieChartSectionData(
    title: title,
    value: value,
    color: color,
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
