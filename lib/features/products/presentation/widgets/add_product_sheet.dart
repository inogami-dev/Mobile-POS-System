import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pos_system/core/widgets/bottom_sheet_decorated.dart';
import 'package:pos_system/core/widgets/container.dart';
import 'package:pos_system/core/widgets/text_field.dart';
import 'package:pos_system/core/widgets/text_formatter.dart';

class AddProductSheet extends ConsumerStatefulWidget {
  const AddProductSheet({super.key});

  @override
  ConsumerState<AddProductSheet> createState() => _AddProductSheetState();
}

class _AddProductSheetState extends ConsumerState<AddProductSheet> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final myColorScheme = Theme.of(context).colorScheme;

    return MyDecoratedBottomSheet(
      width: width,
      height: height * 0.56,
      child: Column(
        children: [
          MyTextfield(
            labelText: "Product Name",
            prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedPackage),
            textController: TextEditingController(),
          ),
          MyTextfield(
            labelText: "Product Description",
            prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedText),
            textController: TextEditingController(),
          ),
          MyTextfield(
            labelText: "Price",
            prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedMoney04),
            textController: TextEditingController(),
          ),
          MyTextfield(
            labelText: "Get Barcode (Button ni dapat)",
            prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedText),
            textController: TextEditingController(),
          ),
          MyTextfield(
            labelText: "Picture (Button ni dapat)",
            prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedText),
            textController: TextEditingController(),
          ),
          MyTextfield(
            labelText: "Expiration Date",
            prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedCalendar05),
            textController: TextEditingController(),
          ),
        ],
      ),
    );
  }
}
