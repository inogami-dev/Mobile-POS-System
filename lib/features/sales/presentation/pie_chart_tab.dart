import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pos_system/core/utilities/dimension.dart';
import 'package:pos_system/features/sales/presentation/widgets/pie_chart_section_data.dart';

class MyPieChartTab extends StatefulWidget {
  const MyPieChartTab({super.key});

  @override
  State<MyPieChartTab> createState() => _MyPieChartState();
}

class _MyPieChartState extends State<MyPieChartTab> {
  @override
  Widget build(BuildContext context) {
    final width = MyDimensions.getWidth(context);
    final height = MyDimensions.getHeight(context);
    // final myColorScheme = Theme.of(context).colorScheme;

    return Container(
      width: width * 0.8,
      // height: height * 0.3,
      color: Colors.purple.shade400,
      child: PieChart(
        curve: Curves.easeInOut,
        PieChartData(
          // centerSpaceRadius: width * 0.1,
          centerSpaceRadius: 0,
          sectionsSpace: 0,
          // pieTouchData: PieTouchData(
          //   touchCallback: (FlTouchEvent event, pieTouchResponse) {
          //     if (event.isInterestedForInteractions &&
          //         pieTouchResponse != null) {
          //       showMyAnimatedSnackBar(
          //         context: context,
          //         dataToDisplay: pieTouchResponse
          //             .touchedSection!
          //             .touchedSectionIndex
          //             .toString(),
          //       );
          //     }
          //   },
          // ),
          titleSunbeamLayout: false,
          // borderData: FlBorderData(
          //   show: true,
          //   border: Border.all(color: Colors.black, width: 8),
          // ),
          sections: [
            myPieChartSectionData(value: 40, color: Colors.blue, title: '40%'),
            myPieChartSectionData(value: 30, color: Colors.red, title: '30%'),
            myPieChartSectionData(value: 20, color: Colors.green, title: '20%'),
            myPieChartSectionData(
              value: 10,
              color: Colors.purple,
              title: '10%',
            ),
          ],
        ),
      ),
    );
  }
}
