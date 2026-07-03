import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_system/features/inventory/presentation/widgets/item.dart';
import 'package:pos_system/features/products/data/model/product_model.dart';

class MyItemsArea extends ConsumerStatefulWidget {
  const MyItemsArea({super.key});

  @override
  ConsumerState<MyItemsArea> createState() => _MyItemsAreaState();
}

class _MyItemsAreaState extends ConsumerState<MyItemsArea> {
  late double width;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      // color: Colors.amber,
      padding: EdgeInsets.only(top: 32, left: 16, right: 16),
      child: GridView.builder(
        itemCount: 25,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
          childAspectRatio: 0.85,
        ),
        itemBuilder: (context, index) {
          return MyItem(
            product: ProductModel(
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
    );
  }
}
