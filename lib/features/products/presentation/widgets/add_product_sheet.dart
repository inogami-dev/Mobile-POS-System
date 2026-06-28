import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pos_system/core/utilities/date_formatter.dart';
import 'package:pos_system/core/widgets/bottom_sheet_decorated.dart';
import 'package:pos_system/core/widgets/button.dart';
import 'package:pos_system/core/widgets/container.dart';
import 'package:pos_system/core/widgets/date_picker.dart';
import 'package:pos_system/core/widgets/my_snackbar.dart';
import 'package:pos_system/core/widgets/page_navigator.dart';
import 'package:pos_system/core/widgets/text_field.dart';
import 'package:pos_system/core/widgets/text_formatter.dart';
import 'package:pos_system/features/products/presentation/state_management/single_scan_value.dart';
import 'package:pos_system/features/products/presentation/widgets/scanner.dart';

class AddProductSheet extends ConsumerStatefulWidget {
  const AddProductSheet({super.key});

  @override
  ConsumerState<AddProductSheet> createState() => _AddProductSheetState();
}

class _AddProductSheetState extends ConsumerState<AddProductSheet> {
  // Object Fields
  TextEditingController productNameController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();
  TextEditingController productRriceController = TextEditingController();
  DateTime? expirationDate;
  late String scannedBarcode;

  // Layout Fields
  late ColorScheme myColorScheme;
  late double width;
  late double height;

  @override
  void dispose() {
    productNameController.dispose();
    productDescriptionController.dispose();
    productRriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    myColorScheme = Theme.of(context).colorScheme;
    scannedBarcode = ref.watch<String>(singleScanValueProvider);
    bool isBarcodeScanned = scannedBarcode.isNotEmpty;

    return StatefulBuilder(
      builder: (context, StateSetter setModalState) {
        return MyDecoratedBottomSheet(
          width: width,
          // height: height * 0.56,
          child: Column(
            spacing: 8,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                child: MyText(
                  text: "Add a Product",
                  fontSize: kDefaultFontSize + 8,
                  fontWeight: FontWeight.w800,
                ),
              ),

              MyTextfield(
                labelText: "Product Name",
                prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedPackage),
                textController: productNameController,
              ),
              MyTextfield(
                labelText: "Product Description",
                prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedText),
                textController: productDescriptionController,
              ),
              MyTextfield(
                labelText: "Price",
                prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedMoney04),
                textController: productRriceController,
              ),
              GestureDetector(
                onTap: () {
                  MyNavigator.goTo(context, MyScanner());
                },
                child: MyContainer(
                  width: width * 0.8,
                  height: 50,
                  padding: EdgeInsets.only(left: 16),
                  borderRadius: 50,
                  color: myColorScheme.surfaceContainerHighest,
                  borderColor: myColorScheme.primaryFixed,
                  child: Row(
                    children: [
                      HugeIcon(
                        icon: HugeIcons.strokeRoundedBarCode01,
                        size: 32,
                      ),
                      SizedBox(width: 8),
                      MyText(
                        text: (isBarcodeScanned)
                            ? scannedBarcode
                            : "Scan Barcode",
                      ),
                    ],
                  ),
                ),
              ),
              // MyTextfield(
              //   labelText: "Get Barcode (Button ni dapat)",
              //   prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedText),
              //   textController: TextEditingController(),
              // ),
              MyTextfield(
                labelText: "Picture (Button ni dapat)",
                prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedText),
                textController: TextEditingController(),
              ),
              expirationDateButton(context, setModalState),
              // MyTextfield(
              //   labelText: "Expiration Date",
              //   prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedCalendar05),
              //   textController: TextEditingController(),
              // ),
              SizedBox(height: 16),
              Container(
                width: width * 0.8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8,
                  children: [
                    MyButton(
                      buttonText: "Cancel",
                      isUsedAsAbortButton: true,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    Expanded(
                      child: MyButton(
                        buttonText: "Save Product",
                        onTap: () {
                          showMyAnimatedSnackBar(
                            context: context,
                            dataToDisplay:
                                "Name: ${productNameController.text} \nDescription: ${productDescriptionController.text} \nPrice: ${productRriceController.text} \nExpiration Date: ${expirationDate.toString()}",
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget expirationDateButton(BuildContext context, StateSetter setModalState) {
    return GestureDetector(
      onTap: () async {
        expirationDate = await myDatePicker(context);
        log(expirationDate.toString());
        setModalState(() {});
      },
      child: MyContainer(
        width: width * 0.8,
        height: 50,
        padding: EdgeInsets.only(left: 16),
        borderRadius: 50,
        color: myColorScheme.surfaceContainerHighest,
        borderColor: myColorScheme.primaryFixed,
        child:
            // Column(
            //   // mainAxisAlignment: MainAxisAlignment.start,
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     MyText(text: "Expiration Date"),
            Row(
              children: [
                HugeIcon(
                  icon: HugeIcons.strokeRoundedCalendar05,
                  size: 32,
                  color: myColorScheme.onSurfaceVariant,
                ),
                SizedBox(width: 8),
                MyText(
                  text: (expirationDate != null)
                      ? MyDateFormatter.formatDate(
                          dateTimeInString: expirationDate.toString(),
                        )
                      : "Pick Exp Date",
                ),
              ],
            ),
        //   ],
        // ),
      ),
    );
  }
}
