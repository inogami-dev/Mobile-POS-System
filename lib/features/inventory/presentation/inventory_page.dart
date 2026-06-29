import 'package:flutter/material.dart';
import 'package:pos_system/core/widgets/bottom_sheet.dart';
import 'package:pos_system/core/widgets/button.dart';
import 'package:pos_system/features/products/presentation/widgets/add_product_sheet.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  @override
  Widget build(BuildContext context) {
    final myColorScheme = Theme.of(context).colorScheme;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: width,
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MyButton(
                widthPercentage: 0.45,
                buttonText: "Add Product",
                onTap: () {
                  showMyBottomSheet(context: context, child: AddProductSheet());
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) =>
                  //         const AddProductSheet(), // Change your sheet to a normal Scaffold page
                  //     fullscreenDialog: true, // THIS IS THE MAGIC PROPERTY
                  //   ),
                  // );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
