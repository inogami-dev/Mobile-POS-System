import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_system/core/utilities/dimension.dart';
import 'package:pos_system/core/widgets/container.dart';
import 'package:pos_system/core/widgets/text_formatter.dart';
import 'package:pos_system/features/inventory/presentation/state_management/all_listed_products.dart';
import 'package:pos_system/features/products/data/model/product_model.dart';
import 'package:pos_system/features/sales/domain/enum_sales_view_option.dart';
import 'package:pos_system/features/sales/presentation/state_management/sales_controller.dart';
import 'package:pos_system/features/sales/presentation/widgets/piechart/piechart_helpers.dart';

class MyPieChartTab extends ConsumerStatefulWidget {
  const MyPieChartTab({super.key});

  @override
  ConsumerState<MyPieChartTab> createState() => _MyPieChartState();
}

class _MyPieChartState extends ConsumerState<MyPieChartTab> {
  //
  double totalNumberOfItemsSoldThisWeek = 0;
  String curretlyInViewChart = "This Week";

  // Layout Fields
  late double width;
  late ColorScheme myColorScheme;
  FixedExtentScrollController listWheelScrollController =
      FixedExtentScrollController(initialItem: 2);

  @override
  void dispose() {
    listWheelScrollController.dispose();
    super.dispose();
  }

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
        // To initialize totalNumberOfItemsSoldThisWeek
        if (salesThisWeek.isNotEmpty && totalNumberOfItemsSoldThisWeek == 0) {
          totalNumberOfItemsSoldThisWeek = salesThisWeek.fold<double>(
            0.0,
            (sum, item) => sum + item.values.first,
          );
        }

        final salesPreviousWeek = ref
            .read(salesControllerProvider.notifier)
            .getMostSoldProductsThisWeekInMapFormat(
              salesToRetrieve: SalesToRetrieve.PreviousWeek,
            );

        final salesPreviousPreviousWeek = ref
            .read(salesControllerProvider.notifier)
            .getMostSoldProductsThisWeekInMapFormat(
              salesToRetrieve: SalesToRetrieve.PreviousPreviousWeek,
            );

        return SingleChildScrollView(
          child: Container(
            width: width * 0.8,
            height: height * 1.5,
            // color: Colors.purple.shade400,
            child:
                (salesThisWeek.isEmpty &&
                    salesPreviousWeek.isEmpty &&
                    salesPreviousPreviousWeek.isEmpty)
                ? Center(
                    child: MyText(
                      text: "You have not made any sales yet..",
                      fontSize: kDefaultFontSize + 4,
                    ),
                  )
                : Column(
                    spacing: 4,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Other info
                      SizedBox(height: 4),
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
                            text: totalNumberOfItemsSoldThisWeek
                                .toStringAsFixed(0),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ],
                      ),

                      Container(
                        width: width,
                        height: height * 0.46,
                        // color: Colors.amber,
                        margin: EdgeInsets.only(top: 8),
                        child: RotatedBox(
                          quarterTurns: -1,
                          child: ListWheelScrollView(
                            onSelectedItemChanged: (value) {
                              if (value == 0) {
                                setState(() {
                                  curretlyInViewChart =
                                      "Previous Previous Week's sales";
                                  totalNumberOfItemsSoldThisWeek =
                                      salesPreviousPreviousWeek.fold<double>(
                                        0.0,
                                        (sum, item) => sum + item.values.first,
                                      );
                                });
                              } else if (value == 1) {
                                setState(() {
                                  curretlyInViewChart = "Previous Week's sales";
                                  totalNumberOfItemsSoldThisWeek =
                                      salesPreviousWeek.fold<double>(
                                        0.0,
                                        (sum, item) => sum + item.values.first,
                                      );
                                });
                              } else if (value == 2) {
                                setState(() {
                                  curretlyInViewChart = "This Week's sales";
                                  totalNumberOfItemsSoldThisWeek = salesThisWeek
                                      .fold<double>(
                                        0.0,
                                        (sum, item) => sum + item.values.first,
                                      );
                                });
                              }
                            },
                            controller: listWheelScrollController,
                            itemExtent: (height * 0.4) + 16,
                            diameterRatio: 2.5,
                            physics: const FixedExtentScrollPhysics(),
                            squeeze: 1.056,
                            children: [
                              if (salesPreviousPreviousWeek.isNotEmpty)
                                _rotatedBox(
                                  height: height,
                                  title: "Previous Previous Week's sales",
                                  salesThisWeek: salesPreviousPreviousWeek,
                                  inventoryState: inventoryState,
                                ),
                              if (salesPreviousWeek.isNotEmpty)
                                _rotatedBox(
                                  height: height,
                                  title: "Previous Week's sales",
                                  salesThisWeek: salesPreviousWeek,
                                  inventoryState: inventoryState,
                                ),
                              if (salesThisWeek.isNotEmpty)
                                _rotatedBox(
                                  height: height,
                                  title: "This Week's sales",
                                  salesThisWeek: salesThisWeek,
                                  inventoryState: inventoryState,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  RotatedBox _rotatedBox({
    required double height,
    required String title,
    required List<Map<String, double>> salesThisWeek,
    required AsyncValue<List<ProductModel>> inventoryState,
  }) {
    return RotatedBox(
      quarterTurns: 1,
      child: MyContainer(
        width: width * 0.9,
        height: height * 0.4,
        margin: EdgeInsets.only(bottom: 16),
        borderColor: myColorScheme.outlineVariant,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 24,
          children: [
            MyText(text: title),
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
          ],
        ),
      ),
    );
  }
}
