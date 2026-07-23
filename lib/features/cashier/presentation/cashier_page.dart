import 'package:flutter/material.dart';
import 'package:pos_system/core/utilities/dimension.dart';
import 'package:pos_system/features/cashier/presentation/widgets/counter_scanner.dart';

class CashierPage extends StatefulWidget {
  const CashierPage({super.key});

  @override
  State<CashierPage> createState() => _CashierPageState();
}

class _CashierPageState extends State<CashierPage> {
  late double width;
  late double height;

  @override
  Widget build(BuildContext context) {
    width = MyDimensions.getWidth(context);
    height = MyDimensions.getHeight(context);

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
          ],
        ),
      ),
    );
  }
}
