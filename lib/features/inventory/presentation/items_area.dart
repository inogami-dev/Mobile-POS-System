import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_system/core/utilities/dimension.dart';
import 'package:pos_system/core/widgets/scrollbar.dart';
import 'package:pos_system/features/inventory/presentation/state_management/all_listed_products.dart';
import 'package:pos_system/features/inventory/presentation/widgets/item.dart';
import 'package:pos_system/features/products/data/model/product_model.dart';

class MyItemsArea extends ConsumerStatefulWidget {
  const MyItemsArea({super.key});

  @override
  ConsumerState<MyItemsArea> createState() => _MyItemsAreaState();
}

class _MyItemsAreaState extends ConsumerState<MyItemsArea> {
  late double width;
  ScrollController _scrollController = ScrollController();

  @override
  dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allListedProducts = ref.watch(allListedProductsProvider).value;
    log("allListedProducts: ${allListedProducts?.length ?? 0}");

    width = MyDimensions.getWidth(context);

    return Container(
      width: width,
      // color: Colors.amber,
      padding: EdgeInsets.only(top: 8, left: 16, right: 16),
      child: MyScrollBar(
        controller: _scrollController,
        padding: EdgeInsets.only(left: 10, bottom: 10, right: -15),
        isInteractive: true,
        child: GridView.builder(
          padding: EdgeInsets.all(0),
          controller: _scrollController,
          itemCount: allListedProducts?.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16.0,
            crossAxisSpacing: 16.0,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, index) {
            return MyItem(
              product:
                  allListedProducts?[index] ??
                  ProductModel(
                    storeId: "storeId_$index",
                    name: "Product $index",
                    price: 1456.0,
                    barCode: "barcode_$index",
                    quantity: 5,
                    description:
                        "Description for Product $index kjadka adbak ab wha wbad awhbdj hs s a abdakj",
                    picture: "",
                    expirationDate: "2024-12-31",
                    registeredBy: "User $index",
                    registeredOn: DateTime.now().toString(),
                  ),
            );
          },
        ),
      ),
    );
  }
}
