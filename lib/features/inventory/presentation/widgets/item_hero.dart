import 'package:flutter/material.dart';
import 'package:pos_system/core/utilities/dimension.dart';
import 'package:pos_system/core/utilities/image_picker.dart';
import 'package:pos_system/core/widgets/hero.dart';
import 'package:pos_system/features/inventory/presentation/widgets/item_contents.dart';
import 'package:pos_system/features/products/data/model/product_model.dart';

class ItemHero extends StatelessWidget {
  final String heroTag;
  final ProductModel product;
  const ItemHero({super.key, required this.heroTag, required this.product});

  @override
  Widget build(BuildContext context) {
    final width = MyDimensions.getWidth(context);
    final height = MyDimensions.getHeight(context);
    final productImage = MyImageProcessor.decodeStringToUint8List(
      product.picture,
    );

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
          // log("Larger | Width: $width, Height: $height");
          // log("Larger Item Dimension | ${width * height}");
        },
        child: MyHero(
          tag: heroTag,
          // child: MyItem(product: product),
          child: SafeArea(
            child: MyItemContents(
              width: width,
              height: height,
              product: product,
              isExpanded: true,
              encodedProductImage: productImage,
            ),
          ),
        ),
      ),
    );
  }
}
