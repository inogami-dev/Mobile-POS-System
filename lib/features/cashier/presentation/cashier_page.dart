import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_system/core/utilities/dimension.dart';
import 'package:pos_system/core/widgets/text_formatter.dart';
import 'package:pos_system/features/cashier/data/model/scanned_item.dart';
import 'package:pos_system/features/cashier/presentation/state_management/to_counter_items.dart';
import 'package:pos_system/features/cashier/presentation/widgets/counter_scanner.dart';
import 'package:pos_system/features/inventory/presentation/state_management/all_listed_products.dart';
import 'package:pos_system/features/products/data/model/product_model.dart';

class CashierPage extends ConsumerStatefulWidget {
  const CashierPage({super.key});

  @override
  ConsumerState<CashierPage> createState() => _CashierPageState();
}

class _CashierPageState extends ConsumerState<CashierPage> {
  late double width;
  late double height;

  @override
  Widget build(BuildContext context) {
    width = MyDimensions.getWidth(context);
    height = MyDimensions.getHeight(context);
    List<String> scannedItems = ref.watch(toCounterItemsProvider);
    List<ProductModel>? inventoryItems = ref
        .watch(allListedProductsProvider)
        .value;

    List<ScannedItem> counterListedItems = [];
    inventoryItems?.map((product) {
      if (scannedItems.any((barcode) {
        return barcode == product.barCode;
      })) {
        if (counterListedItems.contains(product.barCode)) {
          // counterListedItems.add(product.copyWith());
        } else {
          counterListedItems.add(
            ScannedItem(
              id: product.barCode,
              name: product.name,
              quantity: product.quantity.toDouble(),
              price: product.price.toDouble(),
            ),
          );
        }
      }
    }).toList();

    return Scaffold(
      body: Container(
        width: width,
        height: height,
        child: Column(
          children: [
            SafeArea(
              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(8),
                child: MyCounterScanner(),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: scannedItems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: MyText(
                      text: counterListedItems[index].name,
                      fontSize: kDefaultFontSize + 2,
                      fontWeight: FontWeight.w600,
                    ),
                    trailing: MyText(
                      text: "P: ${counterListedItems[index].price}",
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
