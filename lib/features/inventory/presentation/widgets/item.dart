import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pos_system/core/utilities/image_picker.dart';
import 'package:pos_system/core/widgets/hero.dart';
import 'package:pos_system/core/widgets/navigator.dart';
import 'package:pos_system/core/widgets/progress_indicator_static.dart';
import 'package:pos_system/features/inventory/presentation/widgets/item_contents.dart';
import 'package:pos_system/features/inventory/presentation/widgets/item_hero.dart';
import 'package:pos_system/features/products/data/model/product_model.dart';

class MyItem extends StatelessWidget {
  final ProductModel product;
  const MyItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width * 0.45;
    double displayHeight = MediaQuery.of(context).size.height * 0.08;
    final productImage = MyImageProcessor.decodeStringToUint8List(
      product.picture,
    );

    return GestureDetector(
      onTap: () {
        MyNavigator.goTo(
          context,
          ItemHero(heroTag: product.id!, product: product),
          animationType: MyAnimationType.fade,
        );
        // log("Small | Width: $displayWidth, Height: $displayHeight");
        // log("Small Item Dimension | ${displayWidth * displayHeight}");
      },
      child: (product.id != null)
          ? MyHero(
              tag: product.id!,
              child: MyItemContents(
                width: displayWidth,
                height: displayHeight,
                product: product,
                isExpanded: false,
                encodedProductImage: productImage,
              ),
            )
          : MyProgressIndicator(),
    );
  }
}
