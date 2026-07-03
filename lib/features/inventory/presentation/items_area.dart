import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_system/features/inventory/presentation/item.dart';

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
        // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //   crossAxisCount: 2,
        //   childAspectRatio: 2.0,
        // ),
        // itemBuilder: (BuildContext context, int index) {
        //   return MyItem();
        // },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
        ),
        itemBuilder: (context, index) {
          return MyItem(text: "Item ${index + 1}");
        },
        itemCount: 10,
      ),
    );
  }
}
