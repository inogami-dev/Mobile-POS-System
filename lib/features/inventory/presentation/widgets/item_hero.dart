import 'package:flutter/material.dart';
import 'package:pos_system/core/widgets/hero.dart';
import 'package:pos_system/core/widgets/text_formatter.dart';
import 'package:pos_system/features/products/data/model/product_model.dart';

class ItemHero extends StatelessWidget {
  final String heroTag;
  final ProductModel product;
  const ItemHero({super.key, required this.heroTag, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: MyHero(
          tag: heroTag,
          // child: MyItem(product: product),
          child: Container(
            color: Colors.transparent,
            child: Center(
              child: Text(
                heroTag,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
