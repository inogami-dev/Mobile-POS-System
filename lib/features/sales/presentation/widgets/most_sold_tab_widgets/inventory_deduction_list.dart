import 'package:flutter/material.dart';
import 'package:pos_system/core/widgets/container.dart';
import 'package:pos_system/core/widgets/scrollbar.dart';
import 'package:pos_system/features/products/data/model/product_model.dart';
import 'package:pos_system/features/sales/presentation/widgets/most_sold_tab_widgets/inventory_deduction_tile.dart';

class InventoryDeductionList extends StatelessWidget {
  final double width;
  final double height;
  final ColorScheme myColorScheme;
  final Color? thumbColor;
  final Color? trackColor;
  final ScrollController listOfProductsScrollController;
  final List<ProductModel?> inventory;
  final List<Map<String, double>> salesBaseOnCurrentlyInViewWeek;
  final int callendarWeekBackwards;

  const InventoryDeductionList({
    super.key,
    required this.width,
    required this.height,
    required this.listOfProductsScrollController,
    required this.myColorScheme,
    required this.thumbColor,
    required this.trackColor,
    required this.inventory,
    required this.salesBaseOnCurrentlyInViewWeek,
    required this.callendarWeekBackwards,
  });

  @override
  Widget build(BuildContext context) {
    return MyContainer(
      width: width * 0.9,
      height: height * 0.4,
      borderColor: myColorScheme.outlineVariant,
      child: MyScrollBar(
        controller: listOfProductsScrollController,
        thumbColor: thumbColor,
        trackColor: trackColor,
        isThumbVisible: null,
        isTrackVisible: null,
        padding: EdgeInsets.only(right: -8),
        child: ListView.builder(
          controller: listOfProductsScrollController,
          itemExtent: 32,
          // itemCount: inventoryState.value?.length ?? 0,
          itemCount: inventory.length,
          itemBuilder: (context, index) {
            final product = inventory[index];

            return InventoryDeductionTile(
              product: product,
              weeklySales: salesBaseOnCurrentlyInViewWeek,
              callendarWeekBackwards: callendarWeekBackwards,
              width: width,
            );
          },
        ),
      ),
    );
  }
}
