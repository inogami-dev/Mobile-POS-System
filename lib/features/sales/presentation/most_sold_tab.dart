import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_system/core/utilities/dimension.dart';
import 'package:pos_system/core/widgets/container.dart';
import 'package:pos_system/core/widgets/text_formatter.dart';
import 'package:pos_system/features/inventory/presentation/state_management/all_listed_products.dart';
import 'package:pos_system/features/sales/domain/enum_sales_view_option.dart';
import 'package:pos_system/features/sales/presentation/state_management/sales_controller.dart';
import 'package:pos_system/features/sales/presentation/widgets/piechart/piechart_helpers.dart';

class MyPieChartTab extends ConsumerStatefulWidget {
  const MyPieChartTab({super.key});

  @override
  ConsumerState<MyPieChartTab> createState() => _MyPieChartState();
}

class _MyPieChartState extends ConsumerState<MyPieChartTab> {
  late double width;
  late ColorScheme myColorScheme;
  @override
  Widget build(BuildContext context) {
    width = MyDimensions.getWidth(context);
    final height = MyDimensions.getHeight(context);
    myColorScheme = Theme.of(context).colorScheme;

    // Watch the STATE of the provider so it rebuilds when data changes!
    final salesState = ref.watch(salesControllerProvider);
    final inventoryState = ref.watch(allListedProductsProvider);

    // Use .when() to handle the loading delay perfectly
    return salesState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (salesData) {
        // Inventory's state is necessary here to check if the items were loaded or not yet. As they will be used together with the sales state later in the pie chart.
        if (inventoryState.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Now that the data is loaded, safely read your calculated list!
        final salesThisWeek = ref
            .read(salesControllerProvider.notifier)
            .getMostSoldProductsThisWeekInMapFormat(
              salesToRetrieve: SalesToRetrieve.ThisWeek,
            );
        // getSalesThisWeek()
        final salesPreviousWeek = ref
            .read(salesControllerProvider.notifier)
            .getMostSoldProductsThisWeekInMapFormat(
              salesToRetrieve: SalesToRetrieve.PreviousWeek,
            );

        return SingleChildScrollView(
          child: Container(
            width: width * 0.8,
            height: height * 0.8,
            // color: Colors.purple.shade400,
            child: (salesThisWeek.isEmpty && salesPreviousWeek.isEmpty)
                ? Center(
                    child: MyText(
                      text: "You have not made any sales yet..",
                      fontSize: kDefaultFontSize + 4,
                    ),
                  )
                : Column(
                    spacing: 8,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SafeArea(child: SizedBox()),
                      SizedBox(height: 16),

                      if (salesThisWeek.isNotEmpty)
                        Expanded(
                          child: PieChart(
                            curve: Curves.easeInOut,
                            PieChartData(
                              centerSpaceRadius: 0,
                              sectionsSpace: 2,
                              titleSunbeamLayout: false,
                              sections: myPieChartItterator(
                                items: salesThisWeek,
                                inventoryItems: inventoryState.value ?? [],
                                width: width,
                                myColorScheme: myColorScheme,
                              ),
                            ),
                          ),
                        ),
                      if (salesThisWeek.isNotEmpty) SizedBox(height: 16),

                      if (salesPreviousWeek.isNotEmpty)
                        MyContainer(
                          width: width * 0.9,
                          height: height * 0.4,
                          borderColor: myColorScheme.outlineVariant,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 32,
                            children: [
                              MyText(text: "Previous Week's sales"),
                              Expanded(
                                child: PieChart(
                                  curve: Curves.easeInOut,
                                  PieChartData(
                                    centerSpaceRadius: 0,
                                    sectionsSpace: 2,
                                    titleSunbeamLayout: false,
                                    sections: myPieChartItterator(
                                      items: salesPreviousWeek,
                                      inventoryItems:
                                          inventoryState.value ?? [],
                                      width: width,
                                      myColorScheme: myColorScheme,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (salesPreviousWeek.isNotEmpty) SizedBox(height: 16),

                      // Other info
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: 8),
                          MyText(
                            text: "The total number of items sold this week:  ",
                            // fontSize: 56,
                          ),
                          MyText(
                            text: salesThisWeek
                                .fold<double>(
                                  0.0,
                                  (sum, item) => sum + item.values.first,
                                )
                                .toStringAsFixed(0),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
