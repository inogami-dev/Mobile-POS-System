import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_system/core/utilities/dimension.dart';
import 'package:pos_system/core/widgets/text_formatter.dart';
import 'package:pos_system/features/inventory/presentation/state_management/all_listed_products.dart';
import 'package:pos_system/features/sales/presentation/state_management/sales_controller.dart';
import 'package:pos_system/features/sales/presentation/widgets/pie_chart_section_data.dart';

class MyPieChartTab extends ConsumerStatefulWidget {
  const MyPieChartTab({super.key});

  @override
  ConsumerState<MyPieChartTab> createState() => _MyPieChartState();
}

class _MyPieChartState extends ConsumerState<MyPieChartTab> {
  late double width;
  @override
  Widget build(BuildContext context) {
    width = MyDimensions.getWidth(context);
    final height = MyDimensions.getHeight(context);

    // ✅ 1. Watch the STATE of the provider so it rebuilds when data changes!
    final salesState = ref.watch(salesControllerProvider);
    final inventoryState = ref.watch(allListedProductsProvider);

    // ✅ 2. Use .when() to handle the loading delay perfectly
    return salesState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (salesData) {
        // Inventory's state is necessary here to check if the items were loaded or not yet. As they will be used together with the sales state later in the pie chart.
        if (inventoryState.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // ✅ 3. Now that the data is loaded, safely read your calculated list!
        final salesThisWeek = ref
            .read(salesControllerProvider.notifier)
            .getMostSoldProducts();

        return Container(
          width: width * 0.8,
          height: height * 0.3,
          // color: Colors.purple.shade400,
          child: Column(
            children: [
              MyText(text: salesThisWeek.length.toString(), fontSize: 56),
              Expanded(
                child: PieChart(
                  curve: Curves.easeInOut,
                  PieChartData(
                    centerSpaceRadius: 0,
                    sectionsSpace: 0,
                    titleSunbeamLayout: false,
                    sections: _myPieChartItterator(salesThisWeek),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // A curated palette of soft, distinct colors
  final List<Color> _chartColors = [
    Colors.blue.shade400,
    Colors.red.shade400,
    Colors.green.shade400,
    Colors.yellow.shade400,
    Colors.orange.shade400,
    Colors.purple.shade400,
    Colors.pink.shade400,
    Colors.teal.shade400,
    Colors.indigo.shade400,
    Colors.brown.shade400,
    Colors.grey.shade400,
    // const Color(0xFF5C6BC0), // Soft Indigo
    // const Color(0xFF66BB6A), // Muted Green
    // const Color(0xFFEF5350), // Soft Red
    // const Color(0xFFFFCA28), // Warm Amber
    // const Color(0xFF26C6DA), // Gentle Cyan
    // const Color(0xFFAB47BC), // Muted Purple
    // const Color(0xFF8D6E63), // Soft Brown
    // const Color(0xFF78909C), // Blue Grey
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

  List<PieChartSectionData> _myPieChartItterator(
    List<Map<String, double>> items, {
    int maxNumberOfItemsToDisplay = 3,
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
      if (item.keys.first.length >= 7) {
        tempTitleFormat = "${item.keys.first.substring(0, 6)}...";
      } else {
        tempTitleFormat = item.keys.first;
      }
      double percentage = (totalSum > 0)
          ? (item.values.first / totalSum) * 100
          : 0.0;
      String formattedTitle =
          "${tempTitleFormat}\n${item.values.first.toStringAsFixed(0)} (${percentage.toStringAsFixed(0)}%)";

      pie.add(
        myPieChartSectionData(
          title: formattedTitle,
          value: item.values.first,
          radius: width * 0.20,
          color:
              (i == items.length - 1 &&
                  items.length > maxNumberOfItemsToDisplay)
              ? Colors.grey
              : sliceColor, // Apply the dynamic color here
        ),
      );
    }

    return pie;
  }
}
