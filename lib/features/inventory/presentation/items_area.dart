import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_system/core/utilities/dimension.dart';
import 'package:pos_system/core/widgets/progress_indicator_static.dart';
import 'package:pos_system/core/widgets/scrollbar.dart';
import 'package:pos_system/features/inventory/presentation/state_management/all_listed_products.dart';
import 'package:pos_system/features/inventory/presentation/state_management/decoded_image_cache.dart';
import 'package:pos_system/features/inventory/presentation/widgets/item.dart';
import 'package:pos_system/features/products/presentation/state_management/queried_products.dart';
import 'package:pos_system/core/widgets/text_formatter.dart';

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
    final queriedProducts = ref.watch(queriedProductsProvider);
    final allProductsState = ref.watch(allListedProductsProvider);
    final allDecodedImageCache = ref.watch(myDecodedImageCacheProvider);

    if (allProductsState.hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: MyText(
            text: "Error loading products. Please check your connection.",
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      );
    }

    final defaultListOfProducts = allProductsState.valueOrNull;
    final allListedProducts = (queriedProducts.isEmpty)
        ? defaultListOfProducts
        : queriedProducts;
    log("allListedProducts: ${allListedProducts?.length ?? 0}");
    final myColorScheme = Theme.of(context).colorScheme;

    width = MyDimensions.getWidth(context);
    final topHeightPaddingToAvoidSearchBarOverlap = kToolbarHeight + 8;

    return Container(
      width: width,
      // color: Colors.amber,
      padding: EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 0.5),
      child: MyScrollBar(
        controller: _scrollController,
        padding: EdgeInsets.only(
          top: kToolbarHeight - 56,
          left: 10,
          bottom: 10,
          right: -15,
        ),
        isInteractive: true,
        thickness: 3,
        thumbColor: myColorScheme.onSurfaceVariant.withAlpha(100),
        trackColor: myColorScheme.onSurface.withAlpha(50),
        child: GridView.builder(
          padding: EdgeInsets.fromLTRB(
            0,
            topHeightPaddingToAvoidSearchBarOverlap,
            0,
            10,
          ),
          controller: _scrollController,
          itemCount: allListedProducts?.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16.0,
            crossAxisSpacing: 16.0,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, index) {
            return (allListedProducts == null)
                ? MyProgressIndicator()
                : MyItem(
                    product: allListedProducts[index],
                    productImage:
                        allDecodedImageCache[allListedProducts[index].picture],
                  );
          },
        ),
      ),
    );
  }
}
